/*
 * Copyright
 * 
 * 免费使用修改再发布, 最好以邮件形式先通知我, 谢谢
 */

/**
 * 使用ANT + JavaScript, 对指定文件夹文件进行批量打包(zip), 再发送邮件归档备份.
 * 主要目的是将一批文件(大小不一), 打包成相同大小的zip包, 这样每个包都能独立使用,
 * 而不是像分卷压缩, 需要取得全部的包后, 才能解压缩使用.
 * 
 * @author Sun klsforever@gmail.com
 * @version 1.0 final, 2010-06-03
 * @link {http://www.sitepen.com/blog/2001/09/25/javascript-and-ant/}
 */

// import statements
// importPackage(java.io);
importClass(java.io.File);
importClass(org.apache.tools.ant.taskdefs.Zip);
importClass(org.apache.tools.ant.taskdefs.Zip.Duplicate);

var mb2Byte = 1024 * 1024;

// Access to Ant-Properties by their names
//var enableLog = parseInt(project.getProperty("log.enable"));
var enableClear = parseInt(project.getProperty("clear.enable"));
var deleteVerbose = Boolean(project.getProperty("delete.verbose"));
var enableUnzip = parseInt(project.getProperty("unzip.enable"));
var unzipFolder = project.getProperty("unzip.folder");
var zipEncoding = project.getProperty("zip.encoding");
// Mail config
var enableMail = parseInt(project.getProperty("mail.enable"));
var mailHost = project.getProperty("mail.mailhost");
var mailPort = project.getProperty("mail.mailport");
var enableMailSsl = Boolean(project.getProperty("mail.ssl"));
var mailFrom = project.getProperty("mail.from");
var mailPassword = project.getProperty("mail.password");
var mailToList = project.getProperty("mail.tolist");

var backupDir = project.getProperty("backup.dir");
var backupFileIncludes = project.getProperty("backup.file.includes");
var backupFileExcludes = project.getProperty("backup.file.excludes");

// MB
var zipFileSizeMb = project.getProperty("zip.file.size");
// byte
var zipFileSize = zipFileSizeMb * mb2Byte;

// TODO 输出文件名
var backupFileName = backupDir.substring(backupDir.lastIndexOf("/") + 1,
    backupDir.length());

// Create a <fileset dir="" includes=""/>
var fs = project.createDataType("fileset");
fs.setDir(new File(backupDir));
//fs.setIncludes(backupFileIncludes);
//fs.setExcludes(backupFileExcludes);

// Get the files (array) of that fileset
var ds = fs.getDirectoryScanner(project);
var srcFiles = ds.getIncludedFiles();

var zipFileNames = new Array();

backup();

/**
 * 进行文件备份操作, 将文件打包为规定大小的zip文件
 */
function backup() {
    var fileName = "";
    var fileNameArray = new Array();
    var fileSize = 0;
    var fileSizeSum = 0;

    for (var i = 0; i < srcFiles.length; i++) {
        fileName = srcFiles[i];
        fileNameArray.push(fileName);

        // get the values via Java API
        fileSize = new File(backupDir, srcFiles[i]).length();
        fileSizeSum += fileSize;

        // 如果单文件大小大于限定的打包文件大小, 则直接跳过这个文件不要
        if (fileSize > zipFileSize) {
            log(fileName + ": " + fileSize / mb2Byte + "MB > "
                + zipFileSizeMb + "MB");

            // 还原需要进行打包的文件名和文件总大小
            fileNameArray.length = 0;
            fileSizeSum = 0;
            continue;
        }

        // 如果累加的文件大小大于限定的打包文件大小,
        // 则去掉刚累加的文件(这时候的大小肯定符合限定大小), 进行一次打包,
        // 循环从去掉的那个文件开始
        if (fileSizeSum > zipFileSize) {
            log("增加" + fileName + "后, 总文件大小: " + fileSizeSum / mb2Byte
                + "MB > " + zipFileSizeMb + "MB");
            log("去掉刚增加的文件后, 总文件大小: " + (fileSizeSum - fileSize) / mb2Byte
                + "MB < " + zipFileSizeMb + "MB");

            // 去掉刚增加的文件
            fileNameArray.length = fileNameArray.length - 1;
            // 循环从刚去掉的文件开始
            i--;

            log(fileNameArray);
            archive(fileNameArray);

            // 还原需要进行打包的文件名和文件总大小
            fileNameArray.length = 0;
            fileSizeSum = 0;
        }
    }

    // 打包最后剩下的文件, 不会大于限定的打包文件大小
    if (fileNameArray.length != 0) {
        log("最后剩下的文件总大小: " + fileSizeSum / mb2Byte + "MB");
        log(fileNameArray);
        archive(fileNameArray);
    }

    // 解压测试文件是否打包成功
    if (enableUnzip) {
        unZipFile();
    }

    // 删除所有打包的zip文件和unzip文件
    if (enableClear) {
        clear();
    }
}

