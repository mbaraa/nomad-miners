.PHONY: run-hashvault-randomx-xmrig-mike
.PHONY: run-hashvault-randomx-xmrig-leon
.PHONY: run-hashvault-randomx-xmrig-ziemowit
.PHONY: run-hashvault-randomx-xmrig-rex

SERVER_ADDRESS=nomad.kurwer.fyi
SERVER_PORT=4646

all:
	$(error format run-{POOL}-{ALGO}-{MINER}-{WORKER}.)

run-hashvault-randomx-xmrig-mike:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
	@cd ../.. && \
	make run-agent TOKEN="${TOKEN}" \
		JOB=xmrig WORKER=mike ALGORITHM=randomx \
		SERVER="stratum+tcp://pool.hashvault.pro" PORT=443 \
		WALLET=42BenUPb4LR9KpwkDAbcDqHiioeFWtPgBcTRY1jUFo6QHQLhHAfPeSHcMDFYdB3fBVijk5b7BdQSe1cVNMSSBKXsAHm4oUz \
		PASSWORD="mike" \
		CPU_THREADS=4

run-hashvault-randomx-xmrig-leon:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
	@cd ../.. && \
	make run-agent TOKEN="${TOKEN}" \
		JOB=xmrig WORKER=leon ALGORITHM=randomx \
		SERVER="stratum+tcp://pool.hashvault.pro" PORT=443 \
		WALLET=42BenUPb4LR9KpwkDAbcDqHiioeFWtPgBcTRY1jUFo6QHQLhHAfPeSHcMDFYdB3fBVijk5b7BdQSe1cVNMSSBKXsAHm4oUz \
		PASSWORD="leon" \
		CPU_THREADS=6

run-hashvault-randomx-xmrig-ziemowit:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
	@cd ../.. && \
	make run-agent TOKEN="${TOKEN}" \
		JOB=xmrig WORKER=ziemowit ALGORITHM=randomx \
		SERVER="stratum+tcp://pool.hashvault.pro" PORT=443 \
		WALLET=42BenUPb4LR9KpwkDAbcDqHiioeFWtPgBcTRY1jUFo6QHQLhHAfPeSHcMDFYdB3fBVijk5b7BdQSe1cVNMSSBKXsAHm4oUz \
		PASSWORD="ziemowit" \
		CPU_THREADS=5

run-hashvault-randomx-xmrig-rex:
ifndef TOKEN
	$(error TOKEN is not defined.)
endif
	@cd ../.. && \
	make run-agent TOKEN="${TOKEN}" \
		JOB=xmrig WORKER=rex ALGORITHM=randomx \
		SERVER="stratum+tcp://pool.hashvault.pro" PORT=443 \
		WALLET=42BenUPb4LR9KpwkDAbcDqHiioeFWtPgBcTRY1jUFo6QHQLhHAfPeSHcMDFYdB3fBVijk5b7BdQSe1cVNMSSBKXsAHm4oUz \
		PASSWORD="rex" \
		CPU_THREADS=4

