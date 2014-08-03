MovableType Development Environment for my personal use
==

    git clone https://github.com/takeyuweb/vagrant_mt_DE.git projectname
    cd projectname
    rm -rf .git

    vagrant up --provision

Access `http://localhost:8080/mt/`


## Configulations

### MySQL

Database mt

User root

Password (empty)

### Apache 2.2

DocumentRoot /vagrant/public

Log /vagrant/logs

## Troubleshoot

### vagrant up 時にエラー

    Failed to mount folders in Linux guest. This is usually because
    the "vboxsf" file system is not available. Please verify that
    the guest additions are properly installed in the guest and
    can work properly. The command attempted was:

    mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` /vagrant /vagrant
    mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` /vagrant /vagrant

#### 対策

`kernel-devel`のアップデートを許可

    vagrant ssh

    sudo vi /etc/yum.conf
    #exclude=kernel*

    exit

    vagrant reload --provision
