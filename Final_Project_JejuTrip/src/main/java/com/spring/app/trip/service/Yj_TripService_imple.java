package com.spring.app.trip.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.model.Yj_TripDAO;



@Service
public class Yj_TripService_imple implements Yj_TripService {
	
	@Autowired
	private Yj_TripDAO dao;

}
