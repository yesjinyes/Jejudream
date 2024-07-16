package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.ReviewVO;

public interface Yj_TripDAO {

	
	// == 맛집 리스트 페이지 보이기 == //
	List<FoodstoreVO> viewFoodstoreList(Map<String, Object> map);

	// == 맛집 총 개수 알아오기 == //
	int getTotalCount(Map<String, Object> map);
	
	// == 맛집 랜덤 추천 == //
	List<FoodstoreVO> randomRecommend(Map<String, Object> map);

	//////////////////////////////////////////////////////////////////////////
	
	// == 맛집 상세 조회하기 == //
	FoodstoreVO viewfoodstoreDetail(Map<String, String> paraMap);

	// == 맛집 상세 추가 이미지 == //
	List<Map<String, String>> viewfoodaddImg(Map<String, String> paraMap);

	// == 좋아요 총 개수 알아오기 == //
	int countFoodlike(Map<String, String> paraMap);

	// == 좋아요 여부 알아오기 == //
	List<FoodstoreVO> checkLike(Map<String, String> paraMap);
	
	// == 좋아요 추가 == //
	int addLike(Map<String, String> paraMap);

	// == 좋아요 취소 == //
	void deleteLike(Map<String, String> paraMap);

	
	//////////////////////////////////////////////////////////////////////////
	
	// == 맛집 리뷰 쓰기 == //
	int addFoodstoreReview(ReviewVO reviewvo);

	// == 작성한 리뷰 보이기 == //
	List<ReviewVO> getReviewList(String parent_code);

	// === 리뷰 수정하기 === //
	int updateReview(Map<String, String> paraMap);

	// == 리뷰 삭제하기 == //
	int deleteReview(String review_code);

	// == 리뷰 총 개수 구하기 == //
	int getReviewTotalCount(String parent_code);

	

	

	

} 
