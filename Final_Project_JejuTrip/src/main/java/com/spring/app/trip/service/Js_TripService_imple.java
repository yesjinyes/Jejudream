package com.spring.app.trip.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.GoogleMail;
import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.domain.RoomDetailVO;
import com.spring.app.trip.model.Js_TripDAO;

@Service
public class Js_TripService_imple implements Js_TripService {
   
   @Autowired
   private Js_TripDAO dao;
   
   @Autowired
   private AES256 aES256;
   
   @Autowired
   private GoogleMail mail;

   // 조건에 따른 숙소리스트 select 해오기
   @Override
   public List<Map<String,String>> lodgingList(Map<String, Object> paraMap) {
      
      List<Map<String,String>> lodgingList = dao.lodgingList(paraMap);
      
      return lodgingList;
   }

   
   // 숙소리스트에서 조건에 따른 숙소 개수 구해오기
   @Override
   public int getLodgingTotalCount(Map<String, Object> paraMap) {
		
	   int totalCount = dao.getLodgingTotalCount(paraMap);
	   
	   return totalCount;
	   
   } // end of public int getLodgingTotalCount(Map<String, Object> paraMap) {

   
   // 숙소리스트에 표현할 편의시설 목록 구해오기
   @Override
   public List<Map<String,String>> getConvenientList(String lodging_code) {
	   
	   List<Map<String,String>> convenientList = dao.getConvenientList(lodging_code);
	   
	   return convenientList;
	   
   } // end of public List<String> getConvenientList() {


   // 숙소의상세정보만 가져오기
   @Override
   public LodgingVO getLodgingDetail(String lodgingCode) {
	   
	   LodgingVO lodgingDetail = dao.getLodgingDetail(lodgingCode);
	
	   return lodgingDetail;
	   
	} // end of public LodgingVO getLodgingDetail(String lodgingCode) {


	// 숙소의 객실 정보 가져오기
	@Override
	public List<Map<String, String>> getRoomDetail(Map<String, String> dateSendMap) {
		
		List<Map<String, String>> roomDetailList = dao.getRoomDetail(dateSendMap);
		
		return roomDetailList;
		
	} // end of public List<Map<String, String>> getRoomDetail(String lodgingCode) { 

	
	// 결제페이지에서 예약하려하는 객실정보 가져오기 
	@Override
	public Map<String, String> getReserveRoomDetail(Map<String, String> paraMap) {
		
		Map<String, String> roomDetail = dao.getReserveRoomDetail(paraMap);
		
		return roomDetail;
		
	}// end of public RoomDetailVO getRoomDetail(Map<String, String> paraMap) {

	
	// 예약결과 예약번호 표현을 위한 채번해오기
	@Override
	public String getReservationNum() {
		
		String num = dao.getReservationNum();
		
		return num;
		
	} // end of public String getReservationNum() {
	
	
	// 결제 후 예약테이블에 insert 하기
	@Override
	public int insertReservation(Map<String, String> paraMap) {
		
		int n = dao.insertReservation(paraMap);
		
		return n;
		
	} // end of public int insertReservation(Map<String, String> paraMap) {


	
	// 예약완료된 정보 가져오기
	@Override
	public Map<String, String> getReservationInfo(Map<String, String> paraMap) {
		
		Map<String, String> resultMap = dao.getReservationInfo(paraMap);
		
		return resultMap;
		
	} // end of public Map<String, String> getReservationInfo(Map<String, String> paraMap) {


	// 댓글 페이징 처리를 위한 토탈 카운트 구해오기
	@Override
	public int getCommentTotalCount(String lodging_code) {
		
		int totalCount = dao.getCommentTotalCount(lodging_code); 
		
		return totalCount;
		
	} // end of public int getCommentTotalCount(String lodging_code) {


