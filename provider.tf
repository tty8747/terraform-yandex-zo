variable "yatoken" {}

provider "yandex" {
  token     = "${var.yatoken}"
  cloud_id  = "cloud-id"
  folder_id = "folder-id"
  zone      = "${var.zoneid}"
}
