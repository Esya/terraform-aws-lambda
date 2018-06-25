resource "aws_lambda_function" "lambda" {
  description                    = "${var.description}"
  role                           = "${aws_iam_role.lambda.arn}"
  handler                        = "${var.handler}"
  memory_size                    = "${var.memory_size}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  runtime                        = "${var.runtime}"
  timeout                        = "${var.timeout}"
  tags                           = "${var.tags}"
  dead_letter_config             = ["${var.dead_letter_config}"]
  vpc_config                     = ["${var.vpc_config}"]

  # Use a generated filename to determine when the source code has changed.

  filename   = "${lookup(data.external.built.result, "filename")}"
  depends_on = ["null_resource.archive"]

  # The aws_lambda_function resource has a schema for the environment
  # variable, where the only acceptable values are:
  #   a. Undefined
  #   b. An empty list
  #   c. A list containing 1 element: a map with a specific schema
  # Use slice to get option "b" or "c" depending on whether a non-empty
  # value was passed into this module.

  environment = ["${slice( list(var.environment), 0, length(var.environment) == 0 ? 0 : 1 )}"]
}
