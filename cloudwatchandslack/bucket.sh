aws s3api create-bucket \
  --bucket terraform-state-bucket-20250107-v1 \
  --region ap-northeast-1 \
  --create-bucket-configuration LocationConstraint=ap-northeast-1

aws s3api put-bucket-versioning \
  --bucket terraform-state-bucket-20250107-v1 \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-acl \
  --bucket terraform-state-bucket-20250107-v1 \
  --acl private