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
    
    
    select * from tbl_lodging order by lodging_code; 
    
    select * from tbl_lodging_convenient order by fk_lodging_code
    select * from tbl_lodging_convenient where fk_lodging_code = '5204';
    select convenient_name from tbl_convenient;
    
    select * from tbl_lodging order by lodging_code asc;
    주차장 보유  수영장  바비큐  조식운영  반려동물 허용  편의점 스파/사우나  WIFI  전기차충전소  레스토랑  피트니스센터
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5207' , (select convenient_code from tbl_convenient where convenient_name = '반려동물 허용') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5216' , (select convenient_code from tbl_convenient where convenient_name = '바비큐') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5206' , (select convenient_code from tbl_convenient where convenient_name = '주차장 보유') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5214' , (select convenient_code from tbl_convenient where convenient_name = '수영장') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5214' , (select convenient_code from tbl_convenient where convenient_name = '조식운영') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5213' , (select convenient_code from tbl_convenient where convenient_name = '편의점') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5213' , (select convenient_code from tbl_convenient where convenient_name = '스파/사우나') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5219' , (select convenient_code from tbl_convenient where convenient_name = 'WIFI') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5219' , (select convenient_code from tbl_convenient where convenient_name = '전기차충전소') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5188' , (select convenient_code from tbl_convenient where convenient_name = '레스토랑') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5188' , (select convenient_code from tbl_convenient where convenient_name = '피트니스센터') );
    insert into tbl_lodging_convenient (fk_lodging_code, fk_convenient_code) values ('5209' , (select convenient_code from tbl_convenient where convenient_name = '주차장 보유') );
    
    
    commit;
    select * from tbl_member;
    
    select ROOM_DETAIL_CODE, FK_LODGING_CODE, ROOM_NAME, PRICE, 
    CHECK_IN, CHECK_OUT, ROOM_STOCK, MIN_PERSON, MAX_PERSON,
    ROOM_IMG
    from tbl_room_detail
    where fk_lodging_code = ;
    desc tbl_room_detail;
    desc tbl_reservation;
    
    ALTER TABLE tbl_reservation ADD status number(1) DEFAULT 0;
    
    select * from tbl_room_detail where fk_lodging_code = 5159;
    
    create sequence seq_reserve
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    select * from user_sequences
    
    insert into tbl_reservation (RESERVATION_CODE ,FK_USERID, FK_ROOM_DETAIL_CODE, CHECK_IN, CHECK_OUT, RESERVATION_PRICE, STATUS)
    values (seq_reserve.nextval , 'kudi03628', 375, to_date('2024-07-08', 'yyyy-mm-dd'), to_date('2024-07-09', 'yyyy-mm-dd'), 1, 1);
    insert into tbl_reservation (RESERVATION_CODE ,FK_USERID, FK_ROOM_DETAIL_CODE, CHECK_IN, CHECK_OUT, RESERVATION_PRICE, STATUS)
    values (seq_reserve.nextval , 'kudi03628', 375, to_date('2024-07-08', 'yyyy-mm-dd'), to_date('2024-07-09', 'yyyy-mm-dd'), 1, 1);
    insert into tbl_reservation (RESERVATION_CODE ,FK_USERID, FK_ROOM_DETAIL_CODE, CHECK_IN, CHECK_OUT, RESERVATION_PRICE, STATUS)
    values (seq_reserve.nextval , 'kudi03628', 375, to_date('2024-07-08', 'yyyy-mm-dd'), to_date('2024-07-09', 'yyyy-mm-dd'), 1, 1);
    
    insert into tbl_reservation (RESERVATION_CODE ,FK_USERID, FK_ROOM_DETAIL_CODE, CHECK_IN, CHECK_OUT, RESERVATION_PRICE, STATUS)
    values (seq_reserve.nextval , 'kudi03628', 376, '2024-07-08', '2024-07-09', 1, 1);
    insert into tbl_reservation (RESERVATION_CODE ,FK_USERID, FK_ROOM_DETAIL_CODE, CHECK_IN, CHECK_OUT, RESERVATION_PRICE, STATUS)
    values (seq_reserve.nextval , 'kudi03628', 376, '2024-07-08', '2024-07-09', 1, 1);
    insert into tbl_reservation (RESERVATION_CODE ,FK_USERID, FK_ROOM_DETAIL_CODE, CHECK_IN, CHECK_OUT, RESERVATION_PRICE, STATUS)
    values (seq_reserve.nextval , 'kudi03628', 376, '2024-07-08', '2024-07-09', 1, 1);
    
    commit;
    
    
    select count(*) from tbl_reservation where CHECK_IN between '2024-07-08' and '2024-07-09' and FK_ROOM_DETAIL_CODE = 375;
    
    
    select room_stock from tbl_room_detail where room_detail_code = 375;
    
    
    select room_name
    from tbl_room_detail D
    join tbl_reservation R
    on D.room_detail_code != R.fk_room_detail_code
    where R.CHECK_IN between '2024-07-08' and '2024-07-09'
    and status != 1
    order by room_detail_code asc;
    
    select * from tbl_room_detail order by room_detail_code desc;
    select * from tbl_reservation;
    
    delete from tbl_room_detail where room_detail_code in (671, 672);
    
    commit;
    delete from tbl_reservation where reservation_code = 5;
    commit;  
         
        select lodging_code,  min(price)
        from tbl_lodging L join
        (
        select fk_lodging_code, room_name, price
        from tbl_room_detail D
        
                    
        minus
        
        select fk_lodging_code, room_name, price
        from tbl_room_detail D
        join tbl_reservation R
        on D.room_detail_code = R.fk_room_detail_code
        where R.check_in between '2024-07-08' and '2024-07-09'
        
        )V
        on L.lodging_code = V.fk_lodging_code
        group by lodging_code
        order by lodging_code asc;
        
        
        select room_stock from tbl_
        
        
////////////////////////////////////////////////////////

select *
from tbl_room_detail

select *
from tbl_lodging

SELECT R.fk_lodging_code, R.room_name, R.price, R.room_stock  --, L.lodging_name 
from tbl_room_detail R LEFT JOIN tbl_lodging L
ON R.fk_lodging_code = L.lodging_code;

select R.fk_lodging_code, R.room_name, R.price 
from tbl_room_detail R
join tbl_reservation RSV
on R.room_detail_code = RSV.fk_room_detail_code
where RSV.check_in between '2024-07-08' and '2024-07-09';


SELECT fk_lodging_code, room_name, count(*) AS RESERVATION_CNT
FROM 
(
select R.fk_lodging_code, R.room_name, R.price 
from tbl_room_detail R
join tbl_reservation RSV
on R.room_detail_code = RSV.fk_room_detail_code
where RSV.check_in between '2024-07-08' and '2024-07-09'
) V
GROUP BY fk_lodging_code, room_name
HAVING count(*) < 3;


SELECT fk_lodging_code, room_name
FROM 
(
select R.fk_lodging_code, R.room_name, R.price 
from tbl_room_detail R
join tbl_reservation RSV
on R.room_detail_code = RSV.fk_room_detail_code
where RSV.check_in between '2024-07-08' and '2024-07-09'
) V
GROUP BY fk_lodging_code, room_name
HAVING count(*) = 3;


SELECT R.fk_lodging_code, R.room_name, R.price
from tbl_room_detail R LEFT JOIN tbl_lodging L
ON R.fk_lodging_code = L.lodging_code
WHERE R.fk_lodging_code || ' ' || R.room_name NOT IN(SELECT fk_lodging_code || ' ' || room_name
                                                     FROM 
                                                (
                                                select R.fk_lodging_code, R.room_name, R.price 
                                                from tbl_room_detail R
                                                join tbl_reservation RSV
                                                on R.room_detail_code = RSV.fk_room_detail_code
                                                where RSV.check_in between '2024-07-08' and '2024-07-09'
                                                ) V
                                                GROUP BY fk_lodging_code, room_name
                                                HAVING count(*) = 3);


