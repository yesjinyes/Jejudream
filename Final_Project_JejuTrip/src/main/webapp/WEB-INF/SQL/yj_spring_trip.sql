show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

---------------------------------------------------------------------------------------------------- 
-- ■■■ TEST ■■■ --
----------------------------------------------------------------------------------------------------
-- 테이블 데이터타입 조회
desc 테이블명;

-- 제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명  

-- 테이블 삭제
drop table 테이블명;

-- 컬럼 추가
ALTER TABLE [테이블명] ADD [컬럼명] [자료형]

-- 컬럼 삭제
ALTER TABLE 테이블명 DROP COLUMN 컬럼명

-- 컬럼명 변경
alter table 테이블명 rename column A to B;

-- 데이터 타입 변경
ALTER TABLE (테이블명) MODIFY (컬럼명) VARCHAR2(20);

-- 데이터 값 변경
UPDATE 테이블명 SET field3='변경된 값' WHERE field1 = 'data2';


desc tbl_food_store;

-- ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ㅍ
----------------------------------------------------------------------------------------------------

-- // 맛집 테이블 insert // --
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '한식' ,'제주시 동부', '물꼬해녀의집','눈 앞에서 해녀가 직접 손질해주는 신선한 해산물','9:00~20:00','0507-1363-7331','제주특별자치도 제주시 우도면 우도해안길 496','물꼬해녀의집.jpg',default,'물꼬해녀의집.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '한식' ,'제주시 동부', '성산일출봉 아시횟집','제주바다가 보이는 고등어회가 맛있는 곳','8:00~18:00','0507-1343-3987','제주특별자치도 서귀포시 성산읍 성산등용로 19','성산일출봉 아시횟집.jpg',default,'성산일출봉 아시횟집.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '한식' ,'서귀포시 동부', '돌집식당','엄마가 해주는 백반이 먹고싶을 때 가는 돌집식당','8:00~19:00','0507-1324-3720','제주특별자치도 서귀포시 표선면 서성일로 23','돌집식당.jpg',default,'돌집식당.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '한식' ,'서귀포시 시내', '대윤흑돼지 서귀포올레시장점','누린내 안나는 진짜 흑돼지 맛집','10:00~20:00','064-732-2953','제주특별자치도 서귀포시 서문로 23','대윤흑돼지 서귀포올레시장점.jpg',default,'대윤흑돼지 서귀포올레시장점.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '양식' ,'서귀포시 동부', '제주 판타스틱버거','서양 느낌 물씬 나는 분위기, 음식 맛집','9:00~21:00','0507-1339-6990','제주특별자치도 서귀포시 표선면 토산중앙로15번길 6','제주 판타스틱버거.jpg',default,'제주 판타스틱버거.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '양식' ,'제주시 서부', '동백키친','데이트하기 좋은 유채꽃뷰 파스타, 스테이크맛집','11:00~21:00','0507-1358-1016','제주특별자치도 제주시 한림읍 수원7길 42 1층','동백키친.jpg',default,'동백키친.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '양식' ,'서귀포시 서부', '젠하이드어웨이 제주점','제주 스타일 브런치','11:00~20:00','064-794-0133','제주특별자치도 서귀포시 안덕면 사계남로 186-8','젠하이드어웨이 제주점.jpg',default,'젠하이드어웨이 제주점.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '일식' ,'서귀포시 시내', '영육일삼','촉촉한 카츠가 일품인 곳','11:30~15:00','0507-1329-9492','제주특별자치도 서귀포시 이어도로 679 1층','영육일삼.jpg',default,'영육일삼.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '일식' ,'제주시 시내', '미도리제주','제주도에서 즐기는 퓨전일식','8:00~14:00','0507-1315-5635','제주특별자치도 제주시 우령4길 5 1층','미도리제주.jpg',default,'미도리제주.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '일식' ,'서귀포시 시내', '구르메스시 오마카세','갓 잡은 신선한 해산물로 요리하는 오마카세','17:00~3:00','064-738-4123','제주특별자치도 서귀포시 신서로48번길 59','구르메스시 오마카세.jpg',default,'구르메스시 오마카세.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '중식' ,'서귀포시 시내', '강정중국집','불향 가득한 짬뽕 맛집','10:00~17:00','0507-1358-7021','제주특별자치도 서귀포시 이어도로 633','강정중국집.jpg',default,'강정중국집.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '중식' ,'제주시 시내', '연태만','찹쌀탕수육이 맛있는 곳','9:00~20:00','0507-1328-8448','제주특별자치도 제주시 중앙로21길 10 1층','연태만.jpg',default,'연태만.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '중식' ,'제주시 동부', '함덕중국집','전복이 듬뿍 들어간 해물짬뽕 맛집','8:00~14:00','0507-1338-2572','제주특별자치도 제주시 조천읍 함와로 68 1층','함덕중국집.jpg',default,'함덕중국집.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '기타' ,'서귀포시 시내', '쏭타이 제주점','쌀국수가 맛있는 태국요리 맛집','11:00~16:00','064-738-7831','제주특별자치도 서귀포시 중문관광로72번길 29-9 2층','쏭타이 제주점.jpg',default,'쏭타이 제주점.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '기타' ,'서귀포시 동부', '위미애머물다락쿤','똠양꿍 맛집을 찾는다면 여기','10:00~15:00','064-764-0106','제주특별자치도 서귀포시 남원읍 위미중앙로 274-43','위미애머물다락쿤.jpg',default,'위미애머물다락쿤.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '기타' ,'제주시 서부', '인디언키친 본점','정동 인도커리 맛집','12:00~20:00','0507-1390-5859','제주특별자치도 제주시 애월읍 애원로 191','인디언키친 본점.jpg',default,'인디언키친 본점.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '카페' ,'서귀포시 시내', '서울앵무새 제주','이색 분위기 카페, 신박한 음료가 많은 곳','12:00~18:00','0507-1333-1940','제주특별자치도 서귀포시 색달중앙로 162','서울앵무새 제주.jpg',default,'서울앵무새 제주.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '카페' ,'제주시 서부', '카페데스틸','제주 분위기 낭낭한 감성카페','13:00~20:00','0507-1365-7402','제주특별자치도 제주시 한경면 한경해안로 110','카페데스틸.jpg',default,'카페데스틸.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division, ORGFILENAME) values(seq_common.nextval, '카페' ,'제주시 서부', '레이지펌프','데이트하기 좋은 브런치 맛집','11:00~19:00','0507-1325-8732','제주특별자치도 제주시 애월읍 애월북서길 32','레이지펌프.jpg',default,'레이지펌프.jpg');

