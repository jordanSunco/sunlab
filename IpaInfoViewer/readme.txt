由于需要经常查看共享帐号发表的ipa(iOS App)文件具体对应appstore中的哪个app,
只能手动的在itunes中根据ipa文件的名字来搜索, 很麻烦.
因此自己做了一个java程序, 实现以下功能:
1. 解析ipa文件, 获得plist元数据, 里面包含app的详细介绍, 例如app的名称, 购买帐号, 购买时间等等
    ipa文件其实就是一个zip压缩文件, 打开即可看见iTunesMetadata.plist文件, 是一个XML格式的文件, app的元数据以key-value形式组织
2. 以表格形式展示一个目录中所有的ipa文件的信息, 点击一条记录即跳转到其appstore的页面
    http://itunes.apple.com/us/app/id{itemId}
    
v1.0
选择文件夹, 以表格显示文件夹中所含ipa文件的元数据, 最关键的就是显示
 * ipa文件名
 * 应用的id
 * 应用的名称
 * 应用的icon图标地址
 * 应用所属的类别
 * 应用版本
 * 应用发表时间
 * 购买人帐号
 * 购买时间
选中表格中的一行会在下面的浏览器中显示此应用在appstore中的信息
