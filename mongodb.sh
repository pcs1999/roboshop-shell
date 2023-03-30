set_location=$(pwd)
LOG=/tmp/roboshop.log
source common.sh

echo -e "\e[32m  downloading mongo.repo file ro\e[0m"
cp ${set_location}/files/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${LOG}
condition_check

echo -e "\e[32m installing mongodb \e[0m"
yum install mongodb-org -y &>>${LOG}
condition_check

echo -e "\e[32m enabling mongodb \e[0m"
systemctl enable mongod &>>${LOG}
condition_check

echo -e "\e[32m  start mongodb \e[0m"
systemctl start mongod &>>${LOG}
condition_check

echo -e "\e[32m changing port to 0.0.0.0  \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/gi' /etc/mongod.conf &>>${LOG}
condition_check

echo -e "\e[32m  \e[0m"
systemctl restart mongod &>>${LOG}
condition_check