name = "Kurwer"
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
  rpc  = "nomad.kurwer.fyi:4647"
  http = "nomad.kurwer.fyi:4646"
}

client {
  enabled = false
}
