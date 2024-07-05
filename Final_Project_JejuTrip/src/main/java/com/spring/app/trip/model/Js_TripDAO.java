package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.LodgingVO;


public interface Js_TripDAO {

	List<Map<String, String>> lodgingList(Map<String, Object> paraMap);

	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	int getLodgingTotalCount(Map<String, Object> paraMap);

}
