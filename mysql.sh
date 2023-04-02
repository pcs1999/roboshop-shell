
source common.sh

component= mysqld

print_head "disable MySQL 8 version."
dnf module disable mysql -y &>>${LOG}
condition_check

print_head "installing ${component} "
yum install mysql-community-server -y &>>${LOG}
condition_check

print_head "enabling ${component} "
systemctl enable ${component} &>>${LOG}
condition_check

print_head " start ${component} "
systemctl start ${component} &>>${LOG}
condition_check

print_head "changing  the default root password of ${component} "
mysql_secure_installation --set-root-pass RoboShop@1
condition_check

