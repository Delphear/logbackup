smtmp=$(date +%Y%m%d%H%M%S)
today=$(date +%d)
logpath=${HWORKDIR}/backup/${today}/backup.log
mkdir -p ${HWORKDIR}/backup/${today}
echo "${smtmp}-------------------------开始进行日志备份和删除-------------------------">>${logpath}
#!/backup/sh
#*****************************************************************
#备份策略：
##每天定期把日志（一天前）打包备份在此目录
#包括：
#源目录:
#${HWORKDIR}/log
#${HWORKDIR}/trc
#目标目录
#${HWORKDIR}/backup

#*****************************************************************
#本脚本执行的日志文件
echo "======start  backup log and trc=======">>${logpath}
#获取1天前的时间年月日
#每日打包前一天日志
backupday=${1}
if [ -z ${backupday} ]
	then
	backupday=$(date -d  -1day +%d)
fi
backupday_y=$(date +%Y%m%d)
backupday_y=${backupday_y}
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp}操作日期================${backupday_y}">>${logpath}
echo "${smtmp}备份日期================${backupday}">>${logpath}
localdir_trc=${HWORKDIR}/trc/
localdir_log=${HWORKDIR}/log/
backupdir=${HWORKDIR}/backup/
echo "${smtmp}  backup files start">>${logpath}
#**********************到相应的目录下备份1天以前的文件打包成tar包*********************************
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} =========backup trc========">>${logpath}
cd ${localdir_trc}
#如果这个目录存在，则打包
if [ -d ${backupday} ]
then
	#打包之前先clean一下
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp} =========打包之前先clean,开始========">>${logpath}
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
	echo "${smtmp} =========打包之前先clean,结束，开始打包========">>${logpath}
  backuppath=${backupdir}${backupday}"/trc/"
  mkdir -p ${backuppath}
  for file in `ls`
	do
		dirname=`basename ${file}`
		tar -czf ${backuppath}${backupday_y}_${backupday}_${dirname}.tar.gz ${dirname}
		smtmp=$(date +%Y%m%d%H%M%S)
		echo "${smtmp}${backuppath}${dirname}_${backupday_y}.tar.gz打包完成">>${logpath}
	done
else
  echo "${smtmp} ${localdir_trc}${backupday} is not exist or empty(Don't deal with)">>${logpath}
fi
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} ==========backup log========">>${logpath}
cd ${localdir_log}
if [ -d ${backupday} ]
then
	#打包之前先clean一下
	smtmp=$(date +%Y%m%d%H%M%S)
	echo "${smtmp} =========打包之前先clean,开始========">>${logpath}
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
	echo "${smtmp} =========打包之前先clean,结束，开始打包========">>${logpath}
  backuppath=${backupdir}${backupday}"/log/"
  mkdir -p ${backuppath}
  for file in `ls`
	do
		dirname=`basename ${file}`
		tar -czf ${backuppath}${backupday_y}_${backupday}_${dirname}.tar.gz ${dirname}
		smtmp=$(date +%Y%m%d%H%M%S)
		echo "${smtmp}${backuppath}${dirname}_${backupday_y}.tar.gz打包完成">>${logpath}
	done
else
  echo "${smtmp} ${localdir_log}${day} is not exist or empty(Don't deal with)">>${logpath}
fi
smtmp=$(date +%Y%m%d%H%M%S)
echo "${smtmp} deleting and backup is over">>${logpath}
#*************************到相应目录下删除7天以前的日志文件*****************************
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
