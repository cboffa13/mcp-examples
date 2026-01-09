# AI Infrastructure

This repository contains scripts and templates used to manage the infrastructure of an AI
application as code. 

## Getting started

### Install dependencies

```bash
brew install terraform oci-cli
```

### Authenticate with OCI
```bash
oci session authenticate --profile-name DEFAULT --region us-sanjose-1
```

### Create resources
```bash
terraform init
terraform apply
```

### :warning: (Optional) Destroy resources
```bash
terraform destroy
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
