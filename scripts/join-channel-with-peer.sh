#!/bin/bash

PEER=${1}
PEER_PORT=${2}

export CORE_PEER_TLS_ENABLED=true
export FABRIC_LOGGING_SPEC=INFO
export ORDERER_CA=${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

export CORE_PEER_LOCALMSPID="BusyMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp
export CORE_PEER_ADDRESS=${PEER}.busy.technology:${PEER_PORT}

peer channel join -b channel-artifacts/busychannel.block