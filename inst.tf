resource "yandex_vpc_network" "local" {
  name = "local"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.local.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "pubinst" {
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
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "intinst" {
  name = "app"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd87va5cc00gaq2f5qfb"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "internal_ip_address_proxy" {
  value = "${yandex_compute_instance.pubinst.network_interface.0.ip_address}"
}

output "internal_ip_address_app" {
  value = "${yandex_compute_instance.intinst.network_interface.0.ip_address}"
}


output "external_ip_address_proxy" {
  value = "${yandex_compute_instance.pubinst.network_interface.0.nat_ip_address}"
}

output "external_ip_address_app" {
  value = "${yandex_compute_instance.intinst.network_interface.0.nat_ip_address}"
}
