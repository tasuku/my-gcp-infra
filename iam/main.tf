terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
        }
    }
}

provider "google" {
    project = var.project
    region  = var.region

    impersonate_service_account = var.terraform-admin
}

resource "google_service_account" "sa_poc_service_a_app" {
    account_id = var.sa_poc_service_a_app
    display_name = var.sa_poc_service_a_app_name
    description = var.sa_poc_service_a_app_description
}

resource "google_service_account" "sa_poc_service_b_app" {
    account_id = var.sa_poc_service_b_app
    display_name = var.sa_poc_service_b_app_name
    description = var.sa_poc_service_b_app_description
}