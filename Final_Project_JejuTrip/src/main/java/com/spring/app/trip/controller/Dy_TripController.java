package com.spring.app.trip.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.app.trip.service.Dy_TripService;

@Controller
public class Dy_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Dy_TripService service;
	
	// 회원가입 페이지 요청
	@GetMapping("memberRegister.trip")
	public String memberRegister() {
		
		return "member/memberRegister";
		// /WEB-INF/views/member/memberRegister.jsp
	}
	
	
	// 로그인 페이지 요청
	@GetMapping("login.trip")
	public String login() {
		
		return "login/login";
		// /WEB-INF/views/login/login.jsp
	}
	
	
	// 아이디 찾기 페이지 요청
	@GetMapping("idFind.trip")
	public String idFind() {
		
		return "login/idFind";
		// /WEB-INF/views/login/idFind.jsp
	}
	
	
	// 비밀번호 찾기 페이지 요청
	@GetMapping("pwFind.trip")
	public String pwFind() {
		
		return "login/pwFind";
		// /WEB-INF/views/login/pwFind.jsp
	}
	

}
