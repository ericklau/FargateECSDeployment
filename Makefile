.PHONY: help deploy-master docker deploy-ecr

stackName = sample-application
region = us-east-1
accountid = $(shell aws sts get-caller-identity --query Account --output text)
servicename = $(shell cat parameters.properties|grep ServiceName)

.DEFAULT: help
help:
	@echo "make deploy-master"
	@echo "       deploys $(stackName) Master on Fargate"

debug-master:
	aws --version
	aws sts get-caller-identity
	aws cloudformation describe-stack-events --stack-name $(stackName)

deploy-ecr:
	aws configure set region us-east-1
	aws --region $(region) cloudformation deploy \
		--template-file cloudformation-ecr.yaml \
		--stack-name $(stackName)-ecr \
		--parameter-overrides $(shell cat parameters.properties|grep ServiceName) \
		--no-fail-on-empty-changeset

	@aws cloudformation describe-stacks \
		--stack-name $(stackName)-ecr \
		--output text \
		--query Stacks[0].Outputs[*].OutputValue

docker:
	docker build -t $(shell aws ssm get-parameters --region us-east-1 --names /$(stackName)/docker-uri --query "Parameters[*].{Value:Value}" --output text):latest docker
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(accountid).dkr.ecr.$(region).amazonaws.com
	docker push $(shell aws ssm get-parameters --region us-east-1 --names /$(stackName)/docker-uri --query "Parameters[*].{Value:Value}" --output text):latest

deploy-master:
	aws cloudformation deploy \
		--template-file cloudformation-master_bkp.yaml \
		--stack-name $(stackName) \
		--parameter-overrides $(shell cat parameters.properties) \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset

	@aws cloudformation describe-stacks \
		--stack-name $(stackName) \
		--output text \
		--query Stacks[0].Outputs[*].OutputValue
