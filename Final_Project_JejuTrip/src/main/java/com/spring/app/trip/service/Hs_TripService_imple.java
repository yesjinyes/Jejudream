package com.spring.app.trip.service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.model.Hs_TripDAO;
@Service
public class Hs_TripService_imple implements Hs_TripService {
	
	@Autowired
	private Hs_TripDAO dao;
	
	
	//즐길거리 List
	@Override
	public List<PlayVO> playList() {
		List<PlayVO> playList = dao.playList();
		return playList;
	}

}
