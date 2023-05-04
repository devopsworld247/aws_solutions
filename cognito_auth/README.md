Here are the steps to create the Cognito Pool and the API Gateway setup for OAuth

1.) Create a VPC endpoint for API Gateway in the Source Account or the Acount from which the API call will be made.
2.) Replace the "TBD" string with the examples folder (main.tf) with the ID of the VPC endpoint created in step 1.
3.) Do a Terraform init.
4.) Do a Terraform plan.
5.) Do a Terraform apply.
6.) Confirm and commit.
