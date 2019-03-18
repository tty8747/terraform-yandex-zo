resource "yandex_vpc_network" "zo-cloud" {
  name = "zo-cloud"
}

resource "yandex_vpc_subnet" "local" {
  name           = "local"
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.zo-cloud.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "pub-inst" {
  name = "proxy"

  resources {
    cores  = 1
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = "fd87va5cc00gaq2f5qfb"
    }
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
    cores  = 1
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = "fd87va5cc00gaq2f5qfb"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.local.id}"
    nat       = true
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
