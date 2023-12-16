#!/bin/bash

sudo -i
# ��������� ������, ������� ���������� ��� ���������� �������
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc lynx

cd /root
# �������� SRPM ������ NGINX � ��������� � ������� /root
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.24.0-1.el7.ngx.src.rpm
rpm -i nginx-1.*
# ������� � ��������������� openssl
wget --no-check-certificate https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz
tar -xvf openssl-1.1.1k.tar.gz
# ����������� � ������������� ����� � �������� ������ �� ���� ������
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
# ���������� ���� nginx.spec ����, ����� ������� nginx � ���������� openssl
sed -i 's!--with-debug!--with-openssl=/root/openssl-1.1.1k!' /root/rpmbuild/SPECS/nginx.spec
# ������ RPM-������
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
# ��������� ������
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el7.ngx.x86_64.rpm
systemctl start nginx
# ������� ������� repo ��� �������� �����������
mkdir /usr/share/nginx/html/repo
# �������� ���� ��������� RPM � RPM ��� ��������� ����������� Percona-Server
cp /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.1.0/binary/redhat/7/x86_64/percona-orchestrator-3.2.6-11.el7.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-11.el7.x86_64.rpm
# ������������� �����������
createrepo /usr/share/nginx/html/repo/
# ���������� ��������� "autoindex on;" � ���������������� ���� nginx'�
sed -i 's!index.htm;!index.htm;\n\tautoindex on;!' /etc/nginx/conf.d/default.conf
# ��������� nginx
nginx -s reload
