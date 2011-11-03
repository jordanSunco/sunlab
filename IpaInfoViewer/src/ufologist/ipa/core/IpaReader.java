/*
 * Copyright 
 */

package ufologist.ipa.core;

import java.io.File;
import java.io.IOException;


/**
 * 从iOS App安装文件(.ipa)中提取出应用的元数据信息
 * 
 * @author Sun
 * @version IpaReader.java 2011-11-1 下午03:02:27
 */
public interface IpaReader {
    ItunesMetadata getMetadata(File ipa) throws IOException;
}
