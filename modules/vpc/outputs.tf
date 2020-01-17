output "vpc-id" {
  value = aws_vpc.{{ .Project }}-vpc.id
}

output "subnet-public-a-id" {
  value = aws_subnet.{{ .Project }}-public-a.id
}

output "subnet-public-c-id" {
  value = aws_subnet.{{ .Project }}-public-c.id
}

output "subnet-group-rds-name" {
  value = aws_db_subnet_group.{{ .Project }}-rds.name
}

output "subnet-public-a-cidr-block" {
  value = aws_subnet.{{ .Project }}-public-a.cidr_block
}

output "subnet-public-c-cidr-block" {
  value = aws_subnet.{{ .Project }}-public-c.cidr_block
}

output "subnet-private-a-cidr-block" {
  value = aws_subnet.{{ .Project }}-private-a.cidr_block
}

output "subnet-private-c-cidr-block" {
  value = aws_subnet.{{ .Project }}-private-c.cidr_block
}
