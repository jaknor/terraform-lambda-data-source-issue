terraform {
  required_version = "~>0.11.13"
}

provider "aws" {
}

locals {
  component_name = "terraform-issue-demo"
  alias_name = "production"
}

variable lambda_package_file_path { }

# data "aws_lambda_function" "existing_lambda_func" {
#   function_name = "${local.component_name}"
#   qualifier = "${local.alias_name}"
# }

resource "aws_lambda_function" "lambda_func" {
  function_name = "${local.component_name}"
  filename = "${var.lambda_package_file_path}"
  source_code_hash = "${base64sha256(file("${var.lambda_package_file_path}"))}"
  handler = "main.handler"
  runtime = "nodejs8.10"
  role = "${aws_iam_role.lambda_exec.arn}"
  publish = true
}

resource "aws_lambda_alias" "lambda_func_alias" {
  name             = "${local.alias_name}"
  description      = "This is a test lambda"
  function_name    = "${aws_lambda_function.lambda_func.arn}"
  function_version = "${aws_lambda_function.lambda_func.version}"

  # routing_config = {
  #   additional_version_weights = {
  #     "${data.aws_lambda_function.existing_lambda_func.version}" = "${var.lambda_previous_version_percentage}"
  #   }
  # }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.component_name}-${data.aws_region.current.name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  role = "${aws_iam_role.lambda_exec.name}"
  policy_arn="${data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn}"
}

output "version_number" {
  value = "${aws_lambda_function.lambda_func.version}"
}

# output "test" {
#   value = "${data.aws_lambda_function.existing_lambda_func.version}"
# }