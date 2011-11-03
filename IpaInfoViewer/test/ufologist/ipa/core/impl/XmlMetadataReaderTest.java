/*
 * Copyright 
 */

package ufologist.ipa.core.impl;

import java.io.InputStream;

import org.junit.Assert;
import org.junit.Test;

import ufologist.ipa.core.ItunesMetadata;
import ufologist.ipa.core.ItunesMetadataReader;

/**
 * 
 * @author Sun
 * @version XmlMetadataReaderTest.java 2011-11-1 上午11:00:18
 */
public class XmlMetadataReaderTest {
    private ItunesMetadataReader metadataReader = new XmlMetadataReader();

    @Test
    public void testGetMetadata() {
        InputStream plist = this.getClass().getResourceAsStream(
                "/iTunesMetadata.plist");
        ItunesMetadata metadata = this.metadataReader.getMetadata(plist);

        Assert.assertEquals(metadata.getItemId(), "306550020");
        Assert.assertEquals(metadata.getItemName(),
                "Air Video - Watch your videos anywhere!");
        Assert.assertEquals(metadata.getIconUrl(),
                "http://a1756.phobos.apple.com/us/r1000/106/Purple/3d/27/ce/mzi.wikbkydf.png");
        Assert.assertEquals(metadata.getGenre(), "工具");
        Assert.assertEquals(metadata.getBundleVersion(), "2.4.9");
        Assert.assertEquals(metadata.getReleaseDate(), "2009-03-04T04:16:03Z");
        Assert.assertEquals(metadata.getAppleId(), "aya_iiii@yahoo.cn");
        Assert.assertEquals(metadata.getPurchaseDate(), "2011-10-05T03:19:06Z");
    }
}
