# nginx-stackdriver-terraform

## Overview

You can watch the 1st video here: https://youtu.be/O21OD-VJEv4

You can watch the 2nd video here: https://youtu.be/1N_jtFu2jZU

This repository was tested with `Terraform v0.12.25`.

The Terraform configuration in this repository will set up a GCE instance that's automatically configured to work with Stackdriver Logging and a logging sink that forwards NGINX logs to BigQuery will also be created.

## Requirements

* A service account in the root of the repository
* A GCP project ID set in [variables.tf](./variables.tf#L2)
* Compute, Logging, and Cloud Resource Manager APIs enabled in GCP
* A service account with `roles/editor` and `roles/logging.configWriter` access

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
