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


-- 자주묻는질문(FAQ) insert
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '예약', '예약 확인은 어디서 할 수 있나요?', '당사 웹사이트에서 로그인 후 우측 상단의 마이페이지 > 예약내역에서 예약 세부 정보와 상태를 확인하실 수 있습니다. 해당 메뉴에서 승인대기목록, 확정목록, 취소목록 또한 확인하실 수 있습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '예약', '당일 예약이 가능한가요?', '일부 상품의 경우 당일 예약이 불가능할 수 있으므로 예약을 미리 하시는 것이 좋습니다. 부득이 당일 예약 혹은 제주도에 오셔서 구매를 원할 경우(관광지 이용권 등) 일부 상품에 한해서 이용이 가능합니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '예약', '예약 확정서는 언제 확인할 수 있나요?', '업체가  예약 승인 시 회원정보에 입력된 이메일로 예약 확정서가 발송됩니다. 예약이 반려될 경우 예약취소 이메일이 발송됩니다. 예약 확정서를 받지 못하신 경우, 스팸 편지함/정크 메일 편지함도 확인해 주시기 바랍니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '카드/결제', '취소 및 환불 절차는 어떻게 진행되나요?', '마이페이지 > 예약확인 > 예약취소 기능을 통해 예약하신 일정을 취소하실 수 있습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '카드/결제', '계좌이체도 가능한가요?', '상품에 따라 카드결제만 가능되는 곳이 있으니 미리 숙소 상세 페이지에서 확인하시어 원하는 서비스를 이용하시길 바랍니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '숙소', '객실에 간이침대/유아용 침대를 추가할 수 있나요?', '간이침대/유아용 침대 이용 가능 여부는 숙소에서 결정합니다. 간이침대를 포함해 아동에 대한 추가 요금은 별도로 명시되지 않는 한 예약 금액에 포함되지 않습니다. 더 자세한 사항은 숙소로 문의하시기 바랍니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '숙소', '조식은 객실 요금에 포함되어 있나요?', '객실 요금에 조식이 포함된 경우는 객실 종류별 설명 부분에 "조식 포함"으로 표시됩니다. 객실 요금에 조식이 포함되지 않은 경우는 숙소에서 객실 상품에 조식을 포함하지 않은 경우입니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '숙소', '숙박 예약 시 기준인원이란 무엇인가요?', '숙박하시는 곳에 따라 객실타입 및 평수에 따라 입실 가능한 인원수를 제한하도록 되어있습니다. 기준 인원을 초과할 경우 인당 추가요금을 내고 입실은 가능하나, 이용하실 때 불편함이 있을 수 있어, 사용함에 있어 불편하시지 않도록 기준인원을 책정하고 있습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '맛집', '지역 별 맛집은 어떻게 보나요?', '맛집 리스트 상단에 있는 지역 체크박스를 통해 지역 별 맛집을 조회하실 수 있습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '맛집', '맛집을 내 일정에 추가하고 싶습니다.', '맛집 상세 페이지에서 "일정 추가" 아이콘을 클릭 후 제목, 내용, 날짜, 시간을 설정하여 내 일정에 추가하실 수 있습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '즐길거리', '비회원은 리뷰 작성이 안되나요?', '리뷰 작성은 회원 전용 서비스이므로 로그인 후 사용 가능합니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '즐길거리', '주소 정보가 잘못 나와있는 것 같아요.', '"상세 페이지의 주소 결과가 잘못 나오는 경우에는 여기에 제보해주세요" 를 클릭하여 지도 정보 수정을 제안하실 수 있습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '비회원 예약이 가능한가요?', '당사 웹사이트는 회원 전용으로 운영되고 있습니다. 회원가입을 통해 서비스를 자유롭게 이용해보세요.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');


insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '3불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '4불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '5불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '6불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '7불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '8불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '9불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '10불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '11불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '12불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '13불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '14불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '15불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '16불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '17불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '18불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '19불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '20불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '21불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');
insert into tbl_faq(faq_seq, faq_category, faq_question, faq_answer) values(seq_faq.nextval, '기타', '22불편사항 문의는 어디에 하면 되나요?', '고객센터 내 채팅 기능을 이용하여 불편사항을 접수해 주시면 확인 후 답변 드리겠습니다.');



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
desc tbl_food_store;

commit;



select faq_seq, faq_category, faq_question, faq_answer
from
(
select rownum as rno, faq_seq, faq_category, faq_question, faq_answer
from tbl_faq
)V
where RNO between 1 and 10






