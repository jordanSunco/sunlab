/*
 * copyright
 */

package com.ufologist.model;

/**
 * ����ģ��
 * 
 * @author Sun
 * @version 1.0 2012-9-8
 */
public class Foo {
    /**
     * ����ʹ��int����, ��Ϊ�������ô�����ʱ, KSOAP2��õ�Ĭ��ֵ0.
     * 
     * �����Integer����, δ�������Ե������, KSOAP2ֻ��õ�null, ��ʱ�ᱨ��
     * SoapFault - faultcode: 'soap:Server' faultstring: 'Illegal argument. For input string: ""' faultactor: 'null' detail: null
     */
    private int id;
    private String name;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
