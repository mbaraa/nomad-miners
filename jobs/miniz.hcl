variable "target_node" {
  type = string
  default = "blyat"
}

variable "cpu_threads" {
  type = number
  default = 2
}

variable "memory_mb" {
  type = number
  default = 4096
}

job "miniz" {
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
      delay = "1m"
      mode = "fail"
    }

    task "miniz-task" {
      driver = "raw_exec"

      resources {
        cores = var.cpu_threads
        memory = var.memory_mb
      }

      config {
        work_dir = "/opt/miners/miniZ-linux"
        command = "/opt/miners/miniZ-linux/miniZ"

        args = [
          "--url", "${NOMAD_META_WALLET}:${NOMAD_META_PASSWORD}@${NOMAD_META_POOL_SERVER}:${NOMAD_META_POOL_PORT} --shares-detail --show-shares",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
