@echo off
call ant deploy stop start list -q
call ant deploy stop start list -Durl=http://192.168.200.58:9090/manager -q
call ant deploy stop start list -Durl=http://192.168.19.204:8080/manager -Dusername=admin -Dpassword="" -q
pause