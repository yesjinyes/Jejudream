show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.


select distinct to_id, from_id, status, to_char(chatting_date,'yyyy-mm-dd hh24:mi') as chatting_date , fk_reservation_code
from tbl_chattinglog
where status=0
order by chatting_date desc;

select count(*) as cnt
from tbl_chattinglog
where to_id = 'kakao';




SELECT distinct fk_reservation_code, lodging_name, room_name, user_name, chatting_date, status
FROM 
(
    SELECT rownum AS RNO
         ,fk_reservation_code, lodging_name, room_name, user_name, chatting_date, status
    FROM
    (
        select distinct C.fk_reservation_code, L.lodging_name, room_name, M.user_name, to_char(chatting_date,'yyyy-mm-dd') as chatting_date, C.status
        from tbl_chattinglog C join tbl_reservation R
        on C.fk_reservation_code = R.reservation_code
        join tbl_room_detail D
        on R.fk_room_detail_code = D.room_detail_code
        join tbl_lodging L
        on D.fk_lodging_code = L.lodging_code
        join tbl_member M
        on C.from_id = M.userid
        where to_id = 'kakao'
        order by chatting_date desc
    )V
) T
where RNO between 11 and 15;

select M.userid, M.user_name, L.lodging_name
from tbl_reservation R join tbl_member M
on R.fk_userid = M.userid
join tbl_room_detail D
on R.fk_room_Detail_code = D.room_detail_code
join tbl_lodging L
on D.fk_lodging_code = L.lodging_code
where reservation_code = 21;


select *
from tbl_chattinglog;

SELECT count(*) as cnt
FROM 
(
select count(*) as cnt
from tbl_chattinglog
where to_id = 'kakao'
group by fk_reservation_code
)


SELECT fk_reservation_code, lodging_name, room_name, user_name, chatting_date, status
FROM 
(
    SELECT rownum AS RNO
         ,fk_reservation_code, lodging_name, room_name, user_name, chatting_date, status
    FROM
    (
        select distinct C.fk_reservation_code, L.lodging_name, room_name, M.user_name, to_char(chatting_date,'yyyy-mm-dd') as chatting_date, C.status
        from tbl_chattinglog C join tbl_reservation R
        on C.fk_reservation_code = R.reservation_code
        join tbl_room_detail D
        on R.fk_room_detail_code = D.room_detail_code
        join tbl_lodging L
        on D.fk_lodging_code = L.lodging_code
        join tbl_member M
        on C.from_id = M.userid
        where to_id ='kakao'
        order by chatting_date desc
    )V
) T
where RNO between 1 and 5