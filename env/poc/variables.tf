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

variable "poc01_shared_project" {
    description = "PoC共有プロジェクトの名称"
    type = string
}

variable "sa_poc_service_a_app" {
    description = "PoCプロジェクト01向けのアプリケーションサービスアカウント"
    type = string
}

variable "sa_poc_service_b_app" {
    description = "PoCプロジェクト02向けのアプリケーションサービスアカウント"
    type = string
}

variable "poc01_service_a_project" {
    description = "PoCプロジェクト01[環境面poc01]の名称"
    type = string
}

variable "poc02_service_a_project" {
    description = "PoCプロジェクト01[環境面poc02]の名称"
    type = string
}

variable "poc01_service_b_project" {
    description = "PoCプロジェクト02[環境面poc01]の名称"
    type = string
}
