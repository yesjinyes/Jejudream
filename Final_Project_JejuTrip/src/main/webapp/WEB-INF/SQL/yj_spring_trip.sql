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

