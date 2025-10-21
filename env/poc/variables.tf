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
    description = "デフォルトプロジェクト"
    type = string
}

variable "non_prod" {
    description = "非商用環境フォルダ"
    type = string
}

variable "poc" {
    description = "PoCフォルダ"
    type = string
}

variable "billing_account_id" {
    description = "請求アカウントID"
    type = string
}

variable "shared_project" {
    description = "PoC共有プロジェクトの名称"
    type = string
}

variable "sa_service_a_app" {
    description = "サービスA向けのアプリケーションサービスアカウント"
    type = string
}

variable "sa_service_b_app" {
    description = "サービスB向けのアプリケーションサービスアカウント"
    type = string
}

variable "service_a_01_project" {
    description = "サービスAプロジェクト[環境面01]の名称"
    type = string
}

variable "service_a_02_project" {
    description = "サービスAプロジェクト[環境面02]の名称"
    type = string
}

variable "service_b_01_project" {
    description = "サービスBプロジェクト[環境面01]の名称"
    type = string
}
