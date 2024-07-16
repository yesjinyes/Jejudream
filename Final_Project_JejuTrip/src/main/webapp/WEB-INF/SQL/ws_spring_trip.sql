show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

select *
from tbl_member;

update tbl_member set email = 'CT7IgCT+Y9vM4lsGX1pHmu69lDWbyGyb6bfullGqOz4=' , user_name = '우석정' , mobile = 'e72CTRofXoxe+KHw+V+Ebg==' , address = '서울시' , detail_address = '어딘가' , birthday = '2006-07-05' where userid = 'jeongws' 
