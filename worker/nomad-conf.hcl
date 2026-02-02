name = "WORKER_NAME"
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

client {
  enabled = true
  servers = ["SERVER_ADDRESS:4647"]

  chroot_env {
    "/usr/bin"       = "/usr/bin"
    "/bin"           = "/bin"
    "/usr/local/bin" = "/usr/local/bin"
    "/lib"           = "/lib"
    "/lib64"         = "/lib64"
    "/opt"           = "/opt"
  }
}

plugin "exec" {
}

plugin "raw_exec" {
  config {
    enabled = true
  }
  cpu_hard_limit = false
}
