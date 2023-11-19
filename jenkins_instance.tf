resource "aws_instance" "Jenkins_Instance" {
  instance_type     = "t2.small"
  availability_zone = "us-east-1a"
  ami = "ami-0fc5d935ebf8bc3bc" // Ubuntu Server 22.04
  user_data = file("${path.module}/userdata/jenkins.sh")
  vpc_security_group_ids = [aws_security_group.JenkinsSG.id]
  key_name = "RSA_Key"
  tags = {
  Name = "JenkinsInstance"
  }
}