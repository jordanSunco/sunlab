/*
 * Copyright
 */

package dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import domain.Account;

/**
 * 测试
 * 
 * @author Sun
 * @version TestDao.java 2010-5-24 下午02:32:40
 */
public class TestDao extends SqlMapClientDaoSupport {
    /**
     * 测试连接数据库
     */
    public void test() {
        Account a = new Account();
        a.setFirstName("hello");
        a.setLastName("world");
        a.setEmailAddress("@helloworld.com");

        Account b = new Account();
        b.setFirstName("foo");
        b.setLastName("bar");
        b.setEmailAddress("foobar@helloworld.com");

        SqlMapClientTemplate sqlmct = this.getSqlMapClientTemplate();

        System.out.println("C");
        System.out.println(sqlmct.insert("Account.insert", a));
        System.out.println(sqlmct.insert("Account.insert", b));
        System.out.println("--");

        System.out.println("U");
        a.setFirstName("robot");
        sqlmct.update("Account.update", a);
        System.out.println("--");

        System.out.println("R");
        System.out.println(sqlmct.queryForList("Account.selectAll"));
        System.out.println(sqlmct.queryForList("Account.selectByLike", "f"));
        System.out.println(sqlmct.queryForList("Account.selectByIn", 
                new String[] {"robot", "foo"}));
        List<String> l = new ArrayList<String>();
        l.add("robot");
        System.out.println(sqlmct.queryForList("Account.selectByIn", l));
        System.out.println("--");

        System.out.println("D");
        sqlmct.delete("Account.deleteAll");
        System.out.println("--");
    }
}
