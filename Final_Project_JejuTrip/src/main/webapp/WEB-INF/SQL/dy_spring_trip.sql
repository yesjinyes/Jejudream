show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.



insert into tbl_member(userid, email, pw, user_name, mobile, address, detail_address, birthday, gender)
values('admin', 'G3a1oS69mAbA7+x7+opiiA==', '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', '관리자', 'XvX9PItBFtYP5Fm1q/4T+g==', '서울 마포구 월드컵북로 21', '301호', '2000-01-01', '2');
--    ('admin', 'admin@gmail.com', 'qwer1234$', '관리자', '01099999999', '', '', '', '')
commit;



-- 로그인 처리하기 (일반회원, 관리자)
SELECT userid, user_name, pwdchangegap,
       NVL(lastlogingap, trunc(months_between(sysdate, registerday))) AS lastlogingap, 
       idle, email, mobile, address, detail_address, birthday, gender
FROM 
( select userid, user_name,
         trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap,
         registerday, idle, email, mobile, address, detail_address, birthday, gender
  from tbl_member 
  where status = 1 and userid = 'kimdy' and pw = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382'
) M 
CROSS JOIN 
( select trunc( months_between(sysdate, max(logindate)) ) as lastlogingap 
  from tbl_member_loginhistory 
  where fk_userid = 'kimdy' ) H;


SELECT userid, user_name, pwdchangegap,
       NVL(lastlogingap, trunc(months_between(sysdate, registerday))) AS lastlogingap, 
       idle, email, mobile, address, detail_address, birthday, gender
FROM 
( select userid, user_name,
         trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap,
         registerday, idle, email, mobile, address, detail_address, birthday, gender
  from tbl_member 
  where status = 1 and userid = 'kimdy' and pw = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382'
) M 
CROSS JOIN 
( select trunc( months_between(sysdate, max(logindate)) ) as lastlogingap 
  from tbl_member_loginhistory 
  where fk_userid = 'kimdy' ) H;



desc tbl_member_loginhistory;



