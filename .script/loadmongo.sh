#!/bin/bash
docker run --rm -d -p 27017:27017 -h $(hostname) --name mongo mongo:5.0.3 --replSet=test && sleep 4 && docker exec mongo mongo --eval "rs.initiate();"