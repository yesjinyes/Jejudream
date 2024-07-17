package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.domain.RoomDetailVO;


public interface Js_TripService {

	// 조건에 따른 숙소리스트 select 해오기
	List<Map<String, String>> lodgingList(Map<String, Object> paraMap);

	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	int getLodgingTotalCount(Map<String, Object> paraMap);

	// 숙소리스트에 표현할 편의시설 목록 구해오기
	List<String> getConvenientList(String lodging_code);

	// 숙소의 상세정보만 가져오기
	LodgingVO getLodgingDetail(String lodgingCode);

	// 숙소의 객실 정보 가져오기
	List<Map<String, String>> getRoomDetail(Map<String, String> dateSendMap);

	// 결제페이지에서 예약하려하는 객실정보 가져오기 
	Map<String, String> getReserveRoomDetail(Map<String, String> paraMap);

	// 예약결과 예약번호 표현을 위한 채번해오기
	String getReservationNum();
	
	// 결제 후 예약테이블에 insert 하기
	int insertReservation(Map<String, String> paraMap);

	// 예약완료된 정보 가져오기
	Map<String, String> getReservationInfo(Map<String, String> paraMap);

	// 댓글 페이징 처리를 위한 토탈 카운트 구해오기
	int getCommentTotalCount(String lodging_code);

	// 리뷰리스트 가져오기
	List<Map<String, String>> getCommentList_Paging(Map<String, String> paraMap);

	// 숙소상세페이지 이동시에 예약했는지 확인하기
	int chkReservation(Map<String, String> chkMap);

	// 리뷰를 작성했는지 안했는지 확인하기
	int chkReview(Map<String, String> chkMap);

	// 숙소 상세 댓글 수정하기
	int updateLodgingComment(Map<String, String> paraMap);

	// 숙소 리뷰 삭제하기
	int deleteLodgingComment(String review_code);
	
	// 숙소 리뷰 작성하기
	int addLodgingReview(ReviewVO rvo);
	
	// 같은 지역구분 맛집 랜덤추천해주기
	FoodstoreVO getRandomFood(String local_status);
	
	// 같은 지역구분 즐길거리 랜덤추천해주기
	PlayVO getRandomPlay(String local_status);

	// 한 숙소에 대해 좋아요를 눌렀는지 안눌렀는지
	int getLodgingLike(Map<String, String> chkMap);

	// 한 숙소에 대한 좋아요 취소하기
	int lodgingCancelAddLike(Map<String, String> paraMap);

	// 한 숙소에 대한 좋아요 추가하기
	int lodgingAddLike(Map<String, String> paraMap);

	// 숙소 예약시 일정테이블에 insert
	int insertLodgingSchedule(Map<String, String> paraMap);

	
	

}
