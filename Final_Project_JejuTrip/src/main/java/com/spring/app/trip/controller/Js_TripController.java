package com.spring.app.trip.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.service.Js_TripService;

@Controller
public class Js_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Js_TripService service;
	
	
	// 숙소리스트 페이지로 보내주기
	@GetMapping("/lodgingList.trip")
    public ModelAndView lodgingList(ModelAndView mav, HttpServletRequest request) {
		
		String lodging_code = "";
		// 숙소리스트에 표현할 편의시설 목록 구해오기
		List<String> convenientList =  service.getConvenientList(lodging_code);
		
		
		mav.addObject("convenientList", convenientList);
        mav.setViewName("lodging/lodgingList.tiles1");
       
        return mav; 
       
    } // end of public ModelAndView lodgingList(ModelAndView mav, HttpServletRequest request) {
	
	
	// 숙소리스트 ajax로 갱신
	@ResponseBody
	@GetMapping(value="/updateLodgingList.trip", produces="text/plain;charset=UTF-8")
    public String lodgingList(HttpServletRequest request,
							  @RequestParam(defaultValue = "") String str_category,
							  @RequestParam(defaultValue = "") String str_convenient,
							  @RequestParam(defaultValue = "") String str_local,
							  @RequestParam(defaultValue = "") String searchWord,
							  @RequestParam(defaultValue = "") String currentShowPageNo,
							  @RequestParam(defaultValue = "") String sort,
							  @RequestParam(defaultValue = "") String check_in,
							  @RequestParam(defaultValue = "") String check_out,
							  @RequestParam(defaultValue = "2") String people) {
		/*
		System.out.println("~~ 확인용 str_category " + str_category);
		System.out.println("~~ 확인용 str_convenient " + str_convenient);
		System.out.println("~~ 확인용 str_local " + str_local);
		System.out.println("~~ 확인용 searchWord " + searchWord);
		System.out.println("~~ 확인용 currentShowPageNo " + currentShowPageNo);
		System.out.println("~~~~ 확인용 sort : " + sort);
		System.out.println("~~~ 확인용 check_in : " + check_in);
		System.out.println("~~~ 확인용 check_out : " + check_out);
		System.out.println("~~~ 확인용 people : " + people);
		
		*/
		
		// 한 페이지당 보여줄 숙소 개수
		int sizePerPage = 7;
		
		Map<String,Object> paraMap = new HashMap<>();
		
		// 혹시 모를 페이지번호 기본값 세팅
		if("".equals(currentShowPageNo) || currentShowPageNo == null) {
			
			currentShowPageNo = "1";
		}
		
		// 검색어가 공백이 아닐때
		if(!"".equals(searchWord)) {
			
			paraMap.put("searchWord", String.valueOf(searchWord));
		}
		
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
        paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		if(!"".equals(str_category)) {
			
			String[] arr_category = str_category.split("\\,");
			
			paraMap.put("arr_category", arr_category);
			
		}
		
		if(!"".equals(str_local)) {
			
			String[] arr_local = str_local.split("\\,");
			
			paraMap.put("arr_local", arr_local);
			
		}
		
		if(!"".equals(str_convenient)) {
			
			String[] arr_convenient = str_convenient.split("\\,");
			
			paraMap.put("arr_convenient",arr_convenient);
			
		}
		
		
		switch (sort) {
		
			case "":
				paraMap.put("sort","");
				break;
				
			case "price_asc":
				
				paraMap.put("sort","asc");
				break;
			
			case "price_desc":
				
				paraMap.put("sort","desc");
				break;	
	
			default:
				break;
		} // end of switch
		
		
		paraMap.put("currentShowPageNo",currentShowPageNo);
		
		
		paraMap.put("check_in", check_in);
		paraMap.put("check_out", check_out);
		paraMap.put("people", people);
		
		// 숙소 전체 개수 가져오기
		int totalCount = service.getLodgingTotalCount(paraMap);
		
        // 조건에 따른 숙소리스트 select 해오기
		List<Map<String,String>> lodgingList = service.lodgingList(paraMap);
		
		// System.out.println("select 해오는 lodgingList 길이 : " + lodgingList.size());
		
		JSONArray jsonArr = new JSONArray();
        
		// System.out.println("totalCount : " + totalCount);
		
        if(lodgingList != null) {
        // select 되온게 null 이 아닐때 json에 넣어주기	
        	
        	for(Map<String,String> map : lodgingList ) {
        		
        		JSONObject jsonObj = new JSONObject();
        		
        		jsonObj.put("lodging_code", map.get("lodging_code"));
        		jsonObj.put("lodging_name",map.get("lodging_name"));
        		jsonObj.put("lodging_address",map.get("lodging_address"));
        		jsonObj.put("local_status",map.get("local_status"));
        		jsonObj.put("lodging_category",map.get("lodging_category"));
        		jsonObj.put("main_img",map.get("main_img"));
        		jsonObj.put("review_division",map.get("review_division"));
        		jsonObj.put("price",map.get("price"));
        		
        		jsonObj.put("totalCount", totalCount);
            	jsonObj.put("currentShowPageNo", currentShowPageNo);
            	jsonObj.put("sizePerPage", sizePerPage);
            	
        		jsonArr.put(jsonObj);
        		
        	}// end of for
        	
        } // end of if 
       
        return jsonArr.toString(); 
       
    }// end of public String lodgingList (숙소 리스트 화면)
	
	
	
	// 한 숙소에대한 상세페이지
	@GetMapping("/lodgingDetail.trip")
	public ModelAndView lodingDetail(ModelAndView mav, HttpServletRequest request, LodgingVO lvo,
									 @RequestParam(defaultValue = "") String detail_check_in,
									 @RequestParam(defaultValue = "") String detail_check_out,
									 @RequestParam(defaultValue = "2") String detail_people) {
		/*
		 System.out.println("~~~ 확인용 detail_check_in : " + detail_check_in);
		 System.out.println("~~~ 확인용 detail_check_out : " + detail_check_out);
		 System.out.println("~~~ 확인용 detail_people : " + detail_people);
		*/
		String lodging_code = lvo.getLodging_code();
		
		// System.out.println("~~~ 확인용 : " + lodgingCode);
		
		LodgingVO lodgingDetail = service.getLodgingDetail(lodging_code);
		// 숙소의 상세정보만 가져오기
		
		Map<String,String> dateSendMap = new HashMap<>();
		
		dateSendMap.put("lodging_code", lodging_code);
		dateSendMap.put("check_in", detail_check_in);
		dateSendMap.put("check_out", detail_check_out);
		dateSendMap.put("people", detail_people);
		
		List<String> convenientList = service.getConvenientList(lodging_code);
		// 한 숙소에대한 편의시설 가져오기 (메소드 재활용)
		
		List<Map<String,String>> roomDetailList = service.getRoomDetail(dateSendMap);
		// 숙소의 객실 정보 가져오기
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null) {
			
			String userid = loginuser.getUserid();
			
			Map<String,String> chkMap = new HashMap<>();
			
			chkMap.put("lodging_code", lodging_code);
			chkMap.put("userid",userid);
			
			int chkLike = service.getLodgingLike(chkMap); // 한 숙소에 대해 좋아요를 눌렀는지 안눌렀는지
			
			if(chkLike > 0) {
				
				dateSendMap.put("chkLike", String.valueOf(chkLike));
			}
			
			
			int chkR = service.chkReservation(chkMap); // 숙소상세페이지 이동시에 예약했는지 확인하기 
			
			if(chkR > 0) {
				
				dateSendMap.put("chkR", String.valueOf(chkR));
				
				int chkC = service.chkReview(chkMap); // 리뷰를 작성했는지 안했는지 확인하기
				
				if(chkC > 0) {
					
					dateSendMap.put("chkC", String.valueOf(chkC));
					
				} // end of if 리뷰를 작성했는지 안했는지 chkC > 0
				
			} // end of 예약을 했는지 안했는지 chkR > 0
			
		} // end of 로그인 했는지 안했는지 if
		
		
		String local_status = lodgingDetail.getLocal_status();
		
		// 같은 지역구분 맛집 랜덤추천해주기
		FoodstoreVO fvo = service.getRandomFood(local_status);
		// 같은 지역구분 즐길거리 랜덤추천해주기
		PlayVO pvo = service.getRandomPlay(local_status);
		
		Map<String,Object> randMap = new HashMap<>();
		
		randMap.put("fvo", fvo);
		randMap.put("pvo", pvo);
		
		mav.addObject("randMap",randMap);
		
		mav.addObject("convenientList", convenientList);
		mav.addObject("lodgingDetail", lodgingDetail);
		mav.addObject("roomDetailList", roomDetailList);
		mav.addObject("dateSendMap",dateSendMap);
		
		
		mav.setViewName("lodging/lodgingDetail.tiles1");
		
		return mav;
		
	} // end of public ModelAndView lodingDetail(ModelAndView mav) (숙소 상세화면)
	
	
	// 숙소 상세페이지에서 재검색하기
	@ResponseBody
	@PostMapping(value="/JSONrenewalRooms.trip", produces="text/plain;charset=UTF-8")
	public String JSONrenewalRooms (@RequestParam(value = "lodging_code") String lodging_code,
								    @RequestParam(value = "check_in") String check_in,
								    @RequestParam(value = "check_out") String check_out,
								    @RequestParam(value = "people", defaultValue = "2") String people) {
		
		/*
		System.out.println("재검색 확인용 lodging_code : " + lodging_code);
		System.out.println("재검색 확인용 check_in : " + check_in);
		System.out.println("재검색 확인용 check_out : " + check_out);
		System.out.println("재검색 확인용 people : " + people);
		*/
		
		JSONArray jsonArr = new JSONArray();
		
		if(lodging_code != null && check_in != null &&
		   check_out != null && people != null) {
			
			Map<String,String> dateSendMap = new HashMap<>();
			
			dateSendMap.put("lodging_code", lodging_code);
			dateSendMap.put("check_in", check_in);
			dateSendMap.put("check_out", check_out);
			dateSendMap.put("people", people);
			
			List<Map<String,String>> roomDetailList = service.getRoomDetail(dateSendMap);
			// 숙소의 객실 정보 가져오기(메소드 재활용)
			
			if(roomDetailList != null) {
				
				for(Map<String,String> map : roomDetailList ) {
	        		
	        		JSONObject jsonObj = new JSONObject();
	        		
	        		jsonObj.put("lodging_code", map.get("lodging_code"));
	        		jsonObj.put("room_detail_code", map.get("room_detail_code"));
	        		jsonObj.put("room_name", map.get("room_name"));
	        		jsonObj.put("price", map.get("price"));
	        		jsonObj.put("remaining_qty", map.get("remaining_qty"));
	        		jsonObj.put("min_person", map.get("min_person"));
	        		jsonObj.put("max_person", map.get("max_person"));
	        		jsonObj.put("room_img", map.get("room_img"));
	        		jsonObj.put("check_inTime", map.get("check_inTime"));
	        		jsonObj.put("check_outTime", map.get("check_outTime"));
	        		
	        		jsonArr.put(jsonObj);
	        		
				} // end of for	
				
			} // end of if 
			
		}else {
			
			System.out.println("뭔가 잘못됌");
		}
		
		return jsonArr.toString();
		
	} // end of public String JSONrenewalRooms () (숙소 상세페이지에서 재검색하기) 
	
	
	// 결제 페이지 넘어가기
	@RequestMapping("/lodgingReservation.trip")
	public ModelAndView requiredLogin_lodgingReservation(HttpServletRequest request, 
										   HttpServletResponse response, 
										   ModelAndView mav,
										   @RequestParam(defaultValue = "") String lodging_code,
										   @RequestParam(defaultValue = "") String room_detail_code,
										   @RequestParam(defaultValue = "") String check_in,
										   @RequestParam(defaultValue = "") String check_out) {
		
		
		Map<String,String> paraMap = new HashMap<>();
		
		if(!"".equals(lodging_code) && !"".equals(room_detail_code)) {
			
			paraMap.put("lodging_code", lodging_code);
			paraMap.put("room_detail_code", room_detail_code);
			
			
		}else {
			
			String message = "비정상적인 접근입니다.";
			
			String loc = "javascript:history.back()";
	    	
	    	mav.addObject("message", message);
	    	mav.addObject("loc", loc);
	    	
	    	mav.setViewName("msg");
	    	
	    	return mav;
			
		}
			
		/*
		System.out.println("숙소번호 : " + lodging_code);
		System.out.println("객실번호 : " + room_detail_code);
		System.out.println("## check_in : " + check_in);
		System.out.println("## check_out : " + check_out);
		*/
		
		Map<String,String> reserve_info = service.getReserveRoomDetail(paraMap);
		
		
		if( (!"".equals(check_in) && !"".equals(check_out) ) ) {
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd");
			
			sdf.setLenient(false);
			
			try {
				Date in = sdf.parse(check_in);
				Date out = sdf.parse(check_out);
				
				
				long diff = ((out.getTime()-in.getTime()) / (24 * 60 * 60 * 1000));
				
				int days = (int)diff;		
						
				// System.out.println("~~ 확인용 days " + days);
				
				int sum = days * Integer.parseInt(reserve_info.get("price"));
				
				// System.out.println("~~ 확인용 sum : " + sum);
				
				reserve_info.put("totalPrice", String.valueOf(sum));
				
				reserve_info.put("days", String.valueOf(days));
				
			} catch (ParseException e) {
				
				e.printStackTrace();
			}
			
			reserve_info.put("check_in",check_in);
			reserve_info.put("check_out",check_out);
			
		}else {
			
			String message = "비정상적인 접근입니다.";
			
			String loc = "javascript:history.back()";
	    	
	    	mav.addObject("message", message);
	    	mav.addObject("loc", loc);
	    	
	    	mav.setViewName("msg");
	    	
	    	return mav;
			
		}
		
		
		mav.addObject("reserve_info", reserve_info);
		mav.setViewName("lodging/lodgingReservation.tiles1");
		
		return mav;
		
	} // end of public ModelAndView lodgingReservation 결제하는 예약페이지
	
	
	
	// 결제 팝업창 띄워주기
	@RequestMapping(value="/room_Reservation.trip")
	public ModelAndView goPaymentGateWay(ModelAndView mav) {
		
		mav.setViewName("paymentGateway");
		
		return mav;
		
	} // end of public ModelAndView goPaymentGateWay(ModelAndView mav) {
	
	
	// 결제완료 예약테이블 insert
	@ResponseBody
	@PostMapping(value="/JSONreserveInsert.trip")
	public String JSONreserveInsert(@RequestParam(defaultValue = "") String userid,
									@RequestParam(defaultValue = "") String lodging_code,
			   						@RequestParam(defaultValue = "") String room_detail_code,
			   						@RequestParam(defaultValue = "") String totalPrice,
			   						@RequestParam(defaultValue = "") String check_in,
			   						@RequestParam(defaultValue = "") String check_out,
			   						@RequestParam(defaultValue = "") String check_inTime,
			   						@RequestParam(defaultValue = "") String check_outTime,
			   						@RequestParam(defaultValue = "") String lodging_name,
			   						@RequestParam(defaultValue = "") String room_name,
			   						@RequestParam(defaultValue = "") String lodging_address,
			   						HttpServletRequest request) {
		
		/*
		System.out.println("~~ 확인용 userid : " + userid);
		System.out.println("~~ 확인용 room_detail_code : " + room_detail_code);
		System.out.println("~~ 확인용 price : " + price);
		System.out.println("~~ 확인용 check_in : " + check_in);
		System.out.println("~~ 확인용 check_out : " + check_out);
		*/
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		Map<String,String> paraMap = new HashMap<>();
		
		JSONObject jsonObj = new JSONObject();
		
		if(userid.equals(loginuser.getUserid())){
			
			paraMap.put("lodging_code", lodging_code);
			paraMap.put("room_detail_code", room_detail_code);
			paraMap.put("userid", userid);
			paraMap.put("totalPrice", totalPrice);
			
			// System.out.println("체크인시간 : " + check_inTime.substring(0,2));
			// System.out.println("체크아웃시간 : " + check_outTime.substring(0,2));
			
			paraMap.put("check_in", check_in + " " + check_inTime.substring(0,2) + ":00:00");
			paraMap.put("check_out", check_out + " " + check_outTime.substring(0,2) + ":00:00");
			
			System.out.println("체크인시간 : " + paraMap.get("check_in"));
			System.out.println("체크아웃시간 : " + paraMap.get("check_out"));
			
			// 예약결과 예약번호 표현을 위한 채번해오기
			String num = service.getReservationNum();
			
			paraMap.put("num", num);
			
			// 결제 후 예약테이블에 insert 하기 
			int n = service.insertReservation(paraMap);
			int m = 0;
			
			if(n==1) {
				
				paraMap.put("lodging_name",lodging_name);
				paraMap.put("room_name",room_name);
				paraMap.put("lodging_address",lodging_address);
				
				m = service.insertLodgingSchedule(paraMap); // 일정테이블에 추가하기
				
			}
			
			
			jsonObj.put("n", n * m);
			jsonObj.put("num", num);
			
		}
		else {
			
			jsonObj.put("n", 0);
			
		}
		
		return jsonObj.toString();
		
	} // end of public String JSONreserveInsert(HttpServletRequest request) {
	
	
	
	// 예약결과페이지 보내기
	@PostMapping("/reserveResult.trip")
	public ModelAndView reserveResult (ModelAndView mav,
									   @RequestParam(defaultValue = "") String lodging_code,
									   @RequestParam(defaultValue = "") String room_detail_code,
									   @RequestParam(defaultValue = "1") String days,
									   @RequestParam(defaultValue = "") String reservation_code) {
		
		Map<String,String> resultMap = new HashMap<>();
		
		// 예약테이블에 insert 가 정상적이라면 정상적으로 넘어온다
		if(!"".equals(reservation_code)&& reservation_code !=null) {
			
			Map<String,String> paraMap = new HashMap<>();
			
			paraMap.put("lodging_code", lodging_code);
			paraMap.put("room_detail_code", room_detail_code);
			paraMap.put("reservation_code", reservation_code);
			
			resultMap = service.getReservationInfo(paraMap);
			
			
			String local_status = resultMap.get("local_status");
			
			// 같은 지역구분 맛집 랜덤추천해주기
			FoodstoreVO fvo = service.getRandomFood(local_status);
			// 같은 지역구분 즐길거리 랜덤추천해주기
			PlayVO pvo = service.getRandomPlay(local_status);
			
			Map<String,Object> randMap = new HashMap<>();
			
			randMap.put("fvo", fvo);
			randMap.put("pvo", pvo);
			
			mav.addObject("randMap",randMap);
			
			if(resultMap != null) {
				
				resultMap.put("days", days); // 몇박인지 저장한데이터
				
			}
			
		}else {
			
			String message = "비정상적인 접근입니다. 예약결과페이지";
			
			String loc = "javascript:history.back()";
	    	
	    	mav.addObject("message", message);
	    	mav.addObject("loc", loc);
	    	
	    	mav.setViewName("msg");
	    	
	    	return mav;
			
		}
		
		mav.addObject("resultMap", resultMap);
		mav.setViewName("lodging/reserveResult.tiles1");
		
		return mav;
		
	} // end of public ModelAndView reserveResult
	
	
	
	// 숙소 리뷰 불러오기
	@ResponseBody
	@GetMapping(value="JSONLodgingCommentList.trip", produces="text/plain;charset=UTF-8")
	public String JSONLodgingCommentList(HttpServletRequest request) {
		
		String lodging_code = request.getParameter("lodging_code");
		String currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(currentShowPageNo == null) {
			
			currentShowPageNo = "1";
		}
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
				
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String,String> paraMap = new HashMap<>();
		
		paraMap.put("lodging_code", lodging_code);
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
        
		// 댓글 페이징 처리를 위한 토탈 카운트 구해오기
		int totalCount = service.getCommentTotalCount(lodging_code);
		
		// 리뷰리스트 가져오기
		List<Map<String,String>> commentList  = service.getCommentList_Paging(paraMap);
		
		
		
		JSONArray jsonArr = new JSONArray();
		
		if(commentList != null) {
			
			
			for(Map<String,String> cmtMap : commentList) {
				
				JSONObject jsonObj = new JSONObject(); // 
				
				jsonObj.put("rno", cmtMap.get("rno"));
				jsonObj.put("review_code", cmtMap.get("review_code")); 
				jsonObj.put("user_name", cmtMap.get("user_name")); 
				jsonObj.put("review_content", cmtMap.get("review_content"));
				jsonObj.put("regDate", cmtMap.get("regDate")); 
				jsonObj.put("registerday", cmtMap.get("registerday")); 
				jsonObj.put("fk_userid", cmtMap.get("fk_userid")); 
				
				jsonObj.put("totalCount", totalCount); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				
				jsonArr.put(jsonObj);
				
			} // end of for
			
		} // end of if
		
		// System.out.println(jsonArr.toString());
		
		return jsonArr.toString(); 
		
	}// end of public String CommentList(HttpServletRequest request) {} \
	
	
	
	// 숙소 리뷰 수정하기
	@ResponseBody
	@PostMapping(value="/JSONUpdateComment.trip", produces="text/plain;charset=UTF-8")
	public String JSONUpdateLodgingComment(@RequestParam (value="review_code") String review_code,
									@RequestParam (value="content") String content) {
		
		// System.out.println("~~~ 확인용 : review_code " + review_code);
		// System.out.println("~~~ 확인용 : content " + content);
		
		Map<String, String> paraMap = new HashMap<>();
		
		JSONObject jsonObj = new JSONObject();
		
		int n = 0;
		
		if(review_code !=null && content !=null) {
			
			paraMap.put("review_code", review_code);
			paraMap.put("content", content);
			
			// 숙소 상세 댓글 수정하기
			n = service.updateLodgingComment(paraMap); 
			
		} // end of if
		
		jsonObj.put("n",n);
		
		return jsonObj.toString();
		
	} // end of public String JSONUpdateComment
	
	
	// 숙소 리뷰 삭제하기
	@ResponseBody
	@PostMapping(value="/JSONDeleteComment.trip", produces="text/plain;charset=UTF-8")
	public String JSONDeleteLodgingComment(@RequestParam (value="review_code") String review_code) {
		
		int n = 0;
		
		if(review_code !=null) {
			
			// 숙소 리뷰 삭제하기
			n = service.deleteLodgingComment(review_code);
			
		}
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	} // end of public String JSONDeleteLodgingComment(@RequestParam (value="review_code") String review_code) {
	
	
	
	// 숙소 리뷰 작성하기
	@ResponseBody
	@PostMapping(value="/addLodgingReview.trip", produces="text/plain;charset=UTF-8")
	public String addLodgingReview(ReviewVO rvo) {
		
		int n = 0;
		
		/*
		System.out.println("fk_userid = "+rvo.getFk_userid());
		System.out.println("parent_code = "+rvo.getParent_code());
		System.out.println("review_content = "+rvo.getReview_content());
		System.out.println("review_division_R = "+rvo.getReview_division_R());
		*/
		
		// 숙소 리뷰 작성하기
		n = service.addLodgingReview(rvo);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	
	} // end of public String addLodgingComment
	
	
	// 숙소 좋아요 취소하기
	@ResponseBody	
	@PostMapping(value="/lodgingcancelAddLike.trip", produces="text/plain;charset=UTF-8")
	public String lodgingCancelAddLike(@RequestParam (value="userid") String userid,
									   @RequestParam (value="lodging_code") String lodging_code) {
		
		
		Map<String,String> paraMap = new HashMap<>();
		
		paraMap.put("userid", userid);
		paraMap.put("lodging_code", lodging_code);
		
		int n = service.lodgingCancelAddLike(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	} // end of public String lodgingcancelAddLike( 숙소 좋아요 취소하기
	
	
	
	
	// 숙소 좋아요 추가하기
	@ResponseBody	
	@PostMapping(value="/lodgingaddLike.trip", produces="text/plain;charset=UTF-8")
	public String lodgingAddLike(@RequestParam (value="userid") String userid,
							     @RequestParam (value="lodging_code") String lodging_code) {
		
		
		Map<String,String> paraMap = new HashMap<>();
		
		paraMap.put("userid", userid);
		paraMap.put("lodging_code", lodging_code);
		
		int n = service.lodgingAddLike(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	} // end of public String lodgingaddLike 숙소 좋아요 추가하기
	
	
	
	
	@PostMapping("/registerRoomDetail.trip")
	public ModelAndView registerRoomDetail(@RequestParam (value="send_fk_lodging_code") String fk_lodging_code,
										   @RequestParam (value="send_companyid") String companyid,
										   ModelAndView mav, HttpServletRequest request) {
		
		// System.out.println("~~ 확인용 fk_lodging_code : " + fk_lodging_code);
		
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		
		if(loginCompanyuser != null && companyid.equalsIgnoreCase(loginCompanyuser.getCompanyid())) {
			// 로그인 한 회사가 자기 회사의 업체를 등록하는 경우
			
			mav.addObject("fk_lodging_code",fk_lodging_code);
			
			mav.setViewName("company/registerRoomDetail.tiles1");
			
		}
		else {
			String message = "업체 계정으로 로그인을 하지 않았거나 잘못된 로그인 정보입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	} // end of public ModelAndView registerRoomDetail 
	
	
}
