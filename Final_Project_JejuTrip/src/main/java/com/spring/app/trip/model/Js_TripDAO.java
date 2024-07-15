package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.RoomDetailVO;


public interface Js_TripDAO {

	// 조건에 따른 숙소리스트 select 해오기
	List<Map<String, String>> lodgingList(Map<String, Object> paraMap);

	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	int getLodgingTotalCount(Map<String, Object> paraMap);

	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	List<String> getConvenientList(String lodging_code);

	// 숙소의상세정보만 가져오기
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

	

}
