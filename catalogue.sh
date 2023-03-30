set_location=$(pwd)
LOG=/tmp/roboshop.log
source common.sh

echo -e "\e[32m Setup NodeJS repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
condition_check

echo -e "\e[32m installing nodejs \e[0m"
yum install nodejs -y &>>${LOG}
condition_check

echo -e "\e[32m adding user roboshop \e[0m"
useradd roboshop &>>${LOG}
condition_check

mkdir -p /app &>>${LOG}


echo -e "\e[32m downloading content \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
condition_check

echo -e "\e[32m   removing any old content\e[0m"
rm -rf /app/* &>>${LOG}
condition_check


echo -e "\e[32m change to app directory \e[0m"
cd /app &>>${LOG}
condition_check


echo -e "\e[32m unziping the content of catalogue  \e[0m"
unzip /tmp/catalogue.zip &>>${LOG}
condition_check

echo -e "\e[32m  change to app directory \e[0m"
cd /app &>>${LOG}
condition_check

echo -e "\e[32m node packages inatlling \e[0m"
npm install &>>${LOG}
condition_check


echo -e "\e[32m copying catalogue service file \e[0m"
cp ${set_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
condition_check


echo -e "\e[32m  reload the system setup \e[0m"
systemctl daemon-reload &>>${LOG}
condition_check


echo -e "\e[32m enable catalogue \e[0m"
systemctl enable catalogue &>>${LOG}
condition_check


echo -e "\e[32m strting catalogue \e[0m"
systemctl start catalogue &>>${LOG}
condition_check


echo -e "\e[32m copying repo file \e[0m"
cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
condition_check


echo -e "\e[32m installing mongod shell from repo \e[0m"
yum install mongodb-org-shell -y &>>${LOG}
condition_check


echo -e "\e[32m redirecting js files \e[0m"
mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js &>>${LOG}
condition_check



