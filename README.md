The project takes parameterised inputs from Jenkins and deploys code according to the parameters. The code are first deployed on Jenkins server and then rynced over to the destination servers. copy_code.sh compresses newly deployed source code from Jenkins server to Destination servers. code_build.sh is the main script.

~~~
JOB_NAME = Jenkins Job name
DESTINATION_SERVERS = Destination server IPs separated by commas
DESTINATION_LOCATION = Code deployment path on the destination server
SOURCE_LOCATION = 
BACKUP_LOCATION = Backup of the source code before deploying the new code
LOGON_USER = Logon user to destination servers
CACHE_CLEANUP_SCRIPT_LOCATION = Python cache clearing script location
ENV = Can be Dev/Stage/UAT/Prod with separate Config for each environment
GROUP = Source code repo
~~~

