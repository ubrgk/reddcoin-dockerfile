#!/bin/bash
set -e

echo "Starting Reddcoin daemon..."
reddcoind -datadir=$REDDCOIN_DATA_DIR -rescan -detachdb &

echo "Waiting for daemon before unlocking wallet..."
sleep 60

n=0
until [ $n -ge 60 ]
do
  echo "Attempting to unlock wallet for staking..."
  reddcoin-cli -datadir=$REDDCOIN_DATA_DIR walletpassphrase $WALLET_PASSPHRASE 9999999 true && break
  n=$[$n+1]

  echo "Unable to unlock wallet, retrying in a few seconds..."
  sleep 5
done

if [ $@ -eq 0 ]; then
  echo "Wallet unlocked successfully."
else
  echo "Unable to unlock wallet after 5 minutes."
  exit 1
fi

wait
