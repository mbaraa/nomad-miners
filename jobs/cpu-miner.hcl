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
  default = 3072
}

job "cpuminer" {
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

    task "cpuminer-task" {
      user = "cpuminer"
      driver = "raw_exec"

      resources {
        cores = var.cpu_threads
        memory = var.memory_mb
      }

      config {
        work_dir = "/opt/miners/cpuminer-opt"
        command = "/opt/miners/cpuminer-opt/cpuminer"

        args = [
          "-a", "${NOMAD_META_ALGORITHM}",
          "-o", "${NOMAD_META_POOL_SERVER}:${NOMAD_META_POOL_PORT}",
          "-u", "${NOMAD_META_WALLET}",
          "-p", "${NOMAD_META_PASSWORD}",
          "--threads=${NOMAD_META_CPU_THREADS}",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
