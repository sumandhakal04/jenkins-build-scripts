echo "##################"
echo "# Get parameters from build.sh"
echo "##################"

PROJECT_NAME=$1
PROJECT_LOCATION=$2
BACKUP_LOCATION=$3
LOGON_USER=$4
CACHE_CLEANUP_SCRIPT_LOCATION=$5
ENVIRONMENT=$6

today=`date '+%Y_%m_%d_%H_%M_%S'`;
echo "PROJECT NAME : $1"
echo "PROJECT_LOCATION : $2"
echo "BACKUP_LOCATION : $3"
echo "LOGON_USER : $4"
echo "CACHE_CLEANUP_SCRIPT_LOCATION : $5"
echo "ENVIRONMENT : $6"

echo "##################"
echo "# Take backup for old build"
echo "##################"

tar --exclude="$PROJECT_LOCATION/logs/*log*" --exclude="$PROJECT_LOCATION/*log*" --exclude="$PROJECT_LOCATION/nohup.out" --exclude="nohup.out" -zcvf $BACKUP_LOCATION/$PROJECT_NAME-$today.tar.gz $PROJECT_LOCATION

echo "##################"
echo "# Extracting the tar files"
echo "##################"

cd /tmp
mkdir $PROJECT_NAME  
mv $PROJECT_NAME.tar $PROJECT_NAME ##copying tar file inside project name
cd $PROJECT_NAME
tar -xvf $PROJECT_NAME.tar  ## extracting the tar file
rm $PROJECT_NAME.tar -rf

echo "##################"
echo "# Cleaning the python cache files"
echo "##################"

sh $CACHE_CLEANUP_SCRIPT_LOCATION

echo "##################"
echo "Copying the file in Destination path"
echo "##################"

rsync -av --progress . $PROJECT_LOCATION

echo "##################"
echo "# Granting permissions"	
echo "##################"

chmod -R +x $PROJECT_LOCATION
