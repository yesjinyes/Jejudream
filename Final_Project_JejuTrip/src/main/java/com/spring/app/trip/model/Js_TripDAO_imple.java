package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.domain.RoomDetailVO;


@Component
@Repository	
public class Js_TripDAO_imple implements Js_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 조건에 따른 숙소리스트 select 해오기
	@Override
	public List<Map<String,String>> lodgingList(Map<String, Object> paraMap) {
		
		List<Map<String,String>> lodgingList = sqlsession.selectList("js_trip.lodgingList" , paraMap);
		return lodgingList;
	}

	
	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	@Override
	public int getLodgingTotalCount(Map<String, Object> paraMap) {
		
		int totalCount = sqlsession.selectOne("js_trip.getLodgingTotalCount", paraMap);
		
		// System.out.println("totalCount : " + totalCount);
		
		return totalCount;
		
	} // end of public int getLodgingTotalCount(Map<String, String> paraMap) {} 


	// 숙소리스트에 표현할 편의시설 목록 구해오기
	@Override
	public List<Map<String,String>> getConvenientList(String lodging_code) {
		
		List<Map<String,String>> convenientList = sqlsession.selectList("js_trip.getConvenientList", lodging_code);
		
		return convenientList;
		
	} // end of public List<String> getConvenientList() { 


	// 숙소의상세정보만 가져오기
	@Override
	public LodgingVO getLodgingDetail(String lodgingCode) {
		
		LodgingVO lodgingDetail = sqlsession.selectOne("js_trip.getLodgingDetail",lodgingCode);
		
		return lodgingDetail;
	} // end of public LodgingVO getLodgingDetail(String lodgingCode) {


	// 숙소의 객실 정보 가져오기
	@Override
	public List<Map<String, String>> getRoomDetail(Map<String, String> dateSendMap) {
		
		List<Map<String, String>> roomDetailList = sqlsession.selectList("js_trip.getRoomDetail", dateSendMap);
		
		return roomDetailList;
		
	} // end of public List<Map<String, String>> getRoomDetail(String lodgingCode) { 


	
	// 결제페이지에서 예약하려하는 객실정보 가져오기
	@Override
	public Map<String, String> getReserveRoomDetail(Map<String, String> paraMap) {
		
		Map<String, String> roomDetail = sqlsession.selectOne("js_trip.getReserveRoomDetail", paraMap);
		
		return roomDetail;
		
	} // end of public Map<String, String> getReserveRoomDetail(Map<String, String> paraMap) {


	// 예약결과 예약번호 표현을 위한 채번해오기
	@Override
	public String getReservationNum() {
		
		String num = sqlsession.selectOne("js_trip.getReservationNum");
		
		return num;
	} // end of public String getReservationNum() { 
	
	
	// 결제 후 예약테이블에 insert 하기
	@Override
	public int insertReservation(Map<String, String> paraMap) {
		
		int n = sqlsession.insert("js_trip.insertReservation", paraMap);
		
		return n;
		
	}// end of public int insertReservation(Map<String, String> paraMap) {


	
	// 예약완료된 정보 가져오기
	@Override
	public Map<String, String> getReservationInfo(Map<String, String> paraMap) {
		
		Map<String, String> resultMap = sqlsession.selectOne("js_trip.getReservationInfo",paraMap);
		
		return resultMap;
		
	} // end of public Map<String, String> getReservationInfo(Map<String, String> paraMap) {


	
	// 댓글 페이징 처리를 위한 토탈 카운트 구해오기
	@Override
	public int getCommentTotalCount(String lodging_code) {
		
		int totalCount = sqlsession.selectOne("js_trip.getLodgingReviewTotalCount",lodging_code);
		
		return totalCount;
		
	} // end of public int getCommentTotalCount(String lodging_code) {


	
	// 리뷰리스트 가져오기
	@Override
	public List<Map<String, String>> getCommentList_Paging(Map<String, String> paraMap) {
		
		List<Map<String, String>> reviewList = sqlsession.selectList("js_trip.getLodgingReviewList_Paging", paraMap);
		
		return reviewList;
		
	} // end of public List<Map<String, String>> getCommentList_Paging(Map<String, String> paraMap) {

	
	
	// 숙소상세페이지 이동시에 예약했는지 확인하기
	@Override
	public int chkReservation(Map<String, String> chkMap) {
		
		int chk = sqlsession.selectOne("js_trip.chkReservation", chkMap);
		
		return chk;
		
	} // end of 


	
	// 리뷰를 작성했는지 안했는지 확인하기
	@Override
	public int chkReview(Map<String, String> chkMap) {
		
		int chk = sqlsession.selectOne("js_trip.chkReview", chkMap);
		
		return chk;
		
	} // end of public int chkReview(Map<String, String> chkMap) {


	
	// 숙소 상세 댓글 수정하기
	@Override
	public int updateLodgingComment(Map<String, String> paraMap) {
		
		int n = sqlsession.update("js_trip.updateLodgingComment", paraMap);
		
		return n;
		
	} // end of public int updateLodgingComment(Map<String, String> paraMap) {


	// 숙소 리뷰 삭제하기
	@Override
	public int deleteLodgingComment(String review_code) {
		
		int n = sqlsession.delete("js_trip.deleteLodgingComment", review_code);
		
		return n;
		
	} // end of public int deleteLodgingComment(String review_code) {


	
	// 숙소 리뷰 작성하기
	@Override
	public int addLodgingReview(ReviewVO rvo) {
		
		int n = sqlsession.insert("js_trip.addLodgingReview", rvo);
		
		return n;
		
	} // end of public int addLodgingReview(ReviewVO rvo) {

	
	
	// 같은 지역구분 맛집 랜덤추천해주기
	@Override
	public FoodstoreVO getRandomFood(String local_status) {
		
		FoodstoreVO fvo = sqlsession.selectOne("js_trip.getRandomFood", local_status);
		
		return fvo;
		
	} // end of public FoodstoreVO getRandomFood(String local_status) {


	// 같은 지역구분 즐길거리 랜덤추천해주기
	@Override
	public PlayVO getRandomPlay(String local_status) {
		
		PlayVO pvo = sqlsession.selectOne("js_trip.getRandomPlay", local_status);
		
		return pvo;
		
	} // end of public PlayVO getRandomPlay(String local_status) {


	// 한 숙소에 대해 좋아요를 눌렀는지 안눌렀는지 
	@Override
	public int getLodgingLike(Map<String, String> chkMap) {
		
		int n = sqlsession.selectOne("js_trip.getLodgingLike", chkMap);
		
		return n;
		
	} // end of public int getLodgingLike(Map<String, String> chkMap) {


	// 한 숙소에 대한 좋아요 취소하기
	@Override
	public int lodgingCancelAddLike(Map<String, String> paraMap) {
		
		int n = sqlsession.delete("js_trip.lodgingCancelAddLike", paraMap);
		
		return n;
	} // end of public int lodgingCancelAddLike(Map<String, String> paraMap) { 


	// 한 숙소에 대한 좋아요 추가하기
	@Override
	public int lodgingAddLike(Map<String, String> paraMap) {

		int n = sqlsession.insert("js_trip.lodgingAddLike", paraMap);
		
		return n;
	} // end of public int lodgingAddLike(Map<String, String> paraMap) { 


	
	// 숙소 예약시 일정테이블에 insert
	@Override
	public int insertLodgingSchedule(Map<String, String> paraMap) {
		
		int n = sqlsession.insert("js_trip.insertLodgingSchedule", paraMap);
		
		return n;
		
	} // end of public int insertLodgingSchedule(Map<String, String> paraMap) { 


	
	// 한 숙소에대한 객실 등록하기
	@Override
	public int insertRoomDetail(RoomDetailVO rvo) {
		
		int n = sqlsession.insert("js_trip.insertRoomDetail",rvo);
		
		return n;
		
	} // end of public int insertRoomDetail(RoomDetailVO rvo) {


	
	// 객실등록 채번해오기
	@Override
	public String getRoomDetailSeq() {
		
		String room_seq = sqlsession.selectOne("js_trip.getRoomDetailSeq");
		
		return room_seq;
		
	} // end of public String getRoomDetailSeq() {


	// 등록한 숙소개수가 몇개인지 알아오기
	@Override
	public int getRoomCnt(String fk_lodging_code) {
		
		int n = sqlsession.selectOne("js_trip.getRoomCnt", fk_lodging_code);
		
		return n;
		 
	} // end of public int getRoomCnt(String fk_lodging_code) {


	// 등록된 객실정보 가져오기
	@Override
	public List<RoomDetailVO> getForUpdateRoomList(String fk_lodging_code) {
		
		List<RoomDetailVO> roomList = sqlsession.selectList("js_trip.getForUpdateRoomList", fk_lodging_code);
		
		return roomList;
		
	} // end of public List<RoomDetailVO> getForUpdateRoomList(String fk_lodging_code) { 


	
	// 객실 수정하기
	@Override
	public int updateRoomDetail(RoomDetailVO rvo) {
		
		int n = sqlsession.update("js_trip.updateRoomDetail", rvo);
		
		return n;
		
	} // end of public int updateRoomDetail(RoomDetailVO rvo) {


	// 수정할때 객실 삭제하기
	@Override
	public int deleteRoomDetail(String room_detail_code) {
		
		int n = sqlsession.delete("js_trip.deleteRoomDetail", room_detail_code);
		
		return n;
		
	} // end of public int deleteRoomDetail(String room_detail_code) {


	
	// 숙소정보 수정하기
	@Override
	public int updateLodging(LodgingVO lvo) {
		
		int n = sqlsession.update("js_trip.updateLodging", lvo);
		
		return n;
		
	} // end of public int updateLodging(LodgingVO lvo) {


	
	// 트랜잭션 1 (존재하는 숙소에 대한 편의시설 정보 삭제하기)
	@Override
	public int t_deleteLodgingConvenient(String fk_lodging_code) {
		
		int n = sqlsession.delete("js_trip.t_deleteLodgingConvenient", fk_lodging_code);
		
		return n;
		
	} // end of public int t_deleteLodgingConvenient(String fk_lodging_code) {


	
	// 트랜잭션 2 (숙소에 대한 편의시설 정보 insert하기)
	@Override
	public int t_insertLodgingConvenient(Map<String, Object> arr_Map) {
		
		int n = sqlsession.insert("js_trip.t_insertLodgingConvenient", arr_Map);
		
		return n;
		
	} // end of public int t_insertLodgingConvenient(Map<String, String> paraMap) {


	
	// 숙소 정보 삭제하기
	@Override
	public int deleteLodgingInfo(String lodging_code) {
		
		int n = sqlsession.delete("js_trip.deleteLodgingInfo", lodging_code);
		
		return n;
		
	} // end of public int deleteLodgingInfo(String lodgingCode) {


	// ==== e메일을 발송할 회원 대상 알아오기 ==== 
	@Override
	public List<Map<String, String>> getReservationList() {
		
		List<Map<String, String>> reservationEmailList = sqlsession.selectList("js_trip.reservationEmailList");
		
		return reservationEmailList;
		
	} // end of public List<Map<String, String>> getReservationList() {


	
	// 이메일 발송하고나서 메일체크 update
	@Override
	public void updateMailSendCheck(Map<String, String[]> paraMap) {
		
		sqlsession.update("js_trip.updateMailSendCheck", paraMap);
		
	} // end of public void updateMailSendCheck(Map<String, String[]> paraMap) {


	// db에서 sysdate에 해당하는 축제가져오기
	@Override
	public List<Map<String, String>> getCurrentFestival() {
		
		List<Map<String, String>> festivalList = sqlsession.selectList("js_trip.getCurrentFestival");
		
		return festivalList;
		
	} // end of public List<Map<String, String>> getCurrentFestival() { 


	
	// 글 작성일이 3일이내인 조회수 높은 커뮤니티 글목록 가져오기
	@Override
	public List<BoardVO> getPopularBoard() {
		
		List<BoardVO> popularBoardList = sqlsession.selectList("js_trip.getPopularBoard");
		
		return popularBoardList;
		
	} // end of public List<BoardVO> getPopularBoard() {


	// 회원이 예약신청한 상세정보 가져오기
	@Override
	public Map<String, String> getMemberReservationInfo(String reservation_code) {
		
		Map<String, String> memberReserveInfo = sqlsession.selectOne("js_trip.getMemberReservationInfo", reservation_code);
		
		return memberReserveInfo;
		
	} // end of public List<Map<String, String>> getMemberReservationInfo(String reservation_code) {


	// 회원이 직접 예약취소상태 만들기
	@Override
	public int memberCancelReserve(String reservation_code) {
		
		int n = sqlsession.update("js_trip.memberCancelReserve", reservation_code);
		
		return n;
		
	} // end of public int memberCancelReserve(String reservation_code) {


	// 가격슬라이더 최대가격을 위한 숙소 최대가격 구해오기
	@Override
	public int getLodgingMaxPirce() {
		
		int price = sqlsession.selectOne("js_trip.getLodgingMaxPirce");
		
		return price;
		
	} // end of public int getLodgingMaxPirce() {

	
	


	
	
	 
	
	
	
}
