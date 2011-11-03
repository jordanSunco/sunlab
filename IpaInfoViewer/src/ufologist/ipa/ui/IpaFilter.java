/*
 * Copyright 
 */

package ufologist.ipa.ui;

import java.io.File;
import java.io.FilenameFilter;

/**
 * 文件过滤器只接受后缀名为.ipa的文件
 * 
 * @author Sun
 * @version IpaFileFilter.java 2011-11-2 下午14:10:03
 */
public class IpaFilter implements FilenameFilter {
    public static final String EXTENSION = ".ipa";

    public boolean accept(File dir, String name) {
        int ipaIndex = name.indexOf(EXTENSION);
        return ipaIndex != -1 || ipaIndex == name.length() - 4;
    }
}
