#!/bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
service docker start
service docker enable
timeout 15 sh -c "until docker info; do echo .; sleep 1; done"

docker swarm join --token "${token}" "${public_ip}:2377"