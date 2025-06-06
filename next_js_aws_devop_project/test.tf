# resource "tls_private_key" "pri_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "keypair" {
#   key_name   = "keypair"
#   public_key = tls_private_key.pri_key.public_key_openssh

#   provisioner "local-exec"
#     command = "echo '${tls_private_key.pri_key.private_key_pem}' > ./my-keypair.pem"
#   }
# }