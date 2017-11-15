smtmp=$(date +%Y%m%d%H%M%S)
logpath=~/backup/backup.log
echo "${smtmp}-------------------------��ʼ������־���ݺ�ɾ��-------------------------">>${logpath}
#!/backup/sh
#*****************************************************************
#���ݲ��ԣ�
##ÿ�춨�ڰ���־��һ��ǰ����������ڴ�Ŀ¼
#������
#ԴĿ¼:
#~/log
#~/trc
#Ŀ��Ŀ¼
#~/backup

#*****************************************************************
#���ű�ִ�е���־�ļ�
echo "************************************************************">>${logpath}
echo "======start  backup log and trc=======">>${logpath}
#��ȡ1��ǰ��ʱ��������
#ÿ�մ��ǰһ����־
backupday=${1}
if [ -z ${backupday} ]
	then
	backupday=$(date -d  -1day +%d)
fi
backupday_y=$(date +%Y%m)
backupday_y=${backupday_y}${backupday}
smtmp=$(date +%Y%m%d%H%M%S)
echo "backupday================${backupday}">>${logpath}
localdir_trc=~/trc/
localdir_log=~/log/
backupdir=~/backup/
echo "${smtmp}  backup files start">>${logpath}
#**********************����Ӧ��Ŀ¼�±���1����ǰ���ļ������tar��*********************************
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} =========backup trc========">>${logpath}
cd ${localdir_trc}
#������Ŀ¼���ڣ�����
if [ -d ${backupday} ]
then
  cd ${backupday}
  CURTIME=$(date +%H%M%S)
  mkdir -p ${CURTIME}
  for file in `ls`
	do
	  file=`basename ${file}`
	  if [ -f ${file} ]
	  then
	        mv ${file} ${CURTIME}
  	fi
	done
  backuppath=${backupdir}${backupday}"/trc/"
  mkdir -p ${backuppath}
  for file in `ls`
	do
		dirname=`basename ${file}`
		tar -czf ${backuppath}${dirname}_${backupday_y}.tar.gz ${dirname}
		smtmp=$(date +%Y%m%d%H%M%S)
		echo "${smtmp}${backuppath}${dirname}_${backupday_y}.tar.gz������">>${logpath}
	done
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp}${backuppath}rest_${backupday_y}.tar.gz������">>${logpath}
else
  echo "${smtmp} ${localdir_trc}${backupday} is not exist or empty(Don't deal with)">>${logpath}
fi
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} ==========backup log========">>${logpath}
cd ${localdir_log}
if [ -d ${backupday} ]
then
  cd ${backupday}
  CURTIME=$(date +%H%M%S)
  mkdir -p ${CURTIME}
  for file in `ls`
	do
	  file=`basename ${file}`
	  if [ -f ${file} ]
	  then
	        mv ${file} ${CURTIME}
  	fi
	done
  backuppath=${backupdir}${backupday}"/log/"
  mkdir -p ${backuppath}
  for file in `ls`
	do
		dirname=`basename ${file}`
		tar -czf ${backuppath}${dirname}_${backupday_y}.tar.gz ${dirname}
		smtmp=$(date +%Y%m%d%H%M%S)
		echo "${smtmp}${backuppath}${dirname}_${backupday_y}.tar.gz������">>${logpath}
	done
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp}${backuppath}rest_${backupday_y}.tar.gz������">>${logpath}
else
  echo "${smtmp} ${localdir_log}${day} is not exist or empty(Don't deal with)">>${logpath}
fi
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} deleting and backup is over">>${logpath}
#*************************����ӦĿ¼��ɾ��7����ǰ����־�ļ�*****************************
delday=${2}
if [ -z ${delday} ]
	then
	delday=$(date -d  -8day +%d)
fi
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}  delete trc start">>${logpath}
cd ${localdir_trc}
echo  "delday====${delday}">>${logpath}
mkdir ${localdir_trc}wsy/
rsync --delete -d wsy/ ${localdir_trc}${delday}/
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}  delete trc over">>${logpath}
rm -rf ${localdir_trc}wsy
echo "${smtmp}  delete log start">>${logpath}
cd ${localdir_log}
mkdir ${localdir_log}wsy/
rsync --delete -d wsy/ ${localdir_log}${delday}/ 
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}  delete log over">>${logpath}
rm -rf ${localdir_log}wsy/
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} delete old file success.">>${logpath}

#REMOTE_IP=127.0.0.1
#USER=user
#PASSWD=1234qwer
#ftp -n ${$REMOTE_IP} <<END
#  user ${USER} ${PASSWD}
#  prompt
#  bin
#  cd $REMOTE_DIR
#  lcd ${localdir_trc}
#  mput ${backfilename_trc}
#  lcd $localdir_log
#  mput $backfilename_log
#  bye
#END
