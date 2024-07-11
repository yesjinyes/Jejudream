


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
where play_category = '체험';   




update tbl_play set play_category = '체험' where play_code = '5050'
update tbl_play set play_category = '전시회' where play_code = '5005';
update tbl_play set play_category = '전시회' where play_code = '5008';

commit;


insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_mobile,play_businesshours, play_address, play_main_img,review_division )
values (seq_common.nextval , '전시회',100,'아르떼뮤지엄' ,'모든 감각의 긴장을 잠시 내려놓고 아르떼 뮤지엄 제주가 선사하는 영원한 자연의 공간 속으로 입장해보세요.', 
'1899-5008','10:00 - 18:00','제주 제주시 애월읍 어림비로 478' , '아르떼뮤지엄.jpg',default );


insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 동부', '목장카페드르쿰다','승마와 카트를 한번에! 취향껏 즐기는 액티비티','9:00-17:00','064-787-5220','서귀포시 표선면 번영로 2454','드르쿰다.jsp','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 동부', '라프 짚라인,족욕','짚와이어, 아로마 족욕 등 다양한 경험을 할 수 있는 종합 문화시설','09:00-18:00','064-784-9030','제주시 조천읍 선교로 115-1','라프짚라인.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 서부', '스머지키트 체험','제주 로즈마리로 제주의 향을 담은 나만의 스머지 키트를 만들어보세요!','8:00-19:00','064-772-1320','애월읍 어림비로 376 어음분교1963','스머지키트.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 시내', '제주제트','해상 레포츠의 신개념! 스릴과 모험의 세계!
','09:00-18:00','064-739-3939','서귀포시 대포로 172-5','제주제트.jpg','C');
"insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 시내', '행복공방 도자기 체험 및 수업','서귀포 나만의 도자기 만들기
','09:00-18:00','	010-2859-9504','서귀포시 중산간서로 188','행복공방.jpg','C');"
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 동부', '탐라승마장','제주에서 가장 오래된 전통의 승마장!','09:00-16:00','064-782-5577','제주시 구좌읍 비자림로 1044','탐라승마장.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 시', '중문레져 UT','사이다같은 스피드! 짜릿한 이색체험!','10:00-일몰전','064-739-8258','서귀포시 대포동 산 39-5','중문레져UTV.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 동부', '서귀포 다이브센터','제주 바다의 메카 서귀포바다에서 즐기는 특별한 체험!','09:00-18:00','010-4255-4176','서귀포시 남원읍 하례망장포로 65-13','서귀포다이브센터.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 동부', '씨워커(국제리더스클럽)
','가족 또는 연인과 함께 에메랄드빛 제주바다위에서 추억만들기','09:00-18:00',' 064-783-0000','조천읍 신흥리 321-14','씨워커jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 서부', '하모돌고래투어','사랑스러운 돌고래 무리들이 제돌이 보트 주위를 감싸는 순간! 인생샷 찰칵','10:00-17:30','010-2980-5105','서귀포시 대정읍 최남단해안로 120','하모돌고래투어.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 동부', '김녕요트 일반투어
','제주만의 풍경과 감탄을 자아내는 요트 투어로 힐링의 순간을 함께 경험해보세요!
','10:00-일몰전','064-725-0225','제주시 구좌읍 김녕리 김녕항','김녕요트 일반투어.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 서부', '차귀도 달래 배낚시
','차귀도의 해안절경을 만끽하며 즐기는 짜릿한 손맛!
','09:50-18:00','010-4740-2578','제주시 한경면 노을해안로 1160','차귀도달래배낚시.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'제주시 동부', '성산스쿠버다이빙
','성산일출봉 아래 경이로운 바닷속 세계!
','09:00-18:00','064-782-6117','서귀포시 성산읍 일출로 258-5(성산포리조트)','성산스쿠버다이빙.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '체험' ,'서귀포시 서부', '산방산유람선
','아름다운 제주 해안을 한눈에 감상 할 수 있는 최고의 코스
','11:00-18:00','064-792-1188','서귀포시 안덕면 화순해안로 106번길 16','산방산유람선.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 동부', '성산일출봉','바다위에 우뚝 솟아난 수성화산·유네스코 세계자연유산, 천연기념물 제420호, 올레1코스','07:00-19:00',' 064-783-0959','서귀포시 성산읍 일출로 284-12','성산일출봉.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 동부', '우도(해양도립공원)','소가 누워있는 형상을 하고 있는 제주의 가장 큰 부속섬','00:00-00:00',' 064-728-1527','제주시 우도면 삼양고수물길 1','우도.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 동부', '사려니숲길','제주 숨은 비경 31, 삼나무 향기에 취하며 걷는 아름답고 청정한 숲길','09:00-17:00','064-900-8800','제주시 조천읍 교래리 산 137-1','사려니숲길.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 시내', '카멜리아힐','커플들과 아이를 동반한 가족 단위 관광객에게 인기가 높은 동양에서 가장 큰 동백 수목원','08:30-19:00 ','064-800-6296','서귀포시 안덕면 병악로 166','카멜리아힐.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 서부', '협재해수욕장','비양도, 은모래, 바다가 그려낸 그림같이 아름다운 해변','00:00-00:00','064-728-3981','제주시 한림읍 한림로 329-10','협재해수욕장.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 동부', '월정리해수욕장','달이 머물다 가는’ 제주도의 아름다운 해변, 월정리해수욕장','00:00-00:00','064-783-5798','제주시 구좌읍 월정리 33-3','월정리해수욕장.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 동부', '산굼부리','사계절마다 다른풍경의 '분화구 식물원', 국가지정 문화재 천연기념물 263호','09:00-18:40','064-783-9900',' 제주시 조천읍 비자림로 768','산굼부리.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 동부', '섭지코지','아름다운 해안이 일품인 섭지','00:00-00:00','064-740-6000','서귀포시 성산읍 고성리','섭지코지.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 시내', '한라산국립공원','한반도 3대 영산 중 하나, 유네스코가 지정한 · 세계생물권보존지역 · 세계자연유산 · 세계지질공원','기후변화에 따름',' 064-713-9950','제주시 1100로 2070-61','한라산.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 시내', '천지연폭포','하늘과 땅이 만나서 이룬 연못, · 천연기념물 제163호 · 천연기념물 제27호 · 올레6코스','09:00-22:00','064-733-1528','서귀포시 남성중로 2-15','천지연폭포.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 서부', '송악산','서남부의 절경을 선사하는 산방산의 이웃산','00:00-00:00','064-760-2917','서귀포시 대정읍 송악관광로 421-1','송악산.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 시내', '쇠소깍','제주 올레 5코스의 끝이자 6코스의 시작인 바닷물과 민물이 만나는 비밀스런 계곡','00:00-00:00','064-732-1562','서귀포시 쇠소깍로 128','쇠소깍.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 서부', '금능해수욕장',' 파란 물감을 풀어놓은 것 같은 바다부터 생김새가 귀여운 비양도, 촉감이 보슬거리는 모래사장까지 이웃한 해변과 비슷한 풍경을 품고 있지만 그보다 사람이 붐비지 않아 여유로운 것이 매력이다.',' 10:00-19:00','064-728-3983~4','제주시 한림읍 금능길 119-10','금능해수욕장.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 서부', '마라도','난대성 해양 동식물이 풍부하고 경관이 아름다운 유인도 중에 국토 최남단인 섬, 천연기념물 제423호','00:00-00:00',' 064-760-4014','서귀포시 대정읍 마라로101번길 46','마라도.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 서부', '애월해안도로','도보, 자전거, 자동차 뭐든 좋은 서부해안도로','00:00-00:00',' 064-728-3394','제주시 애월읍 애월해안로','애월해안도로.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 시내', '정방폭포','높은곳에서 바다로 떨어지는 물줄기의 시원함 · 명승 제43호 · 올레6코스','09:00-17:30',' 064-733-1530','서귀포시 칠십리로214번길 37','정방폭포.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 시내', '제주절물자연휴양림
','삼나무 숲에서 즐기는 산림욕','07:00-18:00','064-728-1510','제주시 명림로 584','제주절물.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 시내', '용두암','용이 승천하려다 뜻을 이루지 못했다는 전설을 담고 있는 곳 · 제주도기념물 제57호 · 올레17코스','00:00-00:00','064-728-3917','제주시 용두암길 15','용두암.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 서부', '산방산
','설문대할망이 한라산 꼭대기를 뽑아 던져놓았다는 산방산 · 명승 제77호 · 천연기념물 제376호 · 올레10코스','09:00-17:00','064-794-2940','서귀포시 안덕면 사계리 산 16','산방산.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 동부', '다랑쉬오름','4계절 색채가 뚜렷한 오름의 여왕','00:00-00:00',' 064-740-6000','제주시 구좌읍 세화리 2705','다랑쉬오름.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'제주시 서부', '더럭초등학교','알록달록 조용한 애월의 작은 초등학교(구, 분교)','18:00~','064-797-7200','제주시 애월읍 하가로 195','더럭초등학교.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '관광지' ,'서귀포시 서부', '천제연폭포','칠선녀가 목욕을 하다 간다는 전설이 있는 폭포 · 서귀포시 중문동 · 천연기념물 제378호 · 올레8코스','09:00-18:00','064-760-6331','서귀포시 천제연로 132(중문동)','천연제폭포.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'제주시 서부', '그리스신화박물관트릭아이뮤지엄','“나도 이곳에선 그리스신화 주인공이다.”
','09:00-18:00','064-773-5800','한림읍 광산로 942','그리스신화박물관트릭아이뮤지엄.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'제주시 동부', '서프라이즈테마파크','세계최대의 압도적인 스케일, 정크아트의 진수
','09:00-21:00','064-783-7272','제주시 조천읍 남조로 2243','서프라이즈테마파크.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'서귀포시 시내', '피규어뮤지엄제주','인기 마블 주인공과 다양한 캐릭터를 한자리에','09:30-18:00','064-792-2244','서귀포시 안덕면 한창로 243','피규어뮤지엄제주.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'서귀포시 서부', '이상한나라의앨리스','동화속 거울 미로! 제주의 이상한 나라로~
','09:00-18:00','064-794-4700','서귀포시 안덕면 중산간서로 1881','이상한나라의앨리스.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'제주시 동부', '캐릭파크','국내 최초 캐릭터 전시관!
','10:00-18:00','064-784-3500','제주시 조천읍 선교로 264','캐릭파크.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'서귀포시 시내', '아프리카박물관','제주에서 아프리카를 느껴보세요
','09:00-19:00','064-738-6565','서귀포시 이어도로 49','아프리카박물관.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'서귀포시 서부', '세계자동차피아노박물관','아시아 최초의 개인소장 자동차박물관 입니다
','09:00-18:00','064-792-3000','서귀포시 안덕면 중산간서로 1610','세계자동차피아노.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'제주시 동부', '포레스트공룡사파리','공룡을 눈앞에서 즐겨보세요~','09:30-17:30','064-783-0300','제주시 조천읍 선교로 474-1','공룡사파리.jpg','C');
insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'서귀포시 시내', '[제주] 버디프렌즈 플래닛
','제주의 자연을 새롭게 즐기다!','10:00-18:00','064-798-2000','서귀포시 천제연로 70','버디프렌즈.jpg','C');


update tbl_play set play_main_img = '드르쿰다.jpg' where play_code = 5348;
update tbl_play set play_main_img = '김녕요트.jpg' where play_code = 5356;
update tbl_play set play_main_img = '씨워커.jpg' where play_code = 5354;
delete from tbl_play where play_name='바다당';

insert into tbl_play ( play_code, play_category, local_status, play_name, play_content, play_businesshours, play_mobile,play_address, play_main_img,review_division ) values(seq_common.nextval, '전시회' ,'제주시 시내', '아르떼뮤지엄','모든 감각의 긴장을 잠시 내려놓고 아르떼 뮤지엄 제주가 선사하는 영원한 자연의 공간 속으로 입장해보세요.','10:00-18:00','1899-5008','제주 제주시 애월읍 어림비로 478','아르떼뮤지엄.jpg','C');

commit;     