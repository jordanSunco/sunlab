/*
 * Copyright 
 */

package ufologist.ipa.core.impl;

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import ufologist.ipa.core.IpaReader;
import ufologist.ipa.core.ItunesMetadata;
import ufologist.ipa.core.ItunesMetadataReader;

/**
 * .ipa文件就是一个zip压缩包, 其中包含一个iTunesMetadata.plist文件即应用的元数据
 * 
 * @author Sun
 * @version IpaReaderImpl.java 2011-11-1 下午03:11:56
 */
public class IpaReaderImpl implements IpaReader {
    public static final String METADATA_FILE_NAME = "iTunesMetadata.plist";

    private ItunesMetadataReader metadataReader = new XmlMetadataReader();

    public ItunesMetadata getMetadata(File ipa) throws IOException {
        ItunesMetadata metadata = null;

        ZipFile zip = new ZipFile(ipa);
        Enumeration<? extends ZipEntry> entries = zip.entries();
        while (entries.hasMoreElements()) {
            ZipEntry entry = entries.nextElement();
            String entryName = entry.getName();

            if (entryName.equals(METADATA_FILE_NAME)) {
                metadata = this.metadataReader.getMetadata(zip
                        .getInputStream(entry));
                break;
            }
        }

        return metadata;
    }
}
