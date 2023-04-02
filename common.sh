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

  print_head " downloading content "
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  condition_check

  print_head "removing any old content"
  rm -rf /app/*  &>>${LOG}
  condition_check

  print_head "unziping the content of ${component}  "
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  condition_check

}

systemd () {
print_head "copying ${component} service file"
cp ${set_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
condition_check


print_head " reload the system setup "
systemctl daemon-reload &>>${LOG}
condition_check


print_head "enable ${component} "
systemctl enable ${component}  &>>${LOG}
condition_check


print_head " start ${component} "
systemctl start ${component}  &>>${LOG}
condition_check
}


NODEJS (){

print_head " Setup NodeJS repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
condition_check

print_head " installing nodejs "
yum install nodejs -y &>>${LOG}
condition_check


print_head "node packages installing"
cd /app
npm install &>>${LOG}
condition_check


if [ "${schema_load}" == "true" ]; then
    print_head " copying repo file "
    cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
    condition_check

    print_head " installing mongod shell from repo "
    yum install mongodb-org-shell -y  &>>${LOG}
    condition_check


    print_head " redirecting js files "
    mongo --host mongodb-dev.chandupcs.online </app/schema/${component}.js  &>>${LOG}
    condition_check
 fi
}

maven () {
  print_head " installing $(component) "
  yum install $(component) -y &>>${LOG} &>>${LOG}
  condition_check

 app_preq

 systemd


 print_head " clean packege command $(component) "
 cd /app
 mvn clean package &>>${LOG}

 print_head "  moving $(component).jar files from taget folder to app directory "
 mv target/shipping-1.0.jar shipping.jar &>>${LOG} &>>${LOG}



}




