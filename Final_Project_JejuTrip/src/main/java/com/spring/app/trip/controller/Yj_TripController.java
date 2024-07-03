package com.spring.app.trip.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.service.Yj_TripService;

@Controller
public class Yj_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Yj_TripService service;
	

	// == 커뮤니티 메인 페이지 보이기 == //
	@GetMapping("/communityMain.trip")
	public String communityMain() {
		
		return "community/communityMain"; 
		// /WEB-INF/views/community/communityMain.jsp 파일 생성
	}

	
	// == 맛집 리스트 페이지 보이기  == //
	@GetMapping("/foodstoreList.trip")
	public ModelAndView foodstoreList(ModelAndView mav, HttpServletRequest request, FoodstoreVO foodstorevo,
									  @RequestParam(defaultValue="") String str_category) {
		
		List<String> categoryList = service.categoryList(); // 상단 카테고리 띄우기
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		Map<String, Object> map = new HashMap<>();
		
		if(!"".equals(str_category)) {
			String[] arr_category = str_category.split("\\,");
			map.put("arr_category", arr_category);
			mav.addObject("str_category", str_category);
		}
			
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트 띄우기
		List<FoodstoreVO> randomRecommend = service.randomRecommend(paraMap); // 맛집 랜덤 추천
	
		mav.addObject("categoryList", categoryList); // 
		mav.addObject("foodstoreList", foodstoreList);
		mav.addObject("randomRecommend", randomRecommend);
		
		mav.setViewName("foodstore/foodstoreList");
		
		return mav;
	}
	

	
	

/*
	// === 선택한 카테고리 맛집 보이기 (Ajax 로 처리) === //
	@ResponseBody
	@GetMapping(value="/viewCheckCategory.trip", produces="text/plain;charset=UTF-8")
	public String viewCheckCategory(HttpServletRequest request) {
		
//		String[] categoryArr = request.getParameterValues("categoryArr");
//		System.out.println("categoryArr 확인 : " + categoryArr);

		String food_category = request.getParameter("foodCategoryEach");
		System.out.println("categoryArr 확인 : " + food_category);
		
//		String food_category = request.getParameter("food_category");
//		System.out.println("food_category 확인 : "+ food_category);
		
		List<FoodstoreVO> foodstoreList = service.viewCheckCategory(food_category);
		
		JSONArray jsonArr = new JSONArray();
		
		for(FoodstoreVO foodvo : foodstoreList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("food_store_code", foodvo.getFood_store_code());
			jsonObj.put("food_main_img", foodvo.getFood_main_img());
			jsonObj.put("food_name", foodvo.getFood_name());
			jsonObj.put("food_content", foodvo.getFood_content());
			jsonObj.put("food_category", foodvo.getFood_category());
			jsonObj.put("food_address", foodvo.getFood_address());
			
			jsonArr.put(jsonObj);
		}// end of for--------------------------
		
		return jsonArr.toString();
	}
*/	
	

	
	
	
	

}
