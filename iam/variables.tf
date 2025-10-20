variable "terraform-admin" {
    description = "Terraform用サービスアカウント"
    type = string
}

variable "org_id" {
    description = "組織ID"
    type = string
}

variable "region" {
    description = "デフォルトリージョン"
    type = string
}

variable "project" {
    description = "アカウント管理用プロジェクト"
    type = string
}

variable "sa_poc_service_a_app" {
    description = "PoCプロジェクト01向けのアプリケーションサービスアカウント"
    type = string
}

variable "sa_poc_service_a_app_name" {
    description = "PoCプロジェクト01向けのアプリケーションサービスアカウント表示名"
    type = string
}

variable "sa_poc_service_a_app_description" {
    description = "PoCプロジェクト01向けのアプリケーションサービスアカウント説明"
    type = string
}

variable "sa_poc_service_b_app" {
    description = "PoCプロジェクト02向けのアプリケーションサービスアカウント"
    type = string
}

variable "sa_poc_service_b_app_name" {
    description = "PoCプロジェクト02向けのアプリケーションサービスアカウント表示名"
    type = string
}

variable "sa_poc_service_b_app_description" {
    description = "PoCプロジェクト02向けのアプリケーションサービスアカウント説明"
    type = string
}