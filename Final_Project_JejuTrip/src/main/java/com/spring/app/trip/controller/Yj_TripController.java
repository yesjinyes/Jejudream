package com.spring.app.trip.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
	public ModelAndView foodstoreList(ModelAndView mav, FoodstoreVO foodstorevo,
									  @RequestParam(defaultValue="") String str_category,
									  @RequestParam(defaultValue="") String str_area,
									  @RequestParam(defaultValue="") String orderType, 
									  @RequestParam(defaultValue="") String orderValue_asc,
									  @RequestParam(defaultValue="") String orderValue_desc) {
		
		List<String> categoryList = service.categoryList(); // 상단 맛집 카테고리
		List<String> areaList = service.areaList(); // 지역 선택
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		Map<String, Object> map = new HashMap<>();
		
		if(!"".equals(str_category)) {
			String[] arr_category = str_category.split("\\,");
			map.put("arr_category", arr_category);
			mav.addObject("str_category", str_category);
		}
		
		if(!"".equals(str_area)) {
			String[] arr_area = str_area.split("\\,");
			map.put("arr_area", arr_area);
			mav.addObject("str_area", str_area);
		}
		
		if(!"".equals(orderValue_asc)) {
			map.put("orderType", orderType);
			map.put("orderValue_asc", orderValue_asc);
		}
		
		if(!"".equals(orderValue_desc)) {
			map.put("orderType", orderType);
			map.put("orderValue_desc", orderValue_desc);
		}
		
			
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트
		List<FoodstoreVO> randomRecommend = service.randomRecommend(paraMap); // 맛집 랜덤 추천
	
	
		
		
		
		mav.addObject("categoryList", categoryList);
		mav.addObject("areaList", areaList);
		
		mav.addObject("foodstoreList", foodstoreList);
		mav.addObject("randomRecommend", randomRecommend);
		
		mav.setViewName("foodstore/foodstoreList");
		
		return mav;
	}
	
	
/* 
	@ResponseBody
	@GetMapping("/foodstoreListJSON.trip")
	public String foodstoreListJSON(FoodstoreVO foodstorevo) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		Map<String, Object> map = new HashMap<>();
		
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트
	
		JSONArray jsonArr = new JSONArray();
		
		for(FoodstoreVO store : foodstoreList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("food_store_code", store.getFood_store_code());
			jsonObj.put("food_category", store.getFood_category());
			jsonObj.put("food_name", store.getFood_name());
			jsonObj.put("food_content", store.getFood_content());
			jsonObj.put("food_main_img", store.getFood_main_img());
			jsonObj.put("local_status", store.getLocal_status());
			jsonObj.put("food_address", store.getFood_address());
			
			jsonArr.put(jsonObj);
		}// end of for-------------
		
		System.out.println("!!확인용 jsonArr => " + jsonArr.toString());
		
		return jsonArr.toString();
	}
*/	
	
	
	
	
	
	
	

	
	

}
