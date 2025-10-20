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

data "google_folders" "all_L2_folders" {
    parent_id = "organizations/${var.org_id}"
}

locals {
    folder_non_prod = one([
        for f in data.google_folders.all_L2_folders.folders : f
        if f.display_name == "Non-Prod"
    ])
}

data "google_folders" "all_non_prod_folders" {
    parent_id = local.folder_non_prod.name
}

locals {
    folder_poc = one([
        for f in data.google_folders.all_non_prod_folders.folders : f
        if f.display_name == "PoC"
    ])
}

# PoC共有プロジェクトフォルダ
resource "google_folder" "poc_shared" {
    display_name = "poc-shared"
    parent = local.folder_poc.name

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
    parent = local.folder_poc.name

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
    parent = local.folder_poc.name

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