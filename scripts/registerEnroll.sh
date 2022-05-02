#!/bin/bash

function createBusy() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/busy.technology/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/busy.technology/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname busy-ca --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

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

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname busy-ca --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname busy-ca --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname busy-ca --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname busy-ca --id.name busyadmin --id.secret busyadminpw --id.type admin --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the busy network"
  set -x
  fabric-ca-client register --caname busy-ca --id.name busy_network --id.secret bW1eK5zM0uF5lZ1f --id.type admin --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/msp --csr.hosts peer0.busy.technology --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/msp/config.yaml

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/msp --csr.hosts peer1.busy.technology --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls --enrollment.profile tls --csr.hosts peer0.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/tlsca
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/tlsca/tlsca.busy.technology-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/ca
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer0.busy.technology/msp/cacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/ca/ca.busy.technology-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls --enrollment.profile tls --csr.hosts peer1.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/peers/peer1.busy.technology/tls/server.key

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/users/User1@busy.technology/msp --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  cp ${PWD}/organizations/peerOrganizations/busy.technology/users/User1@busy.technology/msp/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/users/User1@busy.technology/msp/keystore/explorer-user.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/users/User1@busy.technology/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://busy_network:bW1eK5zM0uF5lZ1f@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp/config.yaml
}

function createOrderer() {
  infoln "Registering orderer1"
  set -x
  fabric-ca-client register --caname busy-ca --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer2"
  set -x
  fabric-ca-client register --caname busy-ca --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer3"
  set -x
  fabric-ca-client register --caname busy-ca --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer4"
  set -x
  fabric-ca-client register --caname busy-ca --id.name orderer4 --id.secret orderer4pw --id.type orderer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer5"
  set -x
  fabric-ca-client register --caname busy-ca --id.name orderer5 --id.secret orderer5pw --id.type orderer --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname busy-ca --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer1 msp"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/msp --csr.hosts orderer1.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/msp/config.yaml

  infoln "Generating the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/msp --csr.hosts orderer2.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/msp/config.yaml

  infoln "Generating the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/msp --csr.hosts orderer3.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/msp/config.yaml

  infoln "Generating the orderer4 msp"
  set -x
  fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/msp --csr.hosts orderer4.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/msp/config.yaml

  infoln "Generating the orderer5 msp"
  set -x
  fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/msp --csr.hosts orderer5.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/msp/config.yaml

  infoln "Generating the orderer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls --enrollment.profile tls --csr.hosts orderer1.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer1.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

  infoln "Generating the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls --enrollment.profile tls --csr.hosts orderer2.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer2.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

  infoln "Generating the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls --enrollment.profile tls --csr.hosts orderer3.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer3.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

  infoln "Generating the orderer4-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls --enrollment.profile tls --csr.hosts orderer4.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer4.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

  infoln "Generating the orderer5-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls --enrollment.profile tls --csr.hosts orderer5.busy.technology --csr.hosts localhost --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/busy.technology/orderers/orderer5.busy.technology/msp/tlscacerts/tlsca.busy.technology-cert.pem

  #infoln "Generating the admin msp"
  #set -x
  #fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  ##{ set +x; } 2>/dev/null

  #cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp/config.yaml
}
