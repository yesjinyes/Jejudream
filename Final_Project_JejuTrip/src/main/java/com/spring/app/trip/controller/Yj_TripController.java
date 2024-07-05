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
		
		List<String> categoryList = service.categoryList(); // 상단 맛집 카테고리
		List<String> areaList = service.areaList(); // 지역 선택
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		Map<String, Object> map = new HashMap<>();
		
		// 카테고리 체크박스 복수 선택 //
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
		mav.addObject("categoryList", categoryList);
		mav.addObject("areaList", areaList);
		
		mav.addObject("foodstoreList", foodstoreList);
		mav.addObject("randomRecommend", randomRecommend);
		
		mav.setViewName("foodstore/foodstoreList.tiles1");
	       
        return mav;
		
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
