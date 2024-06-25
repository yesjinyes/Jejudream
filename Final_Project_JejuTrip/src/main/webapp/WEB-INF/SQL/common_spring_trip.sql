show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.





/* 숙소카테고리 */
CREATE TABLE tbl_lodging_category (
	lodging_category_code VARCHAR2(20) NOT NULL, /* 숙소카테고리일련번호 */
	lodging_category_name VARCHAR2(50), /* 숙소카테고리명칭 펜션 호텔 */
    CONSTRAINT PK_tbl_lodging_category	PRIMARY KEY (lodging_category_code)
);
-- Table TBL_LODGING_CATEGORY이(가) 생성되었습니다.



/* 지역 */
CREATE TABLE tbl_local (
	local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
	local_division VARCHAR2(200), /* 지역구분주소 */
	local_main_category VARCHAR2(200), /* 지역대분류 */
    CONSTRAINT PK_tbl_local	PRIMARY KEY (local_code)
);
-- Table TBL_LOCAL이(가) 생성되었습니다.


/* 즐길거리 카테고리 */
CREATE TABLE tbl_play_category (
	play_category_code VARCHAR2(20) NOT NULL, /* 즐길거리카테고리일련번호 */
	play_category_name VARCHAR2(20), /* 즐길거리카테고리명칭 */
    CONSTRAINT PK_tbl_play_category PRIMARY KEY (play_category_code)
);
-- Table TBL_PLAY_CATEGORY이(가) 생성되었습니다.


/* 회원 */
CREATE TABLE tbl_member (
	userid VARCHAR2(20) NOT NULL, /* 아이디 */
	email VARCHAR2(200) NOT NULL, /* 이메일 */
	pw VARCHAR2(200) NOT NULL, /* 비밀번호 */
	user_name NVARCHAR2(20) NOT NULL, /* 성명 */
	mobile VARCHAR2(200) NOT NULL, /* 휴대폰번호 */
	address VARCHAR2(200), /* 주소 */
	detail_address VARCHAR2(200), /* 상세주소 */
	birthday VARCHAR2(10) NOT NULL, /* 생년월일 */
	gender VARCHAR2(1) NOT NULL, /* 성별 */
	registerday DATE DEFAULT sysdate, /* 가입일자 */
	lastpwdchangedate DATE DEFAULT sysdate, /* 마지막암호변경일자 */
	status NUMBER(1) DEFAULT 1 NOT NULL, /* 회원탈퇴유무 */
	idle NUMBER(1) DEFAULT 0 NOT NULL, /* 휴면유무 */
	userimg VARCHAR2(200) DEFAULT 'usernomal.jpg', /* 유저이미지 */
    CONSTRAINT PK_tbl_member_userid PRIMARY KEY (userid),
    CONSTRAINT UK_tbl_member_email UNIQUE (email),
    CONSTRAINT UK_tbl_member_mobile UNIQUE (mobile)
);
-- Table TBL_MEMBER이(가) 생성되었습니다.



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
-- Table TBL_COMPANY이(가) 생성되었습니다.


/* 편의시설 */
CREATE TABLE tbl_convenient  (
	convenient_code VARCHAR2(20) NOT NULL, /* 편의시설일련번호 */
	convenient_name VARCHAR2(50), /* 편의시설명칭 */
    CONSTRAINT PK_tbl_convenient_code PRIMARY KEY (convenient_code)
);
-- Table TBL_CONVENIENT이(가) 생성되었습니다.


/* 맛집카테고리 */
CREATE TABLE tbl_food_category (
	food_category_code VARCHAR2(20) NOT NULL, /* 맛집카테고리 일련번호 */
	food_category_name VARCHAR2(20), /* 맛집카테고리명칭 */
    CONSTRAINT PK_tbl_food_category_code PRIMARY KEY (food_category_code)
);
-- Table TBL_FOOD_CATEGORY이(가) 생성되었습니다.


