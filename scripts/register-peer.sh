#!/bin/bash

PEER=${1}

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/busy.technology/

echo "###### Registering ${PEER} ######"
fabric-ca-client register --caname busy-ca --id.name ${PEER} --id.secret ${PEER}pw --id.type peer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
