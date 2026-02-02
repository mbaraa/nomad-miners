variable "target_node" {
  type = string
  default = "blyat"
}

variable "cpu_threads" {
  type = number
  default = 4
}

variable "memory_mb" {
  type = number
  default = 6144
}

job "gminer" {
  type = "batch"

  parameterized {
    meta_required = ["ALGORITHM", "POOL_SERVER", "POOL_PORT", "WALLET", "PASSWORD", "TARGET_NODE"]
    meta_optional = ["EXTRA_ARGS", "CPU_THREADS"]
  }

  constraint {
    attribute = "${node.unique.name}"
    value     = var.target_node
  }

  group "mining" {
    restart {
      attempts = 1
      mode = "fail"
    }

    task "gminer-task" {
      driver = "raw_exec"

      resources {
        cpu    = 1000
        memory = 1024
      }

      config {
        command = "/opt/miners/gminer-linux/miner"

        args = [
          "--algo", "${NOMAD_META_ALGORITHM}",
          "--server", "${NOMAD_META_POOL_SERVER}",
          "--port", "${NOMAD_META_POOL_PORT}",
          "--user", "${NOMAD_META_WALLET}",
          "--pass", "${NOMAD_META_PASSWORD}",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
