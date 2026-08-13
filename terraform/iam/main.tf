resource "aws_iam_user" "platform_capstone" {
  name = var.user_name
}

resource "aws_iam_policy" "user_basic_access" {
  name        = "${var.user_name}-basic-access"
  description = "Put/Get/Delete/List permissions for the user"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_basic_access" {
  user       = aws_iam_user.platform-capstone.name
  policy_arn = aws_iam_policy.user_basic_access.arn
}
