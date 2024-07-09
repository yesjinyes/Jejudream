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
select to_char(registerday,'yyyy-mm') as registerday, count(*) as CNT
from tbl_company
group by to_char(registerday,'yyyy-mm')
)
SELECT A.registerday, A.CNT, TO_CHAR( ROUND((A.CNT / B.TOTAL) * 100, 1), '990.0') AS PERCNTAGE
FROM A CROSS JOIN (SELECT SUM(CNT) AS TOTAL FROM A) B
order by registerday;


WITH A
AS (
select to_char(registerday,'yyyy-mm-dd') as registerday, count(*) as CNT
from tbl_company
where registerday between '24-07-01' and last_day('24-07-01')
group by to_char(registerday,'yyyy-mm-dd')
)
SELECT A.registerday, A.CNT, TO_CHAR( ROUND((A.CNT / B.TOTAL) * 100, 1), '990.0') AS PERCNTAGE
FROM A CROSS JOIN (SELECT SUM(CNT) AS TOTAL FROM A) B
order by registerday asc;

WITH A
AS (
select to_char(registerday,'yyyy') as line_year, count(*) as line_CNT
from tbl_company
group by to_char(registerday,'yyyy')
)
SELECT A.line_year, A.line_CNT
FROM A CROSS JOIN (SELECT SUM(line_CNT) AS TOTAL FROM A) B
order by line_year asc;

select *
from tbl_reservation;