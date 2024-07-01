package com.spring.app.trip.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.FoodstoreVO;

@Repository
public class Yj_TripDAO_imple implements Yj_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	
	// === 맛집 리스트 페이지 보이기 === //
	@Override
	public List<FoodstoreVO> viewFoodstoreList() {
		List<FoodstoreVO> foodstoreList = sqlsession.selectList("yj_trip.viewFoodstoreList");
		return foodstoreList;
	}


	
	// === 카테고리 선택에 따른 Ajax === //
	@Override
	public List<FoodstoreVO> viewCheckCategory(String food_category) {
		List<FoodstoreVO> foodstoreList = sqlsession.selectList("yj_trip.viewCheckCategory", food_category);
		return foodstoreList;
	}
	
	
	
//	@Override
//	public List<FoodstoreVO> viewCheckCategory(String[] categoryArr) {
//		List<FoodstoreVO> foodstoreList = sqlsession.selectList("yj_trip.viewCheckCategory", categoryArr);
//		return foodstoreList;
//	}

	
	
}
