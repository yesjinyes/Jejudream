show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

SELECT userid, email, pw, user_name, mobile, address, detail_address, gender, registerday, status, idle
FROM 
(
    SELECT rownum AS RNO
         , userid, email, pw, user_name, mobile, address, detail_address, gender, registerday, status, idle
    FROM
    (
        select userid, email, pw, user_name, mobile, address, detail_address, gender, registerday, status, idle
        from tbl_member
        order by registerday desc
    )V
) T
where RNO between 1 and 5
