output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "private subnet ids"
  value       = module.vpc.private_subnets
}

output "route_table_id" {
  description = "private route table id"
  value       = module.vpc.private_route_table_ids
} 