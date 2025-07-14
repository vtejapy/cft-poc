#enpoint
```
# api gateway endpoint contact center core
resource "aws_security_group" "contact_center_core_endpoint_sg" {
  name        = "contact-center-core-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "contact-center-core-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "contact_center_core_endpoint_sg_ingress" {
  security_group_id = aws_security_group.contact_center_core_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact-center-core-api-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "contact_center_core_endpoint_sg_egress" {

  security_group_id = aws_security_group.contact_center_core_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact_center_core_api-egress"
  })
}

# resource "aws_vpc_security_group_egress_rule" "apigateway_edht_sg_egress" {

#   security_group_id = aws_security_group.contact_center_core_endpoint_sg.id
#   cidr_ipv4         = "10.0.0.0/8"
#   description       = "Allow egress from vpc endpoint security group"
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "apigateway-edht-egress"
#   })
# }

resource "aws_vpc_endpoint" "contact_center_core_api" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.execute-api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.contact_center_core_endpoint_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "contact-center-core-api-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

#api gateway endpoint 2
resource "aws_security_group" "command_center_api_sg" {
  name        = "command-center-api-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "command-center-api-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}


resource "aws_vpc_security_group_ingress_rule" "command_center_default_sg_ingress" {
  description       = "Allow ingress from application load balancer"
  security_group_id = aws_security_group.command_center_api_sg.id
  cidr_ipv4         = "10.0.0.0/8"
  #referenced_security_group_id = aws_security_group.private_alb_sg.id
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  tags = merge(local.common_tags, {
    Name = "command_center-api-default-sg-ingress"
  })
}
# resource "aws_vpc_security_group_ingress_rule" "apigateway_2_ingress_localVDI" {
#   for_each          = var.environment != "prod" ? toset(var.dev_vdi_cidrs) : []
#   description       = "Allow ingress to local machines using VDIs for developers"
#   security_group_id = aws_security_group.command_center_api_sg.id
#   cidr_ipv4         = each.value
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
#   tags = merge(local.common_tags, {
#     Name = "command-center-api-endpoint-ingress-localVDI"
#   })
# }

# resource "aws_vpc_security_group_ingress_rule" "apigateway_2_ingress_localLaptops" {
#   for_each          = var.environment != "prod" ? toset(var.dev_laptop_cidrs) : []
#   description       = "Allow ingress to local machines using laptops for developers"
#   security_group_id = aws_security_group.command_center_api_sg.id
#   cidr_ipv4         = each.value
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
#   tags = merge(local.common_tags, {
#     Name = "command-center-api-endpoint-ingress-localLaptops"
#   })
# }

resource "aws_vpc_security_group_egress_rule" "command_center_api_sg_egress" {
  security_group_id = aws_security_group.command_center_api_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "contact_center_core_api-egress"
  })
}

# resource "aws_vpc_security_group_egress_rule" "command_center_edht_sg_egress" {

#   security_group_id = aws_security_group.command_center_sg.id
#   cidr_ipv4         = "10.0.0.0/8"
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "command-center-api-endpoint-edht-egress"
#   })
# }

resource "aws_vpc_endpoint" "command_center" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.execute-api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.command_center_api_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = false
  tags = merge(local.common_tags, {
    Name = "command-center-api-endpoint-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })
}


# ########



# data "aws_subnet" "subnet_details" {
#   count = length(module.vpc.private_subnet_ids)
#   id    = module.vpc.private_subnet_ids[count.index]
# }

locals {
  skip_az    = var.environment == "prod" ? "us-east-1a" : "us-east-1c"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id if subnet.availability_zone != local.skip_az]
}


resource "aws_security_group" "s3_endpoint_sg" {
  name        = "s3-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "s3-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

# resource "aws_vpc_security_group_ingress_rule" "s3_endpoint_sg_ingress" {
#   security_group_id = aws_security_group.s3_endpoint_sg.id
#   cidr_ipv4         = var.vpc_cidr
#   description       = "Allow ingress from vpc endpoint security group"
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "s3-endpoint-ingress"
#   })
# }

resource "aws_vpc_security_group_ingress_rule" "s3_endpoint_vpc_cidr_sg_ingress" {
  security_group_id = aws_security_group.s3_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "s3-endpoint-vpc-cidr-ingress"
  })
}
resource "aws_vpc_security_group_ingress_rule" "s3_endpoint_http_sg_ingress" {
  security_group_id = aws_security_group.s3_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "s3-endpoint-http-ingress"
  })
}
resource "aws_vpc_security_group_egress_rule" "s3_endpoint_http_sg_egress" {

  security_group_id = aws_security_group.s3_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "s3-endpoint-http-egress"
  })
}
resource "aws_vpc_security_group_egress_rule" "s3_endpoint_sg_egress" {

  security_group_id = aws_security_group.s3_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "s3-endpoint-egress"
  })
}

data "aws_prefix_list" "private_s3" {
  name = "com.amazonaws.${var.region}.s3"
}
resource "aws_security_group_rule" "egress_s3" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_prefix_list.private_s3.id]
  security_group_id = aws_security_group.s3_endpoint_sg.id
}


resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id             = aws_vpc.genpact_poc_vpc.id
  service_name       = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.s3_endpoint_sg.id]
  subnet_ids         = flatten([aws_subnet.private[*].id])
  tags = merge(local.common_tags, {
    Name = "s3-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}


# #secret manager endpoint
resource "aws_security_group" "secretmanager_endpoint_sg" {
  name        = "secretmanager-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "secretmanager-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "secretmanager_endpoint_sg_ingress" {
  security_group_id = aws_security_group.secretmanager_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "secretmanager-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "secretmanager_endpoint_sg_egress" {

  security_group_id = aws_security_group.secretmanager_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "secretmanager-endpoint-egress"
  })
}

resource "aws_vpc_endpoint" "secretmanager_endpoint" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.secretmanager_endpoint_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "secretmanager-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

#api gateway endpoint
# resource "aws_security_group" "contact_center_core_api_sg" {
#   name        = "contact-center-core-api-sg-${var.client}-${var.region}-${var.environment}"
#   description = "Allow tcp inbound traffic from vpc endpoint security group"
#   vpc_id      = aws_vpc.genpact_poc_vpc.id

#   tags = merge(local.common_tags, {
#     Name = "contact-center-core-api-sg-${var.client}-${var.region}-${var.environment}"
#   })
# }

# # data "aws_security_group" "default_sg" {
# #   name = "default"
# # }


# # resource "aws_vpc_security_group_ingress_rule" "apigateway_default_sg_ingress" {
# #   security_group_id            = aws_security_group.contact_center_core_api_sg.id
# #   referenced_security_group_id = data.aws_security_group.default_sg.id
# #   description                  = "Allow ingress from default security group"
# #   from_port                    = 443
# #   to_port                      = 443
# #   ip_protocol                  = "tcp"
# #   tags = merge(local.common_tags, {
# #     Name = "apigateway-default-sg-ingress"
# #   })
# # }

# resource "aws_vpc_security_group_ingress_rule" "contact_center_core_api_sg_ingress" {
#   security_group_id            = aws_security_group.contact_center_core_api_sg.id
#   cidr_ipv4                    = var.vpc_cidr
#   description                  = "Allow ingress from vpc endpoint security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "contact_center_core_api-ingress-${var.client}-${var.region}-${var.environment}"
#   })
# }

# resource "aws_vpc_security_group_egress_rule" "contact_center_core_api_sg_egress" {

#   security_group_id            = aws_security_group.contact_center_core_api_sg.id
#   referenced_security_group_id = aws_security_group.lambda_sg.id
#   description                  = "Allow egress from vpc endpoint security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "contact_center_core_api-egress"
#   })
# }

# resource "aws_vpc_security_group_egress_rule" "contact_center_core_api_sg_egress" {

#   security_group_id = aws_security_group.contact_center_core_api_sg.id
#   cidr_ipv4         = var.vpc_cidr
#   description       = "Allow egress from vpc endpoint security group"
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"v
#   tags = merge(local.common_tags, {
#     Name = "contact_center_core_api-egress-${var.client}-${var.region}-${var.environment}"
#   })
#}

# resource "aws_vpc_endpoint" "contact_center_core_api" {
#   vpc_id              = aws_vpc.genpact_poc_vpc.id
#   service_name        = "com.amazonaws.${var.region}.execute-api"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.contact_center_core_api_sg.id]
#   subnet_ids          = flatten([aws_subnet.private[*].id])
#   private_dns_enabled = true
#   tags = merge(local.common_tags, {
#     Name = "apigateway-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
#   })

# }

#comprehend
resource "aws_security_group" "comprehend_endpoint_sg" {
  name        = "comprehend-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "comprehend-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

# resource "aws_vpc_security_group_ingress_rule" "comprehend_default_sg_ingress" {
#   security_group_id            = aws_security_group.comprehend_endpoint_sg.id
#   referenced_security_group_id = data.aws_security_group.default_sg.id
#   description                  = "Allow ingress from default security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "comprehend-default-sg-ingress"
#   })
# }
resource "aws_vpc_security_group_ingress_rule" "comprehend_endpoint_sg_ingress" {
  security_group_id = aws_security_group.comprehend_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "comprehend-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "comprehend_endpoint_sg_egress" {

  security_group_id = aws_security_group.comprehend_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "comprehend-endpoint-egress"
  })
}

resource "aws_vpc_endpoint" "comprehend_endpoint" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.comprehend"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.contact_center_core_api_sg.id]
  subnet_ids          = local.subnet_ids
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "comprehend-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

#transcribe
resource "aws_security_group" "transcribe_endpoint_sg" {
  name        = "transcribe-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "transcribe-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

# resource "aws_vpc_security_group_ingress_rule" "transcribe_default_sg_ingress" {
#   security_group_id            = aws_security_group.transcribe_endpoint_sg.id
#   referenced_security_group_id = data.aws_security_group.default_sg.id
#   description                  = "Allow ingress from default security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "transcribe-default-sg-ingress"
#   })
# }
resource "aws_vpc_security_group_ingress_rule" "transcribe_endpoint_sg_ingress" {
  security_group_id = aws_security_group.transcribe_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "transcribe-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "transcribe_endpoint_sg_egress" {

  security_group_id = aws_security_group.transcribe_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "transcribe-endpoint-egress"
  })
}

resource "aws_vpc_endpoint" "transcribe_endpoint" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.transcribe"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.contact_center_core_api_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "transcribes-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

#amazon connect app integration endpoint
resource "aws_security_group" "amazon_connect_endpoint_sg" {
  name        = "amazon-connect-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "amazon-connect-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

# resource "aws_vpc_security_group_ingress_rule" "amazon_connect_default_sg_ingress" {
#   security_group_id            = aws_security_group.amazon_connect_endpoint_sg.id
#   referenced_security_group_id = data.aws_security_group.default_sg.id
#   description                  = "Allow ingress from default security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "amazon-connect-default-sg-ingress"
#   })
# }
resource "aws_vpc_security_group_ingress_rule" "amazon_connect_endpoint_sg_ingress" {
  security_group_id = aws_security_group.amazon_connect_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "amazon-connect-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "amazon_connect_endpoint_sg_egress" {

  security_group_id = aws_security_group.amazon_connect_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "amazon-connect-endpoint-egress"
  })
}


resource "aws_vpc_endpoint" "amazon_connect_endpoint" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.app-integrations"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.amazon_connect_endpoint_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "amazon-connect-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

#dynamodb endpoint
resource "aws_security_group" "dynamodb_endpoint_sg" {
  name        = "dynamodb-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "dynamodb-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "dynamodb_sg_ingress" {
  security_group_id = aws_security_group.dynamodb_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from default security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "dynamodb-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "dynamodb_endpoint_sg_egress" {

  security_group_id = aws_security_group.dynamodb_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "dynamodb-endpoint-egress"
  })
}


resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id             = aws_vpc.genpact_poc_vpc.id
  service_name       = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.dynamodb_endpoint_sg.id]
  subnet_ids         = flatten([aws_subnet.private[*].id])
  tags = merge(local.common_tags, {
    Name = "dynamodb-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

# #api gateway endpoint 2
# resource "aws_security_group" "command_center_api_endpoint_sg" {
#   name        = "command-center-api-endpoint-sg-${var.client}-${var.region}-${var.environment}"
#   description = "Allow tcp inbound traffic from vpc endpoint security group"
#   vpc_id      = aws_vpc.genpact_poc_vpc.id

#   tags = merge(local.common_tags, {
#     Name = "command-center-api-endpoint-sg-${var.client}-${var.region}-${var.environment}"
#   })
# }


# resource "aws_vpc_security_group_ingress_rule" "command_center_api_sg_ingress" {
#   description                  = "Allow ingress from application load balancer"
#   security_group_id            = aws_security_group.command_center_api_endpoint_sg.id
#   cidr_ipv4                    = var.vpc_cidr
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "command-center-api-endpoint-default-sg-ingress-${var.client}-${var.region}-${var.environment}"
#   })
# }
# # resource "aws_vpc_security_group_ingress_rule" "command_center_api_localVDI" {
# #   for_each          = var.environment != "prod" ? toset(var.dev_vdi_cidrs) : []
# #   description       = "Allow ingress to local machines using VDIs for developers"
# #   security_group_id = aws_security_group.command_center_api_endpoint_sg.id
# #   cidr_ipv4         = each.value
# #   from_port         = 443
# #   ip_protocol       = "tcp"
# #   to_port           = 443
# #   tags = merge(local.common_tags, {
# #     Name = "command-center-api-endpoint-ingress-localVDI"
# #   })
# # }

# # resource "aws_vpc_security_group_ingress_rule" "command_center_api_ingress_localLaptops" {
# #   for_each          = var.environment != "prod" ? toset(var.dev_laptop_cidrs) : []
# #   description       = "Allow ingress to local machines using laptops for developers"
# #   security_group_id = aws_security_group.command_center_api_endpoint_sg.id
# #   cidr_ipv4         = each.value
# #   from_port         = 443
# #   ip_protocol       = "tcp"
# #   to_port           = 443
# #   tags = merge(local.common_tags, {
# #     Name = "command-center-api-endpoint-ingress-localLaptops"
# #   })
# # }

# resource "aws_vpc_security_group_egress_rule" "command_center_api_endpoint_sg_egress" {
#   security_group_id            = aws_security_group.command_center_api_endpoint_sg.id
#   cidr_ipv4                    = var.vpc_cidr
#   description                  = "Allow egress from vpc endpoint security group"
#   from_port                    = 443
#   to_port                      = 443
#   ip_protocol                  = "tcp"
#   tags = merge(local.common_tags, {
#     Name = "contact_center_core_api-egress-${var.client}-${var.region}-${var.environment}"
#   })
# }

# # resource "aws_vpc_security_group_egress_rule" "apigateway_2_edht_sg_egress" {

# #   security_group_id = aws_security_group.command_center_api_endpoint_sg.id
# #   cidr_ipv4         = var.edh_cidr
# #   from_port         = 443
# #   to_port           = 443
# #   ip_protocol       = "tcp"
# #   tags = merge(local.common_tags, {
# #     Name = "command-center-api-endpoint-edht-egress-${var.client}-${var.region}-${var.environment}"
# #   })
# # }

# resource "aws_vpc_endpoint" "command_center_api_endpoint" {
#   vpc_id              = aws_vpc.genpact_poc_vpc.id
#   service_name        = "com.amazonaws.${var.region}.execute-api"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.command_center_api_endpoint_sg.id]
#   subnet_ids          = flatten([aws_subnet.private[*].id])
#   private_dns_enabled = false
#   tags = merge(local.common_tags, {
#     Name = "command-center-api-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
#   })
# }

#Lex v2 VPC endpoint
resource "aws_security_group" "lex_v2_endpoint_sg" {
  name        = "lex-v2-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "lex-v2-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "lex_v2_endpoint_sg_ingress" {
  security_group_id = aws_security_group.lex_v2_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "lex-v2-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "lex_v2_endpoint_sg_egress" {

  security_group_id = aws_security_group.lex_v2_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "lex-v2-endpoint-egress"
  })
}

resource "aws_vpc_endpoint" "lex_v2_endpoint" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.runtime-v2-lex"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.lex_v2_endpoint_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "lex-v2-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

#Lmabda VPC endpoint
resource "aws_security_group" "lambda_endpoint_sg" {
  name        = "lambda-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  description = "Allow tcp inbound traffic from vpc endpoint security group"
  vpc_id      = aws_vpc.genpact_poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "lambda-endpoint-sg-${var.client}-${var.region}-${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "lambda_endpoint_sg_ingress" {
  security_group_id = aws_security_group.lambda_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow ingress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "lambda-vpc-endpoint-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "lambda_endpoint_sg_egress" {

  security_group_id = aws_security_group.lambda_endpoint_sg.id
  cidr_ipv4         = var.vpc_cidr
  description       = "Allow egress from vpc endpoint security group"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(local.common_tags, {
    Name = "lambda-vpc-endpoint-egress"
  })
}

resource "aws_vpc_endpoint" "lambda_vpc_endpoint" {
  vpc_id              = aws_vpc.genpact_poc_vpc.id
  service_name        = "com.amazonaws.${var.region}.lambda"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.lambda_endpoint_sg.id]
  subnet_ids          = flatten([aws_subnet.private[*].id])
  private_dns_enabled = true
  tags = merge(local.common_tags, {
    Name = "lambda-vpc-endpoint-${var.client}-${var.region}-${var.environment}"
  })

}

```