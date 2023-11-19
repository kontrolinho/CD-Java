// Jenkins Security Group
resource "aws_security_group" "JenkinsSG" {
  name = "JenkinsSG"
  description = "Jenkins Security Group"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // ::/0
  }

    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Nexus Security Group
resource "aws_security_group" "NexusSG" {
    name = "NexusSG"
    description = "Nexus Security Group to Access Jenkins"

    ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    security_groups = ["${aws_security_group.JenkinsSG.id}"]
    }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Sonar Security Group
resource "aws_security_group" "SonarSG" {
    name = "SonarSG"
    description = "Sonar Security Group to Access Jenkins"

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.JenkinsSG.id}"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Editing JenkinsSG to Add Sonar Inbound Rule
resource "aws_security_group_rule" "EditJenkins" {
    depends_on = [aws_security_group.JenkinsSG, aws_security_group.SonarSG]
    security_group_id = "${aws_security_group.JenkinsSG.id}"
    type = "ingress"
    to_port = 8080
    from_port = 8080
    protocol = "tcp"
    source_security_group_id = "${aws_security_group.SonarSG.id}"
}