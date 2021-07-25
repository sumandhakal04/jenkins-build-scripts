echo "##################"
echo "# Get parameters from Jenkins Web"
echo "##################"

figlet $JOB_NAME
echo $JOB_NAME 
echo $DESTINATION_SERVERS
echo $DESTINATION_LOCATION
echo $SOURCE_LOCATION
echo $BACKUP_LOCATION
echo $LOGON_USER
echo $CACHE_CLEANUP_SCRIPT_LOCATION
echo $ENV
echo $GROUP

echo "##################"
echo "# Remove unwanted files "
echo "##################"
cd /var/lib/jenkins/workspace/
rm $JOB_NAME/.git -rf

sync_file_to_tmp(){
    echo "##################"
    echo "# Preparing product packaging "
    echo "##################"
    rsync -av --progress $JOB_NAME /tmp/
}

generate_config_and_copy_to_tmp(){
    echo "##################"
    echo "# Generating and copying config files "
    echo "##################"
    
    cd /var/lib/jenkins/config_generator
    if [[ $GROUP == "python-repo" ]];then
        cp /var/lib/jenkins/config_generator/config-python/${ENV}/config.json /tmp/$JOB_NAME/config-python/config.json
    
    elif [[ $GROUP == "R-repo" ]];then
        cp /var/lib/jenkins/config_generator/config-r/${ENV}/config.json /tmp/$JOB_NAME/config-r/config.json
    
    elif [[ $GROUP == "web-repo" ]];then
        cp /var/lib/jenkins/ansible/config_generator/config-web/${ENV}/config.json /tmp/$JOB_NAME/config-web/config.json

    fi
    
    cd -
}

create_tar_file(){
    echo "##################"
    echo "# Creating the tar file "
    echo "##################"
    cd /tmp/$JOB_NAME/ && tar -cvf /tmp/$JOB_NAME.tar . && cd -
}

send_to_destination(){
    echo "##################"
    echo "# Send to destination"
    echo "##################"
    
    for DESTINATION_SERVER in $(echo $DESTINATION_SERVERS | sed "s/,/ /g")
    do
        echo "Sending project to $DESTINATION_SERVER"
        scp /tmp/$JOB_NAME.tar root@$DESTINATION_SERVER:/tmp
    	ssh -o 'StrictHostKeyChecking=no' $LOGON_USER@$DESTINATION_SERVER 'bash /dev/stdin' $JOB_NAME $DESTINATION_LOCATION $BACKUP_LOCATION $LOGON_USER $CACHE_CLEANUP_SCRIPT_LOCATION $ENV< /build/analytics_build/analytics/analytics_execute.sh
    done
}

cleanup(){
    echo "##################"
    echo "Removing the tar file"
    echo "##################"
    rm /tmp/$JOB_NAME.tar
}

## script starts here ##

sync_file_to_tmp
generate_config_and_copy_to_tmp
create_tar_file
send_to_destination
cleanup
