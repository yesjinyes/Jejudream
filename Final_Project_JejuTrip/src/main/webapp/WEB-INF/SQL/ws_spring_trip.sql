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
from tbl_reservation;



select *
from tbl_room_detail;

SELECT A.lodging_name, A.user_name, A.room_detail_code, A.check_in, A.check_out, A.room_stock, B.reservation_count 
FROM 
(
select L.lodging_name, M.user_name, R.room_detail_code, V.check_in, V.check_out, R.room_stock, V.status, V.reservation_code, R.room_name
from tbl_lodging L JOIN tbl_room_detail R
on L.lodging_code = R.fk_lodging_code
JOIN tbl_reservation V
ON R.room_detail_code = V.fk_room_detail_code
JOIN tbl_member M
ON V.fk_userid = M.userid
where fk_companyid = 'kakao'
order by to_char(reservation_date,'yyyy-mm-dd HH24:mi:ss')
)A
,
(
select count(*) as reservation_count
from tbl_Reservation
where fk_room_detail_code = 375 and check_in >= '24/07/08' and check_out <= '24/07/09'
)B


WITH A
AS (
select R.room_detail_code
from tbl_lodging L JOIN tbl_room_detail R
on L.lodging_code = r.fk_lodging_code
<if test="companyid != null">
    where L.fk_companyid = #{companyid}
</if>
)
SELECT to_char(R.reservation_date,'yyyy-mm-dd') as day, sum(R.reservation_price) as profit_success
FROM A JOIN tbl_reservation R
ON A.room_detail_code = R.fk_room_detail_code
WHERE R.status = 1 and R.reservation_date between extract(year from sysdate)||'-'||#{choice_month}||'-01' and #{choice_month_last_day}
GROUP BY to_char(R.reservation_date,'yyyy-mm-dd')
ORDER BY day