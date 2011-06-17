@echo off
mode con cols=50 lines=10

title �������нű�ʱ��ʱ���Զ��л�����ͬ��IP����
rem /** 
rem  * �����趨 8:00 < ����ʱʱ�� < 17:30 ʱ�л���������IP����
rem  * 17:30 < ����ʱʱ�� ʱ�л��������IP����
rem  * @author Sun
rem  */

rem // ����IP
rem // �����õ�IP����
    set homeIp="��������" static 192.168.1.31 255.255.255.0 192.168.1.1 none
    set homePrimaryDns="��������" static 202.103.96.112 primary
    set homeBackupDns="��������" 61.234.254.5
rem // ��˾�õ�IP����
    set companyIp="��������" dhcp

rem // �����л�IP��Сʱ�ֶ�, Ŀǰֻ֧��һ��ʱ��ֶ�, �������л�2��IP����
    set hourSection=17

echo %date% %time%
rem // ��ȡ��ǰ���ڵ����ڲ���, ���ڸ�ʽΪ: 2011-06-15 ������ => ��
    set day=%date:~13,1%
rem // ��ȡ��ǰʱ��ֵ��Сʱ����, ʱ���ʽΪ: 22:43:11.18 => 22
    set hh=%time:~0,2%

rem // ����ʱ�����������������л�IP����
rem // �����հ�ʱ�����л�IP����, ��ĩ(��, ��)����ʱ��ֱ������Ϊ�����õ�IP����
    if %day% == �� goto setHomeIp
    if %day% == �� goto setHomeIp
    if %hh% leq %hourSection% goto setCompanyIp
    if %hh% gtr %hourSection% goto setHomeIp

:setCompanyIp
echo setCompanyIp
netsh interface ip set addr %companyIp%
netsh interface ip set dns %companyIp%
goto eof

:setHomeIp
echo setHomeIp
netsh interface ip set addr %homeIp%
netsh interface ip set dns %homePrimaryDns%
netsh interface ip add dns %homeBackupDns%
goto eof