package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;

public interface Hs_TripDAO {
	//즐길거리 List
	List<PlayVO> playList();

	List<PlayVO> getPlayListByCategory(Map<String, Object> paraMap);

	int registerPlayEnd(PlayVO playvo);

	int getPlayTotalCount(Map<String, Object> paraMap);

	PlayVO goAddSchedule(String play_code);
	//리뷰작성
	int addReview(ReviewVO reviewvo);
	//리뷰보여주기
	List<ReviewVO> reviewList(Map<String, String> paraMap);
	//리뷰 총수량 알아오기
	int getPlayReviewCount(Map<String, String> paraMap);
	//리뷰 수정하기
	int updateReview(Map<String, String> paraMap);
	//리뷰 삭제하기
	int reviewDel(String review_code);

	

	

}