delete from tbl_food_store purge;

commit;

desc tbl_food_store;



-- 맛집 추가 이미지 테이블 insert
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5451', '물꼬해녀의집_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5451', '물꼬해녀의집_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5451', '물꼬해녀의집_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5452', '성산일출봉 아시횟집_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5452', '성산일출봉 아시횟집_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5452', '성산일출봉 아시횟집_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5453', '돌집식당_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5453', '돌집식당_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5453', '돌집식당_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5454', '대윤흑돼지 서귀포올레시장점_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5454', '대윤흑돼지 서귀포올레시장점_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5454', '대윤흑돼지 서귀포올레시장점_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5455', '제주 판타스틱버거_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5455', '제주 판타스틱버거_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5455', '제주 판타스틱버거_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5456', '동백키친_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5456', '동백키친_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5456', '동백키친_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5457', '젠하이드어웨이 제주점_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5457', '젠하이드어웨이 제주점_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5457', '젠하이드어웨이 제주점_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5458', '영육일삼_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5458', '영육일삼_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5458', '영육일삼_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5459', '미도리제주_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5459', '미도리제주_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5459', '미도리제주_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5460', '구르메스시 오마카세_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5460', '구르메스시 오마카세_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5460', '구르메스시 오마카세_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5461', '강정중국집_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5461', '강정중국집_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5461', '강정중국집_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5462', '연태만_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5462', '연태만_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5462', '연태만_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5463', '함덕중국집_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5463', '함덕중국집_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5463', '함덕중국집_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5464', '쏭타이 제주점_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5464', '쏭타이 제주점_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5464', '쏭타이 제주점_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5465', '위미애머물다락쿤_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5465', '위미애머물다락쿤_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5465', '위미애머물다락쿤_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5466', '인디언키친 본점_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5466', '인디언키친 본점_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5466', '인디언키친 본점_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5467', '서울앵무새 제주_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5467', '서울앵무새 제주_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5467', '서울앵무새 제주_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5468', '카페데스틸_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5468', '카페데스틸_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5468', '카페데스틸_add3.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5469', '레이지펌프_add1.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5469', '레이지펌프_add2.jpg' );
insert into tbl_food_add_img(food_add_code, fk_food_store_code, food_add_img) values(SEQ_FOODADDIMG.nextval, '5469', '레이지펌프_add3.jpg' );

