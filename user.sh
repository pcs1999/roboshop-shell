
source common.sh

print_head " Setup NodeJS repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
condition_check

print_head " installing nodejs "
yum install nodejs -y &>>${LOG}
condition_check

print_head " adding user roboshop "
id roboshop
user_check
condition_check

mkdir -p /app &>>${LOG}


print_head " downloading content "
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${LOG}
condition_check

print_head "   removing any old content"
rm -rf /app/* &>>${LOG}
condition_check


print_head " change to app directory "
cd /app &>>${LOG}
condition_check


print_head " unziping the content of user  "
unzip /tmp/user.zip &>>${LOG}
condition_check

print_head "  change to app directory "
cd /app &>>${LOG}
condition_check

print_head " node packages inatlling "
npm install &>>${LOG}
condition_check


print_head " copying user service file "
cp ${set_location}/files/user.service /etc/systemd/system/user.service &>>${LOG}
condition_check


print_head "  reload the system setup "
systemctl daemon-reload &>>${LOG}
condition_check


print_head " enable user "
systemctl enable user &>>${LOG}
condition_check


print_head " strting user "
systemctl start user &>>${LOG}
condition_check 


print_head " copying repo file "
cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
condition_check


print_head " installing mongod shell from repo "
yum install mongodb-org-shell -y &>>${LOG}
condition_check


print_head " redirecting js files "
mongo --host mongodb-dev.chandupcs.online </app/schema/user.js &>>${LOG}
condition_check