/* 리뷰테이블 */
CREATE TABLE tbl_review (
	review_code VARCHAR2(20) NOT NULL, /* 리뷰일련번호 */
	fk_userid VARCHAR2(20) NOT NULL, /* 아이디 */
	parent_code VARCHAR2(20) NOT NULL, /* 부모일련번호 */
	review_content VARCHAR2(1000) NOT NULL, /* 리뷰내용 */
	registerday DATE default sysdate, /* 리뷰작성일자 */
	review_division_R VARCHAR2(10) NOT NULL, /* 리뷰구분 A,B,C */
    CONSTRAINT PK_tbl_review_code PRIMARY KEY (review_code),
    CONSTRAINT FK_tbl_member_userid FOREIGN KEY (fk_userid) REFERENCES tbl_member (userid) on delete cascade
);
-- Table TBL_REVIEW이(가) 생성되었습니다.


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
-- Table TBL_FOOD_STORE이(가) 생성되었습니다.


/* 숙소 */
CREATE TABLE tbl_lodging(
	lodging_code VARCHAR2(20) NOT NULL, /* 숙소일련번호 */
	fk_local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
	fk_lodging_category_code VARCHAR2(20) NOT NULL, /* 숙소카테고리일련번호 */
	fk_companyid VARCHAR2(20) NOT NULL, /* 업체아이디 */
	lodging_name VARCHAR2(50) NOT NULL, /* 숙소이름 */
	lodging_tell VARCHAR2(20), /* 숙소연락처 */
	lodging_content VARCHAR2(1000), /* 숙소설명 */
	lodging_address VARCHAR2(200), /* 상세주소 */
	main_img VARCHAR2(100), /* 대표이미지 */
	review_division VARCHAR2(10) default 'A', /* 리뷰용구분컬럼(default) A */
    CONSTRAINT PK_tbl_lodging PRIMARY KEY (lodging_code),
    CONSTRAINT FK_tbl_local_tbl_lodging FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade,
    CONSTRAINT FK_tbl_lodging_category_code FOREIGN KEY (fk_lodging_category_code) REFERENCES tbl_lodging_category (lodging_category_code) on delete cascade,
    CONSTRAINT FK_tbl_company_fk_companyid FOREIGN KEY (fk_companyid) REFERENCES tbl_company (companyid) on delete cascade
);
-- Table TBL_LODGING이(가) 생성되었습니다.


/* 숙소별 편의시설 */
CREATE TABLE tbl_lodging_convenient  (
	fk_convenient_code VARCHAR2(20) NOT NULL, /* 편의시설일련번호 */
	fk_lodging_code VARCHAR2(20) NOT NULL, /* 숙소일련번호 */
    CONSTRAINT PK_tbl_lodging_convenient_code PRIMARY KEY (fk_convenient_code, fk_lodging_code),
    CONSTRAINT FK_tbl_convenient_code FOREIGN KEY (fk_convenient_code) REFERENCES tbl_convenient (convenient_code) on delete cascade,
    CONSTRAINT FK_tbl_lodging_code FOREIGN KEY (fk_lodging_code) REFERENCES tbl_lodging (lodging_code) on delete cascade
);
-- Table TBL_LODGING_CONVENIENT이(가) 생성되었습니다.

/* 즐길거리 */
CREATE TABLE tbl_play (
	play_code VARCHAR2(20) NOT NULL, /* 즐길거리일련번호 */
	fk_play_category_code VARCHAR2(20), /* 즐길거리카테고리일련번호 */
	fk_local_code VARCHAR2(20), /* 지역코드 */
	play_address VARCHAR2(200), /* 상세주소 */
	play_main_img VARCHAR2(100), /* 대표이미지 */
	review_divisionC VARCHAR2(10), /* 리뷰용구분컬럼(default) C */
    CONSTRAINT PK_tbl_play 	PRIMARY KEY (play_code),
    CONSTRAINT FK_tbl_local_TO_tbl_play FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade,
    CONSTRAINT FK_tbl_play_category_TO_tbl_play FOREIGN KEY (fk_play_category_code)	REFERENCES tbl_play_category (play_category_code) on delete cascade
);




