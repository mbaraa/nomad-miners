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
  default = 7168
}

job "xmrig" {
  type = "batch"

  parameterized {
    meta_required = ["POOL_SERVER", "POOL_PORT", "WALLET", "CPU_THREADS", "TARGET_NODE"]
    meta_optional = ["EXTRA_ARGS", "PASSWORD", "ALGORITHM"]
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

    task "xmrig-task" {
      user = "root"
      driver = "raw_exec"

      resources {
        cores = var.cpu_threads
        memory = var.memory_mb
      }

      config {
        command = "xmrig"

        args = [
          "--url", "${NOMAD_META_POOL_SERVER}:${NOMAD_META_POOL_PORT}",
          "--user", "${NOMAD_META_WALLET}",
          "--pass", "${NOMAD_META_PASSWORD}",
          "--cpu-priority=0",
          "--threads=${NOMAD_META_CPU_THREADS}",
          "--hugepage-size=1048576",
          "--huge-pages-jit",
          "--randomx-1gb-pages",
          "--av=0",
          "--keepalive",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
