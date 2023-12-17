## Задание № 7. Управление пакетами. Дистрибьюция софта ##
- Создать свой RPM пакет.
- Создать свой репозиторий и разместить там ранее собранный RPM.

Для выполнения задания, я действовал по методичке (в хорошем смысле). Но некоторые изменения пришлось внести, т.к. CentOS 8 Stream не поднялся, и я использовал CentOS 7. Во всех местах, где требовалось скачать пакеты, я изменил ссылки на версии для CentOS 7. В Vagrantfile, в секции provision, вызывается скрипт **script.sh**. В скрипте есть подробные комментарии. Чтобы убедиться в работоспособности репозитория, установим редактор nano:

[root@otus-task7 ~]# yum --disablerepo="*" --enablerepo=test-linux install -y nano\
Loaded plugins: fastestmirror\
Loading mirror speeds from cached hostfile\
test-linux                                                                                                                    | 2.9 kB  00:00:00\
test-linux/primary_db                                                                                                         | 3.4 kB  00:00:00\
Resolving Dependencies\
--> Running transaction check\
---> Package nano.x86_64 0:2.3.1-10.el7 will be installed\
--> Finished Dependency Resolution\

Dependencies Resolved\

=====================================================================================================================================================\
 Package                        Arch                             Version                                  Repository                            Size\
=====================================================================================================================================================\
Installing:\
 nano                           x86_64                           2.3.1-10.el7                             test-linux                           440 k\

Transaction Summary\
=====================================================================================================================================================\
Install  1 Package\

Total download size: 440 k\
Installed size: 1.6 M\
Downloading packages:\
nano-2.3.1-10.el7.x86_64.rpm                                                                                                  | 440 kB  00:00:00\
Running transaction check\
Running transaction test\
Transaction test succeeded\
Running transaction\
  Installing : nano-2.3.1-10.el7.x86_64                                                                                                          1/1\
  Verifying  : nano-2.3.1-10.el7.x86_64                                                                                                          1/1\

Installed:\
  nano.x86_64 0:2.3.1-10.el7\

Complete!
