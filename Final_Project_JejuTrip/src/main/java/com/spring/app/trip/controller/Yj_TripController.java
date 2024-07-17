package com.spring.app.trip.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.service.Yj_TripService;

@Controller
public class Yj_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Yj_TripService service;
	

	// == 커뮤니티 메인 페이지 보이기 == //
	@GetMapping("communityMain.trip")
	public String communityMain() {
		return "community/communityMain.tiles1"; 
	}
	
	
	
	// == 맛집 메인 페이지 보이기 == //
	@GetMapping("foodstoreList.trip")
	public ModelAndView foodstoreList(ModelAndView mav, FoodstoreVO foodstorevo) {
		mav.setViewName("foodstore/foodstoreList.tiles1");
		return mav;
	}
	
	
	
	// == 맛집 리스트 페이지 (Ajax 처리) == //
	@ResponseBody
	@GetMapping(value="foodstoreListJSON.trip", produces="text/plain;charset=UTF-8")
	public String foodstoreListJSON(HttpServletRequest request,
							    @RequestParam(defaultValue="") String str_category,
							    @RequestParam(defaultValue="") String str_area,
							    @RequestParam(defaultValue="") String searchWord,
							    @RequestParam(defaultValue="") String orderType, 
							    @RequestParam(defaultValue="") String orderValue_asc,
							    @RequestParam(defaultValue="") String orderValue_desc,
							    @RequestParam(defaultValue="") String currentShowPageNo) {
		
		List<FoodstoreVO> foodstoreList = null; // insert 된 맛집이 없을 경우 null
		
		// 조회수 처리
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes"); // session 에  "readCountPermission" 에 대한 값을 yes 라고 저장
		
		// 페이징 처리
		int sizePerPage = 7; //한페이지당 7개의 맛집
		
		Map<String, Object> map = new HashMap<>();
		
		if("".equals(currentShowPageNo) || currentShowPageNo == null) {
	    	currentShowPageNo="1";
		}
	    
	    int startRno = ((Integer.parseInt(currentShowPageNo)- 1) * sizePerPage) + 1; // 시작 행번호 
	    int endRno = startRno + sizePerPage - 1; // 끝 행번호
	    
	    map.put("startRno",String.valueOf(startRno) );
	    map.put("endRno",String.valueOf(endRno));
		
		
		// 카테고리 체크박스
		if(!"".equals(str_category)) {
			String[] arr_category = str_category.split("\\,");
			map.put("arr_category", arr_category); 
		}
		
		// 지역 체크박스
		if(!"".equals(str_area)) {
			String[] arr_area = str_area.split("\\,");
			map.put("arr_area", arr_area);
		}
		
		// 오름차순 정렬 //
		if(!"".equals(orderValue_asc)) {
			map.put("orderType", orderType);
			map.put("orderValue_asc", orderValue_asc);
		}
		
		// 내림차순 정렬 //
		if(!"".equals(orderValue_desc)) {
			map.put("orderType", orderType);
			map.put("orderValue_desc", orderValue_desc);
		}
		
		// 검색하기 //
		if(searchWord == null) {
			searchWord = "";
		}
		 
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		map.put("searchWord", searchWord);
		
		map.put("currentShowPageNo", currentShowPageNo); 

		//////////////////////////////////////////////////////////////////////////////
		
		// 맛집 전체개수
	    int totalCount = service.getTotalCount(map);
	    // System.out.println("totalCount => "+totalCount);
	    
		foodstoreList = service.viewFoodstoreList(map); // 맛집 리스트(조회수 증가X)
		//System.out.println("foodstoreList 길이 : " + foodstoreList.size());
		
		List<FoodstoreVO> randomRecommend = service.randomRecommend(map); // 맛집 랜덤 추천
		// System.out.println("~~~ 확인용 randomRecommend => "+ randomRecommend.size());
		
		//////////////////////////////////////////////////////////////////////////////
		
		JSONArray jsonArr = new JSONArray();
	    
		// 맛집 리스트에서 상세페이지 조회하는 경우
		if(foodstoreList != null) {
			
			for(FoodstoreVO storevo : foodstoreList) {
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("food_store_code", storevo.getFood_store_code()); // Mapper HashMap 에 있는 key 값을 가져온 것이다.
				jsonObj.put("food_main_img", storevo.getFood_main_img());
				jsonObj.put("food_name", storevo.getFood_name());
				jsonObj.put("food_content", storevo.getFood_content());
				jsonObj.put("food_category", storevo.getFood_category());
				jsonObj.put("food_address", storevo.getFood_address());
				jsonObj.put("status", 0);
				
				jsonObj.put("totalCount", totalCount); //총 페이지 
            	jsonObj.put("currentShowPageNo", currentShowPageNo); // 현재페이지
            	jsonObj.put("sizePerPage", sizePerPage); // 한페이지당 보여줄 개수
				
				jsonArr.put(jsonObj);
			}// end of for--------------------------------.
		}
		
		// 맛집 랜덤 추천에서 상세페이지 조회하는 경우
		if(randomRecommend != null) {
			for(FoodstoreVO storevo : randomRecommend) {
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("random_recommend_code", storevo.getFood_store_code()); // Mapper HashMap 에 있는 key 값을 가져온 것이다.
				jsonObj.put("food_main_img", storevo.getFood_main_img());
				jsonObj.put("food_name", storevo.getFood_name());
				jsonObj.put("food_content", storevo.getFood_content());
				jsonObj.put("food_category", storevo.getFood_category());
				jsonObj.put("food_address", storevo.getFood_address());
				jsonObj.put("status", 1);
				
				jsonArr.put(jsonObj);
			}// end of for--------------------------------.
		}
		
		// System.out.println(jsonArr.toString());
		
		return jsonArr.toString();
	}
	
	
	
	// == 맛집 상세 페이지 보이기 == //
	@GetMapping("foodstoreDetail.trip")
	public ModelAndView foodstoreDetail(ModelAndView mav, HttpServletRequest request,
										@RequestParam(defaultValue="") String random_recommend_code,
										@RequestParam(defaultValue="") String scheduleTitle,
										@RequestParam(defaultValue="") String scheduleContent,
										@RequestParam(defaultValue="") String scheduleDate) {
	
		String food_store_code = "";
		food_store_code = request.getParameter("food_store_code");
		
		// System.out.println("-------------------------------------------------------");
		// System.out.println("## 확인용 food_store_code => "+ food_store_code);
		// System.out.println("## 확인용 random_recommend_code => "+ random_recommend_code);
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String login_userid = null;
		if(loginuser != null) { // 로그인 한 상태일 때
			login_userid = loginuser.getUserid();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("food_store_code", food_store_code);
		paraMap.put("parent_code", food_store_code);
	
		paraMap.put("random_recommend_code", random_recommend_code);
		paraMap.put("login_userid", login_userid);
		
		paraMap.put("scheduleTitle", scheduleTitle);
		paraMap.put("scheduleContent", scheduleContent);
		paraMap.put("scheduleDate", scheduleDate);
		
		///////////////////////////////////////////////////////
		
		FoodstoreVO foodstorevo = null;
		
		if("yes".equals((String)session.getAttribute("readCountPermission"))) {
			
			foodstorevo = service.viewfoodstoreDetail_withReadCount(paraMap); // 맛집 상세 페이지 띄우기 (조회수 증가 O)
			
			session.removeAttribute("readCountPermission");
		}
		
		else {
			foodstorevo = service.viewfoodstoreDetail(paraMap); // 맛집 상세 페이지 띄우기 (조회수 증가 X)
			
			if(foodstorevo == null) {
				mav.setViewName("redirect:/foodstoreList.trip");
				return mav;
			}
		}
		
		///////////////////////////////////////////////////////
		
		if(scheduleTitle != "") {
			
		}
		
		int n = service.addFoodSchedule(paraMap); // 맛집 일정 추가
		
		if(n==1) {
			System.out.println("insert 성공");
		}
		else {
			System.out.println("insert 실패");
		}
		
		
		// String food_name =  foodstorevo.getFood_name();
		// System.out.println("food_name 확인 =>" + food_name);
	
		List<Map<String, String>> addimgList = service.viewfoodaddImg(paraMap); // 맛집 상세 추가 이미지
		
		mav.addObject("foodstorevo", foodstorevo);
		
 		mav.addObject("addimgList", addimgList);
		
 		mav.setViewName("foodstore/foodstoreDetail.tiles1");
		
 		return mav;
	}
	
	
	// == 상세페이지 조회수 증가 == //
	@GetMapping("foodstoreDetail_2.trip")
	public ModelAndView view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {
		
		String food_store_code = request.getParameter("food_store_code");
		System.out.println("~~~~ food_store_code 나와주세요 => "+ food_store_code);
		
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		Map<String, String> redirect_map = new HashMap<>();
		redirect_map.put("food_store_code", food_store_code);
		
		redirectAttr.addFlashAttribute("redirect_map", redirect_map);
		
		mav.setViewName("redirect:/foodstoreDetail.trip");
		
		return mav;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	// == 좋아요 기능 처리하기 == //
	@ResponseBody
	@PostMapping(value =("foodLike.trip"),produces="text/plain;charset=UTF-8")
	 public String foodLike(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String parent_code = request.getParameter("parent_code");
		String fk_userid = request.getParameter("fk_userid");
		String like_division_R = "B";
		
		// System.out.println("좋아요 버튼 클릭 parent_code"+parent_code);
		// System.out.println("좋아요 버튼 클릭 fk_userid"+fk_userid);
		
		int n = 0;

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("parent_code", parent_code);
		paraMap.put("fk_userid", fk_userid);
		paraMap.put("like_division_R", like_division_R);
		
		List<FoodstoreVO> check = service.checkLike(paraMap); 
		
		if(check.size() == 0) {
			n = service.addLike(paraMap);  // 좋아요 추가
		}
		else {
			service.deleteLike(paraMap);  // 좋아요 지우기
	        n=0;
		}
		
		//System.out.println("n" + n);
		
	    JSONObject jsonObj = new JSONObject(); 
	    jsonObj.put("n", n);
         
        return jsonObj.toString();
	}
	
	
	// == 좋아요 총 개수 구하기 == //
	@ResponseBody
	@GetMapping(value =("countFoodlike.trip"),produces="text/plain;charset=UTF-8")
	 public String countFoodlike(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String parent_code = request.getParameter("parent_code");
	    String fk_userid = request.getParameter("fk_userid");

	    Map<String, String> paraMap = new HashMap<>();
	    paraMap.put("parent_code", parent_code);

	    // 좋아요 총 개수 알아오기
	    int countFoodlike = service.countFoodlike(paraMap);

	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("countLike", countFoodlike);

	    if (fk_userid != null && !fk_userid.isEmpty()) {
	        paraMap.put("fk_userid", fk_userid);
	        
	        List<FoodstoreVO> check = service.checkLike(paraMap); // 좋아요 했는지 알아오기
	        jsonObj.put("check", check != null ? check.size() > 0 : false);
	    } else {
	        jsonObj.put("check", false);
	    }

	    return jsonObj.toString();
	}

	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	// == 리뷰 쓰기 == //
	@ResponseBody
	@PostMapping(value="/addReview.trip", produces="text/plain;charset=UTF-8")
	public String addComment(ReviewVO reviewvo, HttpServletRequest request) {
		
		int n = 0;
		
		try {
			n = service.addFoodstoreReview(reviewvo); // 리뷰쓰기
		
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		jsonObj.put("fk_userid", reviewvo.getFk_userid());
		
		//System.out.println("### controller 에서 insert 확인 : "+ jsonObj.toString());
		
		return jsonObj.toString();
	}
	
	
	// == 작성한 리뷰 보이기 == //
	@ResponseBody
	@GetMapping(value="/foodstoreReviewList.trip", produces="text/plain;charset=UTF-8")
	public String foodstoreReviewList(ReviewVO reviewvo, HttpServletRequest request,
			 						 @RequestParam(defaultValue="") String parent_code,
									 @RequestParam(defaultValue="") String currentShowPageNo) {
		
		if("".equals(currentShowPageNo)) {
			currentShowPageNo = "1"; 
		}
		
		int sizePerPage = 10;
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("parent_code", parent_code);
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
		
		List<ReviewVO> reviewList = service.getReviewList(paraMap);
		
		int totalCount = service.getReviewTotalCount(parent_code); // 리뷰 총 개수 구하기 => 나옴
		
		JSONArray jsonArr = new JSONArray();
		
		if(reviewList != null) {
			for(ReviewVO rvo : reviewList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("review_code", rvo.getReview_code());
				jsonObj.put("fk_userid", rvo.getFk_userid());
				jsonObj.put("parent_code", rvo.getParent_code());
				jsonObj.put("review_content", rvo.getReview_content());
				jsonObj.put("registerday", rvo.getRegisterday());
				
				jsonObj.put("sizePerPage", sizePerPage);
				jsonObj.put("totalCount", totalCount);
				
				jsonArr.put(jsonObj);
			}// end of for------------------
		}
	
		//System.out.println("~~~리뷰 List jsonArr 확인 => "+jsonArr.toString());
		return jsonArr.toString();
	}
	
	
	// == 리뷰 수정하기 == //
	@ResponseBody
	@PostMapping(value="/updateReview.trip", produces="text/plain;charset=UTF-8")
	public String updateReview(HttpServletRequest request) {
		
		String review_code = request.getParameter("review_code");
		String review_content = request.getParameter("review_content");
		
		// System.out.println("~~~review_content 확인 => "+review_content);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("review_code", review_code);
		paraMap.put("review_content", review_content);
		int n = service.updateReview(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString(); // "{"n":1}"
	}
	
	
	// == 리뷰 삭제하기 == //
	@ResponseBody
	@PostMapping(value="/deleteReview.trip", produces="text/plain;charset=UTF-8")
	public String deleteReview(HttpServletRequest request) {
		
		String review_code = request.getParameter("review_code");
		//String parent_code = request.getParameter("parent_code");
		
		//System.out.println("글번호(parent_code) 확인 => " + parent_code);
		
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("review_code", review_code);
		//paraMap.put("parent_code", parent_code);
		
		int n = 0;
		
		try {
			n = service.deleteReview(paraMap);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();		
	}
	
	

}
