package com.spring.app.trip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.model.Yj_TripDAO;
@Service
public class Yj_TripService_imple implements Yj_TripService {
	
	@Autowired
	private Yj_TripDAO dao;

	
	// === 맛집 리스트 페이지 보이기 === //
	@Override
	public List<FoodstoreVO> viewFoodstoreList() {
		List<FoodstoreVO> foodstoreList = dao.viewFoodstoreList();
		return foodstoreList;
	}


	
	// === 카테고리 선택에 따른 Ajax === //
	@Override
	public List<FoodstoreVO> viewCheckCategory(String food_category) {
		List<FoodstoreVO> foodstoreList = dao.viewCheckCategory(food_category);
		return foodstoreList;
	}

//	@Override
//	public List<FoodstoreVO> viewCheckCategory(String[] categoryArr) {
//		List<FoodstoreVO> foodstoreList = dao.viewCheckCategory(categoryArr);
//		return foodstoreList;
//	}
}