-------------------------------------------------------
 숙소코드  객실명   객실개수   예약개수    객실개수 - 예약개수
-------------------------------------------------------
 
 SELECT A.lodging_code, A.room_name, A.room_stock, 
       NVL(B.RESERVATION_CNT, 0) AS RESERVATION_CNT,
       CASE WHEN A.room_stock - NVL(B.RESERVATION_CNT, 0) >= 1 THEN '예약가능'
       ELSE '예약종료' END AS RESERVATION_STATE
 FROM 
 (
  SELECT L.lodging_code, D.room_name, D.room_stock
  FROM tbl_lodging L JOIN tbl_room_detail D
  ON L.lodging_code = D.fk_lodging_code 
 ) A
 LEFT JOIN
 (
  SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
  FROM tbl_room_detail D JOIN tbl_reservation RSV
  ON D.room_detail_code = RSV.fk_room_detail_code
  WHERE RSV.check_in BETWEEN '2024-07-08' AND '2024-07-09'
  GROUP BY D.fk_lodging_code, D.room_name
 ) B
 ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name;


SELECT distinct lodging_code
FROM 
(
SELECT A.lodging_code, A.room_name, A.room_stock, 
       NVL(B.RESERVATION_CNT, 0) AS RESERVATION_CNT,
       CASE WHEN A.room_stock - NVL(B.RESERVATION_CNT, 0) >= 1 THEN '예약가능'
       ELSE '예약종료' END AS RESERVATION_STATE
 FROM 
 (
  SELECT L.lodging_code, D.room_name, D.room_stock
  FROM tbl_lodging L JOIN tbl_room_detail D
  ON L.lodging_code = D.fk_lodging_code 
 ) A
 LEFT JOIN
 (
  SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
  FROM tbl_room_detail D JOIN tbl_reservation RSV
  ON D.room_detail_code = RSV.fk_room_detail_code
  WHERE RSV.check_in BETWEEN '2024-07-08' AND '2024-07-09'
  GROUP BY D.fk_lodging_code, D.room_name
 ) B
 ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name
) V
WHERE V.RESERVATION_STATE = '예약가능'
order by 1 asc;





/////////////////////////////////////////////////////////

