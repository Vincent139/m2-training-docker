# Formation - M2 - Docker

## Prerequisite

- Stop apache
```
sudo service apache2 stop # stop your host apache server to avoid port conflict
```

- Docker and Docker-compose installation
> if you aldready got docker and docker-compose you can skip this part

### Ubuntu >= 16.04
```
sudo apt-get update && sudo apt-get install -y docker docker-compose
```

### Ubuntu <= 14.04
Manual install (cf. https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)

  - Install docker

  ```
  # remove old dockers
  sudo apt-get remove docker docker-engine docker.io
  # install docker
  sudo apt-get update && sudo apt-get install \
      linux-image-extra-$(uname -r) \
      linux-image-extra-virtual

  sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  sudo apt-get update
  sudo apt-get install docker-ce
  sudo service docker start
  ```
  - Install docker-compose

  ```
  # install docker compose
  sudo curl -L \
  https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` \
  -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version
  ```

  - Reboot

  ```
  reboot
  ```

### Add current user to docker group
```
sudo usermod -aG docker `whoami`
```

### Add current user to webserver group (used for grunt)
```
sudo usermod -aG `cat /etc/passwd | grep ":33:" | cut -d':' -f 1` `whoami`
```

Note: It may be necessary to reboot your pc after adding your user to a group.

## Installation

- Step 1 : checkout Magento sources

- Step 2 : Configure application
  - unsample the .env.sample
    ```
    cd docker
    cp .env.sample .env
    ```

  - edit the .env file to adjust paths and configuration
    ```
    M2_LOCAL_PATH=/home/john/projects/formation/magento
    MAGE_UID=1000
    MAGE_GID=1000
    MYIP=172.22.0.1
    ```
  - (info: if you got a dirty whitespace in your path keep it whitout adding quotes)
  - MYIP is used by XDEBUG to remote connect, please enter your host IP on the network (ex : 10.0.22.57) or from inside the container (if the ip of the container is 172.22.0.8 the host is always the .1 : here 172.22.0.1)
  ```
  ➜  ip addr
      ...
      2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether ec:f4:bb:49:58:e9 brd ff:ff:ff:ff:ff:ff
        inet 10.0.22.57/16 brd 10.0.255.255 scope global dynamic eno1
        ...
  ```
  - The value to MAGE_UID and MAGE_GID must be the same as you're host system id (usefull to do ssh agent forwarding) (by default it's 1000 but it could be 100x on your system, please adjust it)
  ```
  ➜  id
  uid=1000(john) gid=1000(john)
  ```

- Step 3 : Create containers
  ```
  make build
  make start
  ```

- Step 4 : Install Magento without datas
  ```
  make install
  ```
  At this point you could navigate to http://127.0.0.1/ and verify all is working well (admin/admin123 for backends)
  (if you already got domain name entries inside you're host you must change your /etc/hosts file manually)

### Debug CLI commands
**Note**: commands must be executed directly in container.

- The first time, you need to add a new server in PHPStorm configuration (in PHP > Servers section). You need to configure the name "m2-formation-docker" and path mapping

#### Start Debug Session

- Add environment variables
```
export XDEBUG_CONFIG="idekey=PHPSTORM" PHP_IDE_CONFIG="serverName=m2-formation-docker"
```

- Launch your command as usual:
```
php my_cli_script.php
```

Debug session should starts! :)

#### Stop Debug Session

- You only need to remove your environment variables:

```
unset XDEBUG_CONFIG PHP_IDE_CONFIG
```

### Test mailhog
- open http://localhost:8025/

```
# Enter Bash on web container
make bash	  

# send a sample email
php -r 'mail("to@address.com", "Test", "Testing!", "From: my@example.com");'
```
