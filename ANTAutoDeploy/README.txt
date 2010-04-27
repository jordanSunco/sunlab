主要功能
使用ANT脚本自动部署WAR包到多台Tomcat

1. 安装
   * JDK 1.5
   * apache ANT(解压 apache-ant-1.x.x.zip, 例如d:\software\apache-ant-1.8.0, 以下简称ANT_HOME)
     新增环境变量 ANT_HOME 为 apache ANT 安装目录
     添加%ANT_HOME%/bin 到 path 环境变量
   * 确保所有Tomcat都部署了manager应用(例如手工打开http://localhost:8080/manager/html)
     conf/Catalina/localhost/manager.xml
   * 确保有manager角色的用户才能登陆manager应用
     conf/tomcat-users.xml
     <role rolename="manager"/>
     <user username="tomcat" password="tomcat" roles="tomcat,manager"/>

2. 配置
   * 将需要部署的WAR包(单个)放在target目录下
     jar -cvf TestWebApp.war *
   * 修改build.properties webapp.name 属性为Web应用的名称(一般和WAR包同名)
   * 修改build.bat
     -Durl=Tomcat Manager 应用的地址
     -Dusername=拥有manager角色的用户名
     -Dpassword=拥有manager角色的密码
   * 如果需要新加部署的Tomcat, 请Copy call ant 这一行, 再自行修改相应调用参数

3. 运行build.bat