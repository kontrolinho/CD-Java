resource "aws_instance" "Ansible_Instance02" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  ami = "ami-0fc5d935ebf8bc3bc" // Ubuntu Server 22.04
  vpc_security_group_ids = [aws_security_group.AnsibleSG]
  key_name = "RSA_Key"
  tags = {
  Name = "AnsibleInstance"
  }
}