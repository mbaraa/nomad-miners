#!/bin/sh

TOKEN=$1
WORKER=$2

make run-agent TOKEN="$TOKEN" JOB=srb-miner WORKER=$WORKER ALGORITHM=kawpow SERVER="kawpow.eu.mine.zpool.ca" PORT=1325 WALLET=LTfkcReKYwSjYyc7G8F41BvykZFpWFxmS6 PASSWORD="${WORKER},c=LTC"