commit;

select *
from tbl_food_add_img
order by FOOD_ADD_CODE;

desc tbl_play;

rollback;

UPDATE tbl_food_store SET local_status='제주시 시내' WHERE local_status = '제주 시내';
UPDATE tbl_food_store SET local_status='서귀포시 시내' WHERE local_status = '서귀포 시내';

delete from tbl_food_add_img where food_add_code = 14;
commit;

select *
from tbl_food_store
order by food_store_code;

delete from tbl_food_store purge;

desc tbl_food_store;

commit;

제주시 시내
제주시 서부
제주시 동부
서귀포시 시내
서귀포시 동부
서귀포시 서부


select *
from tbl_food_store;

commit;

select local_status
from tbl_food_store 

commit;

----------------------------------------------------------------------------------------------------

-- 리스트에 주소 앞부분만 띄우기
select food_name, substr(food_address, instr(food_address, ' ', 1, 1)+1, instr(food_address, ' ', 1, 2)) AS 일부주소
from tbl_food_store;


-- 맛집 랜덤 추천
select food_main_img, food_name
from (
    select food_main_img, food_name 
    from tbl_food_store 
    order by DBMS_RANDOM.RANDOM
)
where rownum <= 5;

-- 숙소 랜덤 추천
select main_img, lodging_name
from (
    select main_img, lodging_name
    from tbl_lodging
    order by DBMS_RANDOM.RANDOM
)
where rownum <= 5;


-- 맛집 리스트 띄우기
select food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile
     , substr(food_address, 0, instr(food_address, ' ', 1, 2)-1) AS food_address
     , food_main_img, review_division 
from tbl_food_store
order by food_store_code;


-- 맛집 카테고리 띄우기
select distinct food_category
from tbl_food_store;


select food_store_code, food_category, food_name
from
(
    select food_store_code, food_category, food_name
         , row_number() over(partition by food_category order by food_store_code desc) as rno
    from tbl_food_store
)
where rno = 1
order by food_store_code;


-- 리뷰 페이징
SELECT review_code, fk_userid, review_content, registerday
FROM
(
    select row_number() over(order by review_code desc) As rno
          , review_code, fk_userid, review_content
          , to_char(registerday, 'yyyy-mm-dd') AS registerday
    from tbl_review
    where parent_code = 5316
    order by review_code desc
)V
WHERE V.rno BETWEEN #{startRno} and #{endRno};



-- 일정 추가 
select SCHEDULENO, subject,
       to_char(STARTDATE, 'yyyy-mm-dd hh24:mi:ss') as startdate,
       to_char(ENDDATE, 'yyyy-mm-dd hh24:mi:ss') as enddate,
       COLOR, PLACE, CONTENT, PARENT_CODE, SCHEDULE_DIVISON, FK_SMCATGONO, FK_LGCATGONO, FK_USERID
from TBL_CALENDAR_SCHEDULE
order by scheduleno;

insert into TBL_CALENDAR_SCHEDULE(SCHEDULENO, STARTDATE, ENDDATE, SUBJECT, COLOR, PLACE, CONTENT, PARENT_CODE, SCHEDULE_DIVISON, FK_SMCATGONO, FK_LGCATGONO, FK_USERID)
values(SEQ_SCHEDULENO.nextval, '2024-07-17', '2024-07-17', '팀회식', 'yellow', '물꼬해녀의집', '팀회식 예정입니다.', '5316', 'B', 2 , 1, 'yy6037');


----------------------------------------------------------------------------------------------------

select * from user_tables;

select *
from tbl_food_store;

select count(*)
from tbl_food_store;

select substr(food_add_img, 0, (food_add_img-3) )
from tbl_food_add_img


select *
from tbl_food_add_img