/* 숙소객실 */
CREATE TABLE tbl_room_detail (
	room_detail_code VARCHAR2(20) NOT NULL, /* 숙소객실일련번호 */
	fk_lodging_code VARCHAR2(20), /* 숙소일련번호 */
	room_name VARCHAR2(50), /* 객실이름 */
	price VARCHAR2(50), /* 객실가격 */
	check_in VARCHAR2(100), /* 체크인시간 */
	check_out VARCHAR2(100), /* 체크아웃시간 */
	room_stock VARCHAR2(20), /* 객실수량 */
	min_person VARCHAR2(20), /* 기존인원 */
	max_person VARCHAR2(20), /* 최대인원 */
    CONSTRAINT PK_tbl_room_detail_code PRIMARY KEY (room_detail_code),
    CONSTRAINT FK_tbl_room_detail_fk_lodging_code FOREIGN KEY (fk_lodging_code) REFERENCES tbl_lodging (lodging_code) on delete cascade
);




/* 예약 */
CREATE TABLE tbl_reservation (
	reservation_code VARCHAR2(20) NOT NULL, /* 예약일련번호 */
	fk_userid VARCHAR2(20), /* 아이디 */
	fk_room_detail_code VARCHAR2(20), /* 숙소객실일련번호 */
	reservation_date DATE, /* 예약일자 */
	check_in VARCHAR2(100), /* 체크인일자 */
	check_out VARCHAR2(100), /* 체크아웃일자 */
	price VARCHAR2(100), /* 예약가격 */
    CONSTRAINT PK_tbl_reservation_code PRIMARY KEY (reservation_code),
    CONSTRAINT FK_tbl_reservation_fk_room_detail_code FOREIGN KEY (fk_room_detail_code) REFERENCES tbl_room_detail (room_detail_code) on delete cascade,
    CONSTRAINT FK_tbl_member_fk_userid FOREIGN KEY (fk_userid)	REFERENCES tbl_member (userid) on delete cascade
);




/* 맛집추가이미지 */
CREATE TABLE tbl_food_add_img (
	food_add_code VARCHAR2(20) NOT NULL, /* 맛집추가일련번호 */
	fk_food_store_code VARCHAR2(20), /* 맛집일련번호 */
	food_add_img VARCHAR2(100), /* 추가이미지파일 */
    CONSTRAINT PK_tbl_food_add_img_code PRIMARY KEY (food_add_code),
    CONSTRAINT FK_tbl_food_store_code FOREIGN KEY (fk_food_store_code) REFERENCES tbl_food_store (food_store_code) on delete cascade
);



/* 객실추가이미지 */
CREATE TABLE tbl_room_add_img (
	room_add_code VARCHAR2(20) NOT NULL, /* 객실추가일련번호 */
	fk_room_detail_code VARCHAR2(20), /* 숙소객실일련번호 */
	room_add_img VARCHAR2(100), /* 추가이미지파일 */
    CONSTRAINT PK_tbl_room_add_code PRIMARY KEY (room_add_code),
    CONSTRAINT FK_tbl_room_detail_code FOREIGN KEY (fk_room_detail_code) REFERENCES tbl_room_detail (room_detail_code) on delete cascade
);

/* 즐길거리추가이미지 */
CREATE TABLE tbl_play_add_img (
	play_add_code VARCHAR2(20) NOT NULL, /* 즐길거리추가일련번호 */
	fk_play_code VARCHAR2(20), /* 즐길거리일련번호 */
	play_add_img VARCHAR2(100), /* 추가이미지파일 */
    CONSTRAINT PK_tbl_play_add_code PRIMARY KEY (play_add_code),
    CONSTRAINT FK_tbl_play_code FOREIGN KEY (fk_play_code) REFERENCES tbl_play (play_code) on delete cascade
);





/* 추가이미지(보류) */
CREATE TABLE tbl_add_img (
	add_img_code <지정 되지 않음> NOT NULL, /* 이미지일련번호 */
	add_parent_code <지정 되지 않음>, /* 부모일련번호 */
	add_img <지정 되지 않음>, /* 추가이미지파일 */
	review_division <지정 되지 않음> /* 구분컬럼 */
);

