

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
  -hostname="proto,proto.default.svc.cluster.local,proto.default.svc,localhost,proto.pigbot.svc,127.0.0.1,proto.pigbot.svc.cluster.local,34.111.92.27,34.111.213.254,34.111.87.41,35.202.88.179,34.111.99.233,34.122.225.76,0.0.0.0,api,172.19.1.128,172.18.1.128" \
  -profile=default \
  ./tls/ca-csr.json | cfssljson -bare /tmp/api-certs


```
