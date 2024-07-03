package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.FoodstoreVO;

public interface Yj_TripDAO {

	// == 맛집 카테고리 가져오기 == //
	 List<String> categoryList();

	// == 맛집 리스트 페이지 보이기 == //
	List<FoodstoreVO> viewFoodstoreList(Map<String, Object> map);

	// == 맛집 랜덤 추천 == //
	List<FoodstoreVO> randomRecommend(Map<String, String> paraMap);

	

} 
