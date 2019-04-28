This repository contains code to show an issue I have been having with terraform. I am trying to retrieve the current version of an alias for a lambda using the aws_lambda_function data source and use it inside the routing_config of an alias. However, when I execute terraform plan it keeps erroring, saying that it cannot parse an empty string as a float. This appears to be related to my usage of a variable in the routing configuration. The expected behavior is that it would use the value from my variable when updating the alias.

To reproduce.

Pull repository
Execute terraform init
Execute terraform plan
Execute terraform apply
Inside example.tf uncomment the following:
* The variable named lambda_previous_version_percentage
* The data source named existing_lambda_func
* The routing_config inside lambda_func_alias

Execute terraform plan again

When prompted for var.lambda_previous_version_percentage enter a valid float value (I.E. 0.5)

You should receive an error stating

Error: aws_lambda_alias.lambda_func_alias: routing_config.0.additional_version_weights (${data.aws_lambda_function.existing_lambda_func.version}): cannot parse '' as float: strconv.ParseFloat: parsing "${var.lambda_previous_version_percentage}": invalid syntax