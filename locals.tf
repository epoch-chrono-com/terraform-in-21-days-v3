locals {
  public_cidr = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
  private_cidr = [
    "10.0.100.0/24",
    "10.0.101.0/24",
    "10.0.102.0/24",
  ]
  availability_zones = [
    "sa-east-1a",
    "sa-east-1b",
    "sa-east-1c",
  ]
}
