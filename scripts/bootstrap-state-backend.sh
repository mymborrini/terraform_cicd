
# The idea is to keep this script idempotent

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-central-1

BUCKET="${BUCKET:-tf-state}"
TABLE="${TABLE:-tf-state-lock}"
REGION="${AWS_REGION:-eu-central-1}"
ON_LOCALSTACK="--endpoint-url=http://localhost:4566"

echo "==> Account: $(aws ${ON_LOCALSTACK} sts get-caller-identity --query Account --output text)"
echo "==> Region:  ${REGION}"
echo "==> Bucket:  ${BUCKET}"
echo "==> Table:   ${TABLE}"

if aws ${ON_LOCALSTACK} s3api head-bucket --bucket ${BUCKET} 2>/dev/null; then
  echo "[skip] S3 bucket ${BUCKET} already exists"
else
  echo "[create] S3 bucket ${BUCKET}"
  aws ${ON_LOCALSTACK} s3api create-bucket --bucket "${BUCKET}" --region "${REGION}" --create-bucket-configuration "LocationConstraint=${REGION}" >/dev/null
fi

echo "[apply] versioning enabled on ${BUCKET}"
aws ${ON_LOCALSTACK} s3api put-bucket-versioning \
    --bucket "${BUCKET}" \
    --versioning-configuration Status=Enabled

echo "[apply] default encryption AES256 on ${BUCKET}"
aws ${ON_LOCALSTACK} s3api put-bucket-encryption \
    --bucket "${BUCKET}" \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}
        }]
    }'

echo "[apply] block all public access on ${BUCKET}"
aws ${ON_LOCALSTACK} s3api put-public-access-block \
  --bucket "${BUCKET}" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

if aws ${ON_LOCALSTACK} dynamodb describe-table --table-name "${TABLE}" --region "${REGION}" >/dev/null 2>&1; then
  echo "[skip] DynamoDB table ${TABLE} already exists"
else
  echo "[create] DynamoDB table ${TABLE}"
  aws ${ON_LOCALSTACK} dynamodb create-table \
    --table-name "${TABLE}" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "${REGION}" >/dev/null
  echo "[wait] table ACTIVE..."
  aws ${ON_LOCALSTACK} dynamodb wait table-exists --table-name "${TABLE}" --region "${REGION}"
fi

echo
echo "Done. State backend is ready."
echo "Put '${BUCKET}' and '${TABLE}' into your backends/*.hcl files, then run terraform init."