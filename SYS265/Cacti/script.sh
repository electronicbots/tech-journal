#!/bin/bash

echo $'\e[1;32m'"sudo ./script.sh <username> <password>"$'\e[0m'
if [ "$EUID" -ne 0 ]
  then
        echo $'\e[1;31m'"Please run as root"$'\e[0m'
        exit
fi

echo $'\e[1;32m'"Configuring SensuGo"$'\e[0m'
echo ""
cd /tmp
curl -s https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh | bash
yum -y install sensu-go-backend
curl -L https://docs.sensu.io/sensu-go/latest/files/backend.yml -o /etc/sensu/backend.yml
service sensu-backend start
service sensu-backend status

echo $'\e[1;32m'"Sensu-Backend is running?"$'\e[0m'
echo ""
export SENSU_BACKEND_CLUSTER_ADMIN_USERNAME=$1
export SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD=$2
sensu-backend init
echo ""
curl http://127.0.0.1:8080/health
echo ""
echo $'\e[1;32m'"Healthy is set to True?"$'\e[0m'
echo ""
echo "Configuring Firwall"
firewall-cmd --permanent --add-port 2379/tcp
firewall-cmd --permanent --add-port 2380/tcp
firewall-cmd --permanent --add-port 3000/tcp
firewall-cmd --permanent --add-port 6060/tcp
firewall-cmd --permanent --add-port 8080/tcp
firewall-cmd --permanent --add-port 8081/tcp
firewall-cmd --permanent --add-port 3030/tcp
firewall-cmd --permanent --add-port 3031/tcp
firewall-cmd --permanent --add-port 8125/udp
echo ""
echo $'\e[1;32m'"Login to the link below using the credentials you set"$'\e[0m'
echo ""
echo $'\e[1;31m'"http://localhost:3000/"$'\e[0m'
