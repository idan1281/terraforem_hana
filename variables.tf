# Variables section
variable "region" { default = "eu-de-1" } #Other region `au-ap-1`
#variable "image" { default = "sles-12-sp1-amd64-vmware-build113" }
variable "image" { } # the default is the newest sles image - it is being greped via the source file
variable "guest_os" { default = "linux" }
variable "key_pair" { default = "Idan-Pub2" }
variable "db_flavor" { default = "60" }
variable "security_group" { default = "default" }
variable "ssh_user_name" { default = "ccloud" }
variable "ssh_key_path" { default = "/Users/c5240533/.ssh/id_rsa" } # On macOS, it is `/Users/<your_user_name>/.ssh/id_rsa`; on Windows `C:\Users\<your_user_name>\.ssh\id_rsa`
variable "hana_tag" { default = "hana_single" }
variable "dns_enabled" { default = "false"}
variable "hana_revision" { default = "00"}
variable "hana_type" { default = "hana-single"}
#variable "s4h_version" { default = "1506"} #in app json it is referenced as SAPERP_VERSION
variable "fip_pool" {default = "FloatingIP-internal-monsoon3"}

