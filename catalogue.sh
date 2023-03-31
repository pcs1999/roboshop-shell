
source common.sh

print_head " Setup NodeJS repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
condition_check

print_head " installing nodejs "
yum install nodejs -y &>>${LOG}
condition_check

print_head " adding user roboshop "
useradd roboshop &>>${LOG}
condition_check

mkdir -p /app &>>${LOG}


print_head " downloading content "
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
condition_check

print_head "   removing any old content"
rm -rf /app/* &>>${LOG}
condition_check


print_head " change to app directory "
cd /app &>>${LOG}
condition_check


print_head " unziping the content of catalogue  "
unzip /tmp/catalogue.zip &>>${LOG}
condition_check

print_head "  change to app directory "
cd /app &>>${LOG}
condition_check

print_head " node packages inatlling "
npm install &>>${LOG}
condition_check


print_head " copying catalogue service file "
cp ${set_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
condition_check


print_head "  reload the system setup "
systemctl daemon-reload &>>${LOG}
condition_check


print_head " enable catalogue "
systemctl enable catalogue &>>${LOG}
condition_check


print_head " strting catalogue "
systemctl start catalogue &>>${LOG}
condition_check


print_head " copying repo file "
cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
condition_check


print_head " installing mongod shell from repo "
yum install mongodb-org-shell -y &>>${LOG}
condition_check


print_head " redirecting js files "
mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js &>>${LOG}
condition_check



