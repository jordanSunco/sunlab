@echo off
call ant
call ant -Durl=http://192.168.19.204:8080/manager -Dusername=admin -Dpassword="" -q
pause