#!/bin/bash

container_name=checkmk
file_dir=/root/docker/checkmk
backup_dir=/home/user/checkmk_backup

current_version=$(docker exec -it $container_name omd version | awk '{print $7}' | sed 's/.....$//') 

while [ -z $new_version ]
do
read -p "New Version? (Current: $current_version): " new_version
new_version=$new_version
done

#updating the checkmk files
updateprocess()
{
	cp -r $file_dir $backup_dir
	docker container run -t -d --rm --volumes-from $container_name --name checkmk_update checkmk/check-mk-raw:$new_version bash
	docker cp -L checkmk:/omd/versions/default - | docker cp - checkmk_update:/omd/versions/
	docker exec -it -u cmk checkmk_update omd update
	docker kill checkmk_update
}

#replacing old version in docker-compose file with new one
compose_replace()
{
sed -i s/$current_version/$new_version/g docker-compose.yml
docker-compose down && docker-compose up -d
}

#check if container has new version
check()
{
	if docker ps | grep "$new_version" ;
		then
			echo
			echo "Update successful."
			echo
		else
			echo "Something went wrong."
			exit 0
		fi
}

if docker ps | grep "$new_version" ;
        then
                echo "Version already in use."
		exit 0
        else
		echo "Versioncheck done, beginning update."
		updateprocess
		compose_replace
		check
	fi


