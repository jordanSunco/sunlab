/*
 * copyright
 */

package com.ufologist.model;

/**
 * 公用模型
 * 
 * @author Sun
 * @version 1.0 2012-9-8
 */
public class Foo {
    /**
     * 必须使用int类型, 因为当不设置此属性时, KSOAP2会得到默认值0.
     * 
     * 如果是Integer类型, 未设置属性的情况下, KSOAP2只会得到null, 此时会报错
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
