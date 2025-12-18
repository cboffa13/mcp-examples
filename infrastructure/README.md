# AI Infrastructure

This repository contains scripts and templates used to manage the infrastructure of an AI
application as code. 

## Getting started

### Install dependencies

```bash
brew install terraform oci-cli
```

### Authenticate with OCI and create instance

```bash
oci session authenticate --profile-name DEFAULT --region us-sanjose-1
terraform init
terraform plan -out setup.plan
terraform apply setup.plan
```

## Development

### Format
```bash
make format
```

### Run tests

```bash
make test
```
