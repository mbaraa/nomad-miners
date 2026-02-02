#!/bin/sh

TOKEN=$1
WORKER=$2

cd ..
make run-agent TOKEN="$TOKEN" JOB=miniz WORKER=$WORKER ALGORITHM=equihash144 SERVER="equihash144.eu.mine.zpool.ca" PORT=2144 WALLET=LTfkcReKYwSjYyc7G8F41BvykZFpWFxmS6 PASSWORD="${WORKER},c=LTC,zap=BTCZ/BTG" ARGS="--pers='BitCoinZ BgoldPoW'"
