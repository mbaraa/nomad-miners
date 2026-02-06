#!/bin/sh

TOKEN=$1
PAYOUT_COIN=$2
WORKER=$3

coin_address=""
coin_symbol=""

case "$PAYOUT_COIN" in
    "LTC")
        coin_symbol="LTC"
        coin_address="LTfkcReKYwSjYyc7G8F41BvykZFpWFxmS6"
        ;;
    "BTC")
        coin_symbol="BTC"
        coin_address="14hHveMbgiyjPFgVS6n8F7rHpCzXVUFQMZ"
        ;;
    *)
        echo "Unsupported coin: $PAYOUT_COIN"
        ;;
esac

make run-agent TOKEN="$TOKEN" \
    JOB=miniz WORKER=$WORKER ALGORITHM=equihash144 \
    SERVER="equihash144.eu.mine.zpool.ca" PORT=2144 \
    WALLET=${coin_address} \
    PASSWORD="${WORKER},c=${coin_symbol},zap=BTCZ/BTG" \
    ARGS="--pers='BitCoinZ BgoldPoW'" \
    CPU_THREADS=2
