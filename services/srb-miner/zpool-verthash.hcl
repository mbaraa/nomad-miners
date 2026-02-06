variable "payout" {
  type = object({
    coin = string
    address = string
  })
  default = {
    coin = "LTC"
    address = "LTfkcReKYwSjYyc7G8F41BvykZFpWFxmS6"
  }
}

variable "miners" {
  type = map(object({
    threads = number
    memory  = number
  }))
  default = {
    # "rex" = { threads = 2, memory = 3072 }
    # "leon" = { threads = 2, memory = 3072 }
    # "tucker" = { threads = 2, memory = 3072 }
    # "mike" = { threads = 2, memory = 3072 }
    "ziemowit" = { threads = 2, memory = 3072 }
    # "jack" = { threads = 2, memory = 3072 }
  }
}

job "srb-miner-zpool" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["srb-miner-verthash-${group.key}"]

    content {
      constraint {
        attribute = "${node.unique.name}"
        value     = group.key
      }

      task "srb-miner-task" {
        user   = "root"
        driver = "raw_exec"

        resources {
          cores  = group.value.threads
          memory = group.value.memory
        }

        config {
          work_dir = "/opt/miners/SRBMiner-Multi"
          command = "/opt/miners/SRBMiner-Multi/SRBMiner-MULTI"
          args = [
            "--algorithm", "verthash",
            "--pool", "verthash.eu.mine.zpool.ca:6144",
            "--wallet", "${var.payout.address}",
            "--password", "${group.key},c=${var.payout.coin}",
            "--disable-cpu",
          ]
        }
      }
    }
  }
}
