@echo off
mode con cols=50 lines=10

title 根据运行脚本时的时间自动切换到不同的IP配置
rem /** 
rem  * 例如设定 8:00 < 运行时时间 < 17:30 时切换到工作的IP配置
rem  * 17:30 < 运行时时间 时切换到家里的IP配置
rem  * @author Sun
rem  */

rem // 配置IP
rem // 家里用的IP配置
    set homeIp="本地连接" static 192.168.1.31 255.255.255.0 192.168.1.1 none
    set homePrimaryDns="本地连接" static 202.103.96.112 primary
    set homeBackupDns="本地连接" 61.234.254.5
rem // 公司用的IP配置
    set companyIp="本地连接" dhcp

rem // 配置切换IP的小时分段, 目前只支持一个时间分段, 可用于切换2种IP配置
    set hourSection=17

echo %date% %time%
rem // 获取当前日期的星期部分, 日期格式为: 2011-06-15 星期三 => 三
    set day=%date:~13,1%
rem // 获取当前时间值的小时部分, 时间格式为: 22:43:11.18 => 22
    set hh=%time:~0,2%

rem // 根据时间和星期来决定如何切换IP配置
rem // 工作日按时间来切换IP配置, 周末(六, 日)不管时间直接配置为家里用的IP配置
    if %day% == 六 goto setHomeIp
    if %day% == 日 goto setHomeIp
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