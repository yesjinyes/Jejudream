package com.spring.app.trip.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.model.Hs_TripDAO;
@Service
public class Hs_TripService_imple implements Hs_TripService {
	
	@Autowired
	private Hs_TripDAO dao;
	
	
	//즐길거리 List
	@Override
	public List<PlayVO> playList() {
		List<PlayVO> playList = dao.playList();
		return playList;
	}
	
	


	@Override
	public List<PlayVO> getPlayListByCategory(Map<String, Object> paraMap) {
		List<PlayVO> platList = dao.getPlayListByCategory(paraMap);
		return platList;
	}

	//즐길거리 등록 
	@Override
	public int registerPlayEnd(PlayVO playvo) {
		int n = dao.registerPlayEnd(playvo);
		return n;
	}


	@Override
	public int getPlayTotalCount(Map<String, Object> paraMap) {
		int n = dao.getPlayTotalCount(paraMap);
		return n;
	}


	@Override
	public PlayVO goAddSchedule(String play_code) {
		PlayVO goAddSchedule = dao.goAddSchedule(play_code);
		return goAddSchedule;
	}



	//리뷰작성
	@Override
	public int addReview(ReviewVO reviewvo) {
		int n = dao.addReview(reviewvo);
		return n;
	}



	//리뷰 보여주기
	@Override
	public List<ReviewVO> reviewList(Map<String, String> paraMap) {
		List<ReviewVO> reviewList = dao.reviewList(paraMap);
		return reviewList;
	}



	//리뷰 총수량 알아오기
	@Override
	public int getPlayReviewCount(Map<String, String> paraMap) {
		int getPlayReviewCount =dao.getPlayReviewCount(paraMap);
		return getPlayReviewCount;
	}



	//리뷰수정하기
	@Override
	public int updateReview(Map<String, String> paraMap) {
		int n = dao.updateReview(paraMap);
		return n;
	}

	//리뷰삭제하기
	@Override
	public int reviewDel(String review_code) {
		int n = dao.reviewDel(review_code);
		return n;
	}


	

}