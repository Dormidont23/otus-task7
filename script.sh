#!/bin/bash

sudo -i
# Некоторые пакеты, которые пригодятся при выполнении задания
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc lynx

cd /root
# Загрузка SRPM пакета NGINX и установка в каталог /root
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.24.0-1.el7.ngx.src.rpm
rpm -i nginx-1.*
# Скачать и разархивировать openssl
wget --no-check-certificate https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz
tar -xvf openssl-1.1.1k.tar.gz
# Разобраться с зависимостями чтобы в процессе сборки не было ошибок
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
# Подправить файл nginx.spec файл, чтобы собрать nginx с поддержкой openssl
sed -i 's!--with-debug!--with-openssl=/root/openssl-1.1.1k!' /root/rpmbuild/SPECS/nginx.spec
# Сборка RPM-пакета
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
# Установка пакета
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el7.ngx.x86_64.rpm
systemctl start nginx
# Создать каталог repo для будущего репозитория
mkdir /usr/share/nginx/html/repo
# Копируем туда собранный RPM и RPM для установки репозитория Percona-Server
cp /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.1.0/binary/redhat/7/x86_64/percona-orchestrator-3.2.6-11.el7.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-11.el7.x86_64.rpm
# Инициализация репозитория
createrepo /usr/share/nginx/html/repo/
# Добавление директивы "autoindex on;" в конфигурационный файл nginx'а
sed -i 's!index.htm;!index.htm;\n\tautoindex on;!' /etc/nginx/conf.d/default.conf
# Передёрнем nginx
nginx -s reload
