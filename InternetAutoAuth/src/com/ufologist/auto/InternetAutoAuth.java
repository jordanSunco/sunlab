/*
 * Copyright 
 */

package com.ufologist.auto;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Properties;

import javax.swing.JOptionPane;

import sun.misc.BASE64Encoder;

/**
 * 上网自动授权App
 * 
 * @author Sun
 * @version 1.0 2012-9-10 下午6:01:13
 * @see <a href="http://www.comscigate.com/JDJ/archives/0807/morin/index.html">java.net.NetworkInterface</a>
 */
public class InternetAutoAuth {
    /**
     * 只检测特定网络接口名, 例如指定为有线连接, 只有当有线连接上时才进行认证
     */
    private String networkInterfaceName;

    /**
     * 上网认证地址
     */
    private String authUrl = "http://172.16.2.242/login";
    private String userName;
    private String password;

    private int retry = 200;
    private long interval = 3000;

    private boolean debug = false;

    public static void main(String[] args) {
        // 只在工作日(星期一 ~ 五工作时间)执行
        Calendar now = Calendar.getInstance();
        int day = now.get(Calendar.DAY_OF_WEEK);
        if (day == Calendar.SATURDAY || day == Calendar.SUNDAY
                || now.get(Calendar.HOUR_OF_DAY) > 17) {
            return;
        }

        try {
            InternetAutoAuth auto = new InternetAutoAuth();
            if (auto.checkNetwork()) {
                auto.auth();
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
            error("网络异常!\n" + e.getMessage());
        }
    }

    public InternetAutoAuth() throws IOException {
        initConfig();
    }

    private static void error(String info) {
        JOptionPane.showMessageDialog(null, info, "Error",
                JOptionPane.ERROR_MESSAGE);
    }

    private void initConfig() throws IOException {
        Properties config = new Properties();
        config.load(this.getClass().getResourceAsStream("/config.properties"));

        this.userName = config.getProperty("userName");
        this.password = config.getProperty("password");

        if (config.getProperty("networkInterfaceName") != null) {
            this.networkInterfaceName = config.getProperty("networkInterfaceName");
        } else {
            this.networkInterfaceName = getDefaultNetworkInterfaceName();
        }
        if (config.getProperty("authUrl") != null) {
            this.authUrl = config.getProperty("authUrl");
        }
        if (config.getProperty("retry") != null) {
            this.retry = Integer.parseInt(config.getProperty("retry"));
        }
        if (config.getProperty("interval") != null) {
            this.interval = Long.parseLong(config.getProperty("interval"));
        }
        if (config.getProperty("debug") != null) {
            this.debug = Boolean.valueOf(config.getProperty("debug"));
        }

        if (this.debug) {
            showAllNetworkInterface();
        }
    }

    private boolean checkNetwork() {
        NetworkInterface networkInterface = null;
        for (int i = 0; i < this.retry; i++) {
            try {
                networkInterface = NetworkInterface.getByName(this.networkInterfaceName);
                System.out.println(new Date() + " - " + networkInterface.toString());

                // 对于网卡配置为自动获得IP, 有分配IP则表示网络已经连上
                if (networkInterface.getInetAddresses().hasMoreElements()) {
                    return true;
                }

                Thread.sleep(this.interval);
            } catch (SocketException e) {
                // 可能发生NoRouteToHostException, 继续尝试
                e.printStackTrace(System.out);
            } catch (InterruptedException e) {
                e.printStackTrace(System.out);
            }
        }

        error(networkInterface.toString() + "\n网络连接超时!");
        return false;
    }

    /**
     * 查看所有网卡信息, 用于调试
     * @throws SocketException 
     */
    private void showAllNetworkInterface() throws SocketException {
        Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
        StringBuilder networkInterfaceInfo = new StringBuilder();

        while (networkInterfaces.hasMoreElements()) {
            networkInterfaceInfo.append(networkInterfaces.nextElement().toString());
            networkInterfaceInfo.append("\n");
        }

        networkInterfaceInfo.deleteCharAt(networkInterfaceInfo.length() - 1);
        JOptionPane.showMessageDialog(null, networkInterfaceInfo.toString(), "Info",
                JOptionPane.INFORMATION_MESSAGE);
    }

    /**
     * 获取一张有效网卡的名称作为默认使用
     * 
     * @return
     * @throws SocketException
     */
    private String getDefaultNetworkInterfaceName() throws SocketException {
        Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
        NetworkInterface networkInterface;
        String networkInterfaceName = "";
        Enumeration<InetAddress> ips;

        while (networkInterfaces.hasMoreElements()) {
            networkInterface = networkInterfaces.nextElement();
            ips = networkInterface.getInetAddresses();

            if (ips.hasMoreElements()) {
                // 排除一张特殊的Loopback网卡, IP地址为127.0.0.1
                // name:lo (MS TCP Loopback interface) index: 1 addresses: 127.0.0.1;
                if (!ips.nextElement().isLoopbackAddress()) {
                    networkInterfaceName = networkInterface.getName();
                    break;
                }
            } else { // 默认使用第一个遇到的没有分配IP地址的网卡
                networkInterfaceName = networkInterface.getName();
                break;
            }
        }

        return networkInterfaceName;
    }

    private boolean auth() throws MalformedURLException {
        boolean success = false;

        // Basic认证实现登录
        BASE64Encoder enc = new BASE64Encoder();
        String userNamePassword = this.userName + ":" + this.password;
        String encodedAuthorization = enc.encode(userNamePassword.getBytes());

        URL urlObject = new URL(this.authUrl);
        HttpURLConnection conn = null;
        for (int i = 0; i < this.retry; i++) {
            try {
                conn = (HttpURLConnection) urlObject.openConnection();
                conn.setRequestProperty("Authorization", "Basic "
                        + encodedAuthorization);
                conn.setRequestMethod("GET");
                System.out.println(new Date() + " - " + encodedAuthorization);

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    success = true;
                    break;
                }
                Thread.sleep(this.interval);
            } catch (IOException e) {
                e.printStackTrace(System.out);
            } catch (InterruptedException e) {
                e.printStackTrace(System.out);
            } finally {
                if (conn != null) {
                    conn.disconnect();
                }
            }
        }

        if (!success) {
            error("认证失败!\n" + userNamePassword);
        }

        return success;
    }
}
