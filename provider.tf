variable "ya-token" {}
variable "ya-cloud-id" {}
variable "ya-folder-id" {}
variable "ya-zone" {}

provider "yandex" {
  token     = "${var.ya-token}"
  cloud_id  = "${var.ya-cloud-id}"
  folder_id = "${var.ya-folder-id}"
  zone      = "${var.ya-zone}"
}
