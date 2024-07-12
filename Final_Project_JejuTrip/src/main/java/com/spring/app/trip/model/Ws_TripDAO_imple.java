package com.spring.app.trip.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;

@Component
@Repository
public class Ws_TripDAO_imple implements Ws_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 회사 회원가입을 위한 메소드 생성
	@Override
	public int companyRegister(CompanyVO cvo) {
		int n = sqlsession.insert("ws_trip.companyRegister",cvo);
		return n;
	}// end of public int companyRegister(CompanyVO cvo) {
	
	// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드
	@Override
	public int companyIdCheck(String companyid) {
		String select_companyid = sqlsession.selectOne("ws_trip.companyIdCheck",companyid);
		if(select_companyid != null) {
			return 1;
		}
		else {
			return 0;
		}
	}// end of public int companyIdCheck(String companyid) {
	
	// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	@Override
	public int companyEmailCheck(String email) {
		String select_companyEmail = sqlsession.selectOne("ws_trip.companyEmailCheck",email);
		if(select_companyEmail != null) {
			return 1;
		}
		else {
			return 0;
		}
	}// end of public int companyEmailCheck(String encrypt) {
	
	// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	@Override
	public int registerHotelEnd(LodgingVO lodgingvo) {
		int n = sqlsession.insert("ws_trip.registerHotelEnd",lodgingvo);
		return n;
	}// end of public int registerHotelEnd(LodgingVO lodgingvo) {
	
	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	@Override
	public List<LodgingVO> select_lodgingvo(Map<String, String> paraMap) {
		List<LodgingVO> lodgingvoList = sqlsession.selectList("ws_trip.select_lodgingvo",paraMap);
		return lodgingvoList;
	}// end of public LodgingVO select_all_lodgingvo() {
	
	// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
	@Override
	public int screeningRegisterEnd(Map<String, String> paraMap) {
		int n = sqlsession.update("ws_trip.screeningRegisterEnd",paraMap);
		return n;
	}
	
	// 총 게시물 건수(totalCount)
	@Override
	public int getTotalCount(String choice_status) {
		int total_count = sqlsession.selectOne("ws_trip.getTotalCount",choice_status);
		return total_count;
	}// end of public int getTotalCount(String choice_status) {
	
	// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
	@Override
	public List<Map<String, String>> select_convenient() {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.select_convenient");
		return mapList;
	}

	// insert 하기위해 seq 채번해오기
	@Override
	public String getSeq() {
		String seq = sqlsession.selectOne("ws_trip.getSeq");
		return seq;
	}
	
	// 숙소정보에 따른 편의시설 정보 insert 해주기
	@Override
	public void insert_convenient(Map<String, String> paraMap) {
		String str_convenient = paraMap.get("str_convenient");
		String[] arr_convenient = str_convenient.split(",");
		String seq = paraMap.get("seq");
		paraMap = new HashMap<>();
		paraMap.put("seq",seq);
		for(int i=0; i<arr_convenient.length; i++) {
			
			String convenient_code = arr_convenient[i];
			paraMap.put("convenient_code", convenient_code);
			sqlsession.insert("ws_trip.insert_convenient",paraMap);
		}
		
	}
	
	//편의시설 정보를 가져와서 view 페이지에 표출시켜주기위한 List select
	@Override
	public List<Map<String, String>> select_convenient_list() {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.select_convenient_list");
		return mapList;
	}
	
	// 숙소 테이블에서 해당 업체의 신청건수, 승인건수, 반려 건수를 각각 알아온다.
	@Override
	public List<Map<String, String>> select_count_registerHotel(String companyid) {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.select_count_registerHotel",companyid);
		return mapList;
	}
	
	// 로그인 한 기업의 신청 목록을 읽어와서 view 페이지에 목록으로 뿌려주기 위한 select
	@Override
	public List<LodgingVO> select_loginCompany_lodgingvo(String companyid) {
		List<LodgingVO> lodgingvo = sqlsession.selectList("ws_trip.select_loginCompany_lodgingvo",companyid);
		return lodgingvo;
	}
	
	// 업체가 신청한 호텔에 대한 상세 정보를 보여주기위해 DB에서 읽어온다.
	@Override
	public LodgingVO selectRegisterHotelJSON(String lodging_code) {
		LodgingVO lodgingvo = sqlsession.selectOne("ws_trip.selectRegisterHotelJSON", lodging_code);
		return lodgingvo;
	}
	
	// 모든 회원의 정보를 읽어오는 메소드 생성
	@Override
	public List<MemberVO> select_member_all(Map<String, String> paraMap) {
		List<MemberVO> memberList = sqlsession.selectList("ws_trip.select_member_all", paraMap);
		return memberList;
	}
	
	// 모든 기업의 정보를 읽어오는 메소드 생성
	@Override
	public List<CompanyVO> select_Company_all(Map<String, String> paraMap) {
		List<CompanyVO> company = sqlsession.selectList("ws_trip.select_Company_all", paraMap);
		return company;
	}
	
	// member 테이블의 총 행 개수 알아오기
	@Override
	public int getTotalMemberCount() {
		int count = sqlsession.selectOne("ws_trip.getTotalMemberCount");
		return count;
	}
	
	// company 테이블의 총 행 개수 알아오기
	@Override
	public int getTotalCompanyCount() {
		int count = sqlsession.selectOne("ws_trip.getTotalCompanyCount");
		return count;
	}
	
	// 멤버 정보를 가져온다.
	@Override
	public MemberVO select_detailMember(String userid) {
		MemberVO member = sqlsession.selectOne("ws_trip.select_detailMember",userid);
		return member;
	}
	
	// 아이디를 토대로 회사 정보를 가져온다.
	@Override
	public CompanyVO select_detailCompany(String userid) {
		CompanyVO company = sqlsession.selectOne("ws_trip.select_detailCompany",userid);
		return company;
	}
	
	// 매년 가입자 수 통계를 내기 위한 차트 값 가져오기
	@Override
	public List<Map<String, String>> get_year_login_member_chart() {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.get_year_login_member_chart");
		return mapList;
	}
	
	// 매달 가입자 수 통계를 내기 위한 차트 값 가져오기
	@Override
	public List<Map<String, String>> get_month_login_member_chart(String choice_year) {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.get_month_login_member_chart",choice_year);
		return mapList;
	}
	
	// 사용자 연령대 차트에 사용할 정보 가져오기
	@Override
	public List<Map<String, String>> user_age_group_chart() {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.user_age_group_chart");
		return mapList;
	}
	
	// 사용자 성별 차트에 사용할 정보 가져오기
	@Override
	public List<Map<String, String>> user_gender_chart() {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.user_gender_chart");
		return mapList;
	}
	
	// 매년 호텔 예약건수를 찾아와서 차트화 시켜주기위한 정보 가져오기
	@Override
	public List<Map<String, String>> get_year_reservation_hotel_chart(String lodging_code) {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.get_year_reservation_hotel_chart",lodging_code);
		return mapList;
	}
	
	// 선택한 년도의 매월 예약건수를 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_month_reservation_chart(Map<String, String> paraMap) {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.get_month_reservation_chart",paraMap);
		return mapList;
	}
	
	// 숙소  테이블에서 기본적인 정보 목록을 가져온다.
	@Override
	public List<LodgingVO> select_lodging(Map<String, String> paraMap) {
		List<LodgingVO> lodgingList = sqlsession.selectList("ws_trip.select_lodging",paraMap);
		return lodgingList;
	}
	
	// tbl_lodging 테이블에서 status가 1인 모든 숙소의 개수를 읽어온다.
	@Override
	public int getTotalLodgingCount() {
		int totalCount = sqlsession.selectOne("ws_trip.getTotalLodgingCount");
		return totalCount;
	}
	
	// 맛집  테이블에서 기본적인 정보 목록을 가져온다.
	@Override
	public List<FoodstoreVO> select_foodstore(Map<String, String> paraMap) {
		List<FoodstoreVO> foodstore = sqlsession.selectList("ws_trip.select_foodstore",paraMap);
		return foodstore;
	}
	
	// tbl_food_store 테이블에 있는 모든 맛집의 개수를 알아온다.
	@Override
	public int getTotalFoodstoreCount() {
		int totalCount = sqlsession.selectOne("ws_trip.getTotalFoodstoreCount");
		return totalCount;
	}
	
	//즐길거리  테이블에서 기본적인 정보 목록을 가져온다.
	@Override
	public List<PlayVO> select_play(Map<String, String> paraMap) {
		List<PlayVO> playList = sqlsession.selectList("ws_trip.select_play",paraMap);
		return playList;
	}
	
	// tbl_play 테이블에 있는 모든 즐길거리 개수를 알아온다.
	@Override
	public int getTotalPlayCount() {
		int totalCount = sqlsession.selectOne("ws_trip.getTotalPlayCount");
		return totalCount;
	}
	
	// 선택한 월에서 매일의 예약건수를 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_day_reservation_chart(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_day_reservation_chart",paraMap);
		return mapList;
	}
	
	// 내가 선택한 월이 있다면 그 월의 마지막 날을 구해준다.
	@Override
	public String get_last_day(String choice_month) {
		String choice_month_last_day = sqlsession.selectOne("ws_trip.get_choice_month_last_day",choice_month);
		return choice_month_last_day;
	}
	
	// 매년 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
	@Override
	public List<Map<String, String>> get_year_profit_chart(String companyid) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_year_profit_chart",companyid);
		return mapList;
	}
	
	// 선택한 년도의 매월 매출액을 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_month_profit_chart(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_month_profit_chart",paraMap);
		return mapList;
	}
	
	// 선택한 월에서 매일의 매출액을 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_day_profit_chart(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_day_profit_chart",paraMap);
		return mapList;
	}
	
	// 기업이 소유하고있는 호텔의 총 예약건을 읽어온다.
	@Override
	public List<Map<String, String>> select_company_all_Reservation(String companyid) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.select_company_all_Reservation",companyid);
		return mapList;
	}
	
	// 예약일자마다의 객실 잔여석을 알아오기 위함이다.
	@Override
	public String select_reservation_Count(Map<String, String> reservationMap) {
		String count = sqlsession.selectOne("ws_trip.select_reservation_Count", reservationMap);
		return count;
	}
	
	// 매년 승인된 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
	@Override
	public List<Map<String, String>> get_year_profit_chart_success(String companyid) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_year_profit_chart_success",companyid);
		return mapList;
	}
	
	// 매년 취소 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
	@Override
	public List<Map<String, String>> get_year_profit_chart_fail(String companyid) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_year_profit_chart_fail",companyid);
		return mapList;
	}
	
	// 선택한 년도의 매월 승인매출액을 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_month_profit_chart_succeess(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_month_profit_chart_succeess",paraMap);
		return mapList;
	}
	
	// 선택한 년도의 매월 취소금액을 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_month_profit_chart_fail(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_month_profit_chart_fail",paraMap);
		return mapList;
	}
	
	// 선택한 월에서 매일의 승인된 매출액을 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_day_profit_chart_success(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_day_profit_chart_success",paraMap);
		return mapList;
	}
	
	// 선택한 월에서 매일의 취소금액을 가져와서 차트화 시켜준다.
	@Override
	public List<Map<String, String>> get_day_profit_chart_fail(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.get_day_profit_chart_fail",paraMap);
		return mapList;
	}

}
