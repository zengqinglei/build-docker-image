# Build a keepalived docker image
There are two ways to build a docker image, and the different functional scenarios are used.
## First: The current repository is used to build docker images with features such as nginx checks.

### Build with makefile
**1. Configuring Makefile:**
``` bash
# The source address of the docker image to be published
Domain= registry.cn-shenzhen.aliyuncs.com
# Docker image name
NAME = $(Domain)/zengql-release/keepalived
# Keepalived official release version number
VERSION = 2.0.8
```
Execute the **make run** command to complete the build

**2. The above compiled image I put in Alibaba Cloud:**
``` bash
docker pull registry.cn-shenzhen.aliyuncs.com/zengql-release/keepalived:2.0.7
```
### Run the docker image
**1. Configure keepalived.conf:**
``` bash
mkdir /keepalived/
cd /keepalived
vim keepalived.conf
```
``` bash
global_defs {
    # Email address notified when switching virtual IP
    notification_email {
        zengql@live.cn
    }
    notification_email_from localhost@localhost.com
    smtp_server 127.0.0.1
    smtp_connect_timeout 30
    router_id LVS_DEVEL
    # Due to the need to execute the nginx check script
    script_user root
    enable_script_security
}
vrrp_script chk_nginx {
    script "/bin/sh /etc/keepalived/scripts/check_nginx.sh"
    # Check every 2 seconds
    interval 2
    # If the check fails, the weight is reduced by 5
    weight -5
    # At least two failures really fail
    fall 3
    # Check success without changing weight
    rise 2
}
vrrp_instance VI_1 {
    interface ens33
    # MASTER OR BACKUP
    state MASTER
    # The virtual route Id must be consistent.
    virtual_router_id 127
    priority 90
    # Authorization must be consistent in order to communicate
    authentication {
       auth_type PASS
       auth_pass 1111
    }
    virtual_ipaddress {
        192.168.0.102
    }
    track_script {
        chk_nginx
    }
}
```
**2. Configure check_nginx.sh:**
``` bash
mkdir scripts/
vim scripts/check_nginx.sh
```
``` bash
#!/bin/bash

for k in 1 2
do
    check_code=$( curl --connect-timeout 3 -sL -w "%{http_code}\\n" http://localhost:80 -o /dev/null )
    if [ "$check_code" != "200" ]; then
        if [ "$k" != "2" ]; then
            sleep 1
        else
            killall keepalived
            exit 1
        fi
    else
       exit 0
       break;
    fi
done
```
**3. Run my keepalived Alibaba Cloud image:**
``` bash
docker run -d --name=keepalived --privileged --restart=always --network=host -v /keepalived/:/etc/keepalived/ registry.cn-shenzhen.aliyuncs.com/zengql-release/keepalived:2.0.7
```

## Second: The following tutorial applies to the [official source](https://github.com/acassen/keepalived) build docker image

### Compiler Environment

* System: Centos 7
* Keepalived: Git clone master branch([My Issues](https://github.com/acassen/keepalived/issues/987)),v2.0.7

### Install software

``` bash
yum -y install aclocal automake autoconf gcc-c++ openssl openssl-devel libnl libnl-devel libnfnetlink-devel
```

### Start compiling

**1. Download the source and compile:**

``` bash
git clone https://github.com/acassen/keepalived.git
cd keepalived/
./build_setup
./configure
make
make dist
```

**2. Use the ll command to check if there is a file with a shortcut, as shown below:**
![image](https://user-images.githubusercontent.com/7374317/44624524-1b31d400-a923-11e8-99be-aebae62c506b.png)  
**3. Delete the shortcut and copy the source file from the shortcut to the file.**

### Start building a docker image

``` bash
make docker
```

### Start the docker image

**1. Create a configuration file :**

``` bash
# vim /keepalived/keepalived.conf

vrrp_instance VI_1 {
    interface ens33
    state MASTER
    virtual_router_id 127
    priority 100

    virtual_ipaddress {
        192.168.0.102
    }
}
```

**2. Running container:**

``` bash
docker run -d --name=keepalived --privileged --restart=always --network=host -v /keepalived/keepalived.conf:/usr/local/etc/keepalived/keepalived.conf keepalived
```

![image](https://user-images.githubusercontent.com/7374317/44624682-15d68880-a927-11e8-8b48-20ab48ad083c.png)
**Remarks:** _The source code is the official author's immediate adjustment on the Master branch according to the Issues([My Issues](https://github.com/acassen/keepalived/issues/987)) I proposed, and the follow-up should be merged into the new version._
