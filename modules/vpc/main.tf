# VPC Settings
resource "aws_vpc" "{{ .Project }}-vpc" {
  cidr_block = "10.1.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink   = false

  instance_tenancy = "default"

  tags = {
    Name        = "{{ .Project }}-vpc"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

# Public Subnets Settings
resource "aws_subnet" "{{ .Project }}-public-a" {
  vpc_id = aws_vpc.{{ .Project }}-vpc.id
  #cidr_block        = "10.3.1.0/24"
  cidr_block        = cidrsubnet(aws_vpc.{{ .Project }}-vpc.cidr_block, 8, 1)
  availability_zone = var.availability_zone[terraform.workspace].a

  tags = {
    Name        = "{{ .Project }}-public-a"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

resource "aws_subnet" "{{ .Project }}-public-c" {
  vpc_id = aws_vpc.{{ .Project }}-vpc.id
  #cidr_block        = "10.3.3.0/24"
  cidr_block        = cidrsubnet(aws_vpc.{{ .Project }}-vpc.cidr_block, 8, 2)
  availability_zone = var.availability_zone[terraform.workspace].c

  tags = {
    Name        = "{{ .Project }}-public-c"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

# Private Subnets Settings
resource "aws_subnet" "{{ .Project }}-private-a" {
  vpc_id = aws_vpc.{{ .Project }}-vpc.id
  #cidr_block        = "10.3.100.0/24"
  cidr_block        = cidrsubnet(aws_vpc.{{ .Project }}-vpc.cidr_block, 8, 65)
  availability_zone = var.availability_zone[terraform.workspace].a

  tags = {
    Name        = "{{ .Project }}-private-a"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

resource "aws_subnet" "{{ .Project }}-private-c" {
  vpc_id = aws_vpc.{{ .Project }}-vpc.id
  #cidr_block        = "10.3.101.0/24"
  cidr_block        = cidrsubnet(aws_vpc.{{ .Project }}-vpc.cidr_block, 8, 66)
  availability_zone = var.availability_zone[terraform.workspace].c

  tags = {
    Name        = "{{ .Project }}-private-c"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

resource "aws_db_subnet_group" "{{ .Project }}-rds" {
  name        = "{{ .Project }}-rds"
  description = "It is a RDS subnet group on vpc."
  subnet_ids  = [aws_subnet.{{ .Project }}-private-a.id, aws_subnet.{{ .Project }}-private-c.id]
  tags = {
    Name = "{{ .Project }}-rds"
  }
}

# Routes Table Settings

# Default(Private)
resource "aws_default_route_table" "{{ .Project }}-default-route-table" {
  default_route_table_id = aws_vpc.{{ .Project }}-vpc.default_route_table_id

  tags = {
    Name        = "{{ .Project }}-default-route-table"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

resource "aws_route_table_association" "{{ .Project }}-route-private-a" {
  route_table_id = aws_default_route_table.{{ .Project }}-default-route-table.id
  subnet_id      = aws_subnet.{{ .Project }}-private-a.id
}

resource "aws_route_table_association" "{{ .Project }}-route-private-c" {
  route_table_id = aws_default_route_table.{{ .Project }}-default-route-table.id
  subnet_id      = aws_subnet.{{ .Project }}-private-c.id
}

# Public
resource "aws_route_table" "{{ .Project }}-public-route-table" {
  vpc_id = aws_vpc.{{ .Project }}-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.{{ .Project }}-igw.id
  }

  tags = {
    Name        = "{{ .Project }}-public-route-table"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}

resource "aws_route_table_association" "{{ .Project }}-route-public-a" {
  route_table_id = aws_route_table.{{ .Project }}-public-route-table.id
  subnet_id      = aws_subnet.{{ .Project }}-public-a.id
}

resource "aws_route_table_association" "{{ .Project }}-route-public-c" {
  route_table_id = aws_route_table.{{ .Project }}-public-route-table.id
  subnet_id      = aws_subnet.{{ .Project }}-public-c.id
}

# Internet Gateway Settings
resource "aws_internet_gateway" "{{ .Project }}-igw" {
  vpc_id = aws_vpc.{{ .Project }}-vpc.id

  tags = {
    Name        = "{{ .Project }}-igw"
    Environment = terraform.workspace
    Workspace   = terraform.workspace
  }
}
