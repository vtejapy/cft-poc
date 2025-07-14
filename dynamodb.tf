#dny

```
module "dynamodb_table" {
  source = "./modules/dynamodb"

  name         = "queue-experience-db-${var.client}-${var.region}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "contactId"
  #range_key      = "timestamp"
  read_capacity  = 10
  write_capacity = 10

  attributes = [
    {
      name = "contactId"
      type = "S"
    },
    {
      name = "channel"
      type = "S"
    },
    {
      name = "queueName"
      type = "S"
    },
    {
      name = "timestamp"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "QueueNameIndex"
      hash_key        = "queueName"
      projection_type = "ALL"
      write_capacity  = 0
      read_capacity   = 0
    },
    {
      name            = "TimestampIndex"
      hash_key        = "timestamp"
      projection_type = "ALL"
      write_capacity  = 0
      read_capacity   = 0
    },
    {
      name            = "ChannelIndex"
      hash_key        = "channel"
      projection_type = "ALL"
      write_capacity  = 0
      read_capacity   = 0
    }
  ]

  tags = merge(local.common_tags, {
    name = "queue-experience-db-${var.client}-${var.region}-${var.environment}"
  })
}

```