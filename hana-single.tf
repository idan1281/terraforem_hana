#variable "image" {}
# Provider section
provider "openstack" {
}

#create Disk for Hana_DB
resource "openstack_blockstorage_volume_v2" "vol_hana_2" {
 region = "${var.region}"
 name = "vol_db_2"
 description = "Volume for Hana_DB_2"
 availability_zone = "${var.availability_zone}"
 size = 100 # in Giga Byte
}

# create an FIP for Hana_DB
resource "openstack_networking_floatingip_v2" "db_ip_2"
{
        pool = "${var.fip_pool}"
}

## installing Hana_DB server
resource "openstack_compute_instance_v2" "db_instance_2"
{
  name = "demo-hana-single_2"
  region = "${var.region}"
  image_name = "${var.image}"
 # image_name = "sles-12-sp1-amd64-vmware-build115"
  flavor_id = "${var.db_flavor}"
  key_pair = "${var.key_pair}"
  security_groups = ["default"]
  availability_zone = "${var.availability_zone}"

  # Attach the Volume
  volume {
    device = "/dev/sdc"
    volume_id = "${openstack_blockstorage_volume_v2.vol_hana_2.id}"
}

  # Connection details
  connection
  {
    user = "${ var.ssh_user_name }"
    private_key = "${file("${var.ssh_key_path}")}"
    agent = false
  }

  # Create an internal ip and attach floating ip to it
  network
  {
    name = "${var.net_name}"
    uuid = "${var.net_id}"
   # uuid = "431361d3-e329-4f1b-9135-2819a3e9c6cd"
   # name = "Private-corp-sap-shared-01"
    floating_ip = "${openstack_networking_floatingip_v2.db_ip_2.address}"
    access_network = true  # Whether to use this network to access the instance or provision
  }
}

  #Post Install Script after instance creation
  resource "null_resource" "db" {
    triggers {
      db_instance_id = "${ openstack_compute_instance_v2.db_instance_2.id }"
    }

    # Connection details to do provision
    connection {
      host = "${ openstack_networking_floatingip_v2.db_ip_2.address  }"
      user = "${ var.ssh_user_name }"
      private_key = "${file("${var.ssh_key_path}")}"
      agent = false
    }

    # generate attribute file in json format
    provisioner  "local-exec" "create_db_json_script" {
      command = "scripts/json_create-hana-single.sh ${ var.hana_type } ${ var.hana_revision } ${openstack_blockstorage_volume_v2.vol_hana_2.id} ${var.region}"
    }

    # Calling lyra_install script which takes care of lyra client installation locally.
    provisioner "local-exec" "call_lyra_script" {
      command = "scripts/lyra_install.sh ${openstack_compute_instance_v2.db_instance_2.id} ${ var.guest_os }"
    }

    # Script to run on target instance to clean up previous arc installation, useful for subsequent provisions.
    provisioner "remote-exec" {
      inline = [
        "sudo systemctl stop arc.service",
        "sudo rm -rf /opt/arc"
      ]
    }

    # Copy the three lines arc install script to target instance and run it from there
    provisioner "remote-exec" {
      script = "tmp/INS_${openstack_compute_instance_v2.db_instance_2.id}.sh"
    }

    # create automation according to the hana_type variable  
    provisioner "local-exec" "call_automation_script" {
      command = "scripts/automation_create_hana-single.sh ${openstack_compute_instance_v2.db_instance_2.id} ${ var.hana_type }"
    }
  }
 output "hana_version" {
   value = "${ var.hana_type }"
 }

 output "hana_floating_ip" {
   value = "${ openstack_networking_floatingip_v2.db_ip_2.address  }"
 }

 output "hana_instance_name" {
  value = "${openstack_compute_instance_v2.db_instance_2.name}"
 }
