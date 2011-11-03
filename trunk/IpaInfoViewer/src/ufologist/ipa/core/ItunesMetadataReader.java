/*
 * Copyright 
 */

package ufologist.ipa.core;

import java.io.InputStream;

/**
 * 读取Apple应用的元数据信息(plist)文件
 * 
 * @author Sun
 * @version ItunesMetadataReader.java 2011-11-1 上午10:53:27
 */
public interface ItunesMetadataReader {
    ItunesMetadata getMetadata(InputStream plist);
}
