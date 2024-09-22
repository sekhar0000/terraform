resource "aws_key_pair" "dev-key" {
  key_name   = "devopskey"
  public_key = file("devkey.pub")
}

resource "aws_instance" "Rajdev" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.dev-key.key_name
  vpc_security_group_ids = ["sg-098b36477fe3a3ef5"]
  tags = {
    Name    = "dev-instance"
    Project = "Dev"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x  /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }
  connection {
   user = var.USER
  private_key = file("devopskey")
  host = self.public_ip
  }
}
