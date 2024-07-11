package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;

public interface Hs_TripDAO {
	
	List<PlayVO> playList();//즐길거리 List

	List<PlayVO> getPlayListByCategory(Map<String, Object> paraMap);//카테고리별 list 불러오기

	int registerPlayEnd(PlayVO playvo);// 즐길거리 등록 [관리자]

	int getPlayTotalCount(Map<String, Object> paraMap);// 페이징 처리를 위한 즐길거리 수량

	PlayVO goAddSchedule(String play_code);// 즐길거리 디테일 페이지 
	
	int addReview(ReviewVO reviewvo);//즐길거리 리뷰작성
	
	List<ReviewVO> reviewList(Map<String, String> paraMap);//즐길거리 리뷰보여주기
	
	int getPlayReviewCount(Map<String, String> paraMap);//즐길거리 리뷰 총수량 알아오기
	
	int updateReview(Map<String, String> paraMap);//즐길거리 리뷰 수정하기
	
	int reviewDel(String review_code);//즐길거리 리뷰 삭제하기

	PlayVO getPlaySelect(Map<String, String> paraMap); //즐길거리 글 한개 조회하기

	int editEnd(PlayVO playvo);//즐길거리 수정
	
	int increase_readCount(String play_code); //조회수 증가 

	int delReview(Map<String, String> paraMap); //원글 삭제 전 댓글삭제

	int delView(Map<String, String> paraMap); //댓글 삭제 후 원글 삭제

	

	

}