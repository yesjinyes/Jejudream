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


	// == 맛집 총 개수 알아오기 == //
	@Override
	public int getTotalCount(Map<String, Object> map) {
		int totalCount = dao.getTotalCount(map);
		return totalCount;
	}


	// == 맛집 상세 조회하기 == //
	@Override
	public FoodstoreVO viewfoodstoreDetail(String food_store_code) {
		FoodstoreVO foodstorevo = dao.viewfoodstoreDetail(food_store_code);
		return foodstorevo;
	}


	// == 맛집 상세 추가 이미지 == //
	@Override
	public List<Map<String, String>> viewfoodaddImg(String food_store_code) {
		List<Map<String, String>> addimgList = dao.viewfoodaddImg(food_store_code);
		return addimgList;
	}


	// == 검색어 입력시 자동글 완성하기 == //
//	@Override
//	public List<String> wordSearchShow(String searchWord) {
//		List<String> wordList = dao.wordSearchShow(searchWord);
//		return wordList;
//	}







}
