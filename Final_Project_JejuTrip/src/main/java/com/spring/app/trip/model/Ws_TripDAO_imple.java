package com.spring.app.trip.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.Calendar_schedule_VO;
import com.spring.app.trip.domain.Calendar_small_category_VO;
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
	
	// tbl_reservation에서 자기 자신의 기업에 해당하는 모든 예약정보를 가져온다.
	@Override
	public int getTotalreservationCount(Map<String, String> paraMap) {
		int count = sqlsession.selectOne("ws_trip.getTotalreservationCount",paraMap);
		return count;
	}
	
	// 기업이 소유하고있는 호텔의 총 예약건을 페이징 처리 해서 읽어온다.
	@Override
	public List<Map<String, String>> select_company_all_Reservation_paging(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.select_company_all_Reservation_paging",paraMap);
		return mapList;
	}
	
	// 업체가 처리한 결과에 따라 reservation테이블에 status값 바꿔주기
	@Override
	public int updateReservationStatus(Map<String, String> paraMap) {
		int result = sqlsession.update("ws_trip.updateReservationStatus",paraMap);
		return result;
	}
	
	// 회원의 예약 목록을 가져와서 status별로 카운트를 해준다.
	@Override
	public List<String> select_user_all_reservation(String userid) {
		List<String> user_reservation_status = sqlsession.selectList("ws_trip.select_user_all_reservation",userid);
		return user_reservation_status;
	}
	
	// 개인회원이 한 예약정보를 페이징처리하여 읽어온다.
	@Override
	public List<Map<String, String>> select_user_all_Reservation_paging(Map<String, String> paraMap) {
		List<Map<String, String>> reservationList = sqlsession.selectList("ws_trip.select_user_all_Reservation_paging",paraMap);
		return reservationList;
	}
	
	// tbl_reservation에서 자기 자신의 모든 예약정보를 카운트한다.
	@Override
	public int getTotalUserReservationCount(Map<String, String> paraMap) {
		int count = sqlsession.selectOne("ws_trip.getTotalUserReservationCount",paraMap);
		return count;
	}
	
	// 회원의 이메일을 읽어온다.
	@Override
	public String get_user_email(String reservation_code) {
		String email = sqlsession.selectOne("ws_trip.get_user_email",reservation_code);
		return email;
	}
	
	// 바우처에 입력할 정보를 가져오기 위해 예약정보등을 가져온다.
	@Override
	public Map<String, String> get_email_map(String reservation_code) {
		Map<String,String> email_map = sqlsession.selectOne("ws_trip.get_email_map", reservation_code);
		return email_map;
	}
	
	// 입력한 값으로 회원 정보를 수정한다.
	@Override
	public int update_member_info(MemberVO membervo) {
		int n = sqlsession.update("ws_trip.update_member_info",membervo);
		return n;
	}
	
	// 로그인한 유저 자기자신의 이메일을 제외한 다른 사람의 이메일중 중복값이 있는 지 알아오기.
	@Override
	public String userEmailDuplicateCheckEdit(Map<String, String> paraMap) {
		
		String exist_email = sqlsession.selectOne("ws_trip.userEmailDuplicateCheckEdit", paraMap);
		
		return exist_email;
	}
	
	// 등록된 일정 가져오기
	@Override
	public List<Calendar_schedule_VO> selectSchedule(String fk_userid) {
		List<Calendar_schedule_VO> scheduleList = sqlsession.selectList("ws_trip.selectSchedule",fk_userid);
		return scheduleList;
	}
	
	// === 일정상세보기 ===
	@Override
	public Map<String, String> detailSchedule(String scheduleno) {
		Map<String, String> map = sqlsession.selectOne("ws_trip.detailSchedule", scheduleno);
		return map;
	}
	
	// 내 캘린더에서 내캘린더 소분류  보여주기
	@Override
	public List<Calendar_small_category_VO> showMyCalendar(String fk_userid) {
		List<Calendar_small_category_VO> List = sqlsession.selectList("ws_trip.showMyCalendar",fk_userid);
		return List;
	}
	
	// 총 일정 검색 건수(totalCount)
	@Override
	public int getTotalScheduleCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("ws_trip.getTotalScheduleCount",paraMap);
		return n;
	}
	
	// 페이징 처리한 캘린더 가져오기(검색어가 없다라도 날짜범위 검색은 항시 포함된 것임)
	@Override
	public List<Map<String, String>> scheduleListSearchWithPaging(Map<String, String> paraMap) {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.scheduleListSearchWithPaging",paraMap);
		return mapList;
	}
	
	// 일정 등록하기
	@Override
	public int registerSchedule_end(Map<String, String> paraMap) {
		int n = sqlsession.insert("ws_trip.registerSchedule_end",paraMap);
		return n;
	}
	
	// 공유자 명단 불러오기
	@Override
	public List<MemberVO> searchJoinUserList(String joinUserName) {
		List<MemberVO> mvo = sqlsession.selectList("ws_trip.searchJoinUserList",joinUserName);
		return mvo;
	}
	
	// 일정 수정 완료하기
	@Override
	public int editSchedule_end(Calendar_schedule_VO svo) {
		int n = sqlsession.update("ws_trip.editSchedule_end",svo);
		return n;
	}
	
	// 일정삭제하기
	@Override
	public int deleteSchedule(String scheduleno) {
		int n = sqlsession.delete("ws_trip.deleteSchedule",scheduleno);
		return n;
	}
	
	// 해당 예약에 관련된 companyid를 가져와야한다.
	@Override
	public String getCompanyidToTblReservation(String reservation_code) {
		String companyid = sqlsession.selectOne("ws_trip.getCompanyidToTblReservation",reservation_code);
		return companyid;
	}
	
	// 예약 코드를 가지고 업체아이디와 업체명을 가져오기
	@Override
	public Map<String, String> getCompanyIdAndLodgingNameToTblReservationCode(String reservation_code) {
		Map<String,String> map = sqlsession.selectOne("ws_trip.getCompanyIdAndLodgingNameToTblReservationCode",reservation_code);
		return map;
	}
	
	// 채팅을 보냈다는 기록을 남겨준다.
	@Override
	public void insert_send_chatting(Map<String, String> chatMap) {
		sqlsession.insert("ws_trip.insert_send_chatting",chatMap);
		
	}
	
	// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
	@Override
	public int get_new_chatting(String userid) {
		int n = sqlsession.selectOne("ws_trip.get_new_chatting",userid);
		return n;
	}
	
	// 기업으로 온 모든 채팅 목록을 읽어온다.
	@Override
	public List<Map<String, String>> select_company_all_chatting_paging(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.select_company_all_chatting_paging",paraMap);
		return mapList;
	}
	
	// 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
	@Override
	public int getTotalCompanyChattingCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("ws_trip.getTotalCompanyChattingCount",paraMap);
		return n;
	}
	
	// 채팅에 해당하는 고객 아이디와 이름을 가져온다.
	@Override
	public Map<String, String> getMemberIdAndNameToTblReservationCode(String reservation_code) {
		Map<String,String> map = sqlsession.selectOne("ws_trip.getMemberIdAndNameToTblReservationCode",reservation_code);
		return map;
	}
	
	// 채팅 로그 테이블에 해당 예약건에 관련한 채팅을 읽음처리한다.
	@Override
	public void update_chattinglog(String reservation_code) {
		sqlsession.update("ws_trip.update_chattinglog",reservation_code);
		
	}

	// 채팅방에서 나가게되면 채팅 기록방에서 나가기 직전까지의 읽음 컬럼을 읽음처리로 바꿔준다.
	@Override
	public void update_chattinglog_after_chatting(Map<String, String> paraMap) {
		sqlsession.update("ws_trip.update_chattinglog_after_chatting",paraMap);
		
	}
	
	// 회원으로 온 모든 채팅 목록을 읽어온다.
	@Override
	public List<Map<String, String>> select_member_all_chatting_paging(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.select_member_all_chatting_paging",paraMap);
		return mapList;
	}

	// 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
	@Override
	public int getTotalMemberChattingCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("ws_trip.getTotalMemberChattingCount",paraMap);
		return n;
	}
	
	// 동일한 사람과 진행한 채팅기록이 남아있는지 확인하기위함이다.
	@Override
	public int get_chatting_log(Map<String, String> chatMap) {
		int n = sqlsession.selectOne("ws_trip.get_chatting_log",chatMap);
		return n;
	}
	
	// 이미 해당 채팅방에 있는 로그가 insert되어있는 경우에는 해당 커럼의 값들을 바꿔준다.
	@Override
	public void update_chattinglog_no_read(Map<String, String> chatMap) {
		sqlsession.update("ws_trip.update_chattinglog_no_read",chatMap);
		
	}
	
	// 로그인을 했을 때 모든 채팅의 개수를 읽어온다.
	@Override
	public int get_all_chatting(String companyid) {
		int n = sqlsession.selectOne("ws_trip.get_all_chatting",companyid);
		return n;
	}
	
	// 관리자로 온 모든 채팅 목록을 읽어온다.
	@Override
	public List<Map<String, String>> select_admin_all_chatting_paging(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("ws_trip.select_admin_all_chatting_paging",paraMap);
		return mapList;
	}

	// 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
	@Override
	public int getTotalAdminChattingCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("ws_trip.getTotalAdminChattingCount",paraMap);
		return n;
	}

	// 유저 아이디로 이름 가져오기
	@Override
	public String getUserName(String userid) {
		String user_name = sqlsession.selectOne("ws_trip.getUserName",userid);
		return user_name;
	}

	// 새로 온 관리자 메세지가 있는지 확인한다.
	@Override
	public int get_from_admin_chatting_exist(String userid) {
		int n = sqlsession.selectOne("ws_trip.get_from_admin_chatting_exist",userid);
		return n;
	}

	// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
	@Override
	public int get_new_chatting_admin(String userid) {
		int n = sqlsession.selectOne("ws_trip.get_new_chatting_admin",userid);
		return n;
	}

	// 로그인을 했을 때 모든 채팅의 개수를 읽어온다.
	@Override
	public int get_all_chatting_admin(String userid) {
		int n = sqlsession.selectOne("ws_trip.get_all_chatting_admin",userid);
		return n;
	}

}
