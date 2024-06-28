package com.spring.app.trip.controller;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.service.Ws_TripService;

@Controller
public class Ws_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Ws_TripService service;
	
	@GetMapping("/main.trip") 
	public ModelAndView readComment(ModelAndView mav) {
		
		mav.setViewName("main/main.tiles1");
		
		return mav;
	}

}
