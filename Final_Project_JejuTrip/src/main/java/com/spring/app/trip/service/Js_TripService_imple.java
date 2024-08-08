package com.spring.app.trip.service;


import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.common.usermodel.HyperlinkType;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Hyperlink;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

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
	@Scheduled(cron="0 20 11 * * *")
	public void reservationEmailSending() throws Exception {
		
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
					    + "    <td style='border: 1px solid #ddd; width:200px; text-align:center; padding: 8px; font-weight: bold;'>예약숙소명</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px;'>" + reservationList.get(i).get("lodging_name") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; width:200px; text-align:center; padding: 8px; font-weight: bold;'>예약객실명</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px;'>" + reservationList.get(i).get("room_name") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; width:200px; text-align:center; padding: 8px; font-weight: bold;'>예약자명</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px;'>" + reservationList.get(i).get("user_name") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; width:200px; text-align:center; padding: 8px; font-weight: bold;'>예약 체크인시간</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px; color: red;'>" + reservationList.get(i).get("check_in") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td style='border: 1px solid #ddd; width:200px; text-align:center; padding: 8px; font-weight: bold;'>예약 체크아웃시간</td>"
					    + "    <td style='border: 1px solid #ddd; padding: 8px; color: red;'>" + reservationList.get(i).get("check_out") + "</td>"
					    + "  </tr>"
					    + "  <tr>"
					    + "    <td colspan='2' style='border: 1px solid #ddd; padding: 8px; font-weight: bold;'><img src='http://127.0.0.1:9099/JejuDream/resources/images/lodginglist/room/"+reservationList.get(i).get("room_img") +"' style='width: 200px; height: 200px;'</td>"
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


	
	// 축제와 행사 엑셀파일 다운받기
	@Override
	public void festivalList_to_Excel(Model model) {
		
		// === 조회결과물인 empList 를 가지고 엑셀 시트 생성하기 ===
	    // 시트를 생성하고, 행을 생성하고, 셀을 생성하고, 셀안에 내용을 넣어주면 된다.
		
		// 엑셀세팅해주기 (workbook이 엑셀파일 자체를 의미한다)
		SXSSFWorkbook workbook = new SXSSFWorkbook();
		
		// 시트생성
	    SXSSFSheet sheet = workbook.createSheet("2024년축제와행사");
		
	    // 시트 열 너비 설정 (0부터 시작) ==> 일단은 열은 고정적이다
		sheet.setColumnWidth(0, 4000);
		sheet.setColumnWidth(1, 7000);
		sheet.setColumnWidth(2, 4000);
		sheet.setColumnWidth(3, 3000);
		sheet.setColumnWidth(4, 3000);
		sheet.setColumnWidth(5, 15000);
		
		
		
		// 행의 위치를 나타내는 변수 
	    int rowLocation = 0;
	    
		////////////////////////////////////////////////////////////////////////////////////////
		// CellStyle 정렬하기(Alignment)
		// CellStyle 객체를 생성하여 Alignment 세팅하는 메소드를 호출해서 인자값을 넣어준다.
		// 아래는 HorizontalAlignment(가로)와 VerticalAlignment(세로)를 모두 가운데 정렬 시켰다.
	    
	    CellStyle mergeRowStyle = workbook.createCellStyle();
	    // (workbook이 엑셀파일 자체를 의미한다) 즉, 아래의 설정으로 엑셀파일의
	    
	    mergeRowStyle.setAlignment(HorizontalAlignment.CENTER);
	    // .setAlignment(HorizontalAlignment.CENTER) ==> 가로기준 가운데 정렬
	    
	    mergeRowStyle.setVerticalAlignment(VerticalAlignment.CENTER); 
	 // import org.apache.poi.ss.usermodel.VerticalAlignment 으로 해야함.
		// .setVerticalAlignment(VerticalAlignment.CENTER) ==> 세로기준 가운데 정렬
	    
	    
	    CellStyle headerStyle = workbook.createCellStyle();
	    
	    headerStyle.setAlignment(HorizontalAlignment.CENTER);
	    // .setAlignment(HorizontalAlignment.CENTER) ==> 가로기준 가운데 정렬
	    
	    headerStyle.setVerticalAlignment(VerticalAlignment.CENTER); 
	    // .setVerticalAlignment(VerticalAlignment.CENTER) ==> 세로기준 가운데 정렬
	    
	    
	    // CellStyle 배경색(ForegroundColor)만들기
        // setFillForegroundColor 메소드에 IndexedColors Enum인자를 사용한다.
        // setFillPattern은 해당 색을 어떤 패턴으로 입힐지를 정한다.
	    
	    // 엑셀 색채우기 스타일 설정하기 
	    mergeRowStyle.setFillForegroundColor(IndexedColors.GOLD.getIndex()); // IndexedColors.DARK_BLUE.getIndex() 는 색상(남색)의 인덱스값을 리턴시켜준다.
	    
	    // 엑셀 테두리 스타일 설정하기  (아래 세팅은 실선)
	    mergeRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    
	    
	    headerStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
	    
	    // 엑셀 테두리 스타일 설정하기  (아래 세팅은 실선)
	    headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    
	    
        // Cell 폰트(Font) 설정하기
        // 폰트 적용을 위해 POI 라이브러리의 Font 객체를 생성해준다.
        // 해당 객체의 세터를 사용해 폰트를 설정해준다. 대표적으로 글씨체, 크기, 색상, 굵기만 설정한다.
        // 이후 CellStyle의 setFont 메소드를 사용해 인자로 폰트를 넣어준다.
        
        Font mergeRowFont = workbook.createFont(); // import org.apache.poi.ss.usermodel.Font; 으로 한다.
        
        mergeRowFont.setFontName("나눔고딕"); // 엑셀 글씨체 설정하기
	    
        mergeRowFont.setFontHeight((short)500); // 엑셀 ?
        mergeRowFont.setColor(IndexedColors.WHITE.getIndex()); // 엑셀 글자색 설정하기
        mergeRowFont.setBold(true); // 엑셀 글자굵기 설정하기
        
        mergeRowStyle.setFont(mergeRowFont); // 위에 Font 선언하고 설정한 것을 style에다가 넣어준다.
        
        
        
        // CellStyle 테두리 Border
        // 테두리는 각 셀마다 상하좌우 모두 설정해준다.
        // setBorderTop, Bottom, Left, Right 메소드와 인자로 POI라이브러리의 BorderStyle 인자를 넣어서 적용한다.
	    headerStyle.setBorderTop(BorderStyle.THICK);
	    headerStyle.setBorderBottom(BorderStyle.THICK); // 선을 굵게
	    headerStyle.setBorderLeft(BorderStyle.THIN);	// 선을 얇게
	    headerStyle.setBorderRight(BorderStyle.THIN);
        
	    
	    // Cell Merge 셀 병합시키기
        /* 셀병합은 시트의 addMergeRegion 메소드에 CellRangeAddress 객체를 인자로 하여 병합시킨다.
           CellRangeAddress 생성자의 인자로(시작 행, 끝 행, 시작 열, 끝 열) 순서대로 넣어서 병합시킬 범위를 정한다. 배열처럼 시작은 0부터이다.  
        */
        // 병합할 행 만들기
	    Row mergeRow = sheet.createRow(rowLocation);  // 엑셀에서 행의 시작은 0 부터 시작한다. (import org!!!)
	    // 즉, 해당 시트에 0번째 행을 만드는것이다 
	    
	    
	    // 병합할 행에 "우리회사 사원정보" 로 셀을 만들어 셀에 스타일을 주기
	    for(int i=0; i<6; i++) {
	    // 여기서 8인 이유는 보여지는 컬럼갯수가 8이기 때문이다
	    	
	         Cell cell = mergeRow.createCell(i);
	         // 즉, 해당시트에 0번째 행의 셀을만든다(8개의 셀)  
	         cell.setCellStyle(mergeRowStyle);
	         // 그리고 아주위에서 설정한 셀스타일(가운데정렬 폰트 등등)을 적용시키는것이다!
	         cell.setCellValue("2024년 축제와 행사");
	         // 병합한 셀에다가 값을 넣는다
	         
	    }// end of for-------------------------
	    
	    // 셀 병합하기  (rowLocation은 0으로 세팅했었다!
	    sheet.addMergedRegion(new CellRangeAddress(rowLocation, rowLocation, 0, 5)); // 시작 행, 끝 행, 시작 열, 끝 열 
	    // rowLocation ==> 
	    ////////////////////////////////////////////////////////////////////////////////////////////////
	    
	    
	    // 헤더 행 생성
        Row headerRow = sheet.createRow(++rowLocation); // 엑셀에서 행의 시작은 0 부터 시작한다.
                                                        // ++rowLocation는 전위연산자임.
        // 즉, 여기서 rowLocation이 1로 변경된다!!! 1번쨰(두번째)행이라는 뜻
        
     // 해당 행의 첫번째 열 셀 생성
        Cell headerCell = headerRow.createCell(0); // 엑셀에서 열의 시작은 0 부터 시작한다.
        headerCell.setCellValue("축제등록번호");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 두번째 열 셀 생성
        headerCell = headerRow.createCell(1);
        headerCell.setCellValue("축제 및 행사명");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 세번째 열 셀 생성
        headerCell = headerRow.createCell(2);
        headerCell.setCellValue("지역구분");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 네번째 열 셀 생성
        headerCell = headerRow.createCell(3);
        headerCell.setCellValue("시작날짜");
        headerCell.setCellStyle(headerStyle);
        
        
        // 해당 행의 다섯번째 열 셀 생성
        headerCell = headerRow.createCell(4);
        headerCell.setCellValue("종료날짜");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 여섯번째 열 셀 생성
        headerCell = headerRow.createCell(5);
        headerCell.setCellValue("상세링크");
        headerCell.setCellStyle(headerStyle);
        
        
        // 즉, 위에까지 순서는 구분할 부분의 스타일을 만들어놓고 세팅해주고, 셀을 만들고 만들어진 스타일을 적용시키고 값을 넣는다!!! (병합이 제일 마지막)
        
        
        // 삽입될 행에 적용할 스타일 생성
        CellStyle contentStyle = workbook.createCellStyle();
        
        contentStyle.setAlignment(HorizontalAlignment.CENTER);
	    // .setAlignment(HorizontalAlignment.CENTER) ==> 가로기준 가운데 정렬
	    
        contentStyle.setVerticalAlignment(VerticalAlignment.CENTER); 
	    // .setVerticalAlignment(VerticalAlignment.CENTER) ==> 세로기준 가운데 정렬
	    
        contentStyle.setWrapText(true); // 텍스트 줄 바꿈
        
        
        // ==== 축제및 행사 내용에 해당하는 행 및 셀 생성하기 ==== //
        Row bodyRow = null;
        Cell bodyCell = null;
        
        List<Map<String,String>> festivalList = dao.excel_to_festivalList();
        
        for(int i=0; i<festivalList.size(); i++) {
        	
        	Map<String, String> festivalMap = festivalList.get(i);
        	// 전체 축제와 행사목록 가져오기
        	
        	// 행생성
            bodyRow = sheet.createRow(i + (rowLocation+1));
            // 여기서는 첫 rowLocation이 2가된다 (즉, 내용이 들어갈 3번째 행) for문이라서 내용이 있는만큼 행이 증가된다!
            
            // 데이터 축제등록번호 표시
            bodyCell = bodyRow.createCell(0);
            bodyCell.setCellValue(festivalMap.get("festival_no"));
            bodyCell.setCellStyle(contentStyle);
            
            // 데이터 축제와행사명 표시
            bodyCell = bodyRow.createCell(1);
            bodyCell.setCellValue(festivalMap.get("title_name")); 
            bodyCell.setCellStyle(contentStyle);
            
            // 데이터 지역구분 표시
            bodyCell = bodyRow.createCell(2);
            bodyCell.setCellValue(festivalMap.get("local_status")); 
            bodyCell.setCellStyle(contentStyle);
            
            // 데이터 측제시작일자 표시
            bodyCell = bodyRow.createCell(3);
            bodyCell.setCellValue(festivalMap.get("startdate")); 
            bodyCell.setCellStyle(contentStyle);
            
            // 데이터 축제종료일자 표시
            bodyCell = bodyRow.createCell(4);
            bodyCell.setCellValue(festivalMap.get("enddate")); 
            bodyCell.setCellStyle(contentStyle);
            
            // 데이터 축제상세링크 표시
            
            Hyperlink link_article = workbook.getCreationHelper().createHyperlink(HyperlinkType.URL);
            link_article.setAddress(festivalMap.get("link"));
            
            bodyCell = bodyRow.createCell(5);
            bodyCell.setHyperlink(link_article);
            bodyCell.setCellValue(festivalMap.get("link"));
            bodyCell.setCellStyle(contentStyle);

        	
        } // end of for
        
        
        // 각 행과 셀의 데이터와 스타일 적용이 끝났다면	 model을 통해서 위 내용을 받아준다!
        model.addAttribute("locale", Locale.KOREA); // 얘만 import java.util!!!!!!!!!!
        model.addAttribute("workbook", workbook);
        model.addAttribute("workbookName", "2024년 제주도 축제와 행사");
        
		
	} // end of public void festivalList_to_Excel(Model model) {


	// 관리자가 보는 축제/행사 정보 가져오기
	@Override
	public List<Map<String, String>> adminFestivalList(Map<String,String> paraMap) {
		
		List<Map<String, String>> adminFestivalList = dao.adminFestivalList(paraMap);
		
		return adminFestivalList;
		
	} // end of public List<Map<String, String>> adminFestivalList() {


	
	// 관리자가 보는 축제/행사 개수 가져오기
	@Override
	public int getFestivalTotalCount(Map<String, String> paraMap) {
		
		int totalCount = dao.getFestivalTotalCount(paraMap);
		
		return totalCount;
		
	} // end of public int getFestivalTotalCount(Map<String, String> paraMap) {


	
	// 관리자가 등록하는 축제/행사
	@Override
	public int registerFestival(Map<String, String> paraMap) {
		
		int n = dao.registerFestival(paraMap);
		
		return n;
		
	} // end of public int registerFestival(Map<String, String> paraMap) {}


	// 관리자가 해당 축제 및 행사 삭제하기
	@Override
	public int adminDeleteFestival(String festival_no) {
		
		int n = dao.adminDeleteFestival(festival_no);
		
		return n;
		
	} // end of public int adminDeleteFestival(String festival_no) {


	// 관리자가 수정할려는 축제 및 행사 정보 가져오기
	@Override
	public Map<String, String> getEditFestivalInfo(String festival_no) {
		
		Map<String, String> resultMap = dao.getEditFestivalInfo(festival_no);
		
		return resultMap;
		
	} // end of public Map<String, String> getEditFestivalInfo(String festival_no) {


	
	// 관리자가 입력한 축제정보 DB 수정하기
	@Override
	public int updateFestival(Map<String, String> paraMap) {
		
		int n = dao.updateFestival(paraMap);
		
		return n;
		 
	} // end of public int updateFestival(Map<String, String> paraMap) {}


	



	

	
	
}   
