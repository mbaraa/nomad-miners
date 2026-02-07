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
    "tucker" = { threads = 2, memory = 3072 }
    "mike" = { threads = 2, memory = 3072 }
    # "ziemowit" = { threads = 2, memory = 3072 }
    "jack" = { threads = 2, memory = 3072 }
  }
}

job "gminer-zpool" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["gminer-kawpow-${group.key}"]

    content {
      constraint {
        attribute = "${node.unique.name}"
        value     = group.key
      }

      restart {
        delay = "1m"
        mode = "fail"
      }

      task "gminer-task" {
        user   = "root"
        driver = "raw_exec"

        resources {
          cores  = group.value.threads
          memory = group.value.memory
        }

        config {
          work_dir = "/opt/miners/gminer-linux"
          command = "/opt/miners/gminer-linux/miner"
          args = [
            "--algo", "kawpow",
            "--server", "kawpow.eu.mine.zpool.ca",
            "--port", "1325",
            "--user", "${var.payout.address}",
            "--pass", "${group.key},c=${var.payout.coin}",
          ]
        }
      }
    }
  }
}
