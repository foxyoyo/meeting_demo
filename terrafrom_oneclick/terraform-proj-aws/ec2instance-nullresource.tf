# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]
  connection {
    type     = "ssh"
    host     = module.ec2_public.public_ip
    user     = "ubuntu"
    password = ""
    private_key = file("secrets/terraform-fox.pem")
    timeout  = "10m"
  }  

## File Provisioner: Copies the terraform-fox.pem file to /home/ubuntu/terraform-fox.pem
  provisioner "file" {
    source      = "secrets/terraform-fox.pem"
    destination = "/home/ubuntu/terraform-fox.pem"
  }
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /home/ubuntu/terraform-fox.pem",
      "echo 'Write init shell script in here'"

    ]
  }
## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-logs/"
    #on_failure = continue
  }

}
