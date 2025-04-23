resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  # you can provide the public key as below
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEOgYI9zsWR23z46SxT6DwYCEpU63M7hkS178IPdLGr+ DELL@DESKTOP-FBTQHV4"
  # Or you can provide the public key file as below
  public_key = file("~/.ssh/openvpn.pub")
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #convert a StingList to List and select 1st element of the List
  subnet_id              = element (split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
# subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  associate_public_ip_address = true
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}