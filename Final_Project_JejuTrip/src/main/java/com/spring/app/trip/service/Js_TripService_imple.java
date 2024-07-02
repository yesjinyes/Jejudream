package com.spring.app.trip.service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.model.Js_TripDAO;

@Service
public class Js_TripService_imple implements Js_TripService {
	
	@Autowired
	private Js_TripDAO dao;

	@Override
	public List<LodgingVO> lodgingList() {
		
		List<LodgingVO> lodgingList = dao.lodgingList();
		
		return lodgingList;
	}

}
