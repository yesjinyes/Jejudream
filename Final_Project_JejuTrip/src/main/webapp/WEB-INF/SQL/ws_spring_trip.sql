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
from user_tables;

select *
from user_sequences;

select *
from tbl_lodging
order by lodging_code asc;

select lodging_code, local_status, lodging_category, fk_companyid, lodging_name, lodging_tell, lodging_content, lodging_address, main_img, filename, orgfilename, filesize, status, feedback_msg
from tbl_lodging
order by lodging_code asc;

update tbl_lodging set status = 2 , feedback_msg = '호텔 카테고리가 이상합니다.' where lodging_code = 5006;

commit;


