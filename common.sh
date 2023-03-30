condition_check () {
  if [ $? -eq 0 ]
  then
    echo echo -e "\e[32m SUCCESS \e[0m"
  else
    echo echo -e "\e[31m FAILURE \e[0m"
  exit
  echo please refer the log->${LOG}
  fi
}