{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SqsSendMessage",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${var.sqs_arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.sns_arn}"
        }
      }
    }
  ]
}
