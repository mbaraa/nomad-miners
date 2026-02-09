.PHONY: setup-worker
.PHONY: setup-server
.PHONY: run-agent
.PHONY: register-server-acl
.PHONY: register-worker-node
.PHONY: get-server-acl
.PHONY: payout-coins

SERVER_ADDRESS=nomad.kurwer.fyi
SERVER_PORT=4646

all:
	$(error lol.)

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

run-batch:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
ifndef JOB
	$(error JOB is not defined.)
endif
ifndef WORKER
	$(error WORKER is not defined.)
endif
	@NOMAD_TOKEN=${TOKEN} nomad job run -address="http://${SERVER_ADDRESS}:${SERVER_PORT}" \
		-var="target_node=${WORKER}" \
		./batches/${JOB}.hcl
	# @NOMAD_TOKEN=${TOKEN} nomad job dispatch -address="http://${SERVER_ADDRESS}:${SERVER_PORT}" ${JOB}

payout-coins:
	@echo '{coin = "LTC", address = "LTfkcReKYwSjYyc7G8F41BvykZFpWFxmS6"}'
	@echo '{coin = "BTC", address = "14hHveMbgiyjPFgVS6n8F7rHpCzXVUFQMZ"}'
	@echo '{coin = "XMR", address = "42BenUPb4LR9KpwkDAbcDqHiioeFWtPgBcTRY1jUFo6QHQLhHAfPeSHcMDFYdB3fBVijk5b7BdQSe1cVNMSSBKXsAHm4oUz"}'
	@echo '{coin = "VTC", address = "vtc1q9djvxr7n0a3uzdr7y557eh7s3hlsknrmd8tzdp"}'

run-service:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
ifndef JOB_GROUP
	$(error JOB_GROUP is not defined.)
endif
ifndef JOB
	$(error JOB is not defined.)
endif
ifndef PAYOUT
	$(error PAYOUT is not defined, make payout-coins.)
endif
	@NOMAD_TOKEN=${TOKEN} nomad job run \
		-address="http://${SERVER_ADDRESS}:${SERVER_PORT}" \
		-var='payout=${PAYOUT}' \
		./services/${JOB_GROUP}/${JOB}.hcl

reboot-all-workers:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
	@NOMAD_TOKEN=${TOKEN} nomad job run \
		-address="http://${SERVER_ADDRESS}:${SERVER_PORT}" \
		./batches/reboot-all.hcl

reboot-worker:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
ifndef WORKER
	$(error WORKER is not defined.)
endif
	@NOMAD_TOKEN=${TOKEN} nomad job run \
		-address="http://${SERVER_ADDRESS}:${SERVER_PORT}" \
		-var="target_node=${WORKER}" \
		./batches/reboot.hcl

