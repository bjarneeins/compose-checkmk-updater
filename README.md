# compose-checkmk-updater

Updater for the official checkmk docker image run with docker-compose.

## Usage

1. Define the Variables in the beginning of the script

```bash
nano compose-checkmk-updater.sh
```

```bash
#!/bin/bash

container_name=checkmk
file_dir=/root/docker/checkmk
backup_dir=/home/user/checkmk_backup

...

```

2. Make the script executable

```bash
chmod +x compose-checkmk-updater.sh
```
    
3. Move the script in the same folder as your docker-compose.yml

```bash
mv compose-checkmk-updater.sh /some/dir
```

4. Run the script
```bash
./compose-checkmk-updater.sh
```

5. When asked, define the checkmk version which you want to upgrade to

Example when running the script: 

```sh
New Version? (Current: 1.5.0p15): 1.5.0p16
```

This will update your checkmk project from version 1.5.0p15 to 1.5.0p16.