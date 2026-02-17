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
    # "rex" = { threads = 2, memory = 4096 }
    # "leon" = { threads = 2, memory = 4096 }
    # "tucker" = { threads = 2, memory = 4096 }
    "mike" = { threads = 2, memory = 4096 }
    # "ziemowit" = { threads = 2, memory = 4096 }
    # "jack" = { threads = 2, memory = 4096 }
  }
}

job "srb-miner-suprnova" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["srb-miner-verthash-${group.key}"]

    content {
      constraint {
        attribute = "${node.unique.name}"
        value     = group.key
      }

      restart {
        delay = "1m"
        mode = "fail"
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
            "-o", "stratum+tcp://vtc.suprnova.cc:1775",
            "-u", "hexagon16.${group.key}",
            "-p", "1",
            "--verthash-data", "/opt/miners/VerthashMiner/verthash.dat",
            "--all-cu-devices",
            "--all-cl-devices",
          ]
        }
      }
    }
  }
}
