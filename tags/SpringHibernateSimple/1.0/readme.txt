SPRING & Hibernate SIMPLE Template Project, release 1.0 (2010-03-12)
--------------------------------------------------

1. 简介
SPRING & Hibernate SIMPLE Template Project(以下简称SHS)是一个用于Web的快速开发项目模板.
基础框架:
* Spring 2.5.6 (IoC / AOP)
* Hibernate 3.3.2 (ORM)
* Ehcache 1.6.1 (Cache)
主要目的是:
* 统一开发环境, 以此模板为基础快速搭建集成 Spring Web开发环境, 提供了最基础的功能
* 规划配置文件
* 规范开发包

主要功能:
* 注解机制IoC
* 注解机制或XML机制 ORM
* 缓存

2. 发布信息
SHS是一个 Eclipse(eclipse-jee-galileo-SR1, Galileo Packages [based on Eclipse 3.5 SR1]) Dynamic Web Project

lib详解
* 日志模块
  - log4j
* Spring模块
  - IoC(commons-logging, spring-core, spring-beans)
  - AOP(aopalliance, cglib, spring-aop)
  - Context(spring-context)
  - DAO & ORM(spring-jdbc, spring-orm, spring-tx)
  - Web(spring-web)
* JDBC模块
  - h2
* 数据源(连接池)模块
  - 使用Spring自带DriverManagerDataSource
* Hibernate模块
  - DOM4J
  - SLF4J(SLF4J-log4j)
  - JTA
  - commons-collections
  - javassist
  - ANTLR
  - hibernate-core
* Ehcache模块
  - ehcache
  - hibernate-ehcache
  
可选增强库
1. Hibernate注解配置实体类映射
 * JPA(ejb3-persistence)
 * hibernate-annotations(hibernate-commons-annotations)
2. 声明(AOP)事务处理
 * aspectjweaver
 
3. 运行方式
  a. 启动H2数据库(resources/tools/h2/h2.bat)
  b. 连接到jdbc:h2:tcp://localhost/~/test
  c. 运行resources/sql/schema.sql中的SQL语句, 初始化数据
  d. test.TestMain Run As Java Application
  e. SpringHibernateSimple Run On Server