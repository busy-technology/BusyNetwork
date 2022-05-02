#!/bin/bash
# imports
. ./scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem
export PEER0_BUSYORG_CA=${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/ca.crt
export PEER1_BUSYORG_CA=${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/ca.crt


# Set environment variables for the peer org
setGlobalsForPeer0BusyOrg() {

local USING_ORG="busyOrg"
  infoln "Using organization ${USING_ORG}"

    export CORE_PEER_LOCALMSPID="BusyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BUSYORG_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp
    export CORE_PEER_ADDRESS=localhost:7051
  
}

setGlobalsForPeer1BusyOrg() {

local USING_ORG="busyOrg"
  infoln "Using organization ${USING_ORG}"

    export CORE_PEER_LOCALMSPID="BusyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BUSYORG_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp
    export CORE_PEER_ADDRESS=localhost:9051
  
}