	// 리뷰리스트 가져오기
	@Override
	public List<Map<String, String>> getCommentList_Paging(Map<String, String> paraMap) {
		
		List<Map<String, String>> reviewList = dao.getCommentList_Paging(paraMap);
		
		return reviewList;
	}// end of public List<Map<String, String>> getCommentList_Paging(Map<String, String> paraMap) { 


	
	// 숙소상세페이지 이동시에 예약했는지 확인하기
	@Override
	public int chkReservation(Map<String, String> chkMap) {
		
		int chk = dao.chkReservation(chkMap);
		
		return chk;
		
	} // end of public int chkReservation(Map<String, String> chkMap) {


	
	// 리뷰를 작성했는지 안했는지 확인하기
	@Override
	public int chkReview(Map<String, String> chkMap) {
		
		int chk = dao.chkReview(chkMap);
		
		return chk;
		
	} // end of public int chkReview(Map<String, String> chkMap) {


	
	// 숙소 상세 댓글 수정하기
	@Override
	public int updateLodgingComment(Map<String, String> paraMap) {
		
		int n = dao.updateLodgingComment(paraMap);
		
		return n;
		
	} // end of public int updateLodgingComment(Map<String, String> paraMap) { 


	
	// 숙소 리뷰 삭제하기
	@Override
	public int deleteLodgingComment(String review_code) {
		
		int n = dao.deleteLodgingComment(review_code);
		
		return n;
		
	} // end of public int deleteLodgingComment(String review_code) {


	
	// 숙소 리뷰 작성하기
	@Override
	public int addLodgingReview(ReviewVO rvo) {
		
		int n = dao.addLodgingReview(rvo);
		
		return n;
		
	} // end of public int addLodgingReview(ReviewVO rvo) { 

	
	// 같은 지역구분 맛집 랜덤추천해주기
	@Override
	public FoodstoreVO getRandomFood(String local_status) {
		
		FoodstoreVO fvo = dao.getRandomFood(local_status);
		
		return fvo;
		
	} // end of public FoodstoreVO getRandomFood(String local_status) {


	// 같은 지역구분 즐길거리 랜덤추천해주기
	@Override
	public PlayVO getRandomPlay(String local_status) {
		
		PlayVO pvo = dao.getRandomPlay(local_status);
		
		return pvo;
		
	} // end of public PlayVO getRandomPlay(String local_status) {


	
	// 한 숙소에 대해 좋아요를 눌렀는지 안눌렀는지
	@Override
	public int getLodgingLike(Map<String, String> chkMap) {
		
		int n = dao.getLodgingLike(chkMap);
		
		return n;
		
	} // end of public int getLodgingLike(Map<String, String> chkMap) {


	// 한 숙소에 대한 좋아요 취소하기
	@Override
	public int lodgingCancelAddLike(Map<String, String> paraMap) {
		
		int n = dao.lodgingCancelAddLike(paraMap);
		
		return n;
	} // end of public int lodgingCancelAddLike(Map<String, String> paraMap) { 


	// 한 숙소에 대한 좋아요 추가하기
	@Override
	public int lodgingAddLike(Map<String, String> paraMap) {

		int n = dao.lodgingAddLike(paraMap);
		
		return n;
	} // end of public int lodgingAddLike(Map<String, String> paraMap) { 


	
	// 숙소 예약시 일정테이블에 insert
	@Override
	public int insertLodgingSchedule(Map<String, String> paraMap) {
		
		int n = dao.insertLodgingSchedule(paraMap);
		
		return n;
		
	} // end of public int insertLodgingSchedule(Map<String, String> paraMap) {


	
	// 한 숙소에대한 객실 등록하기
	@Override
	public int insertRoomDetail(RoomDetailVO rvo) {
		
		int n = dao.insertRoomDetail(rvo);
		
		return n;
		
	} // end of public int insertRoomDetail(RoomDetailVO rvo) {


	// 객실등록 채번해오기
	@Override
	public String getRoomDetailSeq() {
		
		String room_seq = dao.getRoomDetailSeq();
		
		return room_seq;
		
	} // end of public String getRoomDetailSeq() {


