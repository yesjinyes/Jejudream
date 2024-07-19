package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

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
	public List<String> getConvenientList(String lodging_code) {
		
		List<String> convenientList = sqlsession.selectList("js_trip.getConvenientList", lodging_code);
		
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
		
		int totalCount = sqlsession.selectOne("js_trip.getCommentTotalCount",lodging_code);
		
		return totalCount;
		
	} // end of public int getCommentTotalCount(String lodging_code) {


	
	// 리뷰리스트 가져오기
	@Override
	public List<Map<String, String>> getCommentList_Paging(Map<String, String> paraMap) {
		
		List<Map<String, String>> reviewList = sqlsession.selectList("js_trip.getCommentList_Paging", paraMap);
		
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
	
	
	
	
}
