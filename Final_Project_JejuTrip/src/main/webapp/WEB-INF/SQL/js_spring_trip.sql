show user;
-- USER이(가) "SYS"입니다.

-- 이제 부터 오라클 계정생성시 계정명앞에 c## 붙이지 않고 생성하도록 하겠다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

create user final_orauser2 identified by gclass default tablespace users;
-- User SEMI_ORAUSER2이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to final_orauser2;
-- Grant을(를) 성공했습니다.
select play_code, fk_play_category_code, fk_local_code
from tbl_play;


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



/* 편의시설 */
CREATE TABLE tbl_convenient  (
	convenient_code VARCHAR2(20) NOT NULL, /* 편의시설일련번호 */
	convenient_name VARCHAR2(50), /* 편의시설명칭 */
    CONSTRAINT PK_tbl_convenient_code PRIMARY KEY (convenient_code)
);

select * from tbl_lodging_category;


SELECT local_code
FROM tbl_local 
WHERE local_division LIKE '%제주시%' 
  AND local_division NOT LIKE '%읍%' 
  AND local_division NOT LIKE '%면%'
  and local_division not like '중문관광로72번길 60';



select * from tbl_lodging;
insert into tbl_lodging (lodging_code,fk_local_code,fk_lodging_category_code,fk_companyid,lodging_name,lodging_tell,lodging_content,lodging_address,main_img)
values(seq_common.nextval,109,1,'company1','그랜드 조선 제주','064-738-6600',
'그랜드 조선의 모든 순간은 즐거움으로 가득 찬 하나의 여정이 됩니다.조선호텔이 지난 100여 년간 고객과 함께 해온 역량과 경험을 집대성하여 발전시킨 그랜드 조선은 호스피탈리티 산업의 본질 탐구와 혁신을 통해 세계적 수준의 호텔 경험을 제공합니다. 아무런 준비 없이 찾아도 머무는 동안 최적의 편안함과 최고의 즐거움을 느낄 수 있는 곳. 선제적이고 유연한 서비스와 끊임없이 새로운 경험들로 잊지 못할 즐거운 여정을 선사합니다.',
'제주특별자치도 서귀포시 중문관광로72번길 60','그랜드 조선 제주_thum.jpg');
commit;





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

/* 숙소객실 */
CREATE TABLE tbl_room_detail (
	room_detail_code VARCHAR2(20) NOT NULL, /* 숙소객실일련번호 */
	fk_lodging_code VARCHAR2(20) NOT NULL, /* 숙소일련번호 */
	room_name VARCHAR2(50) NOT NULL, /* 객실이름 */
	price NUMBER(10) NOT NULL, /* 객실가격 */
	check_in VARCHAR2(100) NOT NULL, /* 체크인시간 */
	check_out VARCHAR2(100) NOT NULL, /* 체크아웃시간 */
	room_stock NUMBER(1) NOT NULL, /* 객실수량 */
	min_person NUMBER(2) default 2, /* 기존인원 */
	max_person NUMBER(2) default 2, /* 최대인원 */
    CONSTRAINT PK_tbl_room_detail_code PRIMARY KEY (room_detail_code),
    CONSTRAINT FK_tbl_room_detail_fk_code FOREIGN KEY (fk_lodging_code) REFERENCES tbl_lodging (lodging_code) on delete cascade
);


/* 객실추가이미지 */
CREATE TABLE tbl_room_add_img (
	room_add_code VARCHAR2(20) NOT NULL, /* 객실추가일련번호 */
	fk_room_detail_code VARCHAR2(20), /* 숙소객실일련번호 */
	room_add_img VARCHAR2(100), /* 추가이미지파일 */
    CONSTRAINT PK_tbl_room_add_code PRIMARY KEY (room_add_code),
    CONSTRAINT FK_tbl_room_detail_code FOREIGN KEY (fk_room_detail_code) REFERENCES tbl_room_detail (room_detail_code) on delete cascade
);

