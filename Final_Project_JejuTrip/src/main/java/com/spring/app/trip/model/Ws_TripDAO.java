package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;

public interface Ws_TripDAO {

	int companyRegister(CompanyVO cvo);// 회사 회원가입을 위한 메소드 생성
	int companyIdCheck(String companyid);// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드
	int companyEmailCheck(String encrypt);// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	int registerHotelEnd(LodgingVO lodgingvo);// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	List<LodgingVO> select_lodgingvo(Map<String, String> paraMap);	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	int screeningRegisterEnd(Map<String, String> paraMap);// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
	int getTotalCount(String choice_status);// 총 게시물 건수(totalCount)
	List<Map<String, String>> select_convenient();// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
	String getSeq();// insert 를 위해 seq 채번 해오기
	void insert_convenient(Map<String, String> paraMap);// 숙소정보에 따른 편의시설 정보 insert 해주기
	List<Map<String, String>> select_convenient_list();//편의시설 정보를 가져와서 view 페이지에 표출시켜주기위한 List select
	List<Map<String, String>> select_count_registerHotel(String companyid);// 숙소 테이블에서 해당 업체의 신청건수, 승인건수, 반려 건수를 각각 알아온다.
	List<LodgingVO> select_loginCompany_lodgingvo(String companyid);// 로그인 한 기업의 신청 목록을 읽어와서 view 페이지에 목록으로 뿌려주기 위한 select
	LodgingVO selectRegisterHotelJSON(String lodging_code);// 업체가 신청한 호텔에 대한 상세 정보를 보여주기위해 DB에서 읽어온다.
	List<MemberVO> select_member_all(Map<String, String> paraMap);// 모든 회원의 정보를 읽어오는 메소드 생성
	List<CompanyVO> select_Company_all(Map<String, String> paraMap);// 모든 기업의 정보를 읽어오는 메소드 생성
	int getTotalMemberCount();// member 테이블의 총 행 개수 알아오기
	int getTotalCompanyCount();// company 테이블의 총 행 개수 알아오기
	MemberVO select_detailMember(String userid);// 멤버 정보를 가져온다.
	CompanyVO select_detailCompany(String userid);// 아이디를 토대로 회사 정보를 가져온다.
	List<Map<String, String>> get_year_login_member_chart();// 매년 가입자 수 통계를 내기 위한 차트 값 가져오기
	List<Map<String, String>> get_month_login_member_chart(String choice_year);// 매달 가입자 수 통계를 내기 위한 차트 값 가져오기
	List<Map<String, String>> user_age_group_chart();// 사용자 연령대 차트에 사용할 정보 가져오기
	List<Map<String, String>> user_gender_chart();// 사용자 성별 차트에 사용할 정보 가져오기
	List<Map<String, String>> get_year_reservation_hotel_chart(String lodging_code);// 매년 호텔 예약건수를 찾아와서 차트화 시켜주기위한 정보 가져오기
	List<Map<String, String>> get_month_reservation_chart(Map<String, String> paraMap);// 선택한 년도의 매월 예약건수를 가져와서 차트화 시켜준다.
	List<LodgingVO> select_lodging(Map<String, String> paraMap);// 숙소  테이블에서 기본적인 정보 목록을 가져온다.
	int getTotalLodgingCount();// tbl_lodging 테이블에서 status가 1인 모든 숙소의 개수를 읽어온다.
	List<FoodstoreVO> select_foodstore(Map<String, String> paraMap);// 맛집  테이블에서 기본적인 정보 목록을 가져온다.
	int getTotalFoodstoreCount();// tbl_food_store 테이블에 있는 모든 맛집의 개수를 알아온다.
	List<PlayVO> select_play(Map<String, String> paraMap);//즐길거리  테이블에서 기본적인 정보 목록을 가져온다.
	int getTotalPlayCount();// tbl_play 테이블에 있는 모든 즐길거리 개수를 알아온다.
	List<Map<String, String>> get_day_reservation_chart(Map<String, String> paraMap);// 선택한 월에서 매일의 예약건수를 가져와서 차트화 시켜준다.
	String get_last_day(String choice_month);// 내가 선택한 월이 있다면 그 월의 마지막 날을 구해준다.
	List<Map<String, String>> get_year_profit_chart(String companyid);// 매년 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
	List<Map<String, String>> get_month_profit_chart(Map<String, String> paraMap);// 선택한 년도의 매월 매출액을 가져와서 차트화 시켜준다.
	List<Map<String, String>> get_day_profit_chart(Map<String, String> paraMap);// 선택한 월에서 매일의 매출액을 가져와서 차트화 시켜준다.
	List<Map<String, String>> select_company_all_Reservation(String companyid);// 기업이 소유하고있는 호텔의 총 예약건을 읽어온다.
	String select_reservation_Count(Map<String, String> reservationMap);// 예약일자마다의 객실 잔여석을 알아오기 위함이다.
	List<Map<String, String>> get_year_profit_chart_success(String companyid);// 매년 승인된 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
	List<Map<String, String>> get_year_profit_chart_fail(String companyid);// 매년 취소 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
	List<Map<String, String>> get_month_profit_chart_succeess(Map<String, String> paraMap);// 선택한 년도의 매월 승인매출액을 가져와서 차트화 시켜준다.
	List<Map<String, String>> get_month_profit_chart_fail(Map<String, String> paraMap);// 선택한 년도의 매월 취소금액을 가져와서 차트화 시켜준다.
	List<Map<String, String>> get_day_profit_chart_success(Map<String, String> paraMap);// 선택한 월에서 매일의 승인된 매출액을 가져와서 차트화 시켜준다.
	List<Map<String, String>> get_day_profit_chart_fail(Map<String, String> paraMap);// 선택한 월에서 매일의 취소금액을 가져와서 차트화 시켜준다.
	int getTotalreservationCount(Map<String, String> paraMap);// tbl_reservation에서 자기 자신의 기업에 해당하는 모든 예약정보를 가져온다.
	List<Map<String, String>> select_company_all_Reservation_paging(Map<String, String> paraMap);// 기업이 소유하고있는 호텔의 총 예약건을 페이징 처리 해서 읽어온다.
	int updateReservationStatus(Map<String, String> paraMap);// 업체가 처리한 결과에 따라 reservation테이블에 status값 바꿔주기
	List<String> select_user_all_reservation(String userid);// 회원의 예약 목록을 가져와서 status별로 카운트를 해준다.
	List<Map<String, String>> select_user_all_Reservation_paging(Map<String, String> paraMap);// 개인회원이 한 예약정보를 페이징처리하여 읽어온다.
	int getTotalUserReservationCount(Map<String, String> paraMap);// tbl_reservation에서 자기 자신의 모든 예약정보를 카운트한다.
	String get_user_email(String reservation_code);// 회원의 이메일을 읽어온다.
	Map<String, String> get_email_map(String reservation_code);// 바우처에 입력할 정보를 가져오기 위해 예약정보등을 가져온다.
	int update_member_info(MemberVO membervo);// 입력한 값으로 회원 정보를 수정한다.
	String userEmailDuplicateCheckEdit(Map<String, String> paraMap);// 로그인한 유저 자기자신의 이메일을 제외한 다른 사람의 이메일중 중복값이 있는 지 알아오기.

}
