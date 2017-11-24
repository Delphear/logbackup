smtmp=$(date +%Y%m%d%H%M%S)
today=$(date +%d)
logpath=${HWORKDIR}/backup/${today}/backup.log
mkdir -p ${HWORKDIR}/backup/${today}
echo "${smtmp}-------------------------��ʼ������־���ݺ�ɾ��-------------------------">>${logpath}
#!/backup/sh
#*****************************************************************
#���ݲ��ԣ�
##ÿ�춨�ڰ���־��һ��ǰ����������ڴ�Ŀ¼
#������
#ԴĿ¼:
#${HWORKDIR}/log
#${HWORKDIR}/trc
#Ŀ��Ŀ¼
#${HWORKDIR}/backup

#*****************************************************************
#���ű�ִ�е���־�ļ�
echo "======start  backup log and trc=======">>${logpath}
#��ȡ1��ǰ��ʱ��������
#ÿ�մ��ǰһ����־
backupday=${1}
if [ -z ${backupday} ]
	then
	backupday=$(date -d  -1day +%d)
fi
backupday_y=$(date +%Y%m%d)
backupday_y=${backupday_y}
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}��������================${backupday_y}">>${logpath}
echo "${smtmp}��������================${backupday}">>${logpath}
localdir_trc=${HWORKDIR}/trc/
localdir_log=${HWORKDIR}/log/
backupdir=${HWORKDIR}/backup/
echo "${smtmp}  backup files start">>${logpath}
#**********************����Ӧ��Ŀ¼�±���1����ǰ���ļ������tar��*********************************
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} =========backup trc========">>${logpath}
cd ${localdir_trc}
#������Ŀ¼���ڣ�����
if [ -d ${backupday} ]
then
	#���֮ǰ��cleanһ��
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp} =========���֮ǰ��clean,��ʼ========">>${logpath}
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
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp} =========���֮ǰ��clean,��������ʼ���========">>${logpath}
  backuppath=${backupdir}${backupday}"/trc/"
  mkdir -p ${backuppath}
  for file in `ls`
	do
		dirname=`basename ${file}`
		tar -czf ${backuppath}${backupday_y}_${backupday}_${dirname}.tar.gz ${dirname}
		smtmp=$(date +%Y%m%d%H%M%S)
		echo "${smtmp}${backuppath}${dirname}_${backupday_y}.tar.gz������">>${logpath}
	done
else
  echo "${smtmp} ${localdir_trc}${backupday} is not exist or empty(Don't deal with)">>${logpath}
fi
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} ==========backup log========">>${logpath}
cd ${localdir_log}
if [ -d ${backupday} ]
then
	#���֮ǰ��cleanһ��
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp} =========���֮ǰ��clean,��ʼ========">>${logpath}
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
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp} =========���֮ǰ��clean,��������ʼ���========">>${logpath}
  backuppath=${backupdir}${backupday}"/log/"
  mkdir -p ${backuppath}
  for file in `ls`
	do
		dirname=`basename ${file}`
		tar -czf ${backuppath}${backupday_y}_${backupday}_${dirname}.tar.gz ${dirname}
		smtmp=$(date +%Y%m%d%H%M%S)
		echo "${smtmp}${backuppath}${dirname}_${backupday_y}.tar.gz������">>${logpath}
	done
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
mkdir -p ${localdir_trc}nulldir/
rsync --delete -d nulldir/ ${localdir_trc}${delday}/
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}  delete trc over">>${logpath}
rm -rf ${localdir_trc}nulldir
echo "${smtmp}  delete log start">>${logpath}
cd ${localdir_log}
mkdir -p ${localdir_log}nulldir/
rsync --delete -d nulldir/ ${localdir_log}${delday}/ 
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}  delete log over">>${logpath}
rm -rf ${localdir_log}nulldir/
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
