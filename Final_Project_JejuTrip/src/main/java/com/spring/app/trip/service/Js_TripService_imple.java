package com.spring.app.trip.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
   public List<String> getConvenientList(String lodging_code) {
	   
	   List<String> convenientList = dao.getConvenientList(lodging_code);
	   
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
	

	
	
}   
