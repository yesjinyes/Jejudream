package com.spring.app.trip.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.domain.LikeVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.model.Hs_TripDAO;
@Service
public class Hs_TripService_imple implements Hs_TripService {
	
	@Autowired
	private Hs_TripDAO dao;
	
	//첨부파일 삭제를 위한 것
	@Autowired
	private FileManager fileManager;
	
	//즐길거리 List
	@Override
	public List<PlayVO> playList() {
		List<PlayVO> playList = dao.playList();
		return playList;
	}
	//카테고리별 list 불러오기
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

	//조회수 증가
	@Override
	public PlayVO goAddSchedule(String play_code) {
		
		PlayVO goAddSchedule = dao.goAddSchedule(play_code);
		
		int n = dao.increase_readCount(goAddSchedule.getPlay_code());
		if(n==1) {
			goAddSchedule.setReadCount(String.valueOf(Integer.parseInt(goAddSchedule.getReadCount())+1));
		}
		
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



	//글 한개 조회하기
	@Override
	public PlayVO getPlaySelect(Map<String, String> paraMap) {
		PlayVO getPlaySelect = dao.getPlaySelect(paraMap);
		return getPlaySelect;
	}




	@Override
	public int editEnd(PlayVO playvo) {
		int n=dao.editEnd(playvo);
		return n;
	}
	
	//글 삭제
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int delPlay(Map<String, String> paraMap) {
		
		// 댓글 삭제 시도
	    int n1 = dao.delReview(paraMap);
	    //System.out.println("n1 : " + n1);
	    
	    
	    // 원글 삭제
	    int n2 = dao.delView(paraMap);
	    if (n2 != 1) {
	        return 0; // 원글 삭제 실패 시 0 반환
	    }

	    // 파일 삭제
	    String fileName = paraMap.get("fileName");
	    String path = paraMap.get("path");
	    if (fileName != null && !"".equals(fileName)) {
	        try {
	            fileManager.doFileDelete(fileName, path);
	        } catch (Exception e) {
	            e.printStackTrace();
	            System.out.println("서비스 파일삭제 실패");
	            return 0; // 파일 삭제 실패 시 0 반환
	        }
	    }

	    return 1; // 모든 작업이 성공적으로 완료되면 1 반환

	}
	
	//좋아요를 했는지 알아오기
	@Override
	public List<LikeVO> checkLike(Map<String, String> paraMap) {
		
		List<LikeVO> checkLike = dao.checkLike(paraMap);  // int로 반환된 좋아요 상태 확인
	    
		System.out.println("checkLike : " + checkLike);
	    return checkLike;
	}
	@Override
	public int likeAdd(Map<String, String> paraMap) {
		int n = dao.likeAdd(paraMap);
		return n;
	}
	@Override
	public void likeDel(Map<String, String> paraMap) {
		dao.likeDel(paraMap);
	}
	
	//좋아요 총수량
	@Override
	public int countLike(Map<String, String> paraMap) {
		int countLike = dao.countLike(paraMap);
		return countLike;
	}
	
	
	///////카테고리 count/////////////
	@Override
	public int countTotal() {
	    return dao.countTotal();
	}

	@Override
	public int countTourism() {
	    return dao.countTourism();
	}

	@Override
	public int countShowing() {
	    return dao.countShowing();
	}

	@Override
	public int countExperience() {
	    return dao.countExperience();
	}
	
	//일행 추가를 위한 유저 ID select
	@Override
	public List<MemberVO> searchPlayJoinUserList(String joinUserName) {
		List<MemberVO> JoinUserList = dao.searchPlayJoinUserList(joinUserName);
		return JoinUserList;
	}
	
	//일정추가
	@Override
	public int registerPlaySchedule_end(Map<String, String> paraMap) {
		int n = dao.registerPlaySchedule_end(paraMap);
		return n;
	}
	
	
	


	

}