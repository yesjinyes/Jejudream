package com.spring.app.trip.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.app.trip.service.Yj_TripService;

@Controller
public class Yj_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Yj_TripService service;
	

	// === 커뮤니티 메인 페이지 보이기 === //
	@GetMapping("/community_main.trip")
	public String community_main(HttpServletRequest request) {
		
//		String ctxPath = request.getContextPath();
//		System.out.println("ctxPath => " + ctxPath);
		
		return "community/community_main"; 
		// /WEB-INF/views/community/community_main.jsp 파일 생성
	}
	// 수정

}
