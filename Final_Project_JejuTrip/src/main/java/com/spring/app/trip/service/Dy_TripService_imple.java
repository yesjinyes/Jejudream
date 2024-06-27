package com.spring.app.trip.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.model.Dy_TripDAO;

@Service
public class Dy_TripService_imple implements Dy_TripService {
	
	@Autowired
	private Dy_TripDAO dao;

}
