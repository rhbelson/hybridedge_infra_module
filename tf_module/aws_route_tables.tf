# Create Region Route Table for regular subnets
resource "aws_route_table" "region_route_table" {
  vpc_id = aws_vpc.hyb303_vpc.id
  tags = {
    Name = "Region Route Table"
  }
}

# Setup Region Route (for IGW)
resource "aws_route" "region_route" {
  route_table_id         = aws_route_table.region_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hyb303_internet_gw.id
}

# Associate Route Table with region subnets
resource "aws_route_table_association" "region_route_associations" {
  for_each       = var.availability_zones
  subnet_id      = aws_subnet.region_subnets[each.key].id
  route_table_id = aws_route_table.region_route_table.id
}


# -------------------------------------------------------------------------------

# Create Wavelength Route Table for Wavelength subnets
resource "aws_route_table" "WLZ_route_table" {
  vpc_id = aws_vpc.hyb303_vpc.id
  tags = {
    Name = "Wavelength Zone Route Table"
  }
}

# Setup Wavelength Route (for CGW)
resource "aws_route" "WLZ_route" {
  route_table_id         = aws_route_table.WLZ_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  carrier_gateway_id     = aws_ec2_carrier_gateway.hyb303_carrier_gateway.id
}

# Associate Wavelength Route Table with Wavelength Zone subnets
resource "aws_route_table_association" "WLZ_route_associations" {
  for_each       = var.wavelength_zones
  subnet_id      = aws_subnet.wavelength_subnets[each.key].id
  route_table_id = aws_route_table.WLZ_route_table.id
}


# -------------------------------------------------------------------------------

# Create Local Zone Routing
resource "aws_route_table_association" "LZ_route_associations" {
  for_each       = var.local_zones
  subnet_id      = aws_subnet.localzones_subnets[each.key].id
  route_table_id = aws_route_table.region_route_table.id
}
