package dao;

import domain.Account;
import domain.AccountExample;
import java.sql.SQLException;
import java.util.List;

public interface AccountDAO {
    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int countByExample(AccountExample example) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int deleteByExample(AccountExample example) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int deleteByPrimaryKey(Integer id) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    void insert(Account record) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    void insertSelective(Account record) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    List selectByExample(AccountExample example) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    Account selectByPrimaryKey(Integer id) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int updateByExampleSelective(Account record, AccountExample example) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int updateByExample(Account record, AccountExample example) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int updateByPrimaryKeySelective(Account record) throws SQLException;

    /**
     * This method was generated by Apache iBATIS ibator.
     * This method corresponds to the database table ACCOUNT
     *
     * @ibatorgenerated Wed Jun 30 15:50:27 CST 2010
     */
    int updateByPrimaryKey(Account record) throws SQLException;
}