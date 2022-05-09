```bash

docker run -it --rm -v ${PWD}:/work -w /work debian bash


apt-get update && apt-get install -y curl &&
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 -o /usr/local/bin/cfssl && \
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64 -o /usr/local/bin/cfssljson && \
chmod +x /usr/local/bin/cfssl && \
chmod +x /usr/local/bin/cfssljson

#generate ca in /tmp
cfssl gencert -initca ./tls/ca-csr.json | cfssljson -bare /tmp/ca

#generate certificate in /tmp
cfssl gencert \
  -ca=/tmp/ca.pem \
  -ca-key=/tmp/ca-key.pem \
  -config=./tls/ca-config.json \
  -hostname="mongo,mongo.mongodb.svc.cluster.local,mongo.default.svc,localhost,127.0.0.1,mongo.pigbot.svc.cluster.local,34.117.143.215,34.66.213.165,mongo.cwxstat.io" \
  -profile=default \
  ./tls/ca-csr.json | cfssljson -bare /tmp/mongo-certs


```

# You need IP address

```bash
gcloud compute addresses create mongo  --region=us-central1
gcloud compute addresses list
```

```bash
k cp certs-no-git-2 mongodb/mongo-6f588b9955-tnkzr:/data/db/certs2

```

This puts files

mongod --tlsMode=requireTLS --tlsCertificateKeyFile=/data/db/certs/merged.pem --tlsCAFile=/data/db/certs/ca.pem


mongod --tlsMode=requireTLS --tlsCertificateKeyFile=/data/db/certs/mongo-certs-key.pem --tlsCAFile=/data/db/certs/ca.pem



openssl x509 -outform der -in ca.pem -out ca.crt 




mongo --disableImplicitSessions --eval "db.adminCommand('ping')" --tlsCertificateKeyFile=/data/db/certs/merged.pem --tls --tlsCAFile=/data/db/certs/ca.pem

## Use This

mongosh --tlsCertificateKeyFile=/etc/mongo/certs/merged.pem --tls --tlsCAFile=/etc/mongo/certs/ca.pem --tlsAllowInvalidCertificates

gsutil ls gs://mchirico-configs/certs-mongo