function archive(fileNameArray) {
    var zipFileName = getFileName(backupFileName, fileNameArray[0],
        fileNameArray[fileNameArray.length - 1], "zip");

    zipFile(zipFileName, fileNameArray);
    zipFileNames.push(zipFileName);

    // 发送邮件备份打包文件
    if (enableMail) {
        // 需要进行zip操作的文件名列表(使用用逗号分割)
        sendMail(getFileNameWithoutExtension(zipFileName),
            fileNameArray.toString(), zipFileName);
    }
}

function zipFile(zipFileName, fileNameArray) {
    var zip = project.createTask("zip");
    zip.setEncoding(zipEncoding);
    zip.setBasedir(new File(backupDir));
    zip.setDestFile(new File(backupDir, zipFileName));

    // 使用fileset 对付文件名中有空格的情况
    if (fileNameArray.toString().match(/\s/)) {
        var fs = project.createDataType("fileset");
        fs.setDir(new File(backupDir));
        fs.appendIncludes(fileNameArray);
        zip.addFileset(fs);
    }

    // TODO 为什么 fileset 已经过滤掉了文件, 还需要设置zip.includes?
    zip.setIncludes(fileNameArray);
    // TODO 由于设置了2次文件过滤, 莫名出现重复文件(文件名中没有空格)
    var duplicate = new Zip.Duplicate();
    duplicate.setValue("preserve");
    zip.setDuplicate(duplicate);

    zip.perform();
}

function unZipFile() {
    var unZip = project.createTask("unzip");
    unZip.setEncoding(zipEncoding);
    unZip.setDest(new File(backupDir, unzipFolder));

    var fs = project.createDataType("fileset");
    fs.setDir(new File(backupDir));
    fs.appendIncludes(zipFileNames);
    unZip.addFileset(fs);

    unZip.perform();
}

function sendMail(subject, message, fileName) {
    var mail = project.createTask("mail");
    mail.setMailhost(mailHost);
    mail.setMailport(mailPort);
    mail.setSSL(enableMailSsl);
    mail.setFrom(mailFrom);
    mail.setUser(mailFrom.substring(0, mailFrom.lastIndexOf("@")));
    mail.setPassword(mailPassword);
    mail.setToList(mailToList);

    mail.setSubject(subject);
    mail.setMessage(message);
    // files是以空格或者逗号分割的
    // 当文件全路径中包含空格时, 就会悲剧了, 改用fileset
    // mail.setFiles(files);
    // fileset.setIncludes也会有空格问题
    // 不过发邮件附件只有一个文件, 使用setFile加入单个文件就可以了
    var fs = project.createDataType("fileset");
    fs.setDir(new File(backupDir));
    // shortcut for specifying a single-file fileset
    fs.setFile(new File(backupDir, fileName));
    mail.addFileset(fs);

    mail.perform();
}

/**
 * 清除打包程序生成的zip文件和unzip文件
 */
function clear() {
    var deleteTask = project.createTask("delete");
    deleteTask.setVerbose(deleteVerbose);
    deleteTask.setDir(new File(backupDir, unzipFolder));

    var fs = project.createDataType("fileset");
    fs.setDir(new File(backupDir));
    fs.appendIncludes(zipFileNames);
    deleteTask.addFileset(fs);

    deleteTask.perform();
}

/**
 * 获得由起始文件名组合而成的文件名
 * 格式为fileName(startFileName-endFileName).extension
 */
function getFileName(baseName, startFileName, endFileName, extension) {
    var fileName = baseName
        + "("
        + getFileNameWithoutExtension(startFileName)
        + "-"
        + getFileNameWithoutExtension(endFileName)
        + ")";
    return fileName + "." + extension;
}

function getFileNameWithoutExtension(fileName) {
    return fileName.substring(0, fileName.lastIndexOf("."));
}

function log(message) {
    // 采用Project.log(message) 来做日志, 代替echo task, 不再配置是否开启日志
    project.log(message);
//    if (enableLog) {
//        var echo = project.createTask("echo");
//        echo.setMessage(message);
//        echo.perform();
//    }
}
