.PHONY: init init-remote migrate-state plan

ENV_FILE ?= .env
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
	tofu init

init-remote:
	set -a && . "./$(ENV_FILE)" && set +a && tofu init -reconfigure $(B2_BACKEND_ARGS)

migrate-state:
	set -a && . "./$(ENV_FILE)" && set +a && tofu init -migrate-state -force-copy $(B2_BACKEND_ARGS)

plan:
	tofu plan
