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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.ReviewVO;
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
							    @RequestParam(defaultValue="") String orderValue_desc,
							    @RequestParam(defaultValue="") String currentShowPageNo) {
		
		// System.out.println("currentShowPageNo 확인 !!" + currentShowPageNo);

		// 페이징 처리
		int sizePerPage = 7; //한페이지당 7개의 맛집
		
		Map<String, Object> map = new HashMap<>();
		
		if("".equals(currentShowPageNo) || currentShowPageNo == null) {
	    	currentShowPageNo="1";
		}
	    
	    int startRno = ((Integer.parseInt(currentShowPageNo)- 1) * sizePerPage) + 1; // 시작 행번호 
	    int endRno = startRno + sizePerPage - 1; // 끝 행번호
	    
	    map.put("startRno",String.valueOf(startRno) );
	    map.put("endRno",String.valueOf(endRno));
		
		
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
		
		map.put("currentShowPageNo", currentShowPageNo); 

		//////////////////////////////////////////////////////////////////////////////
		
		// 맛집 전체개수
	    int totalCount = service.getTotalCount(map);
	    // System.out.println("totalCount => "+totalCount);
	    
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트(조회수 증가X)
		//System.out.println("foodstoreList 길이 : " + foodstoreList.size());
		
		List<FoodstoreVO> randomRecommend = service.randomRecommend(map); // 맛집 랜덤 추천
		// System.out.println("~~~ 확인용 randomRecommend => "+ randomRecommend.size());
		
		//////////////////////////////////////////////////////////////////////////////
		
		JSONArray jsonArr = new JSONArray();
	    
		// 맛집 리스트에서 상세페이지 조회하는 경우
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
				
				jsonObj.put("totalCount", totalCount); //총 페이지 
            	jsonObj.put("currentShowPageNo", currentShowPageNo); // 현재페이지
            	jsonObj.put("sizePerPage", sizePerPage); // 한페이지당 보여줄 개수
				
				jsonArr.put(jsonObj);
			}// end of for--------------------------------.
		}
		
		// 맛집 랜덤 추천에서 상세페이지 조회하는 경우
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
		
//		System.out.println("-------------------------------------------------------");
//		System.out.println("## 확인용 food_store_code => "+ food_store_code);
//		System.out.println("## 확인용 random_recommend_code => "+ random_recommend_code);
		
		paraMap.put("food_store_code", food_store_code); // 맛집 리스트에서 상세 페이지로 넘어가기
		paraMap.put("random_recommend_code", random_recommend_code); // 맛집 추천에서 상세 페이지로 넘어가기
		
		FoodstoreVO foodstorevo = service.viewfoodstoreDetail(paraMap); // 맛집 상세 페이지 띄우기
		
//		String food_name =  foodstorevo.getFood_name();
//		System.out.println("food_name 확인 =>" + food_name);
		
	
		List<Map<String, String>> addimgList = service.viewfoodaddImg(paraMap); // 맛집 상세 추가 이미지
		
		mav.addObject("foodstorevo", foodstorevo);
		
 		mav.addObject("addimgList", addimgList);
		
 		mav.setViewName("foodstore/foodstoreDetail.tiles1");
		
 		return mav;
	}
	
	
	// == 리뷰 쓰기 == //
	@ResponseBody
	@PostMapping(value="/addReview.trip", produces="text/plain;charset=UTF-8")
	public String addComment(ReviewVO reviewvo, HttpServletRequest request) {

		int n = 0;
		
		try {
			n = service.addFoodstoreReview(reviewvo); // 리뷰쓰기
		
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
		jsonObj.put("fk_userid", reviewvo.getFk_userid());
		
		System.out.println("### jsonObj 확인 : "+ jsonObj.toString());
		
		return jsonObj.toString();
	}
	

	
	// == 작성한 리뷰 보이기 == //
	@ResponseBody
	@GetMapping(value="/foodstoreReviewList.trip", produces="text/plain;charset=UTF-8")
	public String foodstoreReviewList(ReviewVO reviewvo, HttpServletRequest request) {
		
		String parent_code = request.getParameter("parent_code");
		
		// 작성한 리뷰 보이기
		List<ReviewVO> reviewList = service.getReviewList(parent_code);
		
		JSONArray jsonArr = new JSONArray();
		
		if(reviewList != null) {
			for(ReviewVO rvo : reviewList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("review_code", rvo.getReview_code());
				jsonObj.put("fk_userid", rvo.getFk_userid());
				jsonObj.put("parent_code", rvo.getParent_code());
				jsonObj.put("review_content", rvo.getReview_content());
				jsonObj.put("registerday", rvo.getRegisterday());
				
				jsonArr.put(jsonObj);
			}// end of for------------------
			
		}
		System.out.println("~~~리뷰 List jsonArr 확인 => "+jsonArr.toString());
		
		return jsonArr.toString();
		
	}
	
	
	
	
	

}
