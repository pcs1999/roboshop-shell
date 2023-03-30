set_loaction=$(pwd)
LOG=/tmp/roboshop.log 
source common.sh 


echo -e "\e[33m installing nginx webserver \e[0m"
yum install nginx -y &>>{LOG}
condition_check

echo -e "\e[33m enabling nginx \e[0m"
systemctl enable nginx &>>{LOG} 

condition_check

echo -e "\e[33m start nginx webserver \e[0m"
systemctl start nginx &>>{LOG}
condition_check

echo -e "\e[33m remove old content nginx webserver \e[0m"
rm -rf  /usr/share/nginx/html/*  &>>{LOG}
condition_check

echo -e "\e[33m downloading the content nginx webserver \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>{LOG}
condition_check

echo -e "\e[33m change directory nginx webserver \e[0m"
cd /usr/share/nginx/html &>>{LOG}
condition_check

echo -e "\e[33m uzipping the frontend.zip  \e[0m"
unzip /tmp/frontend.zip &>>{LOG}
condition_check

echo -e "\e[33m config for proxy nginx webserver \e[0m"
cp ${set_loaction}/files/nginx-roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>{LOG}
condition_check