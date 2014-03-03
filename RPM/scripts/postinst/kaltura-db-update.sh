#!/bin/bash - 
#===============================================================================
#          FILE: kaltura-db-update.sh
#         USAGE: ./kaltura-db-update.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: David Bezemer, <themmai@gmail.com>
#  ORGANIZATION: Learnlab
#       CREATED: 03/02/14 16:22:40 EST
#      REVISION:  ---
#===============================================================================
#set -o nounset                              # Treat unset variables as an error

RC=0

if [ -r "/opt/kaltura/app/configurations/system.ini" -a -r /opt/kaltura/app/deployment/sql_updates ];then
		. /opt/kaltura/app/configurations/system.ini
		for SQL in `cat /opt/kaltura/app/deployment/sql_updates`;do
		# if we have the .done file, then some updates already happened
		# need to check if our current one is in the done list, if so, skip it.
				if [ -r  /opt/kaltura/app/deployment/sql_updates.done ];then
						if grep -q $SQL /opt/kaltura/app/deployment/sql_updates.done;then
								continue
						fi
				fi
				mysql kaltura -h $DB1_HOST -u $SUPER_USER -P $DB1_PORT -p$SUPER_USER_PASSWD < $SQL
				RC=$?
		done
		if [ $RC -eq 0 ];then
				cat /opt/kaltura/app/deployment/sql_updates >> /opt/kaltura/app/deployment/sql_updates.done
				rm /opt/kaltura/app/deployment/sql_updates
		fi
fi

if [ -f /opt/kaltura/app/deployment/sql_updates ];then
	echo "error occurred during DB update"
else
	echo "${RC} manual DB updates done"
fi
