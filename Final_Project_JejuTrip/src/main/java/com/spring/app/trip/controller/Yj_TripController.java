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
	@GetMapping("communityMain.trip")
	public String communityMain() {
		
		return "community/communityMain.tiles1"; 
	}
	
	
	
	// == 맛집 메인 페이지 보이기 == //
	@GetMapping("foodstoreList.trip")
	public ModelAndView foodstoreList(ModelAndView mav, FoodstoreVO foodstorevo) {
		
		mav.setViewName("foodstore/foodstoreList.tiles1");
		
		return mav;
	}
	
	
	
	// == 맛집 메인 페이지 Ajax 처리  == //
	@ResponseBody
	@GetMapping(value="foodstoreListJSON.trip", produces="text/plain;charset=UTF-8")
	public String foodstoreListJSON(HttpServletRequest request,
							    @RequestParam(defaultValue="") String str_category,
							    @RequestParam(defaultValue="") String str_area,
							    @RequestParam(defaultValue="") String searchWord,
							    @RequestParam(defaultValue="") String orderType, 
							    @RequestParam(defaultValue="") String orderValue_asc,
							    @RequestParam(defaultValue="") String orderValue_desc) {
		
		Map<String, Object> map = new HashMap<>();
		
		// 카테고리 체크박스
		if(!"".equals(str_category)) {
			String[] arr_category = str_category.split("\\,");
			map.put("arr_category", arr_category); 
		}
		
		// 지역 체크박스
		if(!"".equals(str_area)) {
			String[] arr_area = str_area.split("\\,");
			map.put("arr_area", arr_area);
		}
		
		// 오름차순 정렬 //
		if(!"".equals(orderValue_asc)) {
			map.put("orderType", orderType);
			map.put("orderValue_asc", orderValue_asc);
		}
		
		// 내림차순 정렬 //
		if(!"".equals(orderValue_desc)) {
			map.put("orderType", orderType);
			map.put("orderValue_desc", orderValue_desc);
		}
		
		// 검색하기 //
		if(searchWord == null) {
			searchWord = "";
		}
		 
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		map.put("searchWord", searchWord);

		//////////////////////////////////////////////////////////////////////////////
		
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트
		//System.out.println("foodstoreList 길이 : " + foodstoreList.size());
		
		List<FoodstoreVO> randomRecommend = service.randomRecommend(map); // 맛집 랜덤 추천
		// System.out.println("~~~ 확인용 randomRecommend => "+ randomRecommend.size());
		
		//////////////////////////////////////////////////////////////////////////////
		
		JSONArray jsonArr = new JSONArray();
	    
		if(foodstoreList != null) {
			
			for(FoodstoreVO storevo : foodstoreList) {
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("food_store_code", storevo.getFood_store_code()); // Mapper HashMap 에 있는 key 값을 가져온 것이다.
				jsonObj.put("food_main_img", storevo.getFood_main_img());
				jsonObj.put("food_name", storevo.getFood_name());
				jsonObj.put("food_content", storevo.getFood_content());
				jsonObj.put("food_category", storevo.getFood_category());
				jsonObj.put("food_address", storevo.getFood_address());
				jsonObj.put("status", 0);
				
				jsonArr.put(jsonObj);
			}// end of for--------------------------------.
		}
		
		if(randomRecommend != null) {
			
			for(FoodstoreVO storevo : randomRecommend) {
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("random_recommend_code", storevo.getFood_store_code()); // Mapper HashMap 에 있는 key 값을 가져온 것이다.
				jsonObj.put("food_main_img", storevo.getFood_main_img());
				jsonObj.put("food_name", storevo.getFood_name());
				jsonObj.put("food_content", storevo.getFood_content());
				jsonObj.put("food_category", storevo.getFood_category());
				jsonObj.put("food_address", storevo.getFood_address());
				jsonObj.put("status", 1);
				
				//System.out.println(jsonObj.toString());
				
				jsonArr.put(jsonObj);
			}// end of for--------------------------------.
		}
		
		// System.out.println(jsonArr.toString());
		
		return jsonArr.toString();
	}
	
	
	
	// == 맛집 상세 페이지 보이기 == //
	@GetMapping("foodstoreDetail.trip")
	public ModelAndView foodstoreDetail(ModelAndView mav, HttpServletRequest request,
										@RequestParam(defaultValue="") String random_recommend_code) {
		
		Map<String, String> paraMap = new HashMap<>();
		
		String food_store_code = request.getParameter("food_store_code");
		System.out.println("## 확인용 food_store_code => "+ food_store_code);
		System.out.println("## 확인용 random_recommend_code => "+ random_recommend_code);
		
		paraMap.put("food_store_code", food_store_code); // 맛집 리스트에서 상세 페이지로 넘어가기
		paraMap.put("random_recommend_code", random_recommend_code); // 맛집 추천에서 상세 페이지로 넘어가기
		
		FoodstoreVO foodstorevo = service.viewfoodstoreDetail(paraMap); // 맛집 상세 페이지 띄우기

		List<Map<String, String>> addimgList = service.viewfoodaddImg(food_store_code); // 맛집 상세 추가 이미지
		
 		mav.addObject("foodstorevo", foodstorevo);

 		mav.addObject("addimgList", addimgList);
		
 		mav.setViewName("foodstore/foodstoreDetail.tiles1");
 		
		return mav;
	}
		
	
	
	
	

	
	

}
