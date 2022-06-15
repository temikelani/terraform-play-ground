resource "aws_instance" "server" {
  ami           = "ami-0528a5175983e7f28"
  instance_type = "t2.micro"
  associate_public_ip_address = var.associate_public_ip_address


  # Dynamic blocks can be used for resources that contain repeatable configuration blocks. Instead of repeating several ebs_block_device blocks, a dynamic block is used to simplify the code. 
  
  # This is done by combining the dynamic block with a for_each loop inside. The first line inside the dynamic block is the for_each loop. The loop is iterating through the list of the ebs_block_device variable, which is a list of maps. 
  
  # In the content block, each value of the map is referenced using the lookup function. The logic here is to look for a value in the map variable and if it's not there, set the value to null. The dynamic block will iterate through each map in the list: 

  #dynamic block with for_each loop
  dynamic "ebs_block_device" {
  for_each = var.ebs_block_device
      content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      }
  }

  tags = {
      Name = "${var.servername}"
  }
}

#public IP address with Count Conditional Expression
resource "aws_eip" "pip" {
  count             = var.associate_public_ip_address ? 1 : 0
  network_interface = aws_instance.server.primary_network_interface_id
  vpc               = true
}

