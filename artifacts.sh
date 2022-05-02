#!/bin/bash
rm -rf channel-artifacts/*
export FABRIC_CFG_PATH=$PWD

configtxgen -outputBlock channel-artifacts/genesis.block -channelID ordererchannel -profile BusyNetworkGenesis
configtxgen -outputCreateChannelTx channel-artifacts/busychannel.tx -channelID busychannel -profile BusyChannel
configtxgen --outputAnchorPeersUpdate channel-artifacts/busy-busychannel-anchor.tx -channelID busychannel -profile BusyChannel -asOrg BusyMSP
