package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.FoodstoreVO;

public interface Yj_TripService {

	// == 맛집 리스트 페이지 보이기 == //
	List<FoodstoreVO> viewFoodstoreList(Map<String, Object> map);
	
	// == 맛집 랜덤 추천 == //
	List<FoodstoreVO> randomRecommend(Map<String, String> paraMap);

	// == 맛집 총 개수 알아오기 == //
	int getTotalCount(Map<String, Object> map);

	// == 맛집 상세 조회하기 == //
	FoodstoreVO viewfoodstoreDetail(String food_store_code);

	// == 맛집 상세 추가 이미지 == //
	List<Map<String, String>> viewfoodaddImg(String food_store_code);

	
	
	
	
	// == 검색어 입력시 자동글 완성하기 == //
	//List<String> wordSearchShow(String searchWord);

	



}
