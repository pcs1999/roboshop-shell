set_location=$(pwd)

set -e

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

mkdir -p /app

curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

cd /app

rm -rf *

unzip /tmp/catalogue.zip

cd /app

npm install

cp ${set_location}/files/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue
systemctl start catalogue

cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js



