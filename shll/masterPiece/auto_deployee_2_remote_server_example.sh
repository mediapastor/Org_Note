#!/bin/sh
export SSHPASS=jumbo.net
SERVER_HOST=jumbo@192.168.123.127
sshpass -e sftp -oBatchMode=no -b - $SERVER_HOST  << !
cd server/ocms
put $(pwd)/build/libs/ocms-rest-service-0.0.1-SNAPSHOT.jar
!
sshpass -p jumbo.net ssh $SERVER_HOST << !
## remot ####
cd ./server/ocms
echo "current floder :" $(pwd)
# kill not read stdin, so i need to user xargs
pgrep -f ocms | xargs kill -15
sleep 1
echo "check ocms is shutdown ?"
ps -ef | grep "[o]cms"
nohup java -jar ocms-rest-service-0.0.1-SNAPSHOT.jar >> ocms.log &
# look log 40 seconds
timeout 40 tail -f ocms.log
bye
#remote #####
!
