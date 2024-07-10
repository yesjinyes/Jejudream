package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.ReviewVO;

public interface Yj_TripService {

	// == 맛집 리스트 페이지 보이기 == //
	List<FoodstoreVO> viewFoodstoreList(Map<String, Object> map);

	// == 맛집 총 개수 알아오기 == //
	int getTotalCount(Map<String, Object> map);
	
	// == 맛집 랜덤 추천 == //
	List<FoodstoreVO> randomRecommend(Map<String, Object> map);

	/////////////////////////////////////////////////////////////////////////////
	
	// == 맛집 상세 조회하기 (조회수 증가 X) == //
	FoodstoreVO viewfoodstoreDetail(Map<String, String> paraMap);

	// == 맛집 상세 추가 이미지 == //
	List<Map<String, String>> viewfoodaddImg(Map<String, String> paraMap);

	// == 맛집 리뷰 쓰기 == //
	int addFoodstoreReview(ReviewVO reviewvo);

	// == 작성한 리뷰 보이기 == //
	List<ReviewVO> getReviewList(String parent_code);



	
	



}