/* 숙소별 편의시설 */
CREATE TABLE tbl_lodging_convenient  (
	fk_convenient_code VARCHAR2(20) NOT NULL, /* 편의시설일련번호 */
	fk_lodging_code VARCHAR2(20) NOT NULL, /* 숙소일련번호 */
    CONSTRAINT PK_tbl_lodging_convenient_code PRIMARY KEY (fk_convenient_code, fk_lodging_code),
    CONSTRAINT FK_tbl_convenient_code FOREIGN KEY (fk_convenient_code) REFERENCES tbl_convenient (convenient_code) on delete cascade,
    CONSTRAINT FK_tbl_lodging_code FOREIGN KEY (fk_lodging_code) REFERENCES tbl_lodging (lodging_code) on delete cascade
);


/* select 숙소카테고리 */
select lodging_category_code, lodging_category_name from tbl_lodging_category where lodging_category_name = '';


/* select 지역 */
select local_code, local_division, local_main_category from tbl_local where local_division like '%' || '서귀포시' || '%'
CREATE TABLE tbl_local (
	local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
	local_division VARCHAR2(200), /* 지역구분주소 */
	local_main_category VARCHAR2(200), /* 지역대분류 */
    CONSTRAINT PK_tbl_local	PRIMARY KEY (local_code)
);
-- Table TBL_LOCAL이(가) 생성되었습니다.


select * from tbl_local 
where ( (local_division like '제주시' || '%' and local_division not like '%'||'면'||'%') 
or (local_division like '제주시' || '%' and local_division not like '%'||'읍'||'%') 
and local_division not like '제주시 중문로' )


-- 입력받은게 ~~시로 시작하면서 ~~읍이나 ~~면이 아니면

select * from tbl_lodging_category;


alter table tbl_play modify play_name varchar2(100);


    begin
       for i in 1..10 loop
          insert into tbl_company(companyid, company_name, pw, email, mobile) 
          values('company'||i, '업체'||i, 'qwer1234$', 'ggggg'||i||'@gmail.com', 
                '02-238-238'||i);
       end loop;
    end;
    
    desc tbl_food_store;
    
    select * from tbl_company;
    commit;
    
    
    
    
    
    /* 회원 로그인기록 테이블 */
    CREATE TABLE tbl_member_loginhistory (
	fk_userid VARCHAR2(20) NOT NULL, /* 아이디 */
	logindate DATE default sysdate NOT NULL, /* 로그인시각 */
	clientip VARCHAR2(20) NOT NULL, /* 접속ip주소 */
    CONSTRAINT FK_tbl_member_history FOREIGN KEY (fk_userid) REFERENCES tbl_member (userid)
    );
    -- Table TBL_MEMBER_LOGINHISTORY이(가) 생성되었습니다.
    
    /* 업체 로그인기록 테이블 */
    CREATE TABLE tbl_company_loginhistory (
	fk_companyid VARCHAR2(20) NOT NULL, /* 아이디 */
	logindate DATE default sysdate NOT NULL, /* 로그인시각 */
	clientip VARCHAR2(20) NOT NULL, /* 접속ip주소 */
    CONSTRAINT FK_tbl_company_history FOREIGN KEY (fk_companyid) REFERENCES tbl_company (companyid)
    );
    -- Table TBL_COMPANY_LOGINHISTORY이(가) 생성되었습니다.
    desc tbl_lodging;
    select * from user_constraints where TABLE_NAME = 'TBL_FOOD_STORE';
    
    ALTER TABLE tbl_food_store RENAME COLUMN fk_local_code TO local_status;
    ALTER TABLE tbl_play RENAME COLUMN fk_local_code TO local_status;
    
    
    
    
    ALTER TABLE tbl_lodging
