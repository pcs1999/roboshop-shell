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
