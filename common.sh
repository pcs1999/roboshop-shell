condition_check () {
  if [ $? -eq 0 ]
  then
    echo echo -e "\e[32mSUCCESS \e[0m"
  else
    echo echo -e "\e[31mFAILURE \e[0m"
  exit
  echo please refer the log->${LOG}
  fi
}