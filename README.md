# terraform_lambda
This repository contains terraform template to create two lambda functions in multiple environments using terraform workspaces (Prod and Dev) .

The main.tf file contains code to create a lambda function configured to use vpc , subnets already existing in aws account. It also includes required policies and roles for cloudwatch and vpc access.