select reverse(substr(reverse(food_add_img), 0, 11))
from tbl_food_add_img
where food_add_code = 5;

-- 물꼬해물의집_add1.jpg 에서 물꼬해물의집 만 뽑아온 것
select reverse(substr(reverse(food_add_img),10))
from tbl_food_add_img
where food_add_code = 5;


select I.food_add_img
FROM 
(
select food_store_code, food_name
from tbl_food_store
where food_store_code = 5316
)S
join tbl_food_add_img I
on S.food_store_code = I.fk_food_store_code
order by food_add_img


select *
from tbl_review
where fk_userid = 'yy6037'
order by to_number(review_code) desc;

delete from tbl_review
where parent_code = 5316

commit;
desc tbl_food_store;


-------------------------------------------------------------------------
-- 맛집 조회수
update tbl_food_store
set readcount = readcount + 1
where food_store_code = '5316';

commit;

select food_store_code, food_name, readcount
from tbl_food_store;

commit;

-----------------------------------------------------
select * from tbl_review;

select * from tbl_food_store;

select * from tbl_like;

select * from user_tables;

select * from tbl_board;

select SCHEDULENO
     , to_char(STARTDATE, 'yyyy-mm-dd hh24:mi:ss') as startdate 
     , to_char(ENDDATE, 'yyyy-mm-dd hh24:mi:ss') as enddate 
     , SUBJECT, COLOR, PLACE, JOINUSER, CONTENT, PARENT_CODE, SCHEDULE_DIVISON, FK_SMCATGONO, FK_LGCATGONO, FK_USERID
from TBL_CALENDAR_SCHEDULE
order by scheduleno desc;

insert into TBL_CALENDAR_SCHEDULE(scheduleno, startdate, fk_userid)
values(seq_scheduleno.nextval, '2024-07-30 17:30:00', 'yy6037');



------------------------------------------------------

-- 숙소 랜덤 추천
select LODGING_CODE, main_img, lodging_name
from (
    select LODGING_CODE, main_img, lodging_name
    from tbl_lodging
    order by DBMS_RANDOM.RANDOM
)
where rownum <= 2;



select lodging_code, main_img, lodging_name
from (
    select lodging_code, main_img, lodging_name
    from tbl_lodging
    where local_status = '제주시 동부'
    order by DBMS_RANDOM.RANDOM
)
where rownum <= 2

desc tbl_lodging;



insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, review_division, orgfilename) values('SEQ_COMMON.nextval', '한식', '서귀포시 시내', '삼미횟집 제주공항점', '도두항을 20년동안 지켜온 싱싱한 회 한상', '10:30~18:00', '0507-1469-6403', '제주 제주시 도두항서5길 1', 'B', '삼미횟집 제주공항점.jpg');

commit;


insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, review_division, orgfilename) values(SEQ_COMMON.nextval, '양식', '제주시 시내', '소렉', '활랍스터구이, 송아지 채끝 스테이크 분위기 좋은 양식집', '10:30~19:00', '0507-1407-9015', '제주 제주시 은남2길 41 1층', 'B', '소렉.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, review_division, orgfilename) values(SEQ_COMMON.nextval, '기타', '서귀포시 서부 ', '팟타이시암', '제주에서 즐기는 태국식 쌀국수와 볶음국수', '10:00~19:30', '064-747-3676', '제주 제주시 용화로 41-2', 'B', '팟타이시암.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, review_division, orgfilename) values(SEQ_COMMON.nextval, '기타', '제주시 시내', '반탈레, 바다의집', '어머 이건 먹어야해! 해물향 가득한 푸팟퐁커리', '11:30~14:30', '0507-1355-4814', '제주 제주시 도두항서길 41 102호', 'B', '반탈레, 바다의집.jpg');
insert into tbl_food_store(food_store_code, food_category, local_status, food_name, food_content, food_businesshours, food_mobile, food_address, review_division, orgfilename) values(SEQ_COMMON.nextval, '카페', '서귀포시 시내', '망고레이 섭지코지점', '생망고를 갈아주는 섭지코지 카페', '15:00~20:00', '064-782-6006', '제주 서귀포시 성산읍 신양로 102', 'B', '망고레이 섭지코지점.jpg');

select *
from tbl_food_store;

commit;

desc tbl_food_store;

