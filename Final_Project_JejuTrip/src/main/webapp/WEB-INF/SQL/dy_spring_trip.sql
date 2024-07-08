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



desc tbl_member_loginhistory;



update tbl_member set lastpwdchangedate = '24/03/01'
where userid = 'eomjh';
commit;



-- 업체 로그인
SELECT companyid, company_name, pwdchangegap,
       NVL(lastlogingap, trunc(months_between(sysdate, registerday))) AS lastlogingap, 
       idle, email, mobile
FROM 
( select companyid, company_name,
         trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap,
         registerday, idle, email, mobile
  from tbl_company
  where status = 1 and companyid = 'naver' and pw = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382'
) M 
CROSS JOIN 
( select trunc( months_between(sysdate, max(logindate)) ) as lastlogingap 
  from tbl_company_loginhistory 
  where fk_companyid = 'naver' ) H;





select userid, user_name
from tbl_member
where user_name = '엄정화' and email = 'yl0AhhmUdz58RxnXBNcWyQ==';



select companyid, company_name
from tbl_company
where company_name = '네이버' and email = 'q8o3ujFmPcgaRxMme3F+XQ==';



select userid
from tbl_member
where userid = 'kimdy' and email = 'iqOrelu2llBP6cnC6yu77REzaKuiYpaUDPuSnEzJZX4=';



-- 맛집 카테고리별 최신 1개씩 조회
select food_category, food_name, food_content
from
(
    select food_category, food_name, food_content
         , row_number() over(partition by food_category order by food_store_code desc) as rno
    from tbl_food_store
)
where rno = 1;



select *
from user_sequences;



select *
from tbl_member
where userid = 'kimdy';

select *
from tbl_member_loginhistory
where fk_userid = 'kimdy'
order by logindate desc;

update tbl_member_loginhistory
set logindate = '23/06/30'
where fk_userid = 'kimdy';

commit;



select pw
from tbl_member
where userid = 'kimdy' and pw = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382';


update tbl_member set lastpwdchangedate = '24/04/01'
where userid = 'eomjh';
commit;




