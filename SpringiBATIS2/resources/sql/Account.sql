CREATE SEQUENCE ACCOUNT_SEQ
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE TABLE ACCOUNT (
    ACC_ID INT PRIMARY KEY
    ACC_FIRST_NAME VARCHAR(255),
    ACC_LAST_NAME VARCHAR(255),
    ACC_EMAIL VARCHAR(255)
);