MODIFY (LODGING_CATEGORY DEFAULT '호텔');
    
    alter table tbl_lodging RENAME COLUMN FK_LOCAL_CODE to local_status;
    select * from tbl_food_store;
    -- 숙소테이블 임시로 제약조건 제거
    ALTER TABLE TBL_FOOD_STORE
    DROP CONSTRAINT FK_TBL_FOOD_LOCAL_CODE;
    
    ALTER TABLE tbl_lodging
    DROP CONSTRAINT FK_TBL_COMPANY_FK_COMPANYID;
    
    ALTER TABLE tbl_lodging
    MODIFY (fk_local_code VARCHAR2(20) NULL,
            fk_companyid VARCHAR2(20) NULL);
            
            
    -- 다시 추가하기
    ALTER TABLE tbl_lodging
ADD CONSTRAINT FK_TBL_LODGING_LOCAL FOREIGN KEY (fk_local_code)
REFERENCES tbl_local (local_code) ON DELETE CASCADE;



ALTER TABLE tbl_lodging
ADD CONSTRAINT FK_tbl_company_fk_companyid FOREIGN KEY (fk_companyid)
REFERENCES tbl_company (companyid) ON DELETE CASCADE;


    desc tbl_lodging;
    desc tbl_room_detail;
    ALTER TABLE tbl_lodging MODIFY LODGING_CONTENT VARCHAR2(2000);
    ALTER TABLE tbl_room_detail MODIFY room_name VARCHAR2(200);
    select * from tbl_lodging;
    select * from tbl_room_detail;
    
    delete from tbl_lodging where lodging_code not in(5006);
    delete from tbl_room_detail;
    commit;
    
    desc tbl_play;
    local_status '제주시 서부'
    
    select * from tbl_lodging where lodging_code not in (5006);
    select distinct fk_lodging_code from tbl_room_detail;
    desc tbl_room_detail;
    select seq_common.nextval
    from dual
    
    alter table 
    ALTER TABLE tbl_room_detail ADD room_img VARCHAR(200);
    
    create sequence seq_room
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    
    alter table tbl_lodging
    add fileName varchar2(255); -- WAS(톰캣)에 저장될 파일명(2024070109291535243254235235234.png)
    -- Table TBL_LODGING이(가) 변경되었습니다.
    alter table tbl_lodging
    add orgFilename varchar2(255); -- 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
    -- Table TBL_LODGING이(가) 변경되었습니다.
    alter table tbl_lodging
    add fileSize varchar2(255);  -- 파일크기
    -- Table TBL_LODGING이(가) 변경되었습니다.
    alter table tbl_lodging
    add feedback_msg varchar2(1000); -- 반려메시지용 컬럼
    
    
    alter table tbl_play
    add fileName varchar2(255); -- WAS(톰캣)에 저장될 파일명(2024070109291535243254235235234.png)
    -- Table TBL_PLAY이(가) 변경되었습니다.
    alter table tbl_play
    add orgFilename varchar2(255); -- 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
    -- Table TBL_PLAY이(가) 변경되었습니다.
    alter table tbl_play
    add fileSize varchar2(255);  -- 파일크기
    -- Table TBL_PLAY이(가) 변경되었습니다.
    
    alter table tbl_food_store
    add fileName varchar2(255); -- WAS(톰캣)에 저장될 파일명(2024070109291535243254235235234.png)
    -- Table TBL_FOOD_STORE이(가) 변경되었습니다.
    alter table tbl_food_store
    add orgFilename varchar2(255); -- 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
    -- Table TBL_FOOD_STORE이(가) 변경되었습니다.
    alter table tbl_food_store
    add fileSize varchar2(255);  -- 파일크기
    -- Table TBL_FOOD_STORE이(가) 변경되었습니다.
  
    desc tbl_food_store;
    
    
    
    alter table tbl_lodging
    add status number(1) default 0;
    
    desc tbl_lodging;
    
    alter table tbl_room_detail
    add fileName varchar2(255); 
    -- Table TBL_ROOM_DETAIL이(가) 변경되었습니다.
    alter table tbl_room_detail
    add orgFilename varchar2(255); 
    -- Table TBL_ROOM_DETAIL이(가) 변경되었습니다.
    alter table tbl_room_detail
    add fileSize varchar2(255);  
    -- Table TBL_ROOM_DETAIL이(가) 변경되었습니다.
    
    
    select * from tbl_lodging order by local_status;
    select * from tbl_room_detail;
    
    -- 제주 시내, 제주시 서부, 제주시 동부, 	서귀포시, 서귀포 동부, 	서귀포 서부
    
    
    update tbl_lodging set local_status = '제주시 서부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '애월읍' || '%');
    update tbl_lodging set local_status = '제주시 서부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '한림읍' || '%');
    update tbl_lodging set local_status = '제주시 서부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '한경면' || '%');
    
    update tbl_lodging set local_status = '제주시 서부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '제주시' || '%' and lodging_address not like '%' || '한경면' || '%' ;
    
    update tbl_lodging set local_status = '제주시 동부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '조천읍' || '%');
    update tbl_lodging set local_status = '제주시 동부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '구좌읍' || '%');
    update tbl_lodging set local_status = '제주시 동부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '우도면' || '%');
    
    update tbl_lodging set local_status = '서귀포시 서부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '안덕면' || '%');
    update tbl_lodging set local_status = '서귀포시 서부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '대정읍' || '%');
    
    update tbl_lodging set local_status = '서귀포시 동부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '남원읍' || '%');
    update tbl_lodging set local_status = '서귀포시 동부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '표선면' || '%');
    update tbl_lodging set local_status = '서귀포시 동부' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '성산읍' || '%');
    
    update tbl_lodging set local_status = '제주시 시내' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '제주시' || '%' and local_status is null);
    update tbl_lodging set local_status = '서귀포시 시내' where lodging_code in (select lodging_code from tbl_lodging where lodging_address like '%' || '서귀포시' || '%' and local_status is null);
    
    commit;
    
    select * from tbl_lodging order by local_status;
    update tbl_lodging set lodging_category = '펜션' where lodging_code in (select lodging_code from tbl_lodging where lodging_name like '%' || '펜션' || '%');
    update tbl_lodging set lodging_category = '리조트' where lodging_code in (select lodging_code from tbl_lodging where lodging_name like '%' || '리조트' || '%');
    
    
    select lodging_name, price, local_status
    from tbl_lodging L
    join tbl_room_detail R
    on L.lodging_code = R.fk_lodging_code
    group by lodging_name;
    
    
    select * from tbl_lodging;
    select * from tbl_
    
    
    
    select LODGING_NAME, LODGING_ADDRESS, LODGING_CODE, LOCAL_STATUS,
	   		 LODGING_CATEGORY, MAIN_IMG, REVIEW_DIVISION
	  from
	  (
          select row_number() over(order by LODGING_CODE desc) as rno, LODGING_NAME, LODGING_ADDRESS, LODGING_CODE, LOCAL_STATUS,
                 LODGING_CATEGORY, MAIN_IMG, REVIEW_DIVISION , price
          from tbl_lodging L join 
          (
          select fk_lodging_code , min(price) as price
          from tbl_room_detail
          group by fk_lodging_code
          )P
          on L.lodging_code = P.fk_lodging_code
          join
          (
          select fk_lodging_code
          from 
          tbl_lodging_convenient V
          join tbl_convenient A
          on V.fk_convenient_code = A.convenient_code
          where convenient_name in ('주차장 보유', '편의점')
          group by fk_lodging_code
          )C
          on L.lodging_code = C.fk_lodging_code
          where status = 1 
      )V
      where rno between 1 and 7; 
      

   
    select count(*)
    from tbl_lodging
    where status = 1 
    and lodging_category in ('호텔', '리조트')
    and local_status in ('서귀포시 시내', '제주시 서부')
    
    
    select * from tbl_convenient; 
    
  
    select * from tbl_lodging_convenient;
    select * from tbl_convenient;
    
    select * from tbl_lodging order by lodging_code asc;
    주차장 보유  수영장  바비큐  조식운영  반려동물 허용  편의점 스파/사우나  WIFI  전기차충전소  레스토랑  피트니스센터
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5157' , (select convenient_code from tbl_convenient where convenient_name = '주차장 보유') );
    commit;
    
   
    