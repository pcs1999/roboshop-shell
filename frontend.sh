
source common.sh 


print_head  " installing nginx webserver "
yum install nginx -y &>>${LOG}
condition_check

print_head  " enabling nginx  "
systemctl enable nginx &>>${LOG} 

condition_check

print_head  " start nginx webserver "
systemctl start nginx &>>${LOG}
condition_check

print_head  " remove old content nginx webserver "
rm -rf  /usr/share/nginx/html/*  &>>${LOG}
condition_check

print_head  " downloading the content nginx webserver "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
condition_check

print_head  " change directory nginx webserver "
cd /usr/share/nginx/html &>>${LOG}
condition_check

print_head  " uzipping the frontend.zip  "
unzip /tmp/frontend.zip &>>${LOG}
condition_check

print_head  " config for proxy nginx webserver "
cp ${set_location}/files/nginx-roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>${LOG}
condition_check