## Repository Safety Policy

This repository is public and open-source.

- Never commit PII.
- Never commit secrets, credentials, tokens, private keys, state files, or backups.
- Never commit real internal domains, hostnames, IP ranges, MAC addresses, node names, or other network topology details.
- Keep all sensitive and environment-specific values in environment variables (for OpenTofu, use `TF_VAR_*` and provider auth env vars).
- Use placeholder values in examples (`example.invalid`, RFC5737 IP ranges, synthetic MACs).