	// 등록한 숙소개수가 몇개인지 알아오기
	@Override
	public int getRoomCnt(String fk_lodging_code) {
		
		int n = dao.getRoomCnt(fk_lodging_code);
		
		return n;
		
	} // end of public int getRoomCnt(String fk_lodging_code) { 


	
	// 등록된 객실정보 가져오기
	@Override
	public List<RoomDetailVO> getForUpdateRoomList(String fk_lodging_code) {
		
		List<RoomDetailVO> roomList = dao.getForUpdateRoomList(fk_lodging_code);
		
		return roomList;
		
	} // end of public List<RoomDetailVO> getForUpdateRoomList(String fk_lodging_code) { 


	// 객실 수정하기
	@Override
	public int updateRoomDetail(RoomDetailVO rvo) {
		
		int n = dao.updateRoomDetail(rvo);
		
		return n;
		
	} // end of public int updateRoomDetail(RoomDetailVO rvo) {


	// 수정할때 객실 삭제하기
	@Override
	public int deleteRoomDetail(String room_detail_code) {
		
		int n = dao.deleteRoomDetail(room_detail_code);
		
		return n;
		
	} // end of public int deleteRoomDetail(String room_detail_code) {


	// 숙소정보 수정하기
	@Override
	public int updateLodging(LodgingVO lvo) {
		
		int n = dao.updateLodging(lvo);
		
		return n;
		
	} // end of public int updateLodging(LodgingVO lvo) {


	
	// 숙소에 해당하는 편의시설 정보 삭제하기 (트랜잭션 처리로 )
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int deleteInsertLodgingConvenient(Map<String, String> paraMap) throws Throwable{
		
		int n1=0, n2 =0;
		
		// 트랜잭션 1 (존재하는 숙소에 대한 편의시설 정보 삭제하기)
		n1 = dao.t_deleteLodgingConvenient(paraMap.get("fk_lodging_code"));
		
		if(n1 > 0) {
			
			String[] arr_convenient = paraMap.get("str_convenient").split(",");
			
			Map<String, Object> arr_Map = new HashMap<>(); 
			
	        arr_Map.put("lodging_code", paraMap.get("fk_lodging_code"));

	        // 트랜잭션 2 (숙소에 대한 편의시설 정보 insert하기)
	        for (String convenientCode : arr_convenient) {
	        	
	            arr_Map.put("convenient_code", convenientCode);
	            
	            n2 += dao.t_insertLodgingConvenient(arr_Map);
	            
	        } // end of for
					
		} // end of if
		
		return n1 * n2;
		
	} // end of public int deleteInsertLodgingConvenient(Map<String, String> paraMap) {


	
	// 숙소 정보 삭제하기
	@Override
	public int deleteLodgingInfo(String lodging_code) {
		
		int n = dao.deleteLodgingInfo(lodging_code);
		
		return n;
		
	} // end of public int deleteLodgingInfo(String lodgingCode) {


