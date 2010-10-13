J2EE 基础项目, 集合Web开发所需的一般框架
* Spring MVC 2.5.6
* iBATIS2
* H2
* JSTL

环境准备
* 启动H2 Server
    resources/tools/h2/h2w.bat
* 初始化表&数据
    resources/sql/Domain.sql
* 部署Web应用到服务器(Tomcat)

测试
    http://localhost:8080/J2eeWithSpring/service/domain/list?id=1
    页面显示
    1, Spring
