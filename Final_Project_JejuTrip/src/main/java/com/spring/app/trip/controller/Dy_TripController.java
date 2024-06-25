package com.spring.app.trip.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.app.trip.service.Dy_TripService;

@Controller
public class Dy_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Dy_TripService service;
	
	// 회원가입
	@GetMapping("memberRegister.trip")
	public String memberRegister() {
		
		return "member/memberRegister";
		// /WEB-INF/views/member/memberRegister.jsp
	}

}