	// ==== Spring Scheduler(스프링 스케줄러)를 사용한 email 발송하기 ====
    // <주의> 스케줄러로 사용되어지는 메소드는 반드시 파라미터가 없어야 한다.!!!!
    // 고객들의 email 주소는 List<String(e메일주소)> 으로 만들면 된다.
    // 또는 e메일 자동 발송 대신에 휴대폰 문자를 자동 발송하는 것도 가능하다.
	@Override
	@Scheduled(cron="0 50 20 * * *")
	public void reservationEmailSending() throws Exception {
		
		// !!! <주의> !!!
	    // 스케줄러로 사용되어지는 메소드는 반드시 파라미터는 없어야 한다.!!!!!
		
		// ==== e메일을 발송할 회원 대상 알아오기 ==== 
		List<Map<String,String>> reservationList = dao.getReservationList();
		
		// **** e메일 발송하기 **** //
		if(reservationList != null && reservationList.size() > 0) {
			
			String[] arr_reservationCode = new String[reservationList.size()]; // 밖에서 선언하면 null포인트 뜰수 있어서 if 안에다가
			// String[] arr_reservationSeq 을 생성하는 이유는 
            // e메일 발송 후 tbl_reservation 테이블의 mailSendCheck 컬럼의 값을 0 에서 1로 update 하기 위한 용도로 
            // update 되어질 예약번호를 기억하기 위한 것임.
			
			
			for(int i=0; i<reservationList.size(); i++) {
				
				String emailContents = 
					    "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
					    + "<h2 style='color: #0056b3;'>예약 확인</h2>"
					    + "<p>안녕하세요, " + reservationList.get(i).get("user_name") + "님,</p>"
					    + "<p>예약해주신 체크인일자가 1일 남았습니다!</p>"
					    + "<table style='border-collapse: collapse; width: 100%;'>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px; font-weight: bold;'>사용자 ID:</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px;'>" + reservationList.get(i).get("userid") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px; font-weight: bold;'>예약자명:</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px;'>" + reservationList.get(i).get("user_name") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px; font-weight: bold;'>방문 예약일:</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px; color: red;'>" + reservationList.get(i).get("check_in") + "</td>"
					    + "  </tr>"
					    + "</table>"
					    + "<p>예약 변경이나 취소를 원하시면 고객 센터로 연락해 주시기 바랍니다.</p>"
					    + "<p>감사합니다.</p>"
					    + "</div>";
				
				mail.sendmail_Reservation(aES256.decrypt(reservationList.get(i).get("email")), emailContents);
				
				arr_reservationCode[i] = reservationList.get(i).get("reservation_code");
				
			} // end of for
			
			// e메일을 발송한 행은 발송했다는 표시해주기 
	        Map<String, String[]> paraMap = new HashMap<>();
	    
	        // paraMap.putIfAbsent(key, value); ==> 맵에 동일한key값이 없을때만 넣어주고 있으면 덮어씌우지않는다.
	        
	        paraMap.put("arr_reservationCode", arr_reservationCode);
	        
	        // 이메일 발송하고나서 메일체크 update
	        dao.updateMailSendCheck(paraMap); 
	        
			
		} // end of if(reservationList != null && reservationList.size() > 0) { 
		
	}// end of public void reservationEmailSending() throws Exception { 


	
	// db에서 sysdate에 해당하는 축제가져오기
	@Override
	public List<Map<String, String>> getCurrentFestival() {
		
		List<Map<String, String>> festivalList = dao.getCurrentFestival();
		
		return festivalList;
		
	} // end of public List<Map<String, String>> getCurrentFestival() {


	
	// 글 작성일이 3일이내인 조회수 높은 커뮤니티 글목록 가져오기
	@Override
	public List<BoardVO> getPopularBoard() {
		
		List<BoardVO> popularBoardList = dao.getPopularBoard();
		
		return popularBoardList;
		
	} // end of public List<BoardVO> getPopularBoard() {


	// 회원이 예약신청한 상세정보 가져오기
	@Override
	public Map<String, String> getMemberReservationInfo(String reservation_code) {
		
		Map<String, String> memberReserveInfo = dao.getMemberReservationInfo(reservation_code);
		
		return memberReserveInfo;
		
	} // end of public List<Map<String, String>> getMemberReservationInfo(String reservation_code) {


	// 회원이 직접 예약취소상태 만들기
	@Override
	public int memberCancelReserve(String reservation_code) {
		
		int n = dao.memberCancelReserve(reservation_code);
		
		return n;
		
	} // end of public int memberCancelReserve(String reservation_code) {


	// 가격슬라이더 최대가격을 위한 숙소 최대가격 구해오기
	@Override
	public int getLodgingMaxPirce() {
		
		int price = dao.getLodgingMaxPirce();
		
		return price;
		
	} // end of public int getLodgingMaxPirce() {


	



	

	
	
}   
