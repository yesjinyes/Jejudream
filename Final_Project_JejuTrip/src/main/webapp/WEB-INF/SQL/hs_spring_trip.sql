


select *
from tbl_play_category
--1관광지 2전시회 3체험 4기타

select *
from tbl_play

select *
from tbl_local

CREATE TABLE tbl_play (
   play_code VARCHAR2(20) NOT NULL, /* 즐길거리일련번호 */
   fk_play_category_code VARCHAR2(20) NOT NULL, /* 즐길거리카테고리일련번호 */
   fk_local_code VARCHAR2(20) NOT NULL, /* 지역코드 */
    play_name VARCHAR2(20) NOT NULL, /* 즐길거리 명칭 */
    play_content VARCHAR2(100), /* 즐길거리 짧은상세정보 */
    play_mobile VARCHAR2(100), /* 즐길거리 연락처 */
    play_businesshours VARCHAR2(100), /* 즐길거리 운영시간 */
   play_address VARCHAR2(200), /* 상세주소 */
   play_main_img VARCHAR2(100), /* 대표이미지 */
   review_division VARCHAR2(10) default 'C', /* 리뷰용구분컬럼(default) C */
    CONSTRAINT PK_tbl_play    PRIMARY KEY (play_code),
    CONSTRAINT FK_tbl_play_local_code FOREIGN KEY (fk_local_code) REFERENCES tbl_local (local_code) on delete cascade,
    CONSTRAINT FK_tbl_play_category_code FOREIGN KEY (fk_play_category_code) REFERENCES tbl_play_category (play_category_code) on delete cascade
);


insert into tbl_play ( play_code, fk_play_category_code, fk_local_code, play_name, play_content, play_mobile,play_businesshours, play_address, play_main_img,review_division )
values (seq_common.nextval , 1,  100 ,'아르떼뮤지엄' ,'모든 감각의 긴장을 잠시 내려놓고 아르떼 뮤지엄 제주가 선사하는 영원한 자연의 공간 속으로 입장해보세요.', 
'1899-5008','10:00 - 18:00','제주 제주시 애월읍 어림비로 478' , '아르떼뮤지엄.jpg',default );

commit;


select play_code ,fk_play_category_code, fk_local_code ,play_name,
	 		play_content, play_mobile, play_businesshours,play_address,
	 		play_main_img,review_division 
	 
	 from tbl_play
     
     

insert into tbl_play ( play_code, fk_play_category_code, fk_local_code, play_name, play_content, play_mobile,play_businesshours, play_address, play_main_img,review_division )
values (seq_common.nextval , 2,  100 ,'박물관은살아있다' ,'마법 같은 공간에서 펼쳐지는 살아있는 전시로 흥미로운 제주 여행을 만들어요.', 
'064-805-0888','10:00 - 19:00','제주 서귀포시 중문관광로 42' , '박물관은살아있다.jpg',default );

insert into tbl_play ( play_code, fk_play_category_code, fk_local_code, play_name, play_content, play_mobile,play_businesshours, play_address, play_main_img,review_division )
values (seq_common.nextval , 3,  100 ,'너도나도ATV' ,'리얼 숲 속을 가로지르며 즐기는 감성레이스!', 
'010-4565-6786','10:00 - 17:00','제주 조천읍 비자림로 1053,중앙목장' , '너도나도ATV.jpg',default );

commit;



SELECT play_code,c.play_category_name as play_category_name ,fk_local_code,play_name,play_content,
       play_mobile,play_businesshours,play_address,play_main_img,review_division
FROM tbl_play p JOIN tbl_play_category c 
ON p.fk_play_category_code = c.play_category_code;

select *
from tbl_play
where play_category = '전시회';   




update tbl_play set play_category = '체험' where play_code = '5050'
update tbl_play set play_category = '전시회' where play_code = '5005';
update tbl_play set play_category = '전시회' where play_code = '5008';

commit;


insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_mobile,play_businesshours, play_address, play_main_img,review_division )
values (seq_common.nextval , '전시회',100,'아르떼뮤지엄' ,'모든 감각의 긴장을 잠시 내려놓고 아르떼 뮤지엄 제주가 선사하는 영원한 자연의 공간 속으로 입장해보세요.', 
'1899-5008','10:00 - 18:00','제주 제주시 애월읍 어림비로 478' , '아르떼뮤지엄.jpg',default );




     