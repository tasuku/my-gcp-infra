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
    project = "shared-service-accounts-475520"
    region  = "asia-northeast1"

    # 「権限借用」の指定
    # gcloud authでログインした個人ユーザの権限で、以下のSAとして振る舞う
    impersonate_service_account = var.terraform-admin
}

resource "random_id" "project_suffix" {
    byte_length = 4
}

# 基本フォルダ構成：環境共通のルートフォルダ
#resource "google_folder" "common" {
#    display_name = "Common"
#    parent = "organizations/${var.org_id}"
#}

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

# PoC共有プロジェクトフォルダ
resource "google_folder" "poc_shared" {
    display_name = "poc-shared"
    parent = google_folder.poc.name

    deletion_protection=false

    depends_on = [
        google_folder.poc
    ]
}

# PoC共有プロジェクト
resource "google_project" "poc01_shared_pj" {
    name = var.poc01_shared_project
    project_id = "${var.poc01_shared_project}-${random_id.project_suffix.hex}"
    folder_id = google_folder.poc_shared.folder_id
    billing_account = var.billing_account_id
    auto_create_network = false

    deletion_policy = "DELETE"

    depends_on = [
        google_folder.poc_shared
    ]

}

# PoC個別プロジェクトその1
resource "google_folder" "poc_service_a" {
    display_name = "poc-service-a-pj"
    parent = google_folder.poc.name

    deletion_protection=false
}

resource "google_project" "poc01_service_a_pj" {
    name = var.poc01_service_a_project
    project_id = "${var.poc01_service_a_project}-${random_id.project_suffix.hex}"
    folder_id = google_folder.poc_service_a.folder_id
    billing_account = var.billing_account_id
    auto_create_network = false

    deletion_policy = "DELETE"

    depends_on = [
        google_folder.poc_service_a
    ]

}

resource "google_project" "poc02_service_a_pj" {
    name = var.poc02_service_a_project
    project_id = "${var.poc02_service_a_project}-${random_id.project_suffix.hex}"
    folder_id = google_folder.poc_service_a.folder_id
    billing_account = var.billing_account_id
    auto_create_network = false

    deletion_policy = "DELETE"

    depends_on = [
        google_folder.poc_service_a
    ]
}

# PoC個別プロジェクトその2
resource "google_folder" "poc_service_b" {
    display_name = "poc-service-b-pj"
    parent = google_folder.poc.name

    deletion_protection=false
}

resource "google_project" "poc01_service_b_pj" {
    name = var.poc01_service_b_project
    project_id = "${var.poc01_service_b_project}-${random_id.project_suffix.hex}"
    folder_id = google_folder.poc_service_b.folder_id
    billing_account = var.billing_account_id
    auto_create_network = false

    deletion_policy = "DELETE"

    depends_on = [
        google_folder.poc_service_b
    ]
}

resource "google_billing_project_info" "poc01_shared_pj_billing" {
    project = google_project.poc01_shared_pj.project_id
    billing_account = var.billing_account_id
}

resource "google_billing_project_info" "poc01_service_a_pj_billing" {
    project = google_project.poc01_service_a_pj.project_id
    billing_account = var.billing_account_id
}

resource "google_billing_project_info" "poc02_service_a_pj_billing" {
    project = google_project.poc02_service_a_pj.project_id
    billing_account = var.billing_account_id
}

resource "google_billing_project_info" "poc01_service_b_pj_billing" {
    project = google_project.poc01_service_b_pj.project_id
    billing_account = var.billing_account_id
}

resource "google_project_service" "poc01_shared_pj_compute_api" {
    project = google_project.poc01_shared_pj.project_id
    service = "compute.googleapis.com"

    depends_on = [google_billing_project_info.poc01_shared_pj_billing]
}

resource "google_project_service" "poc01_service_a_pj_compute_api" {
    project = google_project.poc01_service_a_pj.project_id
    service = "compute.googleapis.com"

    depends_on = [google_billing_project_info.poc01_shared_pj_billing]
}

resource "google_project_service" "poc01_service_b_pj_compute_api" {
    project = google_project.poc01_service_b_pj.project_id
    service = "compute.googleapis.com"

    depends_on = [google_billing_project_info.poc01_shared_pj_billing]
}


resource "google_compute_shared_vpc_host_project" "poc01_host" {
    project = google_project.poc01_shared_pj.project_id

    depends_on = [google_project_service.poc01_shared_pj_compute_api]
}

resource "google_compute_shared_vpc_service_project" "poc01_service_a_pj_service" {
    host_project = google_compute_shared_vpc_host_project.poc01_host.project
    service_project = google_project.poc01_service_a_pj.project_id

    depends_on = [
        google_compute_shared_vpc_host_project.poc01_host,
        google_project_service.poc01_service_a_pj_compute_api
    ]
}

resource "google_compute_shared_vpc_service_project" "poc01_service_b_pj_service" {
    host_project = google_compute_shared_vpc_host_project.poc01_host.project
    service_project = google_project.poc01_service_b_pj.project_id

    depends_on = [
        google_compute_shared_vpc_host_project.poc01_host,
        google_project_service.poc01_service_b_pj_compute_api
    ]
}