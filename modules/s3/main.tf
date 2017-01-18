resource "null_resource" "dummy_dependency" {
  depends_on = [
    "null_resource.kubearn",
    "null_resource.arn",
    "aws_s3_bucket.kubebucket",
  ]
}
