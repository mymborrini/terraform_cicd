.PHONY: init validate bootstrap-init bootstrap-plan bootstrap-state-backend localstack-init bootstrap-validate localstack-stop bootstrap-apply


ENV ?= sandbox
TF := terraform
DIR := terraform_cicd


bootstrap-state-backend:
	./scripts/bootstrap-state-backend.sh

init:
	cd ${DIR} && ${TF} init -backend-config=backends/${ENV}.hcl -reconfigure

validate:
	cd ${DIR} && ${TF} validate

# Bootstrap

bootstrap-init:
	cd ${DIR}/bootstrap && ${TF} init -reconfigure

bootstrap-validate:
	cd ${DIR}/bootstrap && ${TF} validate

bootstrap-plan:
	cd ${DIR}/bootstrap && ${TF} plan -var github_org=mymborrini \
		-var repo=terraform_cicd \
  		-var state_lock_table=tf-state-lock \
  		-var 'reviewers=["mymborrini"]' -out=tfplan

bootstrap-apply:
	cd ${DIR}/bootstrap && ${TF} apply tfplan


# localstack

localstack-init:
	docker-compose --profile localstack up -d

localstack-down:
	docker-compose --profile localstack down


# github runner

github-runner-init:
	docker-compose --profile github up -d

github-runner-down:
	docker-compose --profile github down