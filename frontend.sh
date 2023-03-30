set_loaction=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[32m installing nginx webserver \e[0m"
yum install nginx -y &>>{LOG}
echo $?

echo -e "\e[32m enabling nginx \e[0m"
systemctl enable nginx &>>{LOG}
echo $?

echo -e "\e[32m start nginx webserver \e[0m"
systemctl start nginx &>>{LOG}
echo $?

echo -e "\e[32m remove old content nginx webserver \e[0m"
rm -rf  /usr/share/nginx/html/*  &>>{LOG}
echo $?

echo -e "\e[32m downloading the content nginx webserver \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>{LOG}
echo $?

echo -e "\e[32m change directory nginx webserver \e[0m"
cd /usr/share/nginx/html &>>{LOG}
echo $?

echo -e "\e[32m uzipping the frontend.zip  \e[0m"
unzip /tmp/frontend.zip &>>{LOG}
echo $?

echo -e "\e[32m config for proxy nginx webserver \e[0m"
cp ${set_loaction}/files/nginx-roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>{LOG}
echo $?