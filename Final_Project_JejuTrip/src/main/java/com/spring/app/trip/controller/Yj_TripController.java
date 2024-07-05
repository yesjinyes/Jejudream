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
		
		return "community/communityMain.tiles1"; 
	}

	
	// == 맛집 리스트 페이지 보이기  == //
	@GetMapping("/foodstoreList.trip")
	public ModelAndView foodstoreList(ModelAndView mav, HttpServletRequest request, FoodstoreVO foodstorevo,
									  @RequestParam(defaultValue="") String str_category,
									  @RequestParam(defaultValue="") String str_area,
									  @RequestParam(defaultValue="") String orderType, 
									  @RequestParam(defaultValue="") String orderValue_asc,
									  @RequestParam(defaultValue="") String orderValue_desc) {
		
		//List<String> categoryList = service.categoryList(); // 상단 맛집 카테고리
		//List<String> areaList = service.areaList(); // 지역 선택
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		Map<String, Object> map = new HashMap<>();
		
		
/*		// 카테고리 체크박스 복수 선택 //
		if(!"".equals(str_category)) {
			String[] arr_category = str_category.split("\\,");
			map.put("arr_category", arr_category);
			mav.addObject("str_category", str_category);
		}
		
		// 지역 체크박스 복수 선택 //
		if(!"".equals(str_area)) {
			String[] arr_area = str_area.split("\\,");
			map.put("arr_area", arr_area);
			mav.addObject("str_area", str_area);
		}
*/		
		
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
		String searchWord = request.getParameter("searchWord");
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		map.put("searchWord", searchWord);
		
		
		
		//////////////////////////////////////////////////////////////////////////////
		
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트
		List<FoodstoreVO> randomRecommend = service.randomRecommend(paraMap); // 맛집 랜덤 추천
		
		mav.addObject("searchWord", searchWord);
		//mav.addObject("categoryList", categoryList);
		//mav.addObject("areaList", areaList);
		
		mav.addObject("foodstoreList", foodstoreList);
		mav.addObject("randomRecommend", randomRecommend);
		
		mav.setViewName("foodstore/foodstoreList.tiles1");
	       
        return mav;
		
	}
	
	
	// 카테고리, 지역검색  Ajax 처리
	@ResponseBody
	@GetMapping(value="foodstoreListJSON.trip", produces="text/plain;charset=UTF-8")
	public String foodstoreListJSON(HttpServletRequest request,
								   @RequestParam(defaultValue="") String str_category,
								   @RequestParam(defaultValue="") String str_area) {
		
		Map<String, Object> map = new HashMap<>(); // 검색내용 담을 Map
		
		if(!"".equals(str_category)) { // 넘어온 부서번호 str_deptId 가 "" 아닐 경우 (있을 경우)
			// sql 문에서 in 절을 사용하려면 배열이 꼭! 있어야 하므로 배열로 다시 만들어준다.
			String[] arr_category = str_category.split("\\,");
			map.put("arr_category", arr_category); // Map 속에 들어갈 것이 String[] 타입이니까 위에 Map 선언할 때도 똑같이 맞춰줘야 한다.
		}
		
		if(!"".equals(str_area)) { // 넘어온 부서번호 gender 가 "" 아닐 경우 (있을 경우)
			// sql 문에서 in 절을 사용하려면 배열이 꼭! 있어야 하므로 배열로 다시 만들어준다.
			String[] arr_area = str_area.split("\\,");
			map.put("arr_area", arr_area); // Map 속에 들어갈 것이 String[] 타입인데 둘 다 받아야 하니까 Object 로 받아준다.
		}
		
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map);
		
		JSONArray jsonArr = new JSONArray();
	      
		for(FoodstoreVO storevo : foodstoreList) {
		     
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("food_store_code", storevo.getFood_store_code()); // Mapper HashMap 에 있는 key 값을 가져온 것이다.
			jsonObj.put("food_main_img", storevo.getFood_main_img());
			jsonObj.put("food_name", storevo.getFood_name());
			jsonObj.put("food_content", storevo.getFood_content());
			jsonObj.put("food_category", storevo.getFood_category());
			jsonObj.put("food_address", storevo.getFood_address());
			     
			jsonArr.put(jsonObj);
		}// end of for--------------------------------
		
		System.out.println(jsonArr.toString());
		
		
		return jsonArr.toString();
	}
	
	
	
	
	
	
	
	
	
	// 검색어 입력시 자동글 완성하기
/*	@ResponseBody
	@GetMapping(value="/wordSearchShow.action", produces="text/plain;charset=UTF-8")
	public String wordSearchShow(HttpServletRequest request) {
		
		String searchWord = request.getParameter("searchWord");
		
		List<String> wordList = service.wordSearchShow(searchWord);
		
		JSONArray jsonArr = new JSONArray();

		if(wordList != null) {
			for(String word :wordList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("word", word);
				jsonArr.put(jsonObj); //[{},{},..]
			}// end of for--------
		}

		return jsonArr.toString();
	}
*/
	
	

	
	

}
