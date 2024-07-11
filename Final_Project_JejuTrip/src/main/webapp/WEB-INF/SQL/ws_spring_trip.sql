show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

WITH A
AS (
select to_char(reservation_date,'yyyy-mm') as reservation_year, count(*) as CNT
from tbl_reservation
where reservation_date between '2023-01-01' and '2023-12-31'
group by to_char(reservation_date,'yyyy-mm')
)
SELECT A.reservation_year, A.CNT
FROM A CROSS JOIN (SELECT SUM(CNT) AS TOTAL FROM A) B
order by reservation_year;


WITH A
AS (
select to_char(reservation_date,'yyyy-mm') as reservation_date, count(*) as CNT
from tbl_reservation
group by to_char(reservation_date,'yyyy-mm')
)
SELECT A.reservation_date, A.CNT, TO_CHAR( ROUND((A.CNT / B.TOTAL) * 100, 1), '990.0') AS PERCNTAGE
FROM A CROSS JOIN (SELECT SUM(CNT) AS TOTAL FROM A) B
order by reservation_date;

select *
from tbl_reservation;

-- 일자별 예약 금액 총합 (숙소 마이페이지에서 통계카테고리 내부에 사용할 sql문)
WITH A
AS (
select room_detail_code
from tbl_room_detail
where fk_lodging_code = 5159
)
SELECT to_char(R.reservation_date,'yyyy-mm-dd'), sum(R.reservation_price) as day_total_price
FROM A JOIN tbl_reservation R
ON A.room_detail_code = R.fk_room_detail_code
GROUP BY to_char(R.reservation_date,'yyyy-mm-dd');




SELECT food_store_code, food_name, food_mobile, food_address
FROM 
(
    SELECT rownum AS RNO
         , food_store_code, food_name, food_mobile, food_address
    FROM
    (
        select play_code, play_name, play_mobile, play_address
        from tbl_play
        order by play_name asc
    )V
) T
where RNO between 1 and 5;

select count(*)
from tbl_food_store;

select play_code, play_name, play_mobile, play_address
from tbl_play;