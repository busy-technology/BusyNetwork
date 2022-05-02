#!/bin/bash

. ./envVar.sh

peer lifecycle chaincode package busy-chaincode.tar.gz --path ../BusyChaincode --lang golang --label $1

setGlobalsForPeer0BusyOrg
peer lifecycle chaincode install busy-chaincode.tar.gz 
export CCID=$(peer lifecycle chaincode queryinstalled | cut -d ' ' -f 3 | sed s/.$// | grep $1)
peer lifecycle chaincode approveformyorg -o localhost:7050 --package-id $CCID --channelID busychannel --name busy-chaincode --version 1 --sequence $2 --waitForEvent --tls --cafile $ORDERER_CA --init-required

peer lifecycle chaincode commit -o localhost:7050 --channelID busychannel --name busy-chaincode --version 1 --sequence $2 --tls true --cafile $ORDERER_CA --peerAddresses localhost:7051 --tlsRootCertFiles organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/ca.crt --init-required

peer chaincode invoke -o localhost:7050 --channelID busychannel --name busy-chaincode --tls true --cafile $ORDERER_CA --peerAddresses localhost:7051 --tlsRootCertFiles organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/ca.crt --isInit -c '{"function":"Init","Args":[]}'

setGlobalsForPeer1BusyOrg
peer lifecycle chaincode install busy-chaincode.tar.gz
