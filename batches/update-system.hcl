variable "target_node" {
  type = string
  default = "blyat"
}

job "update-system" {
  type = "batch"

  constraint {
    attribute = "${node.unique.name}"
    value     = var.target_node
  }

  group "update-system" {
    user = "root"
    count = 1

    task "update-arch-linux-system-task" {
      driver = "raw_exec"

      config {
        command = "pacman -Syyu --noconfirm"
      }

      restart {
        attempts = 0
        mode     = "fail"
      }
    }
  }
}

