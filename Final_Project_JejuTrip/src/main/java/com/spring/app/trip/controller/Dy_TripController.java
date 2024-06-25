package com.spring.app.trip.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.spring.app.trip.service.Dy_TripService;

@Controller
public class Dy_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Dy_TripService service;
	
	// DY 푸시 확인용 주석

}
