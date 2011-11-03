/*
 * Copyright 
 */

package ufologist.ipa.core.impl;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import ufologist.ipa.core.ItunesMetadata;
import ufologist.ipa.core.ItunesMetadataReader;

/**
 * 读取XML格式的plist文件数据
 * 
 * TODO new plist reader
 * http://code.google.com/p/plist/
 * http://code.google.com/p/xmlwise/
 * 
 * @author Sun
 * @version XmlMetadataReader.java 2011-11-1 上午10:59:06
 */
public class XmlMetadataReader implements ItunesMetadataReader {
    public ItunesMetadata getMetadata(InputStream plist) {
        ItunesMetadata metadata = new ItunesMetadata();

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        try {
            DocumentBuilder db = dbf.newDocumentBuilder();
            // 关闭解析XML文件时, 通过DTD验证XML的功能
            // 因为如果网络不通会导致解析失败
            db.setEntityResolver(new EntityResolver() {
                public InputSource resolveEntity(String publicId,
                        String systemId) throws SAXException, IOException {
                    return new InputSource(new StringReader(""));
                    // 如果直接return null仍然需要联网获取DTD来验证
                    // return null;
                }
            });
            Document document = db.parse(plist);

            // 为了不遭遇空字符串Node, 不得不取出所有element
            // 如果使用nextSibling, 会取出#Text节点, 是一个空字符串...
            NodeList nodeList = document.getElementsByTagName("*");
            for (int i = 0, length = nodeList.getLength(); i < length; i+=2) {
                Node node = nodeList.item(i);
                if (!node.getNodeName().equals("key")) {
                    continue;
                }

                String key = node.getTextContent();
                String value = nodeList.item(i + 1).getTextContent();

                if (key.equals("itemId")) {
                    metadata.setItemId(value);
                } else if (key.equals("itemName")) {
                    metadata.setItemName(value);
                } else if (key.equals("softwareIcon57x57URL")) {
                    metadata.setIconUrl(value);
                } else if (key.equals("genre")) {
                    metadata.setGenre(value);
                } else if (key.equals("bundleVersion")) {
                    metadata.setBundleVersion(value);
                } else if (key.equals("releaseDate")) {
                    metadata.setReleaseDate(value);
                } else if (key.equals("appleId")) {
                    metadata.setAppleId(value);
                } else if (key.equals("purchaseDate")) {
                    metadata.setPurchaseDate(value);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return metadata;
    }
}
