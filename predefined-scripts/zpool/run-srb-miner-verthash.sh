#!/bin/sh

TOKEN=$1
WORKER=$2

cd ..
make run-agent TOKEN="$TOKEN" JOB=srb-miner WORKER=$WORKER ALGORITHM=verthash SERVER="verthash.eu.mine.zpool.ca" PORT=6144 WALLET=LTfkcReKYwSjYyc7G8F41BvykZFpWFxmS6 PASSWORD="${WORKER},c=LTC"
