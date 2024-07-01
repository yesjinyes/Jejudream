package com.spring.app.trip.service;

import java.util.List;

import com.spring.app.trip.domain.FoodstoreVO;

public interface Yj_TripService {

	// === 맛집 리스트 페이지 보이기 === //
	List<FoodstoreVO> viewFoodstoreList();


	// === 카테고리 선택에 따른 Ajax === //
	List<FoodstoreVO> viewCheckCategory(String food_category);
	// List<FoodstoreVO> viewCheckCategory(String[] categoryArr);

}
