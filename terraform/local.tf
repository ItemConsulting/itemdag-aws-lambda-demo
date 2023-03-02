
locals {
  tags = {
    CostCenter: "demo"
    ManagedBy: "terraform"
    Owner: var.name
  }

  prefix = "${var.name}-"
  bucket = "item-lambdas"

  url = "https://www.item.no"
  searchFor = var.name
}
