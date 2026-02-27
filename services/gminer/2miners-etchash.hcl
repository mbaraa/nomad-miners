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
    "rex" = { threads = 2, memory = 4096 }
    "tucker" = { threads = 2, memory = 4096 }
    "mike" = { threads = 2, memory = 4096 }
    "jack" = { threads = 2, memory = 4096 }
  }
}

job "gminer-2miners" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["gminer-etchash-${group.key}"]

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
            "--algo", "etchash",
            "--server", "etc.2miners.com",
            "--port", "1010",
            "--user", "${var.payout.address}.${group.key}",
          ]
        }
      }
    }
  }
}
