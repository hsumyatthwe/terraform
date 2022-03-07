#Build Webserver during Bootstrap
provider "aws" {
    region = "us-west-2"
}
resource "aws_instance" "web" {
    ami = "ami-0b9f27b05e1de14e9" // Amaxon Linux2
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data = [<<EOF 
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/lastest/meta-data/local-ipv4`
echo "<h2>Webserver with PrivateIP: $MYIP</h2><br>Build by Terraform" > /var/www.html/index.html
service httpd start
chkconfig httpd on
EOF]
    tags = {
        Name = "Webserver Build by Terraform"
        Owner = "Hsu"   
    }
}

resource "aws_security_group" "web" {
    name = "Webserver-ORG"
    description = "Security Group for my webserver"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
     ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
    }
    tags = {
        Name = "Webserver ORG by Terraform"
        Owner = "Hsu"
    }
}