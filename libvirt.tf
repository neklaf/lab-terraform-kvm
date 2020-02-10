# add the provider, this code will connect to Hypervisor using libvirt
provider "libvirt" {
  uri = "qemu:///system"
}

# create pool
resource "libvirt_pool" "debian" {
 provisioner "local-exec" {
    command = "mkdir -p ${path.module}/images/debian_pool"
 }
 name = "debian-pool"
 type = "dir"
 path = "${path.module}/images/debian_pool"
}

# create image volume
resource "libvirt_volume" "image-qcow2" {
 name = "debian-buster-amd64.qcow2"
 pool = libvirt_pool.debian.name
 ##source = "https://gofile.io/?c=twT3jg"
 ##source = "${path.module}/images/debian_pool/base.qcow2"
 source = "https://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2"
 format = "qcow2"
}

# add cloudinit disk to pool
resource "libvirt_cloudinit_disk" "commoninit" {
 name = "commoninit.iso"
 pool = libvirt_pool.debian.name
 user_data = data.template_file.user_data.rendered
}

# read the configuration
data "template_file" "user_data" {
 template = file("${path.module}/cloud_init.cfg")
}

# Define KVM domain to create
resource "libvirt_domain" "master" {
  name   = "master"
  memory = "4096"
  vcpu   = 2

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.image-qcow2.id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

# type = "none" not supported by the provider
  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
