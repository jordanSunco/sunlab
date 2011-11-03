/*
 * Copyright
 */

package ufologist.ipa.core;

/**
 * Apple应用元数据模型
 * 
 * @author Sun
 * @version ItunesMetadata.java 2011-11-1 上午10:54:19
 */
public class ItunesMetadata {
    private String fileName;

    private String itemId;
    private String itemName;
    private String iconUrl;
    /**
     * 类型, 例如工具, 游戏
     */
    private String genre;
    private String bundleVersion;
    private String releaseDate;

    private String appleId;
    private String purchaseDate;

    public String getItemId() {
        return this.itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return this.itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getIconUrl() {
        return this.iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public String getGenre() {
        return this.genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getBundleVersion() {
        return this.bundleVersion;
    }

    public void setBundleVersion(String bundleVersion) {
        this.bundleVersion = bundleVersion;
    }

    public String getReleaseDate() {
        return this.releaseDate;
    }

    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getAppleId() {
        return this.appleId;
    }

    public void setAppleId(String appleId) {
        this.appleId = appleId;
    }

    public String getPurchaseDate() {
        return this.purchaseDate;
    }

    public void setPurchaseDate(String purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
}
