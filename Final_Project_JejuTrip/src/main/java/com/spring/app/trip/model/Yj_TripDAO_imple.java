package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

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

	
	// == 맛집 메인 페이지 보이기 == //
	@Override
	public List<FoodstoreVO> viewFoodstoreList(Map<String, Object> map) {
		List<FoodstoreVO> foodstoreList = sqlsession.selectList("yj_trip.viewFoodstoreList", map);
		return foodstoreList;
	}


	// == 맛집 랜덤 추천 == //
	@Override
	public List<FoodstoreVO> randomRecommend(Map<String, String> paraMap) {
		List<FoodstoreVO> randomRecommend = sqlsession.selectList("yj_trip.randomRecommend", paraMap);
		return randomRecommend;
	}


	// == 맛집 총 개수 알아오기 == //
	@Override
	public int getTotalCount(Map<String, Object> map) {
		int totalCount = sqlsession.selectOne("yj_trip.getTotalCount", map);
		return totalCount;
	}


	// == 맛집 상세 조회하기 == //
	@Override
	public FoodstoreVO viewfoodstoreDetail(String food_store_code) {
		FoodstoreVO foodstorevo = sqlsession.selectOne("yj_trip.viewfoodstoreDetail", food_store_code);
		return foodstorevo;
	}


	// == 맛집 상세 추가 이미지 == //
	@Override
	public List<Map<String, String>> viewfoodaddImg(String food_store_code) {
		List<Map<String, String>> addimgList = sqlsession.selectList("yj_trip.viewfoodaddImg", food_store_code);
		return addimgList;
	}


	// == 검색어 입력시 자동글 완성하기 == //
//	@Override
//	public List<String> wordSearchShow(String searchWord) {
//		List<String> wordList = sqlsession.selectList("yj_trip.wordSearchShow", searchWord);
//		return wordList;
//	}


	


	
	
	
}
