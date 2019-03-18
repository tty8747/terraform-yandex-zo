resource "yandex_vpc_network" "zo-cloud" {
  name = "zo-cloud"
}

resource "yandex_vpc_subnet" "local" {
  name           = "local"
  zone           = "${var.ya-zone}"
  network_id     = "${yandex_vpc_network.zo-cloud.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_disk" "app-disk" {
  name        = "app-disk"
  description = "Disk for app and base"
  folder_id   = "${var.ya-folder-id}"
  type        = "network-nvme"
  zone        = "${var.ya-zone}"
  size        = "${var.size_disk_app}"

  labels {
    environment = "app-disk"
  }
}

resource "yandex_compute_instance" "pub-inst" {
  name = "proxy"

 allow_stopping_for_update = true

  resources {
    cores  = 1
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd83i5r5g44fjkdpuuva"
    }
  }

 secondary_disk {
    disk_id     = "${yandex_compute_disk.app-disk.id}"
    auto_delete = false
#   device_name = "/dev/xvdb"
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.local.id}"
    nat       = true
  }

  metadata {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "int-inst" {
  name = "app"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8k8h8lc4qht3pcgv4t"
      size     = 30
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.local.id}"
    nat       = false
  }

  metadata {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "internal_ip_address_proxy" {
  value = "${yandex_compute_instance.pub-inst.network_interface.0.ip_address}"
}

output "internal_ip_address_app" {
  value = "${yandex_compute_instance.int-inst.network_interface.0.ip_address}"
}


output "external_ip_address_proxy" {
  value = "${yandex_compute_instance.pub-inst.network_interface.0.nat_ip_address}"
}

output "external_ip_address_app" {
  value = "${yandex_compute_instance.int-inst.network_interface.0.nat_ip_address}"
}
