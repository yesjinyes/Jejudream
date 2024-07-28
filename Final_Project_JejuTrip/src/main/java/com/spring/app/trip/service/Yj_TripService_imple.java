package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
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

	// == 맛집 상세 조회하기 (조회수 증가 O) == //
	@Override
	public FoodstoreVO viewfoodstoreDetail_withReadCount(Map<String, String> paraMap) {
		
		FoodstoreVO foodstorevo = dao.viewfoodstoreDetail(paraMap);
		
		String login_userid = paraMap.get("login_userid"); // 로그인 했을 경우에만 조회수 올리기 위함
		
		// String readCount = foodstorevo.getReadCount();
		// System.out.println("이전 조회수  확인 => " + readCount);
		
		if(login_userid != null &&  // 로그인 되어졌고
		   foodstorevo != null) { // 해당 글이 있을 경우
		
			int n = dao.increase_readCount(paraMap); // 글 조회수 1 증가시키기
			
			if(n==1) {
				foodstorevo.setReadCount(String.valueOf(Integer.parseInt(foodstorevo.getReadCount())+1));
			}
		}
		return foodstorevo;
	}
	
	
	// == 맛집 상세 추가 이미지 == //
	@Override
	public List<Map<String, String>> viewfoodaddImg(Map<String, String> paraMap) {
		List<Map<String, String>> addimgList = dao.viewfoodaddImg(paraMap);
		return addimgList;
	}

	//////////////////////////////////////////////////////////////////////////////////////

	// == 맛집 리뷰 쓰기 == //
	@Override
	public int addFoodstoreReview(ReviewVO reviewvo) {
		int n = dao.addFoodstoreReview(reviewvo); // 리뷰쓰기(tbl_review 에 insert)
		return n;
	}


	// == 작성한 리뷰 보이기 == //
	@Override
	public List<ReviewVO> getReviewList(Map<String, String> paraMap) {
		List<ReviewVO> reviewList = dao.getReviewList(paraMap);
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


	// == 리뷰 총 개수 구하기 == //
	@Override
	public int getReviewTotalCount(String parent_code) {
		int n = dao.getReviewTotalCount(parent_code);
		return n;
	}

	//////////////////////////////////////////////////////////////////////////////////////

	// == 좋아요 총 개수 알아오기 == //
	@Override
	public int countFoodlike(Map<String, String> paraMap) {
		int countFoodlike = dao.countFoodlike(paraMap);
		return countFoodlike;
	}


	// == 좋아요 여부 알아오기 == //
	@Override
	public List<FoodstoreVO> checkLike(Map<String, String> paraMap) {
		List<FoodstoreVO> checkLike = dao.checkLike(paraMap);
	    return checkLike;
	}


	// == 좋아요 추가 == //
	@Override
	public int addLike(Map<String, String> paraMap) {
		int n = dao.addLike(paraMap);
		return n;
	}


	// == 좋아요 취소 == //
	@Override
	public void deleteLike(Map<String, String> paraMap) {
		dao.deleteLike(paraMap);
	}

	//////////////////////////////////////////////////////////////////////////////////////

	// == 맛집 일정 추가 == //
	@Override
	public int addFoodSchedule(Map<String, String> paraMap) {
		int n = dao.addFoodSchedule(paraMap);
		return n;
	}


	// == 맛집 수정을 위해 VO 에 있는 정보 불러오기 == //
	@Override
	public FoodstoreVO getFoodstorevo(String food_store_code) {
		FoodstoreVO foodstorevo = dao.getFoodstorevo(food_store_code);
		return foodstorevo;
	}


	// == 맛집  수정하기 (관리자) == //
	@Override
	public int editFoodEnd(FoodstoreVO foodstorevo) {
		int n = dao.editFoodEnd(foodstorevo);
		return n;
	}


	// == 맛집 삭제하기 (관리자) == //
	@Override
	public int deleteFoodstore(String food_store_code) {
		
		// 맛집 삭제
		int n1 = dao.deleteFoodstore(food_store_code);
		
		// 맛집 삭제 시 리뷰도 삭제
		int n2 = dao.deleteFoodstoreReview(food_store_code);
		
		//System.out.println("n1*n2 확인 => " + n1*n2);

		return n1*n2;
	}


	// == 근처 숙소 랜덤 추천 == //
	@Override
	public List<LodgingVO> getLodgingList(String local_status) {
		List<LodgingVO> lodgingList = dao.getLodgingList(local_status);
		return lodgingList;
	}


	// == 이미지 수정 및 삭제를 위해 업로드 된 이미지 불러오기 == //
	@Override
	public Map<String, String> getImg(String food_store_code) {
		Map<String, String> img_map = dao.getImg(food_store_code);
		return img_map;
	}

	/////////////////////////////////////////////////////////////////////////////////////
	
	// == 자주묻는질문 전체 띄우기 (페이징O) == //
	@Override
	public List<Map<String, String>> viewAllFaqList_paging(Map<String, String> paraMap) {
		List<Map<String, String>> faqList = dao.viewAllFaqList_paging(paraMap);
		return faqList;
	}


	// == FAQ 리스트 페이징 처리 위함 == //
	@Override
	public int getTotalFaqList(Map<String, String> paraMap) {
		int n = dao.getTotalFaqList(paraMap);
		// System.out.println("service 에서 FAQ 성공? => "  + n);
		return n;
	}


	

	





}
