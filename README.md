# nginx-stackdriver

## Overview

This repository was tested with `Terraform v0.11.13`.

The Terraform configuration in this repository will setup a GCE instance that's automatically configured to work with Stackdriver Logging.

## Requirements

* A service account in the root of the repository
* Project ID set in [variables.tf](./variables.tf#L2)
* Compute and Logging APIs enabled in GCP

## Usage

Initialize Terraform:

```
$ terraform init
```

View the changes:

```
$ terraform plan
```

Apply the Terraform changes:

```
$ terraform apply
```

## Questions?

Open an issue.
