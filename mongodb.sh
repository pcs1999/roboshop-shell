
source common.sh

print_head "downloading mongo.repo file ro"
cp ${set_location}/files/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${LOG}
condition_check

print_head "installing mongodb "
yum install mongodb-org -y &>>${LOG}
condition_check

print_head "enabling mongodb "
systemctl enable mongod &>>${LOG}
condition_check

print_head " start mongodb "
systemctl start mongod &>>${LOG}
condition_check

print_head "changing port to 0.0.0.0  "
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>${LOG}
condition_check

print_head "  restart mongodb"
systemctl restart mongod &>>${LOG}
condition_check