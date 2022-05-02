# imports  
. ./envVar.sh
. ./scripts/utils.sh

CHANNEL_NAME="$1"
: ${CHANNEL_NAME:="busychannel"}


createChannel() {
	export FABRIC_CFG_PATH=/etc/hyperledger/fabric
	setGlobalsForPeer0BusyOrg 
	# Poll in case the raft leader is not set yet
		set -x
		peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer1.busy.technology -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile $ORDERER_CA 
		res=$?
		
}

joinChannelForPeer0() {
	export FABRIC_CFG_PATH=/etc/hyperledger/fabric
	setGlobalsForPeer0BusyOrg 

	set -x 
	peer channel join -b $BLOCKFILE
	res=$?
}

joinChannelForPeer1() {
	export FABRIC_CFG_PATH=/etc/hyperledger/fabric
	setGlobalsForPeer1BusyOrg 

	set -x 
	peer channel join -b $BLOCKFILE
	res=$?
}

BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"
sleep 2
## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

sleep 2
## Peer0 joins Busy channel
infoln "Peer0 trying to join ${CHANNEL_NAME}"
joinChannelForPeer0
successln "Peer0 joined ${CHANNEL_NAME}"
sleep 2
## Peer1 joins Busy channel
infoln "Peer1 trying to join ${CHANNEL_NAME}"
joinChannelForPeer1
successln "Peer1 joined ${CHANNEL_NAME}"
