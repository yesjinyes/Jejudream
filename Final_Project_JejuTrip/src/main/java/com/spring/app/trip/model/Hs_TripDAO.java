package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.PlayVO;

public interface Hs_TripDAO {
	//즐길거리 List
	List<PlayVO> playList();

	List<PlayVO> playList(Map<String, Object> paraMap);
	List<PlayVO> getPlayListByCategory(Map<String, Object> paraMap);

	int registerPlayEnd(PlayVO playvo);

	

}
