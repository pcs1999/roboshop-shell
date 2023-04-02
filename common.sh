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

user_check () {
print_head "addind user"
id roboshop 
if [ $? -ne 0 ]; then
  useradd roboshop 
fi
}
condition_check

NODEJS (){

print_head " Setup NodeJS repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash 
condition_check

print_head " installing nodejs "
yum install nodejs -y 
condition_check

user_check

mkdir -p /app 

print_head " downloading content "
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
condition_check

print_head "   removing any old content"
rm -rf /app/* 
condition_check


print_head " change to app directory "
cd /app 
condition_check


print_head " unziping the content of ${component}  "
unzip /tmp/${component}.zip 
condition_check

print_head "  change to app directory "
cd /app 
condition_check

print_head " node packages inatlling "
npm install 
condition_check


print_head " copying ${component} service file "
cp ${set_location}/files/${component}.service /etc/systemd/system/${component}.service 
condition_check


print_head "  reload the system setup "
systemctl daemon-reload 
condition_check


print_head " enable ${component} "
systemctl enable ${component} 
condition_check


print_head " start ${component} "
systemctl start ${component} 
condition_check


if [ ${schema_load} == "true" ]; then
    print_head " copying repo file "
    cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo 
    condition_check

    print_head " installing mongod shell from repo "
    yum install mongodb-org-shell -y 
    condition_check


    print_head " redirecting js files "
    mongo --host mongodb-dev.chandupcs.online </app/schema/${component}.js 
    condition_check
 fi
}




