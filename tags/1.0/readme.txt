SPRING FRAMEWORK SIMPLE Template Project, release 1.0 (2010-03-10)
--------------------------------------------------

1. 简介
SIMPLE Template Project(以下简称Simple)是一个项目模板, 以 Spring 2.5.6 为基础搭建的. 主要目的是: 
* 统一开发环境, 以此模板为基础快速搭建集成 Spring 开发环境
* 拆分理解 Spring 各个模块
* 示例代码帮助开发, 方便积累

主要功能:
* IoC / DI
* AOP

2. 发布信息
Simple是一个 Eclipse(eclipse-jee-galileo-SR1, Galileo Packages [based on Eclipse 3.5 SR1]) Java Project

lib目录下包含 Spring 框架jar库, 以及依赖库, 括号内的指仅在个别功能的时候需要
* spring-core 
  依赖 commons-logging
* spring-beans
  依赖 spring-core
* spring-aop
  依赖 spring-core, (spring-beans, AOP Alliance, cglib)
* log4j

3. 运行方式
test.TestMain Run As Java Application 