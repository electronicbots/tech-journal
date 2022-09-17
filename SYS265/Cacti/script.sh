#!/bin/bash

if [ "$EUID" -ne 0 ]
  then
        echo "Please run as root"
        exit
fi

cd /tmp
curl -s https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh | bash
yum -y install sensu-go-backend
curl -L https://docs.sensu.io/sensu-go/latest/files/backend.yml -o /etc/sensu/backend.yml
service sensu-backend start
service sensu-backend status
export SENSU_BACKEND_CLUSTER_ADMIN_USERNAME=$1
export SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD=$2
sensu-backend init
curl http://127.0.0.1:8080/health

echo "Login to http://localhost:3000/"