create table tbl_board
    (seq           number                not null    -- 글번호
    ,fk_userid     varchar2(20)          not null    -- 사용자ID
    ,name          varchar2(20)          not null    -- 글쓴이 
    ,subject       Nvarchar2(200)        not null    -- 글제목
    --,content     Nvarchar2(2000)       not null    -- 글내용
    ,content       clob                  not null    -- 글내용   CLOB(4GB 까지 저장 가능한 데이터 타입) 타입
    ,pw            varchar2(20)          not null    -- 글암호
    ,readCount     number default 0      not null    -- 글조회수
    ,regDate       date default sysdate  not null    -- 글쓴시간
    ,status        number(1) default 1   not null    -- 글삭제여부   1:사용가능한 글,  0:삭제된글
    ,commentCount  number default 0      not null    -- 댓글의 개수 
    ,fileName       varchar2(255)                    -- WAS(톰캣)에 저장될 파일명(2024062609291535243254235235234.png)                                       
    ,orgFilename    varchar2(255)                    -- 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
    ,fileSize       number                           -- 파일크기  
    ,category       number                           -- 어떤 카테고리(자유게시판, 스탭구해요 등등)의 글인지
    
    ,constraint PK_tbl_board_seq primary key(seq)
    ,constraint FK_tbl_board_fk_userid foreign key(fk_userid) references tbl_member(userid)
    ,constraint CK_tbl_board_status check( status in(0,1) )
    );
    -- Table TBL_BOARD이(가) 생성되었습니다.
    
    create sequence boardSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    -- Sequence BOARDSEQ이(가) 생성되었습니다.
    
    
    create table tbl_comment
    (seq           number               not null   -- 댓글번호
    ,fk_userid     varchar2(20)         not null   -- 사용자ID
    ,name          varchar2(20)         not null   -- 성명
    ,content       varchar2(1000)       not null   -- 댓글내용
    ,regDate       date default sysdate not null   -- 작성일자
    ,parentSeq     number               not null   -- 원게시물 글번호
    ,status        number(1) default 1  not null   -- 글삭제여부
                                                   -- 1 : 사용가능한 글,  0 : 삭제된 글
                                                   -- 댓글은 원글이 삭제되면 자동적으로 삭제되어야 한다.
    ,constraint PK_tbl_comment_seq primary key(seq)
    ,constraint FK_tbl_comment_userid foreign key(fk_userid) references tbl_member(userid)
    ,constraint FK_tbl_comment_parentSeq foreign key(parentSeq) references tbl_board(seq) on delete cascade
    ,constraint CK_tbl_comment_status check( status in(1,0) ) 
    );
    -- Table TBL_COMMENT이(가) 생성되었습니다.
    
    
    create sequence commentSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    -- Sequence COMMENTSEQ이(가) 생성되었습니다.

    select * 
    from tbl_lodging
    
    
    
    -------------------------------------------------------
     숙소코드  객실명   객실개수   예약개수    객실개수 - 예약개수
    -------------------------------------------------------
     
     SELECT A.lodging_code, A.room_name, A.room_stock, 
           NVL(B.RESERVATION_CNT, 0) AS RESERVATION_CNT,
           CASE WHEN A.room_stock - NVL(B.RESERVATION_CNT, 0) >= 1 THEN '예약가능'
           ELSE '예약종료' END AS RESERVATION_STATE
     FROM 
     (
      SELECT L.lodging_code, D.room_name, D.room_stock
      FROM tbl_lodging L JOIN tbl_room_detail D
      ON L.lodging_code = D.fk_lodging_code 
     ) A
     LEFT JOIN
     (
      SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
      FROM tbl_room_detail D JOIN tbl_reservation RSV
      ON D.room_detail_code = RSV.fk_room_detail_code
      WHERE RSV.check_in BETWEEN '2024-07-08' AND '2024-07-09'
      GROUP BY D.fk_lodging_code, D.room_name
     ) B
     ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name;
    
    
    select count(*)
	    from tbl_lodging 
    
    SELECT distinct lodging_code, RESERVATION_STATE
    FROM 
    (
    SELECT A.lodging_code, A.room_name, A.room_stock, 
           NVL(B.RESERVATION_CNT, 0) AS RESERVATION_CNT,
           CASE WHEN A.room_stock - NVL(B.RESERVATION_CNT, 0) >= 1 THEN '예약가능'
           ELSE '예약종료' END AS RESERVATION_STATE
     FROM 
     (
      SELECT L.lodging_code, D.room_name, D.room_stock
      FROM tbl_lodging L JOIN tbl_room_detail D
      ON L.lodging_code = D.fk_lodging_code 
     ) A
     LEFT JOIN
     (
      SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
      FROM tbl_room_detail D JOIN tbl_reservation RSV
      ON D.room_detail_code = RSV.fk_room_detail_code
      WHERE RSV.check_in BETWEEN '2024-07-08' AND '2024-07-09'
      GROUP BY D.fk_lodging_code, D.room_name
     ) B
     ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name
    ) V
    WHERE V.RESERVATION_STATE = '예약가능'
    order by 1 asc;
    

   
    select convenient_name
    from tbl_convenient C join tbl_lodging_convenient LC
    on LC.fk_convenient_code = C.convenient_code
    join tbl_lodging L
    on L.lodging_code = LC.fk_lodging_code
    where lodging_code = 5219;
    
    select *
	    from tbl_lodging L
	    join
          (
          select fk_lodging_code
          from 
          tbl_lodging_convenient V
          join tbl_convenient N
          on V.fk_convenient_code = N.convenient_code
	      group by fk_lodging_code
          )T
          on L.lodging_code = T.fk_lodging_code
          join
          (
          	SELECT distinct lodging_code, RESERVATION_STATE
			FROM 
			(
			SELECT A.lodging_code, A.room_name, A.room_stock, max_person,
			       NVL(B.RESERVATION_CNT, 0) AS RESERVATION_CNT,
			       CASE WHEN A.room_stock - NVL(B.RESERVATION_CNT, 0) >= 1 THEN '예약가능'
			       ELSE '예약종료' END AS RESERVATION_STATE, 
                   A.room_stock-NVL(B.RESERVATION_CNT, 0) AS 잔여객실
			 FROM 
			 (
			  SELECT L.lodging_code, D.room_name, D.room_stock, max_person
			  FROM tbl_lodging L JOIN tbl_room_detail D
			  ON L.lodging_code = D.fk_lodging_code 
              where fk_companyid = 'kakao'
			 ) A
			 LEFT JOIN
			 (
			  SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
			  FROM tbl_room_detail D JOIN tbl_reservation RSV
			  ON D.room_detail_code = RSV.fk_room_detail_code
			  -- WHERE RSV.check_in <= '2024-07-11' AND RSV.check_out >= '2024-07-12'
			  GROUP BY D.fk_lodging_code, D.room_name
			 ) B
			 ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name
			) C
			WHERE C.RESERVATION_STATE = '예약가능' and max_person >= 5
          )D
          on L.lodging_code = D.lodging_code
	    where status = 1 
 
        
	select * from tbl_lodging;   
    select * from tbl_reservation;
    select * from tbl_room_detail;
   
   select reservation_code, reservation_price, check_in, check_out,
          leftdays, room_detail_code, room_name, check_intime, check_outtime,
          min_person, max_person, lodging_code, lodging_category, lodging_name, 
          lodging_tell, lodging_address
   from 
   (
   select reservation_code, fk_room_detail_code, reservation_price, check_in, check_out, 
          check_in - to_date(to_char(sysdate, 'yyyy-mm-dd') , 'yyyy-mm-dd')  as leftdays
   from tbl_reservation
   where reservation_code = 16    
   )RSV join 
   (
   select room_detail_code, fk_lodging_code, room_name, check_in as check_intime, check_out as check_outtime, min_person, max_person
   from tbl_room_detail
   where room_detail_code = 571
   )R
   on RSV.fk_room_detail_code = R.room_detail_code
   join
   (
   select lodging_code, lodging_category, lodging_name, lodging_tell, lodging_address 
   from tbl_lodging
   where lodging_code = 5201
    )L
    on R.fk_lodging_code = L.lodging_code
    
    select *
    from tbl_food_store
    
    select food_store_code, local_status, food_name, food_content, food_main_img
			from (
			    select food_store_code, local_status, food_name, food_content, food_main_img
			    from tbl_food_store
                where local_status = '제주시 시내'
			    order by DBMS_RANDOM.RANDOM
			)
            where rownum =1
            
    select play_code, local_status, play_name, play_content, play_main_img
			from (
			    select play_code, local_status, play_name, play_content, play_main_img
			    from tbl_play
                where local_status = '제주시 시내'
			    order by DBMS_RANDOM.RANDOM
			)
            where rownum =1        
            
            
     
     select * from tbl_review;
     
     select * from user_sequences;       
            
     select count(*) from tbl_review
     where parent_code = 5214;      
     
     select rno, review_code, fk_userid, user_name,
            parent_code, review_content, registerday
     from
     (
     select row_number() over(order by review_code desc) as rno, review_code, 
            fk_userid, user_name, parent_code, review_content, R.registerday
     from tbl_member M join tbl_review R
     on M.userid = R.fk_userid
     where R.parent_code = 5214
     )V
     where rno between 1 and 6;
     
     
     insert into tbl_review (review_code, fk_userid, parent_code, review_content, review_division_r) 
     values(SEQ_REVIEW.nextval, 'kudi03628', 5214, '저두 갔다왔는데 나름 괜찮았어여', 'A');
     
     insert into tbl_review (review_code, fk_userid, parent_code, review_content, review_division_r) 
     values(SEQ_REVIEW.nextval, 'kudi02', 5214, '으아아아아악', 'A');
     
     commit;       
     select * from tbl_lodging
     select * from tbl_play
     select * from tbl_food_store
     select * from tbl_reservation
     
     
    
     
     
     
     
     select count(*) as chk
     from tbl_reservation R
     join tbl_room_detail D
     on R.fk_room_detail_code = D.room_detail_code
     where status = 1 and fk_lodging_code = 5214 and fk_userid = 'kudi03628';
     
     
   CREATE TABLE tbl_like (
   fk_userid VARCHAR2(20) NOT NULL,         /* 아이디 */
   parent_code VARCHAR2(20) NOT NULL,       /* 부모일련번호 */
   like_division_R VARCHAR2(10)             /* 좋아요구분 A,B,C */
    ,constraint  PK_tbl_like_userid primary key(fk_userid,parent_code)    
    ,constraint  FK_tbl_like_userid foreign key(fk_userid) references tbl_member(userid) on delete cascade
);


    
    
    -- *** 캘린더 대분류(내캘린더, 사내캘린더  분류) ***
    create table tbl_calendar_large_category 
    (lgcatgono   number(3) not null      -- 캘린더 대분류 번호
    ,lgcatgoname varchar2(50) not null   -- 캘린더 대분류 명
    ,constraint PK_tbl_calendar_large_category primary key(lgcatgono)
    );
    -- Table TBL_CALENDAR_LARGE_CATEGORY이(가) 생성되었습니다.
    
    insert into tbl_calendar_large_category(lgcatgono, lgcatgoname)
    values(1, '나의 일정');
    
    insert into tbl_calendar_large_category(lgcatgono, lgcatgoname)
    values(2, '공유받은 일정');
    
    -- *** 캘린더 소분류 *** 
    -- (예: 내캘린더중 점심약속, 내캘린더중 저녁약속, 내캘린더중 운동, 내캘린더중 휴가, 내캘린더중 여행, 내캘린더중 출장 등등) 
    -- (예: 사내캘린더중 플젝주제선정, 사내캘린더중 플젝요구사항, 사내캘린더중 DB모델링, 사내캘린더중 플젝코딩, 사내캘린더중 PPT작성, 사내캘린더중 플젝발표 등등) 
    create table tbl_calendar_small_category 
    (smcatgono    number(8) not null      -- 캘린더 소분류 번호
    ,fk_lgcatgono number(3) not null      -- 캘린더 대분류 번호
    ,smcatgoname  varchar2(400) not null  -- 캘린더 소분류 명
    -- ,fk_userid    varchar2(40) not null   -- 캘린더 소분류 작성자 유저아이디
    ,constraint PK_tbl_calendar_small_category primary key(smcatgono)
    ,constraint FK_small_category_fk_lgcatgono foreign key(fk_lgcatgono) 
                references tbl_calendar_large_category(lgcatgono) on delete cascade
    ,constraint FK_small_category_fk_userid foreign key(fk_userid) references tbl_member(userid)            
    );
    -- Table TBL_CALENDAR_SMALL_CATEGORY이(가) 생성되었습니다.
    
    alter table tbl_calendar_small_category drop column fk_userid;
    alter table tbl_calendar_small_category drop constraint FK_small_category_fk_userid;
    
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 1 , '숙소');
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 1 , '맛집');
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 1 , '즐길거리');
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 1 , '기타');
    
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 2 , '숙소');
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 2 , '맛집');
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 2 , '즐길거리');
    insert into tbl_calendar_small_category (smcatgono, fk_lgcatgono, smcatgoname) values (seq_smcatgono.nextval, 2 , '기타');
    commit;
    
    select * from tbl_calendar_small_category
    
    create sequence seq_smcatgono
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    -- Sequence SEQ_SMCATGONO이(가) 생성되었습니다.
    
    
    select *
    from tbl_calendar_small_category
    order by smcatgono desc;
    
    
    
    
    -- *** 캘린더 일정 *** 
    create table tbl_calendar_schedule 
    (scheduleno    number                 -- 일정관리 번호
    ,startdate     date                   -- 시작일자
    ,enddate       date                   -- 종료일자
    ,subject       varchar2(400)          -- 제목
    ,color         varchar2(50)           -- 색상
    ,place         varchar2(200)          -- 장소
    ,joinuser      varchar2(4000)         -- 공유자   
    ,content       varchar2(4000)         -- 내용
    ,parent_code   varchar2(20)           -- 부모코드(숙소,맛집,즐길거리)
    ,schedule_divison varchar2(10)        -- A == 숙소, B == 맛집, C==즐길거리
    ,fk_smcatgono  number(8)              -- 캘린더 소분류 번호
    ,fk_lgcatgono  number(3)              -- 캘린더 대분류 번호
    ,fk_userid     varchar2(40) not null  -- 캘린더 일정 작성자 유저아이디
    ,constraint PK_schedule_scheduleno primary key(scheduleno)
    ,constraint FK_schedule_fk_smcatgono foreign key(fk_smcatgono) 
                references tbl_calendar_small_category(smcatgono) on delete cascade
    ,constraint FK_schedule_fk_lgcatgono foreign key(fk_lgcatgono) 
                references tbl_calendar_large_category(lgcatgono) on delete cascade   
    ,constraint FK_schedule_fk_userid foreign key(fk_userid) references tbl_member(userid) 
    );
    -- Table TBL_CALENDAR_SCHEDULE이(가) 생성되었습니다.
    
    drop table tbl_calendar_schedule;
    
    alter table tbl_calendar_schedule drop constraint FK_schedule_fk_smcatgono;
    
    
    create sequence seq_scheduleno
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    -- Sequence SEQ_SCHEDULENO이(가) 생성되었습니다.
    
    select *
    from tbl_calendar_schedule 
    order by scheduleno desc;
    
    
    -- 일정 상세 보기 (<< 이건 예시테이블임 조회가 안됨)
    select SD.scheduleno
         , to_char(SD.startdate,'yyyy-mm-dd hh24:mi') as startdate
         , to_char(SD.enddate,'yyyy-mm-dd hh24:mi') as enddate  
         , SD.subject
         , SD.color
         , nvl(SD.place,'-') as place
         , nvl(SD.joinuser,'공유자가 없습니다.') as joinuser
         , nvl(SD.content,'') as content
         , SD.fk_smcatgono
         , SD.fk_lgcatgono
         , SD.fk_userid
         , M.name
         , SC.smcatgoname
    from tbl_calendar_schedule SD 
    JOIN tbl_member M
    ON SD.fk_userid = M.userid
    JOIN tbl_calendar_small_category SC
    ON SD.fk_smcatgono = SC.smcatgono
    where SD.scheduleno = 21;
    
    
    insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday, coin, point, registerday, lastpwdchangedate, status, idle, gradelevel)  
    values('leesunsin', '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', '이순신', '2IjrnBPpI++CfWQ7CQhjIw==', 'fCQoIgca24/q72dIoEVMzw==', '15864', '경기 군포시 오금로 15-17', '101동 202호', ' (금정동)', '1', '1995-10-04', 0, 0, default, default, default, default, default);
    -- 1 행 이(가) 삽입되었습니다.
    
    commit;
    
    select *
    from tbl_member
    where name = '이순신';

    ------------- >>>>>>>> 일정관리(풀캘린더) 끝 <<<<<<<< -------------
    
    select * from tbl_lodging;
    select to_date('2024-07-18 11:00:00', 'yyyy-mm-dd hh24:mi:ss')
    from dual
    
    select * from tbl_company
    
    select * from tbl_like where parent_code = 5214;
    
   select * from tbl_member;
    
    
    select * from tbl_room_detail;
    
    
    select * from tbl_calendar_schedule;
    
    insert into tbl_calendar_schedule(scheduleno, startdate, enddate, subject, color, place, content, fk_smcatgono, fk_lgcatgono, fk_userid ,schedule_divison ,parent_code) 
    					   values(seq_scheduleno.nextval, to_date(#{check_in}, 'yyyy-mm-dd hh24:mi:ss'), to_date(#{check_out}, 'yyyy-mm-dd hh24:mi:ss'), 
    					   		  #{lodging_name}, '', #{lodging_address}, #{room_name}, 1, 1, #{userid} , 'A',#{lodging_code} )  



    create table tbl_chattinglog(
    to_id VARCHAR2(20) NOT NULL, /* 말거는사람 */
	from_id VARCHAR2(20) NOT NULL, /* 받는사람 */
	status NUMBER default 0 /* 채팅읽은상태 0이면 안읽음 1이면 읽음 */
    );
    
    select * from tbl_lodging where lodging_code = 5404;
    
    select * 
    from tbl_room_detail 
    order by room_detail_code desc;
    where fk_lodging_code = 5338
    
    select * from tbl_reservation;
    alter table tbl_reservation add mailSendCheck number(1) default 0;
    -- Table TBL_RESERVATION이(가) 변경되었습니다.
    
    SELECT R.reservation_code, M.userid, M.user_name, M.email,
       		   to_char(R.check_in, 'yyyy-mm-dd hh24:mi') AS check_in
		FROM tbl_member M JOIN (select * from tbl_reservation 
        where mailsendcheck = 0 and status = 1 and
              reservation_date > check_in - (interval '5' hour) and 
              to_char(check_in,'yyyymmdd') = to_char(sysdate+1,'yyyymmdd') ) R 
		ON M.userid = R.fk_userid
    
    select *
    from tbl_board;
    select *
    from tbl_chattinglog
    
    select *
    from tbl_reservation;
    
    alter table tbl_chattinglog add fk_reservation_code varchar2(20) default 0;
    alter table tbl_chattinglog add chatting_date date default sysdate;
    
    
    alter table tbl_chattinglog ADD CONSTRAINT FK_TBL_chatting_reservation FOREIGN KEY (fk_reservation_code)
REFERENCES tbl_reservation (reservation_code) ON DELETE CASCADE;


    create sequence seq_festival
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;

    -- 축제행사 테이블
    create table tbl_festival 
    (festival_no   number                 -- 축제 일련번호
    ,title_name    varchar2(200)          -- 종료일자
    ,img           varchar2(100)          -- 파일명
    ,startdate     date                   -- 시작일자
    ,enddate       date                   -- 종료일자
    ,local_status  varchar2(100)          -- 지역구분   
    ,link          varchar2(500)          -- 상세링크주소
    );
    
 
    select * from tbl_festival;
   update tbl_festival set title_name = '9.81파크 (하늘 나는 피카츄 프로젝트)', img = '9.81파크 (하늘 나는 피카츄 프로젝트).jpg' where festival_no = 60;
   
   UPDATE tbl_festival
    SET enddate = enddate + INTERVAL '1' YEAR
    WHERE to_char(enddate, 'yyyy') = '2023';
   
   commit;
   
   select festival_no, title_name, img, startdate, enddate, local_status, link 
   from 
   (
   select festival_no, title_name, img, startdate, enddate, local_status, link 
   from tbl_festival
   where startdate <= sysdate and enddate >= sysdate
   )
   where rownum <= 6
   select *
   from tbl_like
   
   select parent_code
   from tbl_like L  join tbl_play P
   on L.parent_code = P.play_code
    join tbl_lodging G
   on L.parent_code = G.lodging_code;
   
   
   select W.parent_code, W.like_division_R , nvl(V.name , Q.name ) as vvname 
   from tbl_like W left join
   (
   select parent_code, like_division_R, play_name as name
   from tbl_like L  join tbl_play P
   on L.parent_code = P.play_code
   )V
   on W.parent_code = V.parent_code
    left join
   (
   select parent_code, like_division_R, lodging_name as name
   from tbl_like L
   join tbl_lodging G
   on L.parent_code = G.lodging_code
   )Q
   on W.parent_code = Q.parent_code
   
   select *
   from
   (
   select * 
   from tbl_board
   where regdate >= sysdate-3
   order by readcount desc
   )
   where rownum <=7;
   
   
   CREATE TABLE tbl_faq (
	faq_seq VARCHAR2(20), /* FAQ글번호 */
	faq_category VARCHAR2(50), /* 카테고리 */
	faq_question VARCHAR2(200), /* 질문 */
	faq_answer VARCHAR2(500), /* 내용 */
    constraint  CK_tbl_faq_category check( faq_category in('예약','카드/결제','숙소','맛집','즐길거리', '기타') )
    );

COMMENT ON TABLE tbl_faq IS '고객센터FAQ 테이블';

COMMENT ON COLUMN tbl_faq.faq_seq IS 'FAQ글번호';

COMMENT ON COLUMN tbl_faq.faq_category IS '카테고리';

COMMENT ON COLUMN tbl_faq.faq_question IS '질문';

COMMENT ON COLUMN tbl_faq.faq_answer IS '내용';


/* 숙소 테이블 코멘트 */

COMMENT ON TABLE tbl_lodging IS '숙소 테이블';
COMMENT ON COLUMN tbl_lodging.lodging_code IS 'PK숙소일련번호';
COMMENT ON COLUMN tbl_lodging.fk_companyid IS 'FK업체아이디';
COMMENT ON COLUMN tbl_lodging.local_status IS '공용지역구분';
COMMENT ON COLUMN tbl_lodging.lodging_category IS '숙소카테고리명칭';
COMMENT ON COLUMN tbl_lodging.lodging_name IS '숙소이름';
COMMENT ON COLUMN tbl_lodging.lodging_tell IS '숙소연락처';
COMMENT ON COLUMN tbl_lodging.lodging_content IS '숙소설명';
COMMENT ON COLUMN tbl_lodging.lodging_address IS '상세주소';
COMMENT ON COLUMN tbl_lodging.main_img IS '초기대표이미지(크롤링)';
COMMENT ON COLUMN tbl_lodging.REVIEW_DIVISION IS '리뷰용구분컬럼(default) A';
COMMENT ON COLUMN tbl_lodging.filename IS '업로드된파일명';
COMMENT ON COLUMN tbl_lodging.orgfilename IS '원래파일명';
COMMENT ON COLUMN tbl_lodging.filesize IS '파일크기';
COMMENT ON COLUMN tbl_lodging.STATUS IS '숙소등록상태';
COMMENT ON COLUMN tbl_lodging.FEEDBACK_MSG IS '숙소등록시 반려메시지';


/* 맛집 테이블 코멘트 */

COMMENT ON TABLE tbl_food_store IS '맛집 테이블';
COMMENT ON COLUMN tbl_food_store.food_store_code IS 'PK맛집일련번호';
COMMENT ON COLUMN tbl_food_store.local_status IS '공용지역구분';
COMMENT ON COLUMN tbl_food_store.food_category IS '맛집카테고리명침';
COMMENT ON COLUMN tbl_food_store.food_name IS '맛집식당이름';
COMMENT ON COLUMN tbl_food_store.food_content IS '맛집간단정보';
COMMENT ON COLUMN tbl_food_store.food_businesshours IS '맛집영업시간';
COMMENT ON COLUMN tbl_food_store.food_address IS '상세주소';
COMMENT ON COLUMN tbl_food_store.food_mobile IS '맛집연락처';
COMMENT ON COLUMN tbl_food_store.food_main_img IS '대표이미지';
COMMENT ON COLUMN tbl_food_store.REVIEW_DIVISION IS '공용테이블구분컬럼(default) B';
COMMENT ON COLUMN tbl_food_store.filename IS '업로드된파일명';
COMMENT ON COLUMN tbl_food_store.orgfilename IS '원래파일명';
COMMENT ON COLUMN tbl_food_store.filesize IS '파일크기';
COMMENT ON COLUMN tbl_food_store.READCOUNT IS '조회수';

/* 즐길거리 테이블 코멘트 */

COMMENT ON TABLE tbl_play IS '즐길거리 테이블';
COMMENT ON COLUMN tbl_play.play_code IS 'PK즐길거리일련번호';
COMMENT ON COLUMN tbl_play.local_status IS '공용지역구분';
COMMENT ON COLUMN tbl_play.play_category IS '즐길거리카테고리';
COMMENT ON COLUMN tbl_play.play_name IS '즐길거리명칭';
COMMENT ON COLUMN tbl_play.play_content IS '즐길거리상세정보';
COMMENT ON COLUMN tbl_play.play_mobile IS '즐길거리연락처';
COMMENT ON COLUMN tbl_play.play_businesshours IS '즐길거리운영시간';
COMMENT ON COLUMN tbl_play.play_address IS '상세주소';
COMMENT ON COLUMN tbl_play.play_main_img IS '대표이미지';
COMMENT ON COLUMN tbl_play.review_division IS '공용테이블구분컬럼(default) C';
COMMENT ON COLUMN tbl_play.readCount IS '조회수';
COMMENT ON COLUMN tbl_play.filename IS '업로드된파일명';
COMMENT ON COLUMN tbl_play.orgfilename IS '원래파일명';
COMMENT ON COLUMN tbl_play.filesize IS '파일크기';

/* 숙소객실 테이블 코멘트 */

COMMENT ON TABLE tbl_room_detail IS '객실 테이블';
COMMENT ON COLUMN tbl_room_detail.room_detail_code IS 'PK객실일련번호';
COMMENT ON COLUMN tbl_room_detail.fk_lodging_code IS 'FK숙소일련번호';
COMMENT ON COLUMN tbl_room_detail.room_name IS '객실이름';
COMMENT ON COLUMN tbl_room_detail.price IS '객실가격';
COMMENT ON COLUMN tbl_room_detail.check_in IS '체크인시간';
COMMENT ON COLUMN tbl_room_detail.check_out IS '체크아웃시간';
COMMENT ON COLUMN tbl_room_detail.room_stock IS '객실수량';
COMMENT ON COLUMN tbl_room_detail.min_person IS '기존인원';
COMMENT ON COLUMN tbl_room_detail.max_person IS '최대인원';
COMMENT ON COLUMN tbl_room_detail.room_img IS '초기객실이미지(크롤링)';
COMMENT ON COLUMN tbl_room_detail.filename IS '업로드된파일명';
COMMENT ON COLUMN tbl_room_detail.orgfilename IS '원래파일명';
COMMENT ON COLUMN tbl_room_detail.filesize IS '파일크기';

/* 예약 테이블 코멘트 */

COMMENT ON TABLE tbl_reservation IS '숙소예약 테이블';
COMMENT ON COLUMN tbl_reservation.reservation_code IS 'PK예약일련번호';
COMMENT ON COLUMN tbl_reservation.fk_userid IS 'FK유저아이디';
COMMENT ON COLUMN tbl_reservation.fk_room_detail_code IS 'FK숙소객실일련번호';
COMMENT ON COLUMN tbl_reservation.reservation_date IS '예약일자';
COMMENT ON COLUMN tbl_reservation.check_in IS '체크인일자';
COMMENT ON COLUMN tbl_reservation.check_out IS '체크아웃일자';
COMMENT ON COLUMN tbl_reservation.RESERVATION_PRICE IS '예약가격';
COMMENT ON COLUMN tbl_reservation.status IS '예약상태';
COMMENT ON COLUMN tbl_reservation.mailSendCheck IS '체크인전 자동 이메일발송체크';

/* 업체 테이블 */

COMMENT ON TABLE tbl_company IS '업체 테이블';
COMMENT ON COLUMN tbl_company.companyid IS 'PK업체아이디';
COMMENT ON COLUMN tbl_company.company_name IS '업체명';
COMMENT ON COLUMN tbl_company.pw IS '비밀번호';
COMMENT ON COLUMN tbl_company.email IS '이메일';
COMMENT ON COLUMN tbl_company.mobile IS '연락처';
COMMENT ON COLUMN tbl_company.registerday IS '가입일자';
COMMENT ON COLUMN tbl_company.lastpwdchangedate IS '마지막암호변경일자';
COMMENT ON COLUMN tbl_company.status IS '회원탈퇴유무';
COMMENT ON COLUMN tbl_company.idle IS '휴면유무';

/* 편의시설 테이블 코멘트 */

COMMENT ON TABLE tbl_convenient IS '편의시설 테이블';
COMMENT ON COLUMN tbl_convenient.convenient_code IS 'PK편의시설일련번호';
COMMENT ON COLUMN tbl_convenient.convenient_name IS '편의시설명칭';

/* 숙소별 편의시설 테이블 */

COMMENT ON TABLE tbl_lodging_convenient  IS '숙소별 편의시설 테이블';
COMMENT ON COLUMN tbl_lodging_convenient.fk_convenient_code IS 'PK,FK편의시설일련번호';
COMMENT ON COLUMN tbl_lodging_convenient.fk_lodging_code IS 'PK,FK숙소일련번호';

/* 회원 테이블 코멘트 */

COMMENT ON TABLE tbl_member IS '회원 테이블';
COMMENT ON COLUMN tbl_member.userid IS 'PK유저아이디';
COMMENT ON COLUMN tbl_member.email IS 'UK이메일';
COMMENT ON COLUMN tbl_member.pw IS '비밀번호';
COMMENT ON COLUMN tbl_member.user_name IS '성명';
COMMENT ON COLUMN tbl_member.mobile IS 'UK휴대폰번호';
COMMENT ON COLUMN tbl_member.address IS '주소';
COMMENT ON COLUMN tbl_member.detail_address IS '상세주소';
COMMENT ON COLUMN tbl_member.birthday IS '생년월일';
COMMENT ON COLUMN tbl_member.gender IS '성별';
COMMENT ON COLUMN tbl_member.registerday IS '가입일자';
COMMENT ON COLUMN tbl_member.lastpwdchangedate IS '마지막암호변경일자';
COMMENT ON COLUMN tbl_member.status IS '회원탈퇴유무';
COMMENT ON COLUMN tbl_member.idle IS '휴면유무';
COMMENT ON COLUMN tbl_member.userimg IS '유저이미지';


/* 리뷰테이블 코멘트 */

COMMENT ON TABLE tbl_review IS '리뷰테이블';
COMMENT ON COLUMN tbl_review.review_code IS 'PK리뷰일련번호';
COMMENT ON COLUMN tbl_review.fk_userid IS 'FK유저아이디';
COMMENT ON COLUMN tbl_review.parent_code IS '공용부모일련번호';
COMMENT ON COLUMN tbl_review.review_content IS '리뷰내용';
COMMENT ON COLUMN tbl_review.registerday IS '리뷰작성일자';
COMMENT ON COLUMN tbl_review.review_division_R IS '리뷰구분A,B,C';

/* 맛집추가이미지 테이블 코멘트 */

COMMENT ON TABLE tbl_food_add_img IS '맛집추가이미지 테이블';
COMMENT ON COLUMN tbl_food_add_img.food_add_code IS 'PK맛집추가이미지일련번호';
COMMENT ON COLUMN tbl_food_add_img.fk_food_store_code IS 'FK맛집일련번호';
COMMENT ON COLUMN tbl_food_add_img.food_add_img IS '맛집추가이미지파일';


/* 업체로그인기록 테이블 코멘트 */

COMMENT ON TABLE tbl_company_loginhistory IS '업체로그인기록 테이블' ;
COMMENT ON COLUMN tbl_company_loginhistory.fk_companyid IS 'FK업체아이디';
COMMENT ON COLUMN tbl_company_loginhistory.logindate IS '로그인시각';
COMMENT ON COLUMN tbl_company_loginhistory.clientip IS '접속ip주소';

/* 회원로그인기록 테이블 코멘트 */

COMMENT ON TABLE tbl_member_loginhistory IS '회원로그인기록 테이블';
COMMENT ON COLUMN tbl_member_loginhistory.fk_userid IS 'FK유저아이디';
COMMENT ON COLUMN tbl_member_loginhistory.logindate IS '로그인시각';
COMMENT ON COLUMN tbl_member_loginhistory.clientip IS '접속ip주소';

/* 게시판 테이블 코멘트 */

COMMENT ON TABLE tbl_board IS '게시판 테이블';
COMMENT ON COLUMN tbl_board.seq IS 'PK,SQ글번호';
COMMENT ON COLUMN tbl_board.fk_userid IS 'FK유저아이디';
COMMENT ON COLUMN tbl_board.name IS '글쓴이';
COMMENT ON COLUMN tbl_board.subject IS '글제목';
COMMENT ON COLUMN tbl_board.content IS '글내용';
COMMENT ON COLUMN tbl_board.pw IS '글암호';
COMMENT ON COLUMN tbl_board.readCount IS '조회수';
COMMENT ON COLUMN tbl_board.regDate IS '글작성일자';
COMMENT ON COLUMN tbl_board.status IS '글삭제여부';
COMMENT ON COLUMN tbl_board.commentCount IS '댓글개수';
COMMENT ON COLUMN tbl_board.filename IS '업로드된파일명';
COMMENT ON COLUMN tbl_board.orgfilename IS '원래파일명';
COMMENT ON COLUMN tbl_board.filesize IS '파일크기';
COMMENT ON COLUMN tbl_board.category IS '글분야';

/* 좋아요 테이블 코멘트 */

COMMENT ON TABLE tbl_like IS '좋아요 테이블';
COMMENT ON COLUMN tbl_like.fk_userid IS 'PK,FK유저아이디';
COMMENT ON COLUMN tbl_like.parent_code IS 'PK공용부모일련번호';
COMMENT ON COLUMN tbl_like.like_division_R IS '좋아요구분 A(숙소),B(맛집),C(즐길거리)';

/* 일정대분류카테고리 테이블 코멘트 */

COMMENT ON TABLE tbl_calendar_large_category IS '일정대분류카테고리 테이블';
COMMENT ON COLUMN tbl_calendar_large_category.lgcatgono IS 'PK대분류일련번호';
COMMENT ON COLUMN tbl_calendar_large_category.lgcatgoname IS '대분류명';

/* 일정소분류카테고리 테이블 코멘트 */

COMMENT ON TABLE tbl_calendar_small_category IS '일정소분류카테고리 테이블';
COMMENT ON COLUMN tbl_calendar_small_category.smcatgono IS 'PK소분류일련번호';
COMMENT ON COLUMN tbl_calendar_small_category.fk_lgcatgono IS 'FK대분류일련번호';
COMMENT ON COLUMN tbl_calendar_small_category.smcatgoname IS '소분류명';

/* 여행일정 테이블 코멘트 */

COMMENT ON TABLE tbl_calendar_schedule IS '여행일정 테이블';
COMMENT ON COLUMN tbl_calendar_schedule.scheduleno IS 'PK,SQ일정관리일련번호';
COMMENT ON COLUMN tbl_calendar_schedule.startdate IS '일정시작일자';
COMMENT ON COLUMN tbl_calendar_schedule.enddate IS '일정종료일자';
COMMENT ON COLUMN tbl_calendar_schedule.subject IS '일정제목';
COMMENT ON COLUMN tbl_calendar_schedule.color IS '일정색상';
COMMENT ON COLUMN tbl_calendar_schedule.place IS '일정장소';
COMMENT ON COLUMN tbl_calendar_schedule.joinuser IS '일정공유자';
COMMENT ON COLUMN tbl_calendar_schedule.content IS '일정내용';
COMMENT ON COLUMN tbl_calendar_schedule.parent_code IS '공용부모일련번호';
COMMENT ON COLUMN tbl_calendar_schedule.schedule_divison IS '일정구분';
COMMENT ON COLUMN tbl_calendar_schedule.fk_userid IS 'FK유저아이디';
COMMENT ON COLUMN tbl_calendar_schedule.fk_lgcatgono IS 'FK대분류일련번호';
COMMENT ON COLUMN tbl_calendar_schedule.fk_smcatgono IS 'FK소분류일련번호';

/* 채팅로그테이블 코멘트*/

COMMENT ON TABLE tbl_chattinglog IS '채팅로그 테이블';
COMMENT ON COLUMN tbl_chattinglog.to_id IS '발신인';
COMMENT ON COLUMN tbl_chattinglog.from_id IS '수신인';
COMMENT ON COLUMN tbl_chattinglog.status IS '읽은상태';
COMMENT ON COLUMN tbl_chattinglog.fk_reservation_code IS 'FK예약일련번호';
COMMENT ON COLUMN tbl_chattinglog.CHATTING_DATE IS '채팅발신일자';

/* 축제와 행사 테이블 코멘트*/

COMMENT ON TABLE TBL_FESTIVAL IS '축제와 행사 테이블';
COMMENT ON COLUMN TBL_FESTIVAL.FESTIVAL_NO IS '축제행사 일련번호(PK)';
COMMENT ON COLUMN TBL_FESTIVAL.LOCAL_STATUS IS '지역구분';
COMMENT ON COLUMN TBL_FESTIVAL.TITLE_NAME IS '축제행사명칭';
COMMENT ON COLUMN TBL_FESTIVAL.STARTDATE IS '축제시작일자';
COMMENT ON COLUMN TBL_FESTIVAL.ENDDATE IS '축제종료일자';
COMMENT ON COLUMN TBL_FESTIVAL.IMG IS '이미지파일명(업로드시 나노타임적용)';
COMMENT ON COLUMN TBL_FESTIVAL.ORG_IMG IS '원래파일이미지명';
COMMENT ON COLUMN TBL_FESTIVAL.LINK IS '해당축제에 대한 관광공사 상세페이지 링크';

/* 게시판 댓글 테이블 코멘트*/

COMMENT ON TABLE TBL_COMMENT IS '게시판 댓글 테이블';
COMMENT ON COLUMN TBL_COMMENT.SEQ IS '댓글번호(PK)';
COMMENT ON COLUMN TBL_COMMENT.FK_USERID IS '작성유저아이디(FK)';
COMMENT ON COLUMN TBL_COMMENT.NAME IS '댓글 글쓴이';
COMMENT ON COLUMN TBL_COMMENT.CONTENT IS '댓글 내용';
COMMENT ON COLUMN TBL_COMMENT.REGDATE IS '댓글 작성일자';
COMMENT ON COLUMN TBL_COMMENT.PARENTSEQ IS '원게시판글번호';
COMMENT ON COLUMN TBL_COMMENT.STATUS IS '댓글삭제여부';
COMMENT ON COLUMN TBL_COMMENT.GROUPNO IS '댓글그룹번호';
COMMENT ON COLUMN TBL_COMMENT.FK_SEQ IS '원댓글번호';
COMMENT ON COLUMN TBL_COMMENT.DEPTHNO IS '0이면 원댓글, 1이상이면 대댓글';

desc tbl_board;

SELECT *
  FROM USER_COL_COMMENTS
  where comments is null
  order by 1 desc;  

SELECT * FROM COLS WHERE TABLE_NAME LIKE 'TBL_COMMENT';

select *
from TBL_COMMENT
drop table TBL_LOCAL purge;

-- 숙소명 리뷰내용 예약체크인일자 리뷰작성일자 작성아이디 숙소번호
select *
from tbl_review;

    select *
    from tbl_lodging;
    
    select * 
    from tbl_room_detail;
    update tbl_reservation set status = 1 where reservation_code = 32;
    commit;
    
    
    SELECT A.lodging_code, A.room_detail_code, A.room_name, A.price,
               A.room_stock - NVL(B.RESERVATION_CNT, 0) AS remaining_qty,
               A.min_person, A.max_person, A.room_img ,check_intime , check_outtime
			 FROM 
			 (
			  SELECT L.lodging_code, D.room_name, D.room_stock, min_person, max_person, 
                     price, room_detail_code, room_img, check_in as check_intime, check_out as check_outtime   
			  FROM tbl_lodging L JOIN tbl_room_detail D
			  ON L.lodging_code = D.fk_lodging_code 
              where lodging_code = 5217
              ) A
			 LEFT JOIN
			 (
			  SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
			  FROM tbl_room_detail D JOIN tbl_reservation RSV
			  ON D.room_detail_code = RSV.fk_room_detail_code
			  WHERE RSV.status = 1 and 
			  (RSV.check_in <= '2024-07-28' AND RSV.check_out >= '2024-07-30')
			  GROUP BY D.fk_lodging_code, D.room_name
			 ) B
			 ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name
			 where max_person >= 2
    
    
    SELECT A.lodging_code, A.room_detail_code, A.room_name, A.price,
       A.room_stock - NVL(B.RESERVATION_CNT, 0) AS remaining_qty,
       A.min_person, A.max_person, A.room_img, A.check_intime, A.check_outtime
FROM (
    SELECT L.lodging_code, D.room_name, D.room_stock, min_person, max_person,
           price, room_detail_code, room_img, check_in AS check_intime, check_out AS check_outtime
    FROM tbl_lodging L
    JOIN tbl_room_detail D ON L.lodging_code = D.fk_lodging_code
    WHERE L.lodging_code = 5217
) A
LEFT JOIN (
    SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT
    FROM tbl_room_detail D
    JOIN tbl_reservation RSV ON D.room_detail_code = RSV.fk_room_detail_code
    WHERE RSV.status = 1
    AND (
        (RSV.check_in <= '2024-07-30' AND RSV.check_out >= '2024-07-28') -- 전체 기간이 겹치는 경우
        OR (RSV.check_in <= '2024-07-28' AND RSV.check_out >= '2024-07-28') -- 시작일이 겹치는 경우
        OR (RSV.check_in <= '2024-07-30' AND RSV.check_out >= '2024-07-30') -- 종료일이 겹치는 경우
    )
    GROUP BY D.fk_lodging_code, D.room_name
) B ON A.lodging_code = B.fk_lodging_code AND A.room_name = B.room_name
WHERE A.max_person >= 2
    
    select *
    from tbl_reservation;
    select *
    from user_sequences
    insert into tbl_reservation (reservation_code, fk_userid, fk_room_detail_code, check_in, check_out, reservation_price, status) 
    values (SEQ_RESERVE.nextval, 'kudi02', 660, '2024-07-29', '2024-07-30' , 5, 1);
    
    select to_char(check_in, 'yyyy-mm-dd hh24:mi:ss') as c
    from tbl_reservation;
    
    select *
    from tbl_room_detail
    

    select R.check_in, L.lodging_name, D.room_name,  L.lodging_address,
           L.lodging_category, L.lodging_tell, D.room_img , R.status,
           R.check_in , R.check_out, R.reservation_price, R.reservation_date,
           D.check_in as check_intime , D.check_out as check_outtime
    from tbl_reservation R
    join tbl_room_detail D
    on R.fk_room_detail_code = D.room_detail_code
    join tbl_lodging L
    on D.fk_lodging_code = L.lodging_code
    where R.reservation_code = '27';


    select rno,  LODGING_NAME, LODGING_ADDRESS, LODGING_CODE, LOCAL_STATUS,
		   	 LODGING_CATEGORY, MAIN_IMG, REVIEW_DIVISION, price
	  from
	  (
		  select ROWNUM as rno,  LODGING_NAME, LODGING_ADDRESS, LODGING_CODE, LOCAL_STATUS,
		   		 LODGING_CATEGORY, MAIN_IMG, REVIEW_DIVISION, price
		  from
		  (
		  	select L.LODGING_NAME, L.LODGING_ADDRESS, L.LODGING_CODE, L.LOCAL_STATUS,
	                 L.LODGING_CATEGORY, L.MAIN_IMG, L.REVIEW_DIVISION , P.price
	          from tbl_lodging L join 
	          (
	          select fk_lodging_code , min(price) as price
	          from tbl_room_detail
	          group by fk_lodging_code
              having min(price) between 150000 and 200000
	          )P
	          on L.lodging_code = P.fk_lodging_code
	          join
	          (
	          select fk_lodging_code
	          from 
	          tbl_lodging_convenient V
	          join tbl_convenient F
	          on V.fk_convenient_code = F.convenient_code
	          group by fk_lodging_code
	          )E
	          on L.lodging_code = E.fk_lodging_code
	          join
	          (
	          	SELECT distinct lodging_code, RESERVATION_STATE
				FROM 
				(
				SELECT A.lodging_code, A.room_name, A.room_stock, max_person,
				       NVL(B.RESERVATION_CNT, 0) AS RESERVATION_CNT,
				       CASE WHEN A.room_stock - NVL(B.RESERVATION_CNT, 0) >= 1 THEN '예약가능'
				       ELSE '예약종료' END AS RESERVATION_STATE
				 FROM 
				 (
				  SELECT L.lodging_code, D.room_name, D.room_stock, max_person, price
				  FROM tbl_lodging L JOIN tbl_room_detail D
				  ON L.lodging_code = D.fk_lodging_code
				  group by L.lodging_code, D.room_name, D.room_stock, max_person, price
	              
				  
				 ) A
				 LEFT JOIN
				 (
				  SELECT D.fk_lodging_code, D.room_name, COUNT(*) AS RESERVATION_CNT 
				  FROM tbl_room_detail D JOIN tbl_reservation RSV
				  ON D.room_detail_code = RSV.fk_room_detail_code
				  WHERE (RSV.check_in < '2024-07-31' AND RSV.check_out > '2024-07-30')
				  and RSV.status = 1
				  GROUP BY D.fk_lodging_code, D.room_name
				 ) B
				 ON A.lodging_code || A.room_name = B.fk_lodging_code || B.room_name
				) C
				WHERE C.RESERVATION_STATE = '예약가능'
	          )D
	          on L.lodging_code = D.lodging_code
	          where status = 1 
		   )W
	   )Q
	   
    select *
    from tbl_board;
    
    select *
    from tbl_calendar_schedule;
    select *
    from tbl_food_store;
    select *
    from tbl_company;

    desc tbl_festival;
    
    select *
    from tbl_room_detail
    where fk_lodging_code = 5161
    
    
    update tbl_room_detail set room_name = '주니어 스위트 트윈+이디 조식 2인' ,room_img = '5161_주니어 스위트 트윈+이디 조식 2인.jpg'
    where room_detail_code = 386
    
    update tbl_room_detail set room_name = '클래식 스위트 트윈+이디 조식 2인' ,room_img = '5161_주니어 스위트 트윈+이디 조식 2인.jpg'
    where room_detail_code = 387
    
    
    
    select *
    from tbl_review
    where parent_code in (select lodging_code from tbl_lodging where fk_companyid = 'jejuceo');
    
    select *
    from tbl_lodging
    where fk_companyid = 'jejuceo';
    
    select *
    from tbl_lodging
    where status =0;
    
    delete from tbl_lodging where lodging_code = 5574;
    
    
    select * from tbl_festival where title_name = 'JEMI FESTA "JEMI LAND"';
    
    update tbl_festival set title_name = 'JEMI FESTA (JEMI LAND)' , img = 'JEMI FESTA (JEMI LAND).jpg'
    where festival_no = 44
    
    commit;
    
    select rno, festival_no, title_name, img, startdate, enddate, local_status, link, recentdate
    from
    (
    select rownum as rno, festival_no, title_name, img, startdate,enddate, local_status, link,recentdate
    from 
        (
        select festival_no, title_name, img, to_char(startdate, 'yyyy-mm-dd') as startdate,
                to_char(enddate, 'yyyy-mm-dd') as enddate, local_status, link, abs(round(sysdate - startdate)) as recentdate
        from tbl_festival
        
        order by recentdate asc
        )V
    )Q
    where Q.rno between 1 and 10
 
    
    desc tbl_comment;
    
    select *
    from user_constraints
    where TABLE_NAME = 'TBL_COMMENT';
    
    select *
    from tbl_comment;
    
    commit;
    
    select *
    from tbl_lodging;
    
    
    select *
    from tbl_lodging L
    join tbl_room_detail R
    on L.lodging_code = R.fk_lodging_code
    where fk_lodging_code is null
    
    
    select *
    from tbl_festival;
    
    select *
    from tbl_reservation;
    
    select V.reservation_code, V.userid, V.user_name, V.email, V.check_in, V.check_out,
          D.room_name, L.lodging_name, D.room_img
    from 
    (
    SELECT R.reservation_code, M.userid, M.user_name, M.email, fk_room_detail_code,
       		   to_char(R.check_in, 'yyyy-mm-dd hh24:mi') AS check_in ,
               to_char(R.check_out, 'yyyy-mm-dd hh24:mi') AS check_out
		FROM tbl_member M JOIN (select * from tbl_reservation 
        where mailsendcheck = 1 and status = 1 and
              to_char(check_in,'yyyymmdd') = to_char(sysdate+1,'yyyymmdd') ) R 
		ON M.userid = R.fk_userid
     )V   
        join tbl_room_detail D
        on V.fk_room_detail_code = D.room_detail_code
        join tbl_lodging L
        on D.fk_lodging_code = L.lodging_code
        
        update tbl_reservation set mailsendcheck = 0 where reservation_code = 59;
        commit;
        select *
        from tbl_lodging
        order by lodging_code desc
 
 select *
 from tbl_reservation
 
 


        