.PHONY: all setup-worker setup-server

all:
	@echo "Usage: make build-os-arch e.g. make build-linux-amd64"
	@echo "To build for all operating systems and architecture (for some reason) use build-all"

setup-worker:
ifndef NAME
	$(error NAME is not defined.)
endif
ifndef SERVER_ADDRESS
	$(error SERVER_ADDRESS is not defined.)
endif
	@cp ./worker/nomad-conf.hcl /etc/nomad.d/${NAME}-conf.hcl
	@cp ./worker/systemd.service /etc/systemd/system/nomad-${NAME}.service
	@sed "s/WORKER_NAME/${NAME}/g" /etc/nomad.d/${NAME}-conf.hcl > /etc/nomad.d/${NAME}-conf.hcl
	@sed "s/SERVER_ADDRESS/${SERVER_ADDRESS}/g" /etc/nomad.d/${NAME}-conf.hcl > /etc/nomad.d/${NAME}-conf.hcl
	@sed "s/WORKER_NAME/${NAME}/g" /etc/systemd/system/nomad-${NAME}.service > /etc/systemd/system/nomad-${NAME}.service
	@systemctl daemon-reload
	@systemctl enable --now nomad-${NAME}-conf

setup-server:
	@cp ./server/nomad-conf.hcl /etc/nomad.d/master-conf.hcl
	@cp ./server/systemd.service /etc/systemd/system/nomad-server.service
	@systemctl daemon-reload
	@systemctl enable --now nomad-server-conf

run-agent:
ifndef JOB
	$(error JOB is not defined.)
endif
ifndef WORKER
	$(error WORKER is not defined.)
endif
ifndef ALGORITHM
	$(error ALGORITHM is not defined.)
endif
ifndef SERVER
	$(error SERVER is not defined.)
endif
ifndef PORT
	$(error PORT is not defined.)
endif
ifndef WALLET
	$(error WALLET is not defined.)
endif
ifndef PASSWORD
	$(error PASSWORD is not defined.)
endif
ifndef ARGS
	@echo "ARGS is missing, just saying, it's passed down to the thing"
endif
	@nomad job run -var="target_node=${WORKER}" ./jobs/${JOB}.hcl
	@nomad job dispatch \
		-meta ALGORITHM="${ALGORITHM}" \
		-meta POOL_SERVER="stratum+tcp://${SERVER}" \
		-meta POOL_PORT="${PORT}" \
		-meta WALLET="${WALLET}" \
		-meta PASSWORD="${PASSWORD}" \
		-meta TARGET_NODE="${WORKER}" \
		-meta EXTRA_ARGS="${ARGS}"
		${JOB}
