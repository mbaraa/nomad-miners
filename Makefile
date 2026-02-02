.PHONY: all setup-worker setup-server

SERVER_ADDRESS=nomad.kurwer.fyi
SERVER_PORT=4646

all:
	$(error lol. $(SERVER_ADDRESS))

setup-worker:
ifndef NAME
	$(error NAME is not defined.)
endif
	@cp ./worker/nomad-conf.hcl /etc/nomad.d/${NAME}-conf.hcl
	@cp ./worker/systemd.service /etc/systemd/system/nomad-${NAME}.service
	@sed -i "s/WORKER_NAME/${NAME}/g" /etc/nomad.d/${NAME}-conf.hcl
	@sed -i "s/SERVER_ADDRESS/${SERVER_ADDRESS}/g" /etc/nomad.d/${NAME}-conf.hcl
	@sed -i "s/WORKER_NAME/${NAME}/g" /etc/systemd/system/nomad-${NAME}.service
	@systemctl daemon-reload
	@systemctl enable --now nomad-${NAME}.service

setup-server:
	@cp ./server/nomad-conf.hcl /etc/nomad.d/master-conf.hcl
	@cp ./server/systemd.service /etc/systemd/system/nomad-server.service
	@systemctl daemon-reload
	@systemctl enable --now nomad-server

register-server-acl:
	@nomad acl bootstrap

get-server-acl:
	@nomad acl token self

register-worker-node:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
ifndef WORKER
	$(error WORKER is not defined.)
endif
	@NOMAD_TOKEN=${TOKEN} nomad acl policy apply -description "${WORKER} policy" ${WORKER}-policy ./worker/acl-policy.hcl
	@NOMAD_TOKEN=${TOKEN} nomad acl token create -name="${WORKER}" -policy="${WORKER}-policy"

run-agent:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
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
	@echo "PASSWORD is missing, just saying, it's passed down to the thing"
endif
ifndef ARGS
	@echo "ARGS is missing, just saying, it's passed down to the thing"
endif
@NOMAD_TOKEN=${TOKEN} nomad job run -address="${SERVER_ADDRESS}:${SERVER_PORT}" -var="target_node=${WORKER}" ./jobs/${JOB}.hcl
	@NOMAD_TOKEN=${TOKEN} nomad job dispatch -address="${SERVER_ADDRESS}:${SERVER_PORT}" \
		-meta ALGORITHM="${ALGORITHM}" \
		-meta POOL_SERVER="stratum+tcp://${SERVER}" \
		-meta POOL_PORT="${PORT}" \
		-meta WALLET="${WALLET}" \
		-meta PASSWORD="${PASSWORD}" \
		-meta TARGET_NODE="${WORKER}" \
		-meta CPU_THREADS="${CPU_THREADS}" \
		-meta EXTRA_ARGS="${ARGS}" \
		${JOB}
