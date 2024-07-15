show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

SELECT lodging_name, user_name, room_detail_code, check_in, check_out, room_stock, status, reservation_code, room_name
FROM 
(
    SELECT rownum AS RNO
         ,lodging_name, user_name, room_detail_code, check_in, check_out, room_stock, status, reservation_code, room_name
    FROM
    (
        select L.lodging_name, M.user_name, R.room_detail_code, to_char(V.check_in,'yyyy-mm-dd') as check_in, to_char(V.check_out,'yyyy-mm-dd') as check_out, R.room_stock, V.status, V.reservation_code, R.room_name
        from tbl_lodging L JOIN tbl_room_detail R
        on L.lodging_code = R.fk_lodging_code
        JOIN tbl_reservation V
        ON R.room_detail_code = V.fk_room_detail_code
        JOIN tbl_member M
        ON V.fk_userid = M.userid
        where V.fk_userid = 'kudi02'
        order by V.reservation_date desc
    )V
) T
where RNO between 1 and 5;

