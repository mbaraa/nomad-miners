variable "target_node" {
  type = string
  default = "blyat"
}

job "cpuminer" {
  type = "batch"

  parameterized {
    meta_required = ["ALGORITHM", "POOL_SERVER", "POOL_PORT", "WALLET", "PASSWORD", "TARGET_NODE"]
    meta_optional = ["EXTRA_ARGS"]
  }

  constraint {
    attribute = "${node.unique.name}"
    value     = var.target_node
  }

  group "mining" {
    user = "cpuminer"

    task "cpuminer-task" {
      driver = "raw_exec"

      config {
        command = "/opt/miners/cpuminer-opt/cpuminer"

        args = [
          "-a", "${NOMAD_META_ALGORITHM}",
          "-o", "${NOMAD_META_POOL_SERVER}:${NOMAD_META_POOL_PORT}",
          "-u", "${NOMAD_META_WALLET}",
          "-p", "${NOMAD_META_TARGET_NODE}${NOMAD_META_PASSWORD}",
          "--threads=${NOMAD_META_CPU_THREADS}",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
