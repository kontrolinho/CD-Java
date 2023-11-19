resource "aws_instance" "Nexus_Instance" {
  instance_type     = "t2.medium"
  availability_zone = "us-east-1a"
  ami = "ami-0df2a11dd1fe1f8e3" //CentOS
  user_data = file("${path.module}/userdata/nexus.sh")
  vpc_security_group_ids = [aws_security_group.NexusSG.id]
  key_name = "RSA_Key"
  tags = {
  Name = "NexusInstance"
  }
}