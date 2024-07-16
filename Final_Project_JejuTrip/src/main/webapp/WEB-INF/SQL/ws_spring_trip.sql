show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

select D.room_name, D.room_img, R.check_in||' '||D.check_in as check_in, R.check_out||' '||D.check_out as check_out ,R.reservation_price, R.reservation_code, L.lodging_name, L.lodging_tell, L.lodging_address
from tbl_reservation R JOIN tbl_room_detail D
on R.fk_room_detail_code = D.room_detail_code
JOIN tbl_lodging L
on D.fk_lodging_code = L.lodging_code
where R.reservation_code = 12;


select *
from tbl_lodging;

select *
from tbl_room_detail;