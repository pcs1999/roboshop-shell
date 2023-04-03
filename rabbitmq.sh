source common.sh

if [ -z "${roboshop_mysql_password}" ]; then
  echo "Variable root_mysql_password is needed"
  exit
fi

print_head " Configure YUM Repos from the script provided by vendor "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
condition_check

print_head " install erlang "
yum install erlang -y
condition_check

print_head "downloading packges of raabittmq  "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
condition_check


print_head "  install rabbitmq-server "
yum install rabbitmq-server -y
condition_check

print_head "enable rabbitmq-server  "
systemctl enable rabbitmq-server
condition_check

print_head "start rabbitmq-server  "
systemctl start rabbitmq-server
condition_check

print_head " add_user roboshop  "
rabbitmqctl add_user roboshop ${roboshop_mysql_password}
condition_check

print_head "  administrator "
rabbitmqctl set_user_tags roboshop administrator
condition_check

print_head "set_permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
condition_check