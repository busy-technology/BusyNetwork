New Peer Addition to an Existing Org

Purpose :  

This document provide the steps to add a new peer in a multihost enviroment for the Hyperledger Fabric v2 network

Assumptions : 
    1. Fabric network is up and running with application chaincode installed
    2. New server provisioned 
    3. Exsiting server holding fabric components. 

Process : 

Step 0 : Server Provisioning for the new peer

A new server has to be provisioned with the necessary inbound and outbound rules for communication with server where a hyperledger fabric network is already running. 

Step 1 : Development of the configuration files

Prepare the following configuration files :
    • register-enroll-peer<>.sh – for cryptomaterial generation using CA
    • docker-compose-peer<>.sh – for docker container configuration

For current implementation , peer3.busy.technology is added to the existing running server.
register-enroll-peer3.sh contians the function createBusy() which holds the necessary commands to register and enroll peer3.busy.technology with the ca.busy.technology already running on a different host.

docker-compose-peer3.sh hold the docker configuration for the new peer container peer3.busy.technology and its couchdb  which will be added to the exsiting running network.

Step2 : CA operations

Post development of the configuration scripts , make note of the ports required to be opened so as to enable the inbound and outbound traffic on the new server provisioned
Now use the script register-enroll-peer3.sh by running it on the server holding running ca for the org.

Commands :  source register-enroll-peer3.sh
		    createBusy
On successful execution , the relevant cryptomaterials will be generated on the ca holding server under the folder structure ->

${PWD}/organizations/peerOrganizations/busy.technology/peers/peer3.busy.technology

Transfer the crytomaterials using the same folder structure on the new server

STEP 3 : Docker Container Operations  
Now perform the transfer of the files as per the following to the root folder of the project (busy-network) in new server 
    • channel-artifacts – busychannel.block 
    • chaincode – busy-chaincode.tar.gz
    • docker-compose-peer3.yaml
    • add-peer-env-peer3 – holding the environment variables

	Add the ip address and hostname of the all the nodes in the etc/hosts folder of the servers ( exsiting running and the new server)

Bring up the docker container for the new peer using the docker-compose-file for the peer3 and verify its logs.

Command used :  
docker-compose -f docker-compose-peer3.yaml --env-file add-peer-env-peer3 up -d

To check logs : docker logs -f <container_id >

STEP 4 : CLI Container Operation

If the exsiting org has cli container running , it can be ulitised to login on the new peer else a new cli container has to be provisioned. 

For current case, there was no running cli container, hence a configuration of the new cli contianer is developed and it is bought up.

Config file - > docker-compose-cli.yaml

Command -> docker-compose -f docker-compose-cli.yaml --env-file add-peer-env-peer3 up -d
Verify that all the containers are running on the new server without errors.

Command used -> docker ps --format "table {{.ID}}\t{{.Names}}"


STEP 5 : Channel Operations

Login to the cli container and issue the set of commands to join the busychannel. Post successful channel joining , query the channel list on the peer to verify the successful chaneel joining.

To login to cli contianer using container id(docker_cli)  : docker exec -it <container_id> /bin/bash

Channel Joining : peer channel join -b channel-artifacts/busychannel.block

Checking the channel list on peer : peer channel list

STEP 6 : Chaincode Operations 

Post the peer has successfully joined the channel , use the set of commands to install the chaincode on the new peer. Please ensure that the chaincode package has been transfered under the following structure : <root-folder>/chaincode/<chaincode-package-name>

Commands : 

Login to the cli  : docker exec -it <container_id> /bin/bash

Chaincode Install : peer lifecycle chaincode install busy-chaincode.tar.gz

Check the installed chaincode : 
peer lifecycle chaincode queryinstalled --peerAddresses peer3.busy.technology:11051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --output json

To verify that the committed chaincode on the exsiting network channel is visible on this new peer, use the command to check the committted chaincode on the channel.