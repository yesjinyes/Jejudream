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
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		List<FoodstoreVO> randomRecommend = service.randomRecommend(paraMap); // 맛집 랜덤 추천
		
		mav.addObject("randomRecommend", randomRecommend);
		
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
		
		List<FoodstoreVO> foodstoreList = null;
		
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
		// == 페이징 처리 == //
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		int totalCount = 0;         // 총 게시물 건수
		int sizePerPage = 4;       // 한 페이지에 보여줄 게시물 수
		int currentShowPageNo = 0;  // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. (지금은 0) 
		int totalPage = 0;          // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) (게시글이 87개라면 9페이지)

		totalCount = service.getTotalCount(map);
		
		// System.out.println("## 확인용 totalCount => " + totalCount); // 20
		
		totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		
		if(str_currentShowPageNo == null) { 
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1; // 1페이지를 보여준다.
				}
			} catch (NumberFormatException e) {
				currentShowPageNo = 1;
			}
		}// end of if(str_currentShowPageNo == null)~else----------------
		
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        map.put("startRno", String.valueOf(startRno));
        map.put("endRno", String.valueOf(endRno));
		
        
		foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트
		
		//System.out.println("foodstoreList 길이 : " + foodstoreList.size());
		
		// 패이지바 만들기
		int blockSize = 3;
		int loop = 1;
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "foodstoreList.trip";
		
		
		
		
		
		
		
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
				     
				jsonArr.put(jsonObj);
			}// end of for--------------------------------.
			
		}
		
		//System.out.println(jsonArr.toString());
		
		return jsonArr.toString();
	}
	
	
	// == 맛집 상세 페이지 보이기 == //
	@GetMapping("foodstoreDetail.trip")
	public ModelAndView foodstoreDetail(ModelAndView mav, HttpServletRequest request) {
		
		String food_store_code = request.getParameter("food_store_code");
		// System.out.println("## 확인용 => "+ food_store_code);

		List<Map<String, String>> addimgList = service.viewfoodaddImg(food_store_code); // 맛집 상세 추가 이미지
		FoodstoreVO foodstorevo = service.viewfoodstoreDetail(food_store_code); // 맛집 상세 페이지
		
		
		mav.addObject("addimgList", addimgList);
 		mav.addObject("foodstorevo", foodstorevo);
		
 		mav.setViewName("foodstore/foodstoreDetail.tiles1");
 		
 		
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
