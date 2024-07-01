package com.spring.app.trip.controller;

import javax.servlet.http.HttpServletRequest;

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
	
	// 가입하려는 기업 아이디가 존재하는 아이디인지 사용가능한 아이디인지 검사하는 메소드
	@ResponseBody
	@PostMapping("/companyIdCheck.trip")
	public String companyIdCheck(HttpServletRequest request) {
		String companyid = request.getParameter("companyid");
		int n = service.companyIdCheck(companyid); // 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드 생성
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	}// end of public String companyRegisterEnd(CompanyVO cvo) {
	
	// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	@ResponseBody
	@PostMapping("companyEmailCheck.trip")
	public String companyEmailCheck(HttpServletRequest request) {
		String email = request.getParameter("email");
		int n = service.companyEmailCheck(email); // 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	}// end of public String companyRegisterEnd(CompanyVO cvo) {
	
	
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
