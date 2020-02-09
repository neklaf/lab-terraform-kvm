# lab-terraform-kvm
Provision a VM on KVM with Terraform

### Initial setup
Clone the repository and install the dependencies:

```bash
$ git clone https://github.com/neklaf/lab-terraform-kvm.git
$ cd lab-terraform-kvm
$ terraform init
$ terraform plan
$ terraform apply
```

Tear down the whole infrastructure with:

```bash
$ terraform destroy -force
$ virsh undefine master
```

<div align="center">
   <sub>Created by
   <a href="https://twitter.com/AitorAcedo">AitorAcedo</a>
</div>
