locals {
  lambda_role_name       = "${terraform.workspace}-${var.suffix}-role_lambda"
  cloudwatch_policy_name = "${terraform.workspace}-${var.suffix}-policy_cloudwatch"
  lambda_function_name   = "${terraform.workspace}-${var.suffix}-lambda"
  tag                    = "${terraform.workspace}"
}


data "archive_file" "code_zip" {
  type        = "zip"
  output_path = "/tmp/function.zip"
  source_file = "files/main.py"
   
  
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#data "aws_subnet_ids" "priv" {
# vpc_id = "vpc-087b4e0167a2591a9"

#  tags = {
#    Name = "*priv*"
#  }
#}


resource "aws_iam_role" "lambda_role" {
  name               = local.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags = {
    terraform = "managed"
    Environment = local.tag
  }
}

resource "aws_iam_policy" "policy_cloudwatch" {
  name = local.cloudwatch_policy_name
  tags = {
    Environment = local.tag
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:GetLogEvents", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.policy_cloudwatch.arn
}
#resource "aws_iam_policy" "policy_two" {
#  name = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"



resource "aws_lambda_function" "task15_lambda" {
  filename         = data.archive_file.code_zip.output_path
  function_name    = local.lambda_function_name
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.code_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  vpc_config {
    #subnet_ids         = "${values(data.aws_subnet_ids.priv).*.ids}" #[aws_subnet.subnet_for_lambda.id]
    subnet_ids     = var.lambda_subnets
    security_group_ids = var.lambda_SG
  }
  tags = {
    Environment = local.tag
  }
  environment {
    variables = {
      my_name = "chizzy"
    }
  }
}

