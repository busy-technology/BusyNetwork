#!/bin/bash

# utility script
. scripts/utils.sh

infoln "Starting busy CA server"
docker-compose -f docker-compose-ca.yaml up -d

infoln "Waiting for 5s to bootstrap CA server"
sleep 5

. scripts/registerEnroll.sh

infoln "Generating crypto for Busy org"
createBusy
infoln "Generating crypto for Orderer org"
createOrderer

infoln "Generating channel artifacts"
./artifacts.sh

infoln "Bootstraping orderer etcdraft cluster"
docker-compose -f docker-compose-orderer.yaml up -d

infoln "Starting peer0 and peer1 of Busy organization"
docker-compose -f docker-compose-peers.yaml -f docker-compose-couchdb.yaml up -d

infoln "Creating Busy channel."
./createChannel.sh

infoln "Generating CCP for Busy org"
./scripts/ccp-generate.sh

infoln "Deploying busy chaincode"
./scripts/chaincode.sh busyv1 1

#infoln "starting explorer"
#docker-compose -f docker-compose-explorer.yaml up -d
#infoln "explorer started"
