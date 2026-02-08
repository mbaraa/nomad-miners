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
    "leon" = { threads = 2, memory = 4096 }
    # "tucker" = { threads = 2, memory = 4096 }
    # "mike" = { threads = 2, memory = 4096 }
    # "ziemowit" = { threads = 2, memory = 4096 }
    # "jack" = { threads = 2, memory = 4096 }
  }
}

job "miniz-zpool" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["miniz-equihash144-${group.key}"]

    content {
      constraint {
        attribute = "${node.unique.name}"
        value     = group.key
      }

      restart {
        delay = "1m"
        mode = "fail"
      }

      task "miniz-task" {
        user   = "root"
        driver = "raw_exec"

        resources {
          cores  = group.value.threads
          memory = group.value.memory
        }

        config {
          work_dir = "/opt/miners/miniZ-linux"
          command = "/opt/miners/miniZ-linux/miniZ"
          args = [
            "--url", "${var.payout.address}:${group.key},c=${var.payout.coin},zap=BTCZ/BTG@equihash144.eu.mine.zpool.ca:2144",
            "--shares-detail",
            "--show-shares",
            "--pers='BitCoinZ BgoldPoW'"
          ]
        }
      }
    }
  }
}
