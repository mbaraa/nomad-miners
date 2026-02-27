variable "payout" {
  type = object({
    coin = string
    address = string
  })
  default = {
    coin = "XMR"
    address = "42BenUPb4LR9KpwkDAbcDqHiioeFWtPgBcTRY1jUFo6QHQLhHAfPeSHcMDFYdB3fBVijk5b7BdQSe1cVNMSSBKXsAHm4oUz"
  }
}

variable "miners" {
  type = map(object({
    threads = number
    memory  = number
  }))
  default = {
    "rex" = { threads = 16, memory = 20480 }
    "tucker" = { threads = 6, memory = 6144 }
    "mike" = { threads = 3, memory = 6144 }
    "arnold" = { threads = 4, memory = 6144 }
    "abu3azeez" = { threads = 3, memory = 3072 }
    "eric" = { threads = 4, memory = 6144 }
    "jack" = { threads = 4, memory = 3072}
  }
}

job "srb-miner-hash-vault" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["srb-miner-randomx-${group.key}"]

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
            "--algorithm", "randomx",
            "--pool", "stratum+tcp://pool.hashvault.pro:443",
            "--wallet", "${var.payout.address}",
            "--password", "${group.key}",
            "--cpu-threads", "${group.value.threads}",
          ]
        }
      }
    }
  }
}
