package com.spring.app.trip.controller;

import java.io.File;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.common.MyUtil;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.service.Yj_TripService;

@Controller
public class Yj_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Yj_TripService service;
	
	@Autowired
	private FileManager fileManager;
	
	

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
	
	
	
	// == 맛집 리스트 페이지 띄우기 == //
	@ResponseBody
	@GetMapping(value="foodstoreListJSON.trip", produces="text/plain;charset=UTF-8")
	public String foodstoreListJSON(HttpServletRequest request,
							    @RequestParam(defaultValue="") String str_category,
							    @RequestParam(defaultValue="") String str_area,
							    @RequestParam(defaultValue="") String searchWordFood,
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
		
		// 전체보기 버튼
		if(map.get("arr_category")!= null && "".equals(orderType) ) {
			map.put("orderType", "all");
		}
		else if(map.get("arr_area")!= null && "".equals(orderType) ) {
			map.put("orderType", "all");
		}
		else {
			// 전체 정렬
			if("".equals(orderType)) {
				map.put("orderType", "all");
				map.remove("arr_category");
				map.remove("arr_area");
			}
		}
		
		// 인기순 정렬 
		if("".equals(orderValue_asc) || "".equals(orderValue_desc)) {
			map.put("orderType", orderType);
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
		searchWordFood = MyUtil.changeEtcTag(searchWordFood);
		
		if(searchWordFood == null) {
			searchWordFood = "";
		}
		 
		if(searchWordFood != null) {
			searchWordFood = searchWordFood.trim();
		}
		map.put("searchWordFood", searchWordFood);
		
		map.put("currentShowPageNo", currentShowPageNo); 

		//////////////////////////////////////////////////////////////////////////////
		
		// 맛집 전체개수
	    int totalCount = service.getTotalCount(map);
	    
	    // 맛집 리스트(조회수 증가X)
		foodstoreList = service.viewFoodstoreList(map);
		
		List<FoodstoreVO> randomRecommend = service.randomRecommend(map); // 맛집 랜덤 추천
		
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
				jsonObj.put("readcount", storevo.getReadCount());
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
		
		return jsonArr.toString();
	}
	
	
	
	// == 맛집 상세 페이지 보이기 == //
	@GetMapping("foodstoreDetail.trip")
	public ModelAndView foodstoreDetail(ModelAndView mav, HttpServletRequest request,
										@RequestParam(defaultValue="") String random_recommend_code) {
		
		String food_store_code = "";
		food_store_code = request.getParameter("food_store_code");
	
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
		
		////////////////////////////////////////////////////////////////
		
		FoodstoreVO foodstorevo = null;
		List<LodgingVO> lodgingList = null;
		
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
		
		/////////////////////////////////////////////////////
		// 근처 숙소 랜덤 추천
		String local_status = foodstorevo.getLocal_status();
		lodgingList = service.getLodgingList(local_status);
		
		/////////////////////////////////////////////////////
	
		List<Map<String, String>> addimgList = service.viewfoodaddImg(paraMap); // 맛집 상세 추가 이미지

		mav.addObject("foodstorevo", foodstorevo);
		mav.addObject("lodgingList", lodgingList);
		
 		mav.addObject("addimgList", addimgList);
		
 		mav.setViewName("foodstore/foodstoreDetail.tiles1");
		
 		return mav;
	}
	
	
	
	// == 상세페이지 조회수 증가 == //
	@GetMapping("foodstoreDetail_2.trip")
	public ModelAndView view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {
		
		String food_store_code = request.getParameter("food_store_code");
		
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
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser == null) {
			
		}
		
		String parent_code = request.getParameter("parent_code");
		String fk_userid = request.getParameter("fk_userid");
		String like_division_R = "B";
		
		int n = 0;

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("parent_code", parent_code);
		paraMap.put("fk_userid", fk_userid);
		paraMap.put("like_division_R", like_division_R);
		
		List<FoodstoreVO> check = service.checkLike(paraMap); 
		
		if(check.size() == 0) {
			n = service.addLike(paraMap); // 좋아요 추가
		}
		else {
			service.deleteLike(paraMap); // 좋아요 지우기
	        n=0;
		}
		
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
		
		// 리뷰 총 개수 구하기
		int totalCount = service.getReviewTotalCount(parent_code); 
		
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
	
		return jsonArr.toString();
	}
	
	
	
	// == 리뷰 수정하기 == //
	@ResponseBody
	@PostMapping(value="/updateReview.trip", produces="text/plain;charset=UTF-8")
	public String updateReview(HttpServletRequest request) {
		
		String review_code = request.getParameter("review_code");
		String review_content = request.getParameter("review_content");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("review_code", review_code);
		paraMap.put("review_content", review_content);
		int n = service.updateReview(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	
	// == 리뷰 삭제하기 == //
	@ResponseBody
	@PostMapping(value="/deleteReview.trip", produces="text/plain;charset=UTF-8")
	public String deleteReview(HttpServletRequest request) {
		
		String review_code = request.getParameter("review_code");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("review_code", review_code);
		
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
	
	
	
	///////////////////////////////////////////////////////////////////////////////////
	
	// == 맛집 일정 추가 == //
	@ResponseBody
	@PostMapping(value="addFoodSchedule.trip", produces="text/plain;charset=UTF-8")
	public ModelAndView addFoodSchedule(ModelAndView mav, HttpServletRequest request,
										@RequestParam(defaultValue="") String parent_code,
										@RequestParam(defaultValue="") String food_address,
										@RequestParam(defaultValue="") String scheduleTitle,
										@RequestParam(defaultValue="") String scheduleContent,
										@RequestParam(defaultValue="") String startdate,
										@RequestParam(defaultValue="") String enddate,
										@RequestParam(defaultValue="") String joinuser) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String login_userid = null;
		if(loginuser != null) { // 로그인 한 상태일 때
			login_userid = loginuser.getUserid();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("parent_code", parent_code);
		paraMap.put("food_address", food_address);
		
		paraMap.put("login_userid", login_userid);
		
		paraMap.put("scheduleTitle", scheduleTitle);
		paraMap.put("scheduleContent", scheduleContent);
		paraMap.put("scheduleContent", scheduleContent);
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		paraMap.put("joinuser", joinuser);
		
		int n = 0;
		
		try {
			n = service.addFoodSchedule(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mav.addObject("n", n);
		
		mav.setViewName("foodstore/foodstoreDetail.tiles1");
		
		return mav;
	}
	
	
	// == 일정 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기 == //
	@ResponseBody
	@RequestMapping(value="/schedule/insertSchedule/searchFoodJoinUserList.trip", produces="text/plain;charset=UTF-8")
	public String searchPlayJoinUserList(HttpServletRequest request) {
		
		String joinUserName = request.getParameter("joinUserName");
		
		// 회원 명단 불러오기
		List<MemberVO> joinUserList = service.searchFoodJoinUserList(joinUserName);

		JSONArray jsonArr = new JSONArray();
		if(joinUserList != null && joinUserList.size() > 0) {
			for(MemberVO mvo : joinUserList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("userid", mvo.getUserid());
				jsObj.put("user_name", mvo.getUser_name());
				
				jsonArr.put(jsObj);
			}
		}
		
		return jsonArr.toString();
	}

	
	// == 맛집 수정 페이지 요청 (관리자) == //
	@GetMapping("/editFoodstore.trip")
	public ModelAndView editFoodstore(ModelAndView mav, HttpServletRequest request) {
		
		String food_store_code = request.getParameter("food_store_code");
		
		// 맛집 수정을 위해 VO 에 있는 정보 불러오기
		FoodstoreVO foodstorevo = service.getFoodstorevo(food_store_code);
		
		mav.addObject("foodstorevo", foodstorevo);
		
		mav.setViewName("foodstore/editFoodstore.tiles1");
		
		return mav;
	}
	
	
	// == 맛집 수정 데이터 처리 (관리자) == //
	@PostMapping("/editFoodEnd.trip")
	public ModelAndView editFoodEnd(ModelAndView mav, FoodstoreVO foodstorevo, MultipartHttpServletRequest mrequest) {
		
		//  ============ 첨부파일 처리 시작 ============ // 
		MultipartFile attach = foodstorevo.getAttach();
		
		if(!attach.isEmpty()) {
			
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			String path = root + "resources" + File.separator + "images" + File.separator + "foodimg";
			String newFileName = "";
			
			byte[] bytes = null; // 첨부파일 내용물 담을 배열
			long fileSize = 0; // 첨부파일의 크기
			
			try {
				String food_store_code =  foodstorevo.getFood_store_code();
				
				// 이미지 수정을 위해 업로드 된 이미지 불러오기
				Map<String, String> img_map = service.getImg(food_store_code);
				String food_main_img = img_map.get("food_main_img");
				String filename = img_map.get("filename");

				if(filename != null ) {
					// 운영경로에 올라가있는 filename 이 null 이 아니면 
					fileManager.doFileDelete(filename, path);
				}
				else { 
					fileManager.doFileDelete(food_main_img, path);
					
				}
				bytes = attach.getBytes();
				
				String originalFilename = attach.getOriginalFilename();
				
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path); // 첨부된 파일 업로드
				
				foodstorevo.setFileName(newFileName);
				foodstorevo.setOrgFilename(originalFilename);
				
				fileSize = attach.getSize();
				foodstorevo.setFileSize(String.valueOf(fileSize));
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		//  ============ 첨부파일 처리 끝 ============ // 
	
		int n = service.editFoodEnd(foodstorevo); // 맛집  수정하기
		
		if(n==1) {
			String message = "맛집 정보가 수정되었습니다.";
			String loc = mrequest.getContextPath() + "/foodstoreList.trip";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		else {
			String message = "맛집 정보 수정에 실패했습니다.";
			String loc = "javascript:history.back()";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// == 맛집 삭제하기 (관리자) == //
	@ResponseBody
	@PostMapping(value="/deleteFoodstore.trip", produces="text/plain;charset=UTF-8")
	public String deleteFoodstore(HttpServletRequest request, @RequestParam(defaultValue="") String parent_code) {
		
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources" + File.separator + "images" + File.separator + "foodimg";

		String food_store_code = request.getParameter("food_store_code");
		
		int totalCount = service.getReviewTotalCount(parent_code); // 리뷰 테이블 삭제를 위한 것
		
		int n = 0;
		
		try {
			// 이미지 수정을 위해 업로드 된 이미지 불러오기
			Map<String, String> img_map = service.getImg(food_store_code);
			
			String food_main_img = img_map.get("food_main_img");
			String filename = img_map.get("filename");

			if(filename != null) {
				// 운영경로에 올라가있는 filename 이 null 이 아니면 
				fileManager.doFileDelete(filename, path);
			}
			else { 
				fileManager.doFileDelete(food_main_img, path);
			}
			
			n = service.deleteFoodstore(food_store_code);
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		jsonObj.put("totalCount", totalCount);
		
		return jsonObj.toString();
	}
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// == 자주묻는질문(FAQ) 리스트 띄우기 == //
	@ResponseBody
	@GetMapping(value="/faqListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String faqListJSON(HttpServletRequest request) {
		
		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		String faq_category = request.getParameter("faq_category"); // 카테고리 탭 선택 ajax 적용을 위한 것

		String searchWordFaq = request.getParameter("searchWordFaq"); 
		
		Map<String, String> paraMap = new HashMap<>();
		
		if(searchWordFaq != null && !"".equals(searchWordFaq)) { // null 이 아니거나, 공백이 아닐 경우에만 Map 에 담아준다.
			paraMap.put("searchWordFaq", searchWordFaq);
		}
		
		if(faq_category == null) { // 카테고리가 전체일 경우 "" 을 주어서 mapper 에서 조건 주기 위함
			faq_category = "";
		}
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		int sizePerPage = 10; // 한 페이지당 10개의  질문을 보여줄 것임
		
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		paraMap.put("faq_category", faq_category);
		

		// 모든 질문 읽어오기
		List<Map<String,String>> faqList = service.viewAllFaqList_paging(paraMap);
		
		int totalCount = service.getTotalFaqList(paraMap); // FAQ 리스트 페이징 처리 위함
		
		JSONArray jsonArr = new JSONArray(); // [] 
		
		if(faqList != null) {
			for(Map<String,String> faqMap : faqList) {
				JSONObject jsonObj = new JSONObject(); 
				
				jsonObj.put("faq_seq", faqMap.get("faq_seq"));
				jsonObj.put("faq_category", faqMap.get("faq_category"));
				jsonObj.put("faq_question", faqMap.get("faq_question"));
				jsonObj.put("faq_answer", faqMap.get("faq_answer"));
				
				jsonObj.put("totalCount", totalCount);   
				jsonObj.put("sizePerPage", sizePerPage);  
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		return jsonArr.toString(); 	
	}
	
	
	
	// == FAQ 등록(관리자) == //
	@ResponseBody
	@PostMapping(value="/registerFAQ.trip", produces="text/plain;charset=UTF-8")
	public String registerFAQ(HttpServletRequest request) {
		
		String selected_category = request.getParameter("selected_category");
		String question = request.getParameter("question");
		String answer = request.getParameter("answer");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("faq_category", selected_category);
		paraMap.put("faq_question", question);
		paraMap.put("faq_answer", answer);
		
		int n = 0;
		
		try {
			n = service.registerFAQ(paraMap);
		
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// == FAQ 수정(관리자) == //
	@ResponseBody
	@PostMapping(value="/updateFAQ.trip", produces="text/plain;charset=UTF-8")
	public String updateFAQ(HttpServletRequest request) {
		
		String update_faq_seq = request.getParameter("update_faq_seq");
		String question_update = request.getParameter("question_update");
		String answer_update = request.getParameter("answer_update");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("faq_seq", update_faq_seq);
		paraMap.put("question_update", question_update);
		paraMap.put("answer_update", answer_update);
		
		int n = 0;
		
		try {
			n = service.updateFAQ(paraMap);
		
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// == FAQ 삭제(관리자) == //
	@ResponseBody
	@PostMapping(value="/deleteFAQ.trip", produces="text/plain;charset=UTF-8")
	public String deleteFAQ(HttpServletRequest request) {
		
		String faq_seq = request.getParameter("faq_seq");
		
		int n = 0;
		
		try {
			n = service.deleteFAQ(faq_seq);
		
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	

}
