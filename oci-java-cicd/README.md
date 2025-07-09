# OCI DevOps CI/CD Project for Java Spring Boot

## Overview
This project demonstrates a complete CI/CD pipeline using **OCI DevOps** to deploy a **Java Spring Boot** REST API to **Oracle Kubernetes Engine (OKE)**.

## Features
- Java REST API with `/api/hello` and `/api/status`
- Dockerized using `Dockerfile`
- Build and Deploy pipelines using OCI DevOps
- Terraform automation for OKE and network setup

## How to Use
1. Set variables in `terraform.tfvars` or pass them during apply
2. `cd terraform && terraform init && terraform apply`
3. Upload source to OCI Code Repository
4. Create a Build Pipeline in OCI DevOps using `build_spec.yaml`
5. Create a Deploy Pipeline using `deploy_spec.yaml`
6. Set up OCIR credentials and trigger the pipeline