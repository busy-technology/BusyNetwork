docker container rm -f $(docker container ls -aq)

docker volume prune -f

docker network prune -f

rm -rf organizations

cd busy-ca-server

#rm -v ! (fabric-ca-server-config.yaml)
rm -rf IssuerPublicKey IssuerRevocationPublicKey ca-cert.pem msp tls-cert.pem

cd ..

rm -rf channel-artifacts