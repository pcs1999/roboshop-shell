set_location=$(pwd)
LOG=/tmp/roboshop.log

condition_check () {
if [ $? -eq 0 ]
then
    echo  -e "\e[32m SUCCESS \e[0m"
else
    echo  -e "\e[31m FAILURE \e[0m"
    echo "please refer the log-> ${LOG}"
    exit
fi
}

print_head () {
  echo -e "\e[1m  $1 \e[0m"
  }

user1_check () {
print_head "adding user"
id roboshop 
if [ $? -ne 0 ]; then
  useradd roboshop 
fi
}
condition_check

app_preq () {
  user1_check &>>${LOG}

  mkdir -p /app

  print_head " downloading app  content "
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  condition_check

  print_head "removing any old content"
  rm -rf /app/*  &>>${LOG}
  condition_check

  print_head "unziping the app content of ${component}  "
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  condition_check

}

systemd () {
print_head "configure ${component} service file"
cp ${set_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
condition_check


print_head " reload the systemd "
systemctl daemon-reload &>>${LOG}
condition_check


print_head "enable ${component} "
systemctl enable ${component}  &>>${LOG}
condition_check


print_head " start ${component} "
systemctl start ${component}  &>>${LOG}
condition_check
}

schema_load () {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo" ]; then
      print_head " copying repo file "
      cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
      condition_check

      print_head " installing mongod client "
      yum install mongodb-org-shell -y  &>>${LOG}
      condition_check

      print_head " loading mongod "
      mongo  --host mongodb-dev.chandupcs.online </app/schema/${component}.js &>>${LOG}
      condition_check
    fi

      if [ ${schema_type} == "mysql" ]; then

         print_head " installing mysql  "
         yum install mysql -y   &>>${LOG}
         condition_check

         print_head " loading mysql "
         mysql --host mysql-dev.chandupcs.online -uroot -p${root_mysql_password} < /app/schema/shipping.sql &>>${LOG}
         condition_check
      fi
   fi
}


NODEJS (){

print_head " Setup NodeJS repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
condition_check

print_head " installing nodejs "
yum install nodejs -y &>>${LOG}
condition_check

app_preq

print_head "node packages installing"
cd /app
npm install &>>${LOG}
condition_check

systemd

schema_load

}

maven () {
  print_head " installing maven "
  yum install maven -y &>>${LOG}
  condition_check

 app_preq

 print_head " clean packege command $(component) "
 cd /app
 mvn clean package &>>${LOG}

 print_head "moving $(component).jar files from taget folder to app directory "
 mv target/$(component)-1.0.jar $(component).jar &>>${LOG}

systemd

schema_load

}

python () {
  print_head "  "
  yum install python36 gcc python3-devel -y &>>${LOG}
  condition_check

 app_preq

 print_head " installing python requirements "
 cd /app
 pip3.6 install -r requirements.txtprint_head  &>>${LOG}
 condition_check

 print_head " update passwords in ${component} file"
 cd /app
 sed -e -i 's/rabbitmq_roboshop_password/${rabbitmq_roboshop_password}'  ${set_location}/files/${component}.service &>>${LOG}
 condition_check


}

