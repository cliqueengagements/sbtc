#!/bin/bash

# Mines some BTC to the default BTC address

num_blocks=$1
dir="$(dirname "$0")"

if [[ -z "$num_blocks" ]]; then
    echo "Usage: ./script.sh [num_blocks]"
    exit 1
fi

btc_address=$(source $dir/get_credentials.sh | jq -r '.credentials["0"].bitcoin.p2wpkh.address')
$dir/../bitcoin/bin/bitcoin-cli generatetoaddress 300 'bcrt1q3tj2fr9scwmcw3rq5m6jslva65f2rqjxfrjz47'
echo "Mined 300 BTC to bcrt1q3tj2fr9scwmcw3rq5m6jslva65f2rqjxfrjz47"
btc_address=$(source $dir/get_credentials.sh | jq -r '.credentials["1"].bitcoin.p2wpkh.address')
$dir/../bitcoin/bin/bitcoin-cli generatetoaddress 300 'bcrt1q3zl64vadtuh3vnsuhdgv6pm93n82ye8q6cr4ch'
echo "Mined 300 BTC to bcrt1q3zl64vadtuh3vnsuhdgv6pm93n82ye8q6cr4ch"
