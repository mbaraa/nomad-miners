variable "target_node" {
  type = string
  default = "blyat"
}

job "miniz" {
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
    task "miniz-task" {
      driver = "raw_exec"

      config {
        command = "/opt/miners/miniZ-linux/miniZ"

        args = [
          "--url", "${NOMAD_META_WALLET}:${NOMAD_META_TARGET_NODE}${NOMAD_META_PASSWORD}@${NOMAD_META_POOL_SERVER}:${NOMAD_META_POOL_PORT} --shares-detail --show-shares"
          "${NOMAD_META_EXTRA_ARGS}"
        ]
      }
    }
  }
}
