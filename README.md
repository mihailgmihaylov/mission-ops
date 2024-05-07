# Mission OPS example project
A sample project to deploy apps in AWS

## Initial AWS environment setup

This repo has several prerequisites:
- you should have a valid AWS environment with a pre-setup awscli and proper authentication


First, we need to create an S3 bucket for the soul purpose of storing the terraform state.
*Note*: we are not going to use a consensus mechanics in the form of a DynamoDB database in this example.
```
aws s3api create-bucket --bucket <prefix>-state --region <region> --create-bucket-configuration LocationConstraint=<region>
```

Example:
```
aws s3api create-bucket --bucket mission-ops-state --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
```

*Improtant*:
Since the terraform state stores very important resources and they are very small in size,
it is strongly recommended to enable S3 bucket versioning:

```
aws s3api put-bucket-versioning --bucket <bucket> --versioning-configuration Status=Enabled
```

Example:
```
aws s3api put-bucket-versioning --bucket mission-ops-state --versioning-configuration Status=Enabled
```

### Initiating Terraform environment

Before running everything, take note of the variables in `terraform/backend.tfvars`.
Those are needed for the initial setup and should reflect your environment and the bucket you created in the previous step.


To initiate the terraform state simply run:
```
cd terraform
terraform init -backend-config=backend.tfvars
```

Expected result:
```
Terraform has been successfully initialized!
```

## Style Guide:
- App names are kebap-cased
- variables are snake_cased
