package com.spring.app.trip.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	

	// == 커뮤니티 메인 페이지 보이기 == //
	@GetMapping("/communityMain.trip")
	public String communityMain() {
		
		return "community/communityMain"; 
		// /WEB-INF/views/community/communityMain.jsp 파일 생성
	}

	
	// == 맛집 리스트 페이지 보이기  == //
	@GetMapping("/foodstoreList.trip")
	public ModelAndView foodstoreList(ModelAndView mav, HttpServletRequest request, FoodstoreVO foodstorevo) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("food_main_img", foodstorevo.getFood_main_img());
		paraMap.put("food_name", foodstorevo.getFood_name());
		
		List<FoodstoreVO> randomRecommend = service.randomRecommend(paraMap); // 맛집 랜덤 추천
		List<FoodstoreVO> foodstoreList = service.viewFoodstoreList(); // 맛집 리스트 띄우기
		
//		List<String> stores = new ArrayList<>();
//		for(int i=0; i<foodstoreList.size(); i++) {
//			stores.add(foodstoreList.get(i).getFood_name());
//		}
		// System.out.println("stores 쌓여라 : " + stores);
		/*
		 	[돌집식당, 물꼬해녀의집, 성산일출봉 아시횟집, 대윤흑돼지 서귀포올레시장점, 제주 판타스틱버거, 
			  동백키친, 젠하이드어웨이 제주점, 영육일삼, 미도리제주, 구르메스시 오마카세, 강정중국집, 연태만, 
			  함덕중국집, 쏭타이 제주점, 위미애머물다락쿤, 인디언키친 본점, 서울앵무새 제주, 카페데스틸, 레이지펌프]
		 */
		
		mav.addObject("randomRecommend", randomRecommend);
		mav.addObject("foodstoreList", foodstoreList);
//		mav.addObject("stores", stores);
		
		mav.setViewName("foodstore/foodstoreList");
		// /WEB-INF/views/foodstore/foodstoreList.jsp 파일 생성
		
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
