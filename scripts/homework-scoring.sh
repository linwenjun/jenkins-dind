#!/bin/sh

set +e

execScriptInDocker() {
  curl -H Content-Type:application/json -X PUT -d "{\"buildNumber\":${BUILD_NUMBER}}" $callback_url
  unzip -o answer.zip __answerBranch
  SCRIPT="evaluate-script-${BUILD_NUMBER}.sh"
  IMAGE="$image"
  echo -e $script > $SCRIPT
  sudo docker run --tty --name $CONTAINER --detach $IMAGE /bin/sh -xc "tail -f /dev/null"         # just to hold container running
  sudo docker cp . $CONTAINER:/var/test-directory # copy directory
  sudo docker exec -i $CONTAINER sh -c "cd /var/test-directory && chmod +x $SCRIPT &&./$SCRIPT" > /tmp/result_detail_${BUILD_NUMBER} 2>&1  # evaluate in container
}

successFunc() {
  echo '' > result
  cat /tmp/result_detail_$BUILD_NUMBER > result 
  version=${GIT_COMMIT}
  curl -X PUT -F "status=4" \
      -F "version=$version" \
      -F "result=@result" $callback_url
}

failedFunc() {
  file="/tmp/result_detail_$BUILD_NUMBER"
  if [ ! -f $file ]
  then
    echo  "仓库不存在，请重新填写仓库地址！" > /tmp/result_detail_${BUILD_NUMBER} 2>&1
  fi
  echo '' > result  #文件存在touch不会重新创建
  cat /tmp/result_detail_$BUILD_NUMBER > result 
  version=${GIT_COMMIT}
  curl -X PUT -F "status=5" \
      -F "version=$version" \
      -F "result=@result" $callback_url
}

finalFunc() {
  sudo docker rm --force ${stack}_${BUILD_NUMBER}
}
 
execScriptInDocker
#  > /dev/null 2>&1
result=$?
if [ $result -eq 0 ]; then
    successFunc
else
    failedFunc
fi

finalFunc
echo "DONE..."
