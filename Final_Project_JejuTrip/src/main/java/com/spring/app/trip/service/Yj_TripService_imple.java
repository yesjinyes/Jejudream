package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.model.Yj_TripDAO;

@Service
public class Yj_TripService_imple implements Yj_TripService {
	
	@Autowired
	private Yj_TripDAO dao;

/*	
	// == 맛집 카테고리 가져오기 == //
	@Override
	public List<String> categoryList() {
		List<String> categoryList = dao.categoryList();
		return categoryList;
	}

	
	// == 지역 선택 == //
	@Override
	public List<String> areaList() {
		List<String> areaList = dao.areaList();
		return areaList;
	}
*/
	
	// == 맛집 리스트 페이지 보이기 == //
	@Override
	public List<FoodstoreVO> viewFoodstoreList(Map<String, Object> map) {
		List<FoodstoreVO> foodstoreList = dao.viewFoodstoreList(map);
		return foodstoreList;
	}
	
	
	// == 맛집 랜덤 추천 == //
	@Override
	public List<FoodstoreVO> randomRecommend(Map<String, String> paraMap) {
		List<FoodstoreVO> randomRecommend = dao.randomRecommend(paraMap);
		return randomRecommend;
	}


	// == 검색어 입력시 자동글 완성하기 == //
//	@Override
//	public List<String> wordSearchShow(String searchWord) {
//		List<String> wordList = dao.wordSearchShow(searchWord);
//		return wordList;
//	}







}
