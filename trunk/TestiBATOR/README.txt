Test iBATOR
--------------------------------------------------

1. 简介
iBATOR是使用XML配置文件, 生成iBATIS配置文件及类模型的工具
需要安装eclipse插件
Apache iBATIS Ibator Feature - http://ibatis.apache.org/tools/ibator/

参考:
http://ibatis.apache.org/docs/tools/ibator/
http://ibatis.apache.org/docs/tools/ibator/configreference/ibatorPlugin.html

主要功能:
* 生成domain类
* 生成dao类
* 生成SqlMap配置文件

2. 运行方式
* 启动 H2 数据库
    resources/tools/h2/h2w.bat
* 初始化数据库
    Account.sql
* 运行 iBATOR
    ibatorConfig.xml - Generate iBATIS Artifacts
* 执行测试
    src/test/dao/AccountDAOImplTest.java - JUnit Test

3. 注意
通过iBATOR插件生成的SqlMapConfig.xml没有transactionManager配置, 需要手工添加, 否则测试不成功
