data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

server {
  enabled          = true
  bootstrap_expect = 1
}

acl {
  enabled = true
}

advertise {
  rpc  = "master.nomad.kurwer.fyi"
  http = "nomad.kurwer.fyi"
}

client {
  enabled = false
}
