variable "target_node" {
  type = string
  default = "blyat"
}

job "gminer" {
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
    task "gminer-task" {
      driver = "raw_exec"

      config {
        command = "/opt/miners/gminer-linux/miner"

        args = [
          "--algo", "${NOMAD_META_ALGORITHM}",
          "--server", "${NOMAD_META_POOL_SERVER}",
          "--port", "${NOMAD_META_POOL_PORT}",
          "--user", "${NOMAD_META_WALLET}",
          "--pass", "${NOMAD_META_TARGET_NODE}${NOMAD_META_PASSWORD}",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
