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
    "rex" = { threads = 6, memory = 6144 }
    "leon" = { threads = 12, memory = 6144 }
    "tucker" = { threads = 6, memory = 6144 }
    "mike" = { threads = 3, memory = 6144 }
    "arnold" = { threads = 4, memory = 6144 }
    "abu3azeez" = { threads = 3, memory = 3072 }
    "ziemowit" = { threads = 8, memory = 6144 }
    "eric" = { threads = 4, memory = 6144 }
    "jack" = { threads = 2, memory = 3072}
  }
}

job "xmrig-hash-vault" {
  type = "service"

  dynamic "group" {
    for_each = var.miners

    labels = ["xmrig-randomx-${group.key}"]

    content {
      constraint {
        attribute = "${node.unique.name}"
        value     = group.key
      }

      restart {
        delay = "1m"
        mode = "fail"
      }

      task "xmrig-task" {
        user   = "root"
        driver = "raw_exec"

        resources {
          cores  = group.value.threads
          memory = group.value.memory
        }

        config {
          command = "xmrig"
          args = [
            "--url", "stratum+tcp://pool.hashvault.pro:443",
            "--user", "${var.payout.address}",
            "--pass", "${group.key}",
            "--threads=${group.value.threads}",
            "--cpu-priority=0",
            "--hugepage-size=1048576",
            "--huge-pages-jit",
            "--randomx-1gb-pages",
            "--av=0",
            "--keepalive",
          ]
        }
      }
    }
  }
}
