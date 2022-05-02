#!/bin/bash

function createBusy() {
  #infoln "Enrolling the CA admin"
  #mkdir -p organizations/peerOrganizations/busy.technology/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/busy.technology/

  #set -x
  #fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname busy-ca --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  #  { set +x; } 2>/dev/null

  echo 'NodeOUs:
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
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml

  infoln "Registering peer3"
  set -x
  fabric-ca-client register --caname busy-ca --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  #infoln "Registering the busy network"
  #set -x
  #fabric-ca-client register --caname busy-ca --id.name busy_network --id.secret bW1eK5zM0uF5lZ1f --id.type admin --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  # { set +x; } 2>/dev/null

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/msp --csr.hosts peer3.busy.technology --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/msp/config.yaml

  
  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls --enrollment.profile tls --csr.hosts peer3.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/tlsca
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/tlsca/tlsca.busy.technology-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/ca
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology/msp/cacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/ca/ca.busy.technology-cert.pem

  }