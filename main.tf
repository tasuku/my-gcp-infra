terraform {
    required_providers {
        random = {
            source = "hashicorp/random"
        }
        google = {
            source = "hashicorp/google"
        }
    }
}

provider "google" {
    project = var.project
    region  = var.region

    # 「権限借用」の指定
    # gcloud authでログインした個人ユーザの権限で、以下のSAとして振る舞う
    impersonate_service_account = var.terraform-admin
}

resource "random_id" "project_suffix" {
    byte_length = 4
}

# 基本フォルダ構成：非商用環境のルートフォルダ
resource "google_folder" "non_prod" {
    display_name = "Non-Prod"
    parent = "organizations/${var.org_id}"
}

# 基本フォルダ構成：商用環境のルートフォルダ
resource "google_folder" "prod" {
    display_name = "Prod"
    parent = "organizations/${var.org_id}"
}

# 基本フォルダ構成：セキュア環境のルートフォルダ
resource "google_folder" "secure" {
    display_name = "Secure"
    parent = "organizations/${var.org_id}"
}

# 基本フォルダ構成：Sandbox環境のルートフォルダ
resource "google_folder" "sandbox" {
    display_name = "Sandbox"
    parent = "organizations/${var.org_id}"
}

# 基本フォルダ構成：PoC環境のルートフォルダ
resource "google_folder" "poc" {
    display_name = "PoC"
    parent = google_folder.non_prod.name

    depends_on = [
        google_folder.non_prod
    ]
}

# 基本フォルダ構成：Dev環境のルートフォルダ
resource "google_folder" "dev" {
    display_name = "Dev"
    parent = google_folder.non_prod.name

    depends_on = [
        google_folder.non_prod
    ]
}

# 基本フォルダ構成：Test環境のルートフォルダ
resource "google_folder" "test" {
    display_name = "Test"
    parent = google_folder.non_prod.name

    depends_on = [
        google_folder.non_prod
    ]
}

# 基本フォルダ構成：Staging環境のルートフォルダ
resource "google_folder" "staging" {
    display_name = "Staging"
    parent = google_folder.non_prod.name

    depends_on = [
        google_folder.non_prod
    ]
}
