show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.

----------------------------------------------------------------------------
/* 업체 */
CREATE TABLE tbl_company (
	companyid VARCHAR2(20) NOT NULL, /* 업체아이디 */
	company_name VARCHAR2(20), /* 업체명 */
	pw VARCHAR2(200) NOT NULL, /* 비밀번호 */
	email VARCHAR2(200) NOT NULL, /* 이메일 */
	mobile VARCHAR2(200) NOT NULL, /* 연락처 */
	registerday DATE DEFAULT sysdate, /* 가입일자 */
	lastpwdchangedate DATE DEFAULT sysdate, /* 마지막암호변경일자 */
	status NUMBER(1) DEFAULT 1 NOT NULL, /* 회원탈퇴유무 */
	idle NUMBER(1) DEFAULT 0 NOT NULL, /* 휴면유무 */
    CONSTRAINT PK_tbl_company_companyid PRIMARY KEY (companyid),
    CONSTRAINT UK_tbl_company_email UNIQUE (email),
    CONSTRAINT UK_tbl_company_mobile UNIQUE (mobile)
);


select *
from tbl_food_category;




select *
from tbl_local;




/* 맛집 */
CREATE TABLE tbl_food_store (
	food_store_code VARCHAR2(20) NOT NULL, /* 맛집일련번호 */
	fk_food_category_code VARCHAR2(20) NOT NULL, /* 맛집카테고리 일련번호 */
	fk_local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
	food_address VARCHAR2(200), /* 상세주소 */
	food_main_img VARCHAR2(100), /* 대표이미지 */
	review_division VARCHAR2(10) default 'B', /* 리뷰용구분컬럼(default) B */
    CONSTRAINT PK_tbl_food_store PRIMARY KEY (food_store_code),
    CONSTRAINT FK_tbl_local_code FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade,
	CONSTRAINT FK_tbl_food_category_code FOREIGN KEY (fk_food_category_code) REFERENCES tbl_food_category (food_category_code)  on delete cascade	
);


/* 맛집추가이미지 */
CREATE TABLE tbl_food_add_img (
	food_add_code VARCHAR2(20) NOT NULL, /* 맛집추가일련번호 */
	fk_food_store_code VARCHAR2(20), /* 맛집일련번호 */
	food_add_img VARCHAR2(100), /* 추가이미지파일 */
    CONSTRAINT PK_tbl_food_add_img_code PRIMARY KEY (food_add_code),
    CONSTRAINT FK_tbl_food_store_code FOREIGN KEY (fk_food_store_code) REFERENCES tbl_food_store (food_store_code) on delete cascade
);


/* 맛집카테고리 */
CREATE TABLE tbl_food_category (
	food_category_code VARCHAR2(20) NOT NULL, /* 맛집카테고리 일련번호 */
	food_category_name VARCHAR2(20), /* 맛집카테고리명칭 */
    CONSTRAINT PK_tbl_food_category_code PRIMARY KEY (food_category_code)
);

rollback;

commit;

select *
from tbl_food_store;


alter table tbl_food_store modify food_name varchar2(50);

insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '1' ,'106', '물꼬해녀의집','눈 앞에서 해녀가 직접 손질해주는 신선한 해산물','9:00~20:00','0507-1363-7331','제주특별자치도 제주시 우도면 우도해안길 496','물꼬해녀의집.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '1' ,'112', '성산일출봉 아시횟집','제주바다가 보이는 고등어회가 맛있는 곳','8:00~18:00','0507-1343-3987','제주특별자치도 서귀포시 성산읍 성산등용로 19','성산일출봉 아시횟집.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '1' ,'111', '돌집식당','엄마가 해주는 백반이 먹고싶을 때 가는 돌집식당','8:00~19:00','0507-1324-3720','제주특별자치도 서귀포시 표선면 서성일로 23','돌집식당.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '1' ,'109', '대윤흑돼지 서귀포올레시장점','누린내 안나는 진짜 흑돼지 맛집','10:00~20:00','064-732-2953','제주특별자치도 서귀포시 서문로 23','대윤흑돼지 서귀포올레시장점.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '3' ,'111', '제주 판타스틱버거','서양 느낌 물씬 나는 분위기, 음식 맛집','9:00~21:00','0507-1339-6990','제주특별자치도 서귀포시 표선면 토산중앙로15번길 6','제주 판타스틱버거.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '3' ,'101', '동백키친','데이트하기 좋은 유채꽃뷰 파스타, 스테이크맛집','11:00~21:00','0507-1358-1016','제주특별자치도 제주시 한림읍 수원7길 42 1층','동백키친.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '3' ,'108', '젠하이드어웨이 제주점','제주 스타일 브런치','11:00~20:00','064-794-0133','제주특별자치도 서귀포시 안덕면 사계남로 186-8','젠하이드어웨이 제주점.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '4' ,'109', '영육일삼','촉촉한 카츠가 일품인 곳','11:30~15:00','0507-1329-9492','제주특별자치도 서귀포시 이어도로 679 1층','영육일삼.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '4' ,'103', '미도리제주','제주도에서 즐기는 퓨전일식','8:00~14:00','0507-1315-5635','제주특별자치도 제주시 우령4길 5 1층','미도리제주.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '4' ,'109', '구르메스시 오마카세','갓 잡은 신선한 해산물로 요리하는 오마카세','17:00~3:00','064-738-4123','제주특별자치도 서귀포시 신서로48번길 59','구르메스시 오마카세.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '2' ,'109', '강정중국집','불향 가득한 짬뽕 맛집','10:00~17:00','0507-1358-7021','제주특별자치도 서귀포시 이어도로 633','강정중국집.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '2' ,'103', '연태만','찹쌀탕수육이 맛있는 곳','9:00~20:00','0507-1328-8448','제주특별자치도 제주시 중앙로21길 10 1층','연태만.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '2' ,'105', '함덕중국집','전복이 듬뿍 들어간 해물짬뽕 맛집','8:00~14:00','0507-1338-2572','제주특별자치도 제주시 조천읍 함와로 68 1층','함덕중국집.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '6' ,'109', '쏭타이 제주점','쌀국수가 맛있는 태국요리 맛집','11:00~16:00','064-738-7831','제주특별자치도 서귀포시 중문관광로72번길 29-9 2층','쏭타이 제주점.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '6' ,'110', '위미애머물다락쿤','똠양꿍 맛집을 찾는다면 여기','10:00~15:00','064-764-0106','제주특별자치도 서귀포시 남원읍 위미중앙로 274-43','위미애머물다락쿤.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '6' ,'100', '인디언키친 본점','정동 인도커리 맛집','12:00~20:00','0507-1390-5859','제주특별자치도 제주시 애월읍 애원로 191','인디언키친 본점.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '5' ,'109', '서울앵무새 제주','이색 분위기 카페, 신박한 음료가 많은 곳','12:00~18:00','0507-1333-1940','제주특별자치도 서귀포시 색달중앙로 162','서울앵무새 제주.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '5' ,'102', '카페데스틸','제주 분위기 낭낭한 감성카페','13:00~20:00','0507-1365-7402','제주특별자치도 제주시 한경면 한경해안로 110','카페데스틸.jpg',default);
insert into tbl_food_store(food_store_code, fk_food_category_code, fk_local_code, food_name, food_content, food_businesshours, food_mobile, food_address, food_main_img, review_division) values(seq_common.nextval, '5' ,'100', '레이지펌프','데이트하기 좋은 브런치 맛집','11:00~19:00','0507-1325-8732','제주특별자치도 제주시 애월읍 애월북서길 32','레이지펌프.jpg',default);

select *
from tbl_food_store;

commit;




