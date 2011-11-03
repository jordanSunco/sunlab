/*
 * Copyright 
 */

package ufologist.ipa.core.impl;

import java.io.File;
import java.io.IOException;

import org.junit.Assert;
import org.junit.Test;

import ufologist.ipa.core.IpaReader;
import ufologist.ipa.core.ItunesMetadata;

/**
 * 
 * @author Sun
 * @version IpaReaderImplTest.java 2011-11-1 下午03:20:03
 */
public class IpaReaderImplTest {
    private IpaReader ipaReader = new IpaReaderImpl();

    @Test
    public void testGetMetadata() throws IOException {
        File ipa = new File(this.getClass().getResource("/Air_Video_2.4.9.ipa")
                .getFile());
        ItunesMetadata metadata = this.ipaReader.getMetadata(ipa);

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
