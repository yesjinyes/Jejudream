package com.spring.app.trip.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.service.Yj_TripService;

@Controller
public class Yj_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Yj_TripService service;
	

	// === 커뮤니티 메인 페이지 보이기 === //
	@GetMapping("/communityMain.trip")
	public String communityMain() {
		
		return "community/communityMain"; 
		// /WEB-INF/views/community/communityMain.jsp 파일 생성
	}
	
/*	
	// === 맛집 리스트 페이지 보이기 === //
	@GetMapping("/foodStoreList.trip")
	public String foodStoreList() {
		
		return "foodStore/foodStoreList";
		// /WEB-INF/views/foodStore/foodStoreList.jsp 파일 생성
	}
*/	
	
	
	// === 맛집 리스트 페이지 보이기 === //
	@GetMapping("/foodStoreList.trip")
	public ModelAndView foodStoreList(ModelAndView mav) {
		
		List<FoodstoreVO> foodStoreList = service.viewFoodStoreList();
		
		mav.addObject("foodStoreList", foodStoreList);
		
		mav.setViewName("foodStore/foodStoreList");
		
		return mav;
		// /WEB-INF/views/foodStore/foodStoreList.jsp 파일 생성
	}
	
	// git test
	// git branch 확인
	

}
