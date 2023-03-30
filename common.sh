condition_check () {
  if [ $? -eq 0 ]
  then
    echo SUCCESS
  else
    echo FAILURE
  exit
  echo please refer the log->${LOG}
  fi
}