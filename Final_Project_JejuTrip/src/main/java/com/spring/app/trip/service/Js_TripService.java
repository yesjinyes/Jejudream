package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.RoomDetailVO;


public interface Js_TripService {

	// 조건에 따른 숙소리스트 select 해오기
	List<Map<String, String>> lodgingList(Map<String, Object> paraMap);

	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	int getLodgingTotalCount(Map<String, Object> paraMap);

	// 숙소리스트에 표현할 편의시설 목록 구해오기
	List<String> getConvenientList();

	// 숙소의 상세정보만 가져오기
	LodgingVO getLodgingDetail(String lodgingCode);

	// 숙소의 객실 정보 가져오기
	List<Map<String, String>> getRoomDetail(String lodgingCode);

	// 결제페이지에서 예약하려하는 객실정보 가져오기 
	Map<String, String> getReserveRoomDetail(Map<String, String> paraMap);

	// 결제 후 예약테이블에 insert 하기
	int insertReservation(Map<String, String> paraMap);
	

}
