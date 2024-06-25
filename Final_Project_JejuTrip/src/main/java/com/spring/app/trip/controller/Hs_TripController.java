package com.spring.app.trip.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.spring.app.trip.service.Hs_TripService;

@Controller
public class Hs_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Hs_TripService service;
	
	

}
