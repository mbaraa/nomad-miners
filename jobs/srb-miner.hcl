variable "target_node" {
  type = string
  default = "blyat"
}

job "srb-miner" {
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
    task "srb-task" {
      user = "root"
      driver = "raw_exec"

      config {
        command = "/opt/miners/SRBMiner-Multi/SRBMiner-MULTI"

        args = [
          "--algorithm", "${NOMAD_META_ALGORITHM}",
          "--pool", "${NOMAD_META_POOL_SERVER}:${NOMAD_META_POOL_PORT}",
          "--wallet", "${NOMAD_META_WALLET}",
          "--password", "${NOMAD_META_TARGET_NODE}${NOMAD_META_PASSWORD}",
          "--disable-cpu",
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
