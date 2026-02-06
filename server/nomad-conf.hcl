name = "Kurwer"
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

server {
  enabled          = true
  bootstrap_expect = 1
  job_gc_threshold = "4h"
  eval_gc_threshold = "2h"
  node_gc_threshold = "1h"
  heartbeat_grace = "5s"
  default_scheduler_config {
    scheduler_algorithm = "binpack"
    preemption_config {
      batch_scheduler   = false
      system_scheduler  = false
      service_scheduler = false
    }
  }
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
