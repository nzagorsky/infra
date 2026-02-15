.PHONY: init init-remote migrate-state plan packer-init packer-fmt packer-build-ubuntu-24-04-nocloud

# The S3 backend expects AWS-style env vars. Our .env uses B2_* names.
# Keep local workflow simple: after `source .env`, `make plan` should work.
TOFU_ENV = \
	AWS_EC2_METADATA_DISABLED=true \
	AWS_ACCESS_KEY_ID="$${AWS_ACCESS_KEY_ID:-$${B2_TOFU_KEY_ID}}" \
	AWS_SECRET_ACCESS_KEY="$${AWS_SECRET_ACCESS_KEY:-$${B2_TOFU_APPLICATION_KEY}}"

B2_BACKEND_ARGS = \
	-backend-config="bucket=$${B2_TOFU_STATE_BUCKET}" \
	-backend-config="key=$${B2_TOFU_STATE_KEY}" \
	-backend-config="region=$${B2_TOFU_REGION}" \
	-backend-config="endpoint=$${B2_TOFU_S3_ENDPOINT}" \
	-backend-config="access_key=$${B2_TOFU_KEY_ID}" \
	-backend-config="secret_key=$${B2_TOFU_APPLICATION_KEY}" \
	-backend-config="use_path_style=true" \
	-backend-config="skip_s3_checksum=true" \
	-backend-config="skip_credentials_validation=true" \
	-backend-config="skip_region_validation=true" \
	-backend-config="skip_metadata_api_check=true" \
	-backend-config="skip_requesting_account_id=true"

init:
	$(TOFU_ENV) tofu init

init-remote:
	$(TOFU_ENV) tofu init -reconfigure $(B2_BACKEND_ARGS)

migrate-state:
	$(TOFU_ENV) tofu init -migrate-state -force-copy $(B2_BACKEND_ARGS)

plan:
	$(TOFU_ENV) tofu plan

apply:
	$(TOFU_ENV) tofu apply
