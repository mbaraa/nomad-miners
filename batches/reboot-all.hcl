job "reboot" {
  type = "batch"

  group "reboot" {
    count = 1

    task "reboot-task" {
      user = "root"
      driver = "raw_exec"

      config {
        command = "reboot"
      }
    }
  }
}

