package com.spring.app.trip.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.ReviewVO;
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


	// == 맛집 총 개수 알아오기 == //
	@Override
	public int getTotalCount(Map<String, Object> map) {
		int totalCount = dao.getTotalCount(map);
		return totalCount;
	}
	
	
	// == 맛집 랜덤 추천 == //
	@Override
	public List<FoodstoreVO> randomRecommend(Map<String, Object> map) {
		List<FoodstoreVO> randomRecommend = dao.randomRecommend(map);
		return randomRecommend;
	}

	//////////////////////////////////////////////////////////////////////////////////////

	// == 맛집 상세 조회하기 (조회수 증가 X) == //
	@Override
	public FoodstoreVO viewfoodstoreDetail(Map<String, String> paraMap) {
		FoodstoreVO foodstorevo = dao.viewfoodstoreDetail(paraMap);
		return foodstorevo;
	}

	
	// == 맛집 상세 추가 이미지 == //
	@Override
	public List<Map<String, String>> viewfoodaddImg(Map<String, String> paraMap) {
		List<Map<String, String>> addimgList = dao.viewfoodaddImg(paraMap);
		return addimgList;
	}


	// == 맛집 리뷰 쓰기 == //
	@Override
	public int addFoodstoreReview(ReviewVO reviewvo) {
		int n = dao.addFoodstoreReview(reviewvo); // 리뷰쓰기(tbl_review 에 insert)
		return n;
	}


	// == 작성한 리뷰 보이기 == //
	@Override
	public List<ReviewVO> getReviewList(String parent_code) {
		List<ReviewVO> reviewList = dao.getReviewList(parent_code);
		return reviewList;
	}


	// == 리뷰 수정하기 == //
	@Override
	public int updateReview(Map<String, String> paraMap) {
		int n = dao.updateReview(paraMap);
		return n;
	}


	// == 리뷰 삭제하기 == //
	@Override
	public int deleteReview(Map<String, String> paraMap) {
		int n = dao.deleteReview(paraMap.get("review_code"));
		return n;
	}

	





}
