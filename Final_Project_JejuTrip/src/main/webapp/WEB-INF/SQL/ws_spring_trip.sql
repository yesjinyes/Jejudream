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
select R.room_detail_code
from tbl_lodging L JOIN tbl_room_detail R
on L.lodging_code = r.fk_lodging_code
where L.fk_companyid = 'kakao'
)
SELECT to_char(R.reservation_date,'yyyy-mm') as year, sum(R.reservation_price) as profit
FROM A JOIN tbl_reservation R
ON A.room_detail_code = R.fk_room_detail_code
WHERE R.reservation_date between '24-01-01' and '24-12-31'
GROUP BY to_char(R.reservation_date,'yyyy-mm')
ORDER BY year;

WITH A
AS (
select R.room_detail_code
from tbl_lodging L JOIN tbl_room_detail R
on L.lodging_code = r.fk_lodging_code
where L.fk_companyid = 'kakao'
)
SELECT to_char(R.check_in,'yyyy-mm-dd') as reservation_year , count(*) as CNT 
FROM A JOIN tbl_reservation R
ON A.room_detail_code = R.fk_room_detail_code
WHERE R.reservation_date between '2024-01-01' and '2024-12-31'
GROUP BY to_char(R.check_in,'yyyy-mm-dd')
order by 1;

WITH A
AS (
select R.room_detail_code
from tbl_lodging L JOIN tbl_room_detail R
on L.lodging_code = r.fk_lodging_code
where L.fk_companyid = 'kakao'
)
SELECT to_char(R.check_in,'yyyy-mm-dd') as reservation_day , count(*) as CNT 
FROM A JOIN tbl_reservation R
ON A.room_detail_code = R.fk_room_detail_code
WHERE R.reservation_date between extract(year from sysdate)||'-07-01' and '2024-07-31'
GROUP BY to_char(R.check_in,'yyyy-mm-dd')
ORDER BY 1;


WITH A
AS (
select R.room_detail_code
from tbl_lodging L JOIN tbl_room_detail R
on L.lodging_code = r.fk_lodging_code
where L.fk_companyid = 'kakao'
)
SELECT to_char(R.check_in,'yyyy-mm') as reservation_month , count(*) as CNT 
FROM A JOIN tbl_reservation R
ON A.room_detail_code = R.fk_room_detail_code
WHERE R.reservation_date between '2024-01-01' and '2024-12-31'
GROUP BY to_char(R.check_in,'yyyy-mm')
ORDER BY 1