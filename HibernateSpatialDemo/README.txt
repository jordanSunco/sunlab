Hibernate Spatial Demo Project, release 1.0 (2011-04-07)
--------------------------------------------------

1. 简介
通过Hibernate Spatial来映射空间数据库中的空间数据表, 以读写空间数据.
借助于Hibernate Spatial来达到兼容多种空间数据库的目的, 因为各种空间数据库实现存储空间数据的机制稍有不同, 如空间数据的类型以及函数名称等等.
基础框架:
* Hibernate 3.3.2 core
* Hibernate Spatial 1.0
* Hibernate Spatial Oracle Provider 1.0
* JTS 1.8

主要功能:
* 读写Oracle10g空间数据库中的空间数据表
* 空间查询(within)

2. 运行方式
  a. 需要有Oracle10g数据库
  b. 修改hibernate.cfg.xml中的数据库连接信息以适合当前环境
  c. ColaMarketDaoImplTest Run As JUnit Test

3. Use JPA Annotations with Hibernate Spatial
使用UseJPAAnnotation中的文件替换src和libs(增加支持JPA Annotation的lib)

4. 参考
Hibernate Spatial Tutorial
    http://www.hibernatespatial.org/tutorial.html
Oracle Spatial User's Guide and Reference 10g Release 1 (10.1)
    http://www.stanford.edu/dept/itss/docs/oracle/10g/appdev.101/b10826/sdo_objrelschema.htm
