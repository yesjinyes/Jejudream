package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.ReviewVO;

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
	public List<FoodstoreVO> randomRecommend(Map<String, Object> map) {
		List<FoodstoreVO> randomRecommend = sqlsession.selectList("yj_trip.randomRecommend", map);
		return randomRecommend;
	}


	// == 맛집 총 개수 알아오기 == //
	@Override
	public int getTotalCount(Map<String, Object> map) {
		int totalCount = sqlsession.selectOne("yj_trip.getTotalCount", map);
		return totalCount;
	}

	
	////////////////////////////////////////////////////////////////////////////////////////////////

	
	// == 맛집 상세 조회하기 == //
	@Override
	public FoodstoreVO viewfoodstoreDetail(Map<String, String> paraMap) {
		FoodstoreVO foodstorevo = sqlsession.selectOne("yj_trip.viewfoodstoreDetail", paraMap);
		return foodstorevo;
	}
	
	
	// == 맛집 상세 추가 이미지 == //
	@Override
	public List<Map<String, String>> viewfoodaddImg(Map<String, String> paraMap) {
		List<Map<String, String>> addimgList = sqlsession.selectList("yj_trip.viewfoodaddImg", paraMap);
		return addimgList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	// == 맛집 리뷰 쓰기 == //
	@Override
	public int addFoodstoreReview(ReviewVO reviewvo) {
		int n = sqlsession.insert("yj_trip.addFoodstoreReview", reviewvo);
		return n;
	}


	// == 작성한 리뷰 보이기 == //
	@Override
	public List<ReviewVO> getReviewList(Map<String, String> paraMap) {
		List<ReviewVO> reviewList = sqlsession.selectList("yj_trip.getReviewList", paraMap);
		return reviewList;
	}


	// === 리뷰 수정하기 === //
	@Override
	public int updateReview(Map<String, String> paraMap) {
		int n = sqlsession.update("yj_trip.updateReview", paraMap);
		return n;
	}


	// == 리뷰 삭제하기 == //
	@Override
	public int deleteReview(String review_code) {
		int n = sqlsession.delete("yj_trip.deleteReview", review_code);
		return n;
	}


	// == 리뷰 총 개수 구하기 == //
	@Override
	public int getReviewTotalCount(String parent_code) {
		int n = sqlsession.selectOne("yj_trip.getReviewTotalCount", parent_code);
		// System.out.println("리뷰 총 개수 확인 => " + n);
		return n;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////

	// == 좋아요 총 개수 알아오기 == //
	@Override
	public int countFoodlike(Map<String, String> paraMap) {
		int countFoodlike = sqlsession.selectOne("yj_trip.countFoodlike",paraMap);
		return countFoodlike;
	}


	// == 좋아요 여부 알아오기 == //
	@Override
	public List<FoodstoreVO> checkLike(Map<String, String> paraMap) {
		List<FoodstoreVO> checkLike = sqlsession.selectList("yj_trip.checkLike",paraMap);
		return checkLike;
	}


	// == 좋아요 추가 == //
	@Override
	public int addLike(Map<String, String> paraMap) {
		int n = sqlsession.insert("yj_trip.addLike", paraMap);
		return n;
	}


	// == 좋아요 취소 == //
	@Override
	public void deleteLike(Map<String, String> paraMap) {
		sqlsession.delete("yj_trip.deleteLike", paraMap);
	}

	// == 글 조회수 1 증가시키기 == //
	@Override
	public int increase_readCount(Map<String, String> paraMap) {
		int n = sqlsession.update("yj_trip.increase_readCount", paraMap);
		return n;
	}


	// == 맛집 일정 추가 == //
	@Override
	public int addFoodSchedule(Map<String, String> paraMap) {
		int n = sqlsession.insert("yj_trip.addFoodSchedule", paraMap);
		return n;
	}


	// == 맛집 수정을 위해 VO 에 있는 정보 불러오기 == //
	@Override
	public FoodstoreVO getFoodstorevo(String food_store_code) {
		FoodstoreVO foodstorevo = sqlsession.selectOne("yj_trip.getFoodstorevo", food_store_code);
		return foodstorevo;
	}


	// == 맛집  수정하기 (관리자) == //
	@Override
	public int editFoodEnd(FoodstoreVO foodstorevo) {
		int n = sqlsession.update("yj_trip.editFoodEnd", foodstorevo);
		return n;
	}


	// == 맛집 삭제하기 (관리자) == //
	@Override
	public int deleteFoodstore(String food_store_code) {
		int n1 = sqlsession.delete("yj_trip.deleteFoodstore", food_store_code);
		// System.out.println("n1 확인 =>" + n1);
		return n1;
	}


	// == 맛집 삭제 시 리뷰도 삭제 == //
	@Override
	public int deleteFoodstoreReview(String food_store_code) {
		int n2 = sqlsession.delete("yj_trip.deleteFoodstoreReview", food_store_code);
		// System.out.println("n2 확인 =>" + n2);
		return n2;
	}


	// == 근처 숙소 랜덤 추천 == //
	@Override
	public List<LodgingVO> getLodgingList(String local_status) {
		List<LodgingVO> lodgingList = sqlsession.selectList("yj_trip.getLodgingList", local_status);
		return lodgingList;
	}


	// == 이미지 수정 및 삭제를 위해 업로드 된 이미지 불러오기 == //
	@Override
	public Map<String, String> getImg(String food_store_code) {
		Map<String, String> img_map = sqlsession.selectOne("yj_trip.getImg", food_store_code);
		return img_map;
	}

	//////////////////////////////////////////////////////////////////////////////////////////

	// == 자주묻는질문 전체 띄우기 (페이징O) == //
	@Override
	public List<Map<String, String>> viewAllFaqList_paging(Map<String, String> paraMap) {
		List<Map<String, String>> faqList = sqlsession.selectList("yj_trip.viewAllFaqList_paging", paraMap);
		return faqList;
	}


	// == FAQ 리스트 페이징 처리 위함 == //
	@Override
	public int getTotalFaqList(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("yj_trip.getTotalFaqList", paraMap);
		//System.out.println("dao 에서 FAQ 성공? => "  + n);
		return n;
	}


	// == 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기 == //
//	@Override
//	public List<MemberVO> searchFoodJoinUserList(String joinUserName) {
//		List<MemberVO> joinUserList = sqlsession.selectList("yj_trip.searchFoodJoinUserList", joinUserName);
//		return joinUserList;
//	}


	// == 인기순으로 정렬 == //
//	@Override
//	public List<FoodstoreVO> viewReadcountList(String readcount) {
//		List<FoodstoreVO> readcountList = sqlsession.selectList("yj_trip.viewReadcountList", readcount);
//		return readcountList;
//	}








	
	
	
}
