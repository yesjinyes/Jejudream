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
-- 제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명  

-- 컬럼 추가
ALTER TABLE [테이블명] ADD [컬럼명] [자료형]

-- 데이터 타입 변경
ALTER TABLE (테이블명) MODIFY (컬럼명) VARCHAR2(20);

-- 테이블 삭제
drop table 테이블명;

-- 테이블 데이터타입 조회
desc 테이블명;

-- 컬럼명 변경
alter table 테이블명 rename column A to B;




-- ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ㅍ
----------------------------------------------------------------------------------------------------
-- main sql 파일에 넣기

/* 숙소 */
CREATE TABLE tbl_lodging(
	lodging_code VARCHAR2(20) NOT NULL, /* 숙소일련번호 */
	fk_local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
	lodging_category VARCHAR2(20) NOT NULL, /* 숙소카테고리 */
	fk_companyid VARCHAR2(20) NOT NULL, /* 업체아이디 */
	lodging_name VARCHAR2(50) NOT NULL, /* 숙소이름 */
	lodging_tell VARCHAR2(20), /* 숙소연락처 */
	lodging_content VARCHAR2(1000), /* 숙소설명 */
	lodging_address VARCHAR2(200), /* 상세주소 */
	main_img VARCHAR2(100), /* 대표이미지 */
	review_division VARCHAR2(10) default 'A', /* 리뷰용구분컬럼(default) A */
    CONSTRAINT PK_tbl_lodging PRIMARY KEY (lodging_code),
    CONSTRAINT FK_tbl_local_tbl_lodging FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade,
    CONSTRAINT FK_tbl_company_fk_companyid FOREIGN KEY (fk_companyid) REFERENCES tbl_company (companyid) on delete cascade
);


/* 맛집 */
CREATE TABLE tbl_food_store (
	food_store_code VARCHAR2(20) NOT NULL, /* 맛집일련번호 */
	fk_local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
    food_category VARCHAR2(20) NOT NULL, /* 맛집카테고리 */
    food_name VARCHAR2(20) NOT NULL, /* 맛집식당이름 */
    food_content VARCHAR2(200), /* 맛집간단정보 */
    food_businesshours VARCHAR2(100), /* 영업시간 */
    food_mobile VARCHAR2(100),  /* 맛집 연락처 */
	food_address VARCHAR2(200), /* 상세주소 */
	food_main_img VARCHAR2(100), /* 대표이미지 */
	review_division VARCHAR2(10) default 'B', /* 리뷰용구분컬럼(default) B */
    CONSTRAINT PK_tbl_food_store PRIMARY KEY (food_store_code),
    CONSTRAINT FK_tbl_local_code FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade
);

desc tbl_food_store;

/* 즐길거리 */
CREATE TABLE tbl_play (
	play_code VARCHAR2(20) NOT NULL, /* 즐길거리일련번호 */
	fk_local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
    play_category VARCHAR2(20) NOT NULL, /* 즐길거리카테고리 */
    play_name VARCHAR2(20) NOT NULL, /* 즐길거리 명칭 */
    play_content VARCHAR2(100), /* 즐길거리 짧은상세정보 */
    play_mobile VARCHAR2(100), /* 즐길거리 연락처 */
    play_businesshours VARCHAR2(100), /* 즐길거리 운영시간 */
	play_address VARCHAR2(200), /* 상세주소 */
	play_main_img VARCHAR2(100), /* 대표이미지 */
	review_division VARCHAR2(10) default 'C', /* 리뷰용구분컬럼(default) C */
    CONSTRAINT PK_tbl_play 	PRIMARY KEY (play_code),
    CONSTRAINT FK_tbl_play_local_code FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade
);


----------------------------------------------------------------------------------------------------

-- 맛집 테이블 insert
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '한식' ,'106', '물꼬해녀의집','눈 앞에서 해녀가 직접 손질해주는 신선한 해산물','9:00~20:00','0507-1363-7331','제주특별자치도 제주시 우도면 우도해안길 496','물꼬해녀의집.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '한식' ,'112', '성산일출봉 아시횟집','제주바다가 보이는 고등어회가 맛있는 곳','8:00~18:00','0507-1343-3987','제주특별자치도 서귀포시 성산읍 성산등용로 19','성산일출봉 아시횟집.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '한식' ,'111', '돌집식당','엄마가 해주는 백반이 먹고싶을 때 가는 돌집식당','8:00~19:00','0507-1324-3720','제주특별자치도 서귀포시 표선면 서성일로 23','돌집식당.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '한식' ,'109', '대윤흑돼지 서귀포올레시장점','누린내 안나는 진짜 흑돼지 맛집','10:00~20:00','064-732-2953','제주특별자치도 서귀포시 서문로 23','대윤흑돼지 서귀포올레시장점.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '양식' ,'111', '제주 판타스틱버거','서양 느낌 물씬 나는 분위기, 음식 맛집','9:00~21:00','0507-1339-6990','제주특별자치도 서귀포시 표선면 토산중앙로15번길 6','제주 판타스틱버거.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '양식' ,'101', '동백키친','데이트하기 좋은 유채꽃뷰 파스타, 스테이크맛집','11:00~21:00','0507-1358-1016','제주특별자치도 제주시 한림읍 수원7길 42 1층','동백키친.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '양식' ,'108', '젠하이드어웨이 제주점','제주 스타일 브런치','11:00~20:00','064-794-0133','제주특별자치도 서귀포시 안덕면 사계남로 186-8','젠하이드어웨이 제주점.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '일식' ,'109', '영육일삼','촉촉한 카츠가 일품인 곳','11:30~15:00','0507-1329-9492','제주특별자치도 서귀포시 이어도로 679 1층','영육일삼.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '일식' ,'103', '미도리제주','제주도에서 즐기는 퓨전일식','8:00~14:00','0507-1315-5635','제주특별자치도 제주시 우령4길 5 1층','미도리제주.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '일식' ,'109', '구르메스시 오마카세','갓 잡은 신선한 해산물로 요리하는 오마카세','17:00~3:00','064-738-4123','제주특별자치도 서귀포시 신서로48번길 59','구르메스시 오마카세.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '중식' ,'109', '강정중국집','불향 가득한 짬뽕 맛집','10:00~17:00','0507-1358-7021','제주특별자치도 서귀포시 이어도로 633','강정중국집.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '중식' ,'103', '연태만','찹쌀탕수육이 맛있는 곳','9:00~20:00','0507-1328-8448','제주특별자치도 제주시 중앙로21길 10 1층','연태만.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '중식' ,'105', '함덕중국집','전복이 듬뿍 들어간 해물짬뽕 맛집','8:00~14:00','0507-1338-2572','제주특별자치도 제주시 조천읍 함와로 68 1층','함덕중국집.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '기타' ,'109', '쏭타이 제주점','쌀국수가 맛있는 태국요리 맛집','11:00~16:00','064-738-7831','제주특별자치도 서귀포시 중문관광로72번길 29-9 2층','쏭타이 제주점.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '기타' ,'110', '위미애머물다락쿤','똠양꿍 맛집을 찾는다면 여기','10:00~15:00','064-764-0106','제주특별자치도 서귀포시 남원읍 위미중앙로 274-43','위미애머물다락쿤.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '기타' ,'100', '인디언키친 본점','정동 인도커리 맛집','12:00~20:00','0507-1390-5859','제주특별자치도 제주시 애월읍 애원로 191','인디언키친 본점.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '카페' ,'109', '서울앵무새 제주','이색 분위기 카페, 신박한 음료가 많은 곳','12:00~18:00','0507-1333-1940','제주특별자치도 서귀포시 색달중앙로 162','서울앵무새 제주.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '카페' ,'102', '카페데스틸','제주 분위기 낭낭한 감성카페','13:00~20:00','0507-1365-7402','제주특별자치도 제주시 한경면 한경해안로 110','카페데스틸.jpg',default);
insert into tbl_food_store(food_store_code, food_category, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '카페' ,'100', '레이지펌프','데이트하기 좋은 브런치 맛집','11:00~19:00','0507-1325-8732','제주특별자치도 제주시 애월읍 애월북서길 32','레이지펌프.jpg',default);

commit;



select food_name, substr(food_address, 0, instr(food_address, ' ', 1, 2)-1) AS 일부주소
from tbl_food_store;

       , instr('쌍용교육센터 서울교육대학교 교육문화원', '교육', 1, 1) -- 3
       -- '쌍용교육센터 서울교육대학교 교육문화원'에서 '교육'이 나오는 위치를 찾는데
       -- 출발점이 1번째부터 검색해서 1번째로 나오는 '교육'의 위치를 알려달라는 말이다.

select 
from tbl_food_store;

select *
from tbl_food_store;
