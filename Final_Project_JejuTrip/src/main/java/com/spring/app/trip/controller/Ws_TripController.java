package com.spring.app.trip.controller;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.service.Ws_TripService;

@Controller
public class Ws_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Ws_TripService service;
	
	@GetMapping("/index.trip") 
	public ModelAndView readComment(ModelAndView mav) {
		
		mav.setViewName("main/main.tiles1");
		
		return mav;
	}
	
	// 회사 회원가입을 위한 ajax 메소드 생성
	@ResponseBody
	@PostMapping("/companyRegisterEnd.trip")
	public String companyRegisterEnd(CompanyVO cvo) {
		
		int n = service.companyRegister(cvo); // 회사 회원가입을 위한 service 메소드 생성
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		return jsonObj.toString();
		
	}

}
