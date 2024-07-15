package com.spring.app.trip.model;



import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.LikeVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
@Component
@Repository
public class Hs_TripDAO_imple implements Hs_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	//즐길거리 List
	@Override
	public List<PlayVO> playList() {
		List<PlayVO> playList = sqlsession.selectList("hs_trip.playList");
		return playList;
	}

	@Override
	public List<PlayVO> getPlayListByCategory(Map<String, Object> paraMap) {
		List<PlayVO> playList = sqlsession.selectList("hs_trip.getPlayListByCategory",paraMap);
		return playList;
	}

	@Override
	public int registerPlayEnd(PlayVO playvo) {
		int n = sqlsession.insert("hs_trip.registerPlayEnd",playvo);
		return n;
	}

	@Override
	public int getPlayTotalCount(Map<String, Object> paraMap) {
		int totalcount = sqlsession.selectOne("hs_trip.getPlayTotalCount",paraMap);
		return totalcount;
	}

	@Override
	public PlayVO goAddSchedule(String play_code) {
		PlayVO goAddSchedule = sqlsession.selectOne("hs_trip.goAddSchedule",play_code);
		return goAddSchedule;
	}

	@Override
	public int addReview(ReviewVO reviewvo) {
		int n = sqlsession.insert("hs_trip.addReview",reviewvo);
		return n;
	}
	//리뷰보여주기
	@Override
	public List<ReviewVO> reviewList(Map<String, String> paraMap) {
		List<ReviewVO> reviewList = sqlsession.selectList("hs_trip.reviewList",paraMap);
		return reviewList;
	}
	//리뷰 총수량 알아오기
	@Override
	public int getPlayReviewCount(Map<String, String> paraMap) {
		int getPlayReviewCount = sqlsession.selectOne("hs_trip.getPlayReviewCount",paraMap);
		return getPlayReviewCount;
	}
	
	//리뷰수정하기
	@Override
	public int updateReview(Map<String, String> paraMap) {
		int n = sqlsession.update("hs_trip.updateReview",paraMap);
		return n;
	}
	//리뷰삭제하기
	@Override
	public int reviewDel(String review_code) {
		int n = sqlsession.delete("hs_trip.reviewDel",review_code);
		return n;
	}
	
	//글 한개 조회하기
	@Override
	public PlayVO getPlaySelect(Map<String, String> paraMap) {
		PlayVO getPlaySelect = sqlsession.selectOne("hs_trip.getPlaySelect",paraMap);
		return getPlaySelect;
	}

	@Override
	public int editEnd(PlayVO playvo) {
		int n = sqlsession.update("hs_trip.editEnd",playvo);
		return n;
	}
	//조회수 증가
	@Override
	public int increase_readCount(String play_code) {
		int n = sqlsession.update("hs_trip.increase_readCount",play_code);
		return n;
	}
	//원글 삭제 전 리뷰삭제
	@Override
	public int delReview(Map<String, String> paraMap) {
		int n = sqlsession.delete("hs_trip.delReview",paraMap);
		return n;
	}
	//리뷰삭제 후 원글 삭제
	@Override
	public int delView(Map<String, String> paraMap) {
		int n = sqlsession.delete("hs_trip.delView",paraMap);
		return n;
	}

	@Override
	public List<LikeVO> checkLike(Map<String, String> paraMap) {
		List<LikeVO> checkLike = sqlsession.selectList("hs_trip.checkLike",paraMap);
		return checkLike;
	}

	@Override
	public int likeAdd(Map<String, String> paraMap) {
		int n = sqlsession.insert("hs_trip.likeAdd",paraMap);
		return n;
	}

	@Override
	public void likeDel(Map<String, String> paraMap) {
		sqlsession.delete("hs_trip.likeDel",paraMap);
		
	}
	
	@Override
	public int countLike(Map<String, String> paraMap) {
		int countLike = sqlsession.selectOne("hs_trip.countLike",paraMap);
		return countLike;
	}

	//카테고리 count
	public int countTotal() {
	    return sqlsession.selectOne("hs_trip.countTotal");
	}

	public int countTourism() {
	    return sqlsession.selectOne("hs_trip.countTourism");
	}

	public int countShowing() {
	    return sqlsession.selectOne("hs_trip.countShowing");
	}

	public int countExperience() {
	    return sqlsession.selectOne("hs_trip.countExperience");
	}

	//일행 추가를 위한 유저 ID select
	@Override
	public List<MemberVO> searchPlayJoinUserList(String joinUserName) {
		List<MemberVO> PlayJoinUserList = sqlsession.selectList("hs_trip.searchPlayJoinUserList",joinUserName);
		return PlayJoinUserList;
	}
	
	//일정추가
	@Override
	public int registerPlaySchedule_end(Map<String, String> paraMap) {
		int n = sqlsession.insert("hs_trip.registerPlaySchedule_end",paraMap);
		return n;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}