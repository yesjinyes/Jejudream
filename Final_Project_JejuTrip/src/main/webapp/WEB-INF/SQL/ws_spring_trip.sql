show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

select scheduleno 
     , startdate, enddate
     , smcatgoname, lgcatgoname, user_name
     , subject, content 
from 
(
    select  row_number() over(order by SD.scheduleno desc) as rno 
          , SD.scheduleno
          , to_char(SD.startdate, 'yyyy-mm-dd hh24:mi') as startdate
          , to_char(SD.enddate, 'yyyy-mm-dd hh24:mi') as enddate
          , SC.smcatgoname, LC.lgcatgoname, M.user_name 
          , SD.subject, SD.content 
    from tbl_calendar_schedule SD 
    JOIN tbl_member M 
    ON SD.fk_userid = M.userid
    JOIN tbl_calendar_small_category SC 
    ON SD.fk_smcatgono = SC.smcatgono
    JOIN tbl_calendar_large_category LC 
    ON SD.fk_lgcatgono = LC.lgcatgono 
    where ( to_char(SD.startdate,'YYYY-MM-DD') between 2024-07-01 and 2024-08-31 )
    AND   ( to_char(SD.enddate,'YYYY-MM-DD') between 2024-07-01 and 2024-08-31 ) 
        and ( SD.fk_lgcatgono = 1 OR SD.fk_userid = 'jeongws' OR
              ( SD.fk_userid != 'jeongws' and lower(SD.joinuser) like '%'||lower('jeongws')||'%' ) ) 
    
) V 
where V.rno between 1 and 5

