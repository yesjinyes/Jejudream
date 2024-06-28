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

-- // 카테고리 테이블 삭제 확인용 // --
select * from tbl_lodging_category;
select * from tbl_play_category;
select * from tbl_food_category;

commit;



drop sequence seq_lodging_category;


