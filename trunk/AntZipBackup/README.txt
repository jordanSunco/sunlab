ANT Zip Backup
--------------------------------------------------

1. 简介
个人电脑上的东西, 始终是依赖于硬盘, 而硬盘是个耗材, 搞不好随时崩掉, 所谓虚拟财富需要定期备份, 否则后悔莫及.
对于文件大而多的情况下, 可以采用分卷压缩的方法, 其弊端是需要取得所有的分卷才能使用.
理想的方式是打包的文件都能够独立运行, 互不影响, 而且我知道每个包有哪些文件.

备份方式: Email(Gmail, QQmail, 163 Mail)
手工过程(繁琐, 机械式):
    1. 打包(zip)本地文件(主要是图片), 由于邮箱附件的大小肯定有限制(Gmail 25M; QQ, 163 50M), 在打包文件肯定不能超过此大小.
            每次都需要选取一定数量的文件, 如果文件数量多, 这个过程就相当郁闷了, 还需要等待打包
    2. 打包好后, 需要发送邮件
            填写主题(附件文件名)啊, 内容(zip所包含的所有文件名)啊, 添加附件等等, 一系列重复劳动
    3. 删除打包备份的文件
使用ANT自动化:
    1. 自动打包文件夹下的所有文件, 符合规定的打包大小
    2. 配置是否自动发送邮件
    3. 配置是否自动解压(unzip)测试打包是否成功
    4. 配置是否清理打包过程产生的文件(zip, unzip)

主要功能:
* 打包文件夹下的文件为规定大小的zip包
* 发送邮件(附件)
* 解压测试打包是否成功
* 清理打包过程产生的文件

2. 发布信息
AntZipBackup是一个 Eclipse(eclipse-jee-galileo-SR1, Galileo Packages [based on Eclipse 3.5 SR1]) Java Project
使用ANT + JavaScript完成自动化zip备份

src目录下包含源码和配置信息
* build.properties
    基础的配置项
* build.xml
    ANT构建配置文件
* scripts.js
    实现程序的逻辑代码, 所有的打包操作等都在这里进行

libs目录下包含ANT Task的依赖库
    在ANT中支持以JavaScript编码方式完成Task(BSF + Rhino)
* commons-logging-1.1.1.jar
* bsf.jar
* js-14.jar
    在ANT中支持发送Email(JavaMail API 1.4.3)
* activation.jar
* mailapi.jar
* smtp.jar

3. 运行方式
* 修改配置文件(build.properties)
    1. 修改需要备份的文件夹路径, 路径分隔符使用斜杠(/), 不支持中文
        backup.dir
    2. 默认不自动发送邮件, 需要启用
        mail.enable=1
    3. 配置邮箱, 如果是使用Gmail发送邮件就不需要修改SMTP
        mail.from
        mail.password
        mail.tolist
* ANT脚本构建(build.xml Run as Ant Build)