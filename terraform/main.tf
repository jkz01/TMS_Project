provider "aws" {
  profile    = "default"
  region     = "us-west-2"
}
resource "aws_instance" "master-node" {
  ami = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_pair
  count = var.master-count
  tags = {
    Name = "${var.master-name}-${count.index + 1}"
      }
}

resource "aws_instance" "worker-node" {
  ami = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_pair
  count = var.worker-count
  tags = {
    Name = "${var.worker-name}-${count.index + 1}"
      }
}

resource "aws_instance" "etcd-node" {
  ami = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_pair
  count = var.etcd-count
  tags = {
    Name = "${var.etcd-name}-${count.index + 1}"
      }
}

resource "local_file" "hosts_cfg" {
  content = templatefile("templates/inventory.tpl",
    {
      master-node = aws_instance.master-node.*.public_ip
      etcd-node = aws_instance.etcd-node.*.public_ip
      worker-node = aws_instance.worker-node.*.public_ip
    }
  )
  filename = "./hosts"
}