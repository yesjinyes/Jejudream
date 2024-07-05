package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.PlayVO;

public interface Hs_TripService {
	//즐길거리 List
	List<PlayVO> playList();

	List<PlayVO> playList(Map<String, Object> paraMap);
	List<PlayVO> getPlayListByCategory(Map<String, Object> paraMap);

	int registerPlayEnd(PlayVO playvo);

	int getPlayTotalCount(Map<String, Object> paraMap);

	

}
