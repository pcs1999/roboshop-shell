set_location=$(pwd)
LOG=/tmp/roboshop.log


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}

yum install nodejs -y &>>${LOG}

useradd roboshop &>>${LOG}

mkdir -p /app &>>${LOG}

curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}

rm -rf /app/* &>>${LOG}

cd /app &>>${LOG}

unzip /tmp/catalogue.zip &>>${LOG}

cd /app &>>${LOG}

npm install &>>${LOG}

cp ${set_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}

systemctl daemon-reload &>>${LOG}

systemctl enable catalogue &>>${LOG}
systemctl start catalogue &>>${LOG}

cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}

yum install mongodb-org-shell -y &>>${LOG}

mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js &>>${LOG}



