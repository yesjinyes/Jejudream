package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.Calendar_schedule_VO;
import com.spring.app.trip.domain.LikeVO;
import com.spring.app.trip.domain.MemberVO;
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

	List<LikeVO> checkLike(Map<String, String> paraMap);//좋아요했는지 알아오기

	int likeAdd(Map<String, String> paraMap);// 좋아요 업데이트

	void likeDel(Map<String, String> paraMap); //좋아요 취소

	int countLike(Map<String, String> paraMap); //좋아요 총수량

	//카테고리 count 
	int countTotal();
	int countTourism();
	int countShowing();
	int countExperience();

	List<MemberVO> searchPlayJoinUserList(String joinUserName);//일행 추가를 위한 유저 ID select

	int registerPlaySchedule_end(Map<String, String> paraMap); //일정추가

	List<Calendar_schedule_VO> checkSchedule(Map<String, String> paraMap); //일정추가했는지알아오기


	

	

}