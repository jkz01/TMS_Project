output "master-ip" {
  value = {
    for instance in aws_instance.master-node :
    instance.tags.Name => instance.public_ip
  }
}

output "worker-ip" {
  value = {
    for instance in aws_instance.worker-node :
    instance.tags.Name => instance.public_ip
  }
}

output "etcd-ip" {
  value = {
    for instance in aws_instance.etcd-node :
    instance.tags.Name => instance.public_ip
  }
}

/*output "ingress-ip" {
  value = {
    for instance in aws_instance.ingress-node :
    instance.tags.Name => instance.public_ip
  }
}
*/