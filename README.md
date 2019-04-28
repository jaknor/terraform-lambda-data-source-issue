# Unable to use lambda data source in lambda alias

I am experimenting with a blue/green deployment setup for lambdas using terraform and lambda aliases.

I am trying to automatically retrieve the previously deployed version of the lambda by using the aws_lambda_function data source and using the value inside the routing_config => additional_version_weights to set up a traffic split.

However, I have run into 2 errors I don't quite understand.

## Error 1

The first error is when I try and use the data source in conjunction with a regular variable. In this case terraform complains about being unable to parse the value, even though when hard coded it works fine.

### Steps to reproduce

* Pull repository
* Navigate to folder example-1
* Execute terraform init
* Execute terraform apply
* When prompted for lambda_package_file_path enter ./package1.zip
* Inside example.tf uncomment the following:
  * The variable named lambda_previous_version_percentage
  * The data source named existing_lambda_func
  * The routing_config inside lambda_func_alias
* Execute terraform apply
* * When prompted for lambda_package_file_path enter ./package2.zip
* When prompted for var.lambda_previous_version_percentage enter a valid float value (I.E. 0.5)

You will receive an error stating

Error: aws_lambda_alias.lambda_func_alias: routing_config.0.additional_version_weights (${data.aws_lambda_function.existing_lambda_func.version}): cannot parse '' as float: strconv.ParseFloat: parsing "${var.lambda_previous_version_percentage}": invalid syntax

## Error 2

To get around the error above I tried hard coding the percentage. In this case terraform will attempt to update the value, however, it will not succeed as it tries to set the version in the routing configuration to an empty value.

### Steps to reproduce

* Pull repository
* Navigate to folder example-2
* Execute terraform init
* Execute terraform apply
* When prompted for lambda_package_file_path enter ./package1.zip
* Inside example.tf uncomment the following:
  * The data source named existing_lambda_func
  * The output previous_version_number
* Execute terraform apply
* When prompted for lambda_package_file_path enter ./package2.zip
* You should receive 2 outputs, the current and the previous version
* Inside example.tf uncomment the following:
  * The routing_config inside lambda_func_alias
* Execute terraform apply
* When prompted for lambda_package_file_path enter ./package3.zip

You will get an error






