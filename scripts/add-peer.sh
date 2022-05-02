#!/bin/bash

PEER=${1}

mkdir -p organizations/peerOrganizations/busy.technology/msp

echo "NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-busy-ca.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-busy-ca.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-busy-ca.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-busy-ca.pem
    OrganizationalUnitIdentifier: orderer" >${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml

echo "Generating the ${PEER} msp"
fabric-ca-client enroll -u https://${PEER}:${PEER}pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/msp --csr.hosts ${PEER}.busy.technology --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/msp/config.yaml

echo "Generating the ${PEER}-tls certificates"
fabric-ca-client enroll -u https://${PEER}:${PEER}pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls --enrollment.profile tls --csr.hosts ${PEER}.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem

cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/${PEER}.busy.technology/tls/server.key

sed -i "s/peer2/${PEER}/g" docker-compose-add-peer.yaml
docker-compose -f docker-compose-add-peer.yaml --env-file add-peer-env up -d
sed -i "s/${PEER}/peer2/g" docker-compose-add-peer.yaml

