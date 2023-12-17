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
# �������� ���� ��������� RPM � �������� nano
cp /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm -O /usr/share/nginx/html/repo/nano-2.3.1-10.el7.x86_64.rpm
# ������������� �����������
createrepo /usr/share/nginx/html/repo/
# ���������� ��������� "autoindex on;" � ���������������� ���� nginx'�
sed -i 's!index.htm;!index.htm;\n\tautoindex on;!' /etc/nginx/conf.d/default.conf
# ��������� nginx
nginx -s reload
# ������� ����������� � /etc/yum.repos.d
touch /etc/yum.repos.d/test-linux.repo
echo "[test-linux]" > /etc/yum.repos.d/test-linux.repo
echo "name=test-linux" >> /etc/yum.repos.d/test-linux.repo
echo "baseurl=http://localhost/repo" >> /etc/yum.repos.d/test-linux.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/test-linux.repo
echo "enabled=1" >> /etc/yum.repos.d/test-linux.repo
# ����� ������� ����� ��� �������������� ��������� �� ����������� test-linux, ����� �������� �� ��������� ����������� CentOS
yum --disablerepo="*" --enablerepo=test-linux install -y nano
