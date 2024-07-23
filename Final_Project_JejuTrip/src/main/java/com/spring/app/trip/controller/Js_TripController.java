package com.spring.app.trip.controller;

import java.io.File;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.domain.RoomDetailVO;
import com.spring.app.trip.service.Js_TripService;

@Controller
public class Js_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Js_TripService service;
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;
	
	// 숙소리스트 페이지로 보내주기
	@GetMapping("/lodgingList.trip")
    public ModelAndView lodgingList(ModelAndView mav, HttpServletRequest request) {
		
		String lodging_code = "";
		// 숙소리스트에 표현할 편의시설 목록 구해오기
		List<Map<String,String>> convenientList = service.getConvenientList(lodging_code);
		
		
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
		
		List<Map<String,String>> convenientList = service.getConvenientList(lodging_code);
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
			
			if(check_inTime.length() >2) {
				
				paraMap.put("check_in", check_in + " " + check_inTime.substring(0,2) + ":00:00");
				paraMap.put("check_out", check_out + " " + check_outTime.substring(0,2) + ":00:00");
				
			}
			else if (check_inTime.length() == 2) {
				
				paraMap.put("check_in", check_in + " 0" + check_inTime.substring(0,1) + ":00:00");
				paraMap.put("check_out", check_out + " 0" + check_outTime.substring(0,1) + ":00:00");
				
			}
			
			
			
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
	
	
	
	// 객실등록버튼을 누르고 객실등록 페이지로 보내주기
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
	
	
	// 한 숙소에 대한 객실 등록하기
	@PostMapping("/registerRoomDetailEnd.trip")
	public ModelAndView registerRoomDetailEnd(@RequestParam("attach[]") List<MultipartFile> multiFileList,
												ModelAndView mav , MultipartHttpServletRequest mrequest,
											  @RequestParam("str_room_name") String str_room_name,
											  @RequestParam("str_price") String str_price,
											  @RequestParam("str_min_person") String str_min_person,
											  @RequestParam("str_max_person") String str_max_person,
											  @RequestParam("str_check_in") String str_check_in,
											  @RequestParam("str_check_out") String str_check_out,
											  @RequestParam("fk_lodging_code") String fk_lodging_code) {
		
		if(multiFileList != null && multiFileList.size() > 0) {
			
			String[] arr_room_name = str_room_name.split("\\,");
			String[] arr_price = str_price.split("\\,");
			String[] arr_min_person = str_min_person.split("\\,");
			String[] arr_max_person = str_max_person.split("\\,");
			String[] arr_check_in = str_check_in.split("\\,");
			String[] arr_check_out = str_check_out.split("\\,");
			
			RoomDetailVO rvo = new RoomDetailVO();
			
			HttpSession session = mrequest.getSession(); 
		    String root = session.getServletContext().getRealPath("/");
		    
		    String path = root + "resources" + File.separator + "images"+File.separator +"lodginglist" + File.separator + "room";
			
			for(int i=0; i<multiFileList.size(); i++) {
				
				rvo.setFk_lodging_code(fk_lodging_code);
				
				String originalFilename = multiFileList.get(i).getOriginalFilename(); 
				
				String newFileName = "";
		        // WAS(톰캣)의 디스크에 저장될 파일명
		        
		        byte[] bytes = null;
		        // 첨부파일의 내용물을 담는 것이다.
		        
		        long fileSize = 0;
		        // 첨부파일의 크기 
		        
		        try {
					bytes = multiFileList.get(i).getBytes(); 
					
					/*
					System.out.println("multiFileList 파일명 : " + originalFilename);
					System.out.println("multiFileList 사이즈 : " + multiFileList.get(i).getSize());
					System.out.println("arr_room_name : " + arr_room_name[i]);
					System.out.println("arr_price : " + arr_price[i]);
					System.out.println("arr_min_person : " + arr_min_person[i]);
					System.out.println("arr_max_person : " + arr_max_person[i]);
					System.out.println("arr_check_in : " + arr_check_in[i]);
					System.out.println("arr_check_out : " + arr_check_out[i]);
					
					multiFileList 파일명 : 01.png
					multiFileList 사이즈 : 185996
					arr_room_name : 객실1
					arr_price : 1111111111
					arr_min_person : 2
					arr_max_person : 2
					arr_check_in : 2
					arr_check_out : 2
					multiFileList 파일명 : 02.png
					multiFileList 사이즈 : 159634
					arr_room_name : 객실2
					arr_price : 2222222
					arr_min_person : 3
					arr_max_person : 3
					arr_check_in : 3
					arr_check_out : 3
					.....
					*/
					
					newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
					
					rvo.setRoom_img(newFileName);
					rvo.setFileName(newFileName);
					
					rvo.setOrgFilename(originalFilename);
					
					fileSize = multiFileList.get(i).getSize();// 첨부파일의 크기 (단위는 byte임)
					
					String room_seq = service.getRoomDetailSeq(); // 객실등록 채번해오기
					
					rvo.setRoom_detail_code(room_seq);
					
					rvo.setFileSize(String.valueOf(fileSize));
					
					rvo.setRoom_name(arr_room_name[i]);
					rvo.setPrice(arr_price[i]);
					rvo.setMin_person(Integer.parseInt(arr_min_person[i]));
					rvo.setMax_person(Integer.parseInt(arr_max_person[i]));
					rvo.setCheck_in((arr_check_in[i]) + "시");
					rvo.setCheck_out((arr_check_out[i]) + "시");
										
					int n = service.insertRoomDetail(rvo); // 객실등록하기
										
				} catch (Exception e) {
					
					System.out.println(i+"번째 파일 업로드 실패함");
					e.printStackTrace();
				}
		        
			} // end of for
			
			String message = "객실 등록이 성공적으로 완료되었습니다!";
			String loc = "index.trip";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		} // end of if
		else {
			
			String message = "객실 등록의 데이터가 정상적이지 않습니다!";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		}
		
		return mav;
		
	} // end of public ModelAndView registerRoomDetailEnd
	
	
	
	// 업체가 객실을 등록했는지 안했는지 알아오기
	@ResponseBody
	@GetMapping(value="/JSONFindRoomRegister.trip", produces="text/plain;charset=UTF-8")
	public String JSONFindRoomRegister(@RequestParam ("lodging_code") String fk_lodging_code) {
		
		JSONObject jsonObj = new JSONObject();
		
		if(fk_lodging_code !=null && !"".equals(fk_lodging_code) ) {
			
			int room_cnt = service.getRoomCnt(fk_lodging_code);
			// 등록한 숙소개수가 몇개인지 알아오기
			
			jsonObj.put("result", room_cnt);
			
		}
		
		return jsonObj.toString();
		
	}// end of public String JSONFindRoomRegister
	
	
	
	// 객실 수정/삭제버튼을 누르고 객실수정 페이지로 보내주기
	@PostMapping("/updateRoomDetail.trip")
	public ModelAndView updateRoomDetail(@RequestParam (value="send_fk_lodging_code") String fk_lodging_code,
										   @RequestParam (value="send_companyid") String companyid,
										   ModelAndView mav, HttpServletRequest request) {
		
		// System.out.println("~~ 확인용 fk_lodging_code : " + fk_lodging_code);
		
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		
		if(loginCompanyuser != null && companyid.equalsIgnoreCase(loginCompanyuser.getCompanyid())) {
			// 로그인 한 회사가 자기 회사의 업체를 등록하는 경우
			
			mav.addObject("fk_lodging_code",fk_lodging_code);
			mav.setViewName("company/updateRoomDetail.tiles1");
			
		}
		else {
			String message = "업체 계정으로 로그인을 하지 않았거나 잘못된 로그인 정보입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	} // end of public ModelAndView updateRoomDetail
	
	
	// Json 으로 등록된 객실정보 가져오기
	@ResponseBody
	@GetMapping(value="/JSONGetRoomDetails.trip", produces="text/plain;charset=UTF-8")
	public String JSONGetRoomDetails(@RequestParam (value="fk_lodging_code") String fk_lodging_code) {
		
		
		// 등록된 객실정보 가져오기
		List<RoomDetailVO> roomList = service.getForUpdateRoomList(fk_lodging_code);
		
		JSONArray jsonArr = new JSONArray();
		
		if(roomList !=null && roomList.size() > 0) {
			
			for(RoomDetailVO rvo : roomList) {
				
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("room_detail_code", rvo.getRoom_detail_code());
				jsonObj.put("room_name", rvo.getRoom_name());
				jsonObj.put("fk_lodging_code", rvo.getFk_lodging_code());
				jsonObj.put("price", rvo.getPrice());
				jsonObj.put("check_in", rvo.getCheck_in());
				jsonObj.put("check_out", rvo.getCheck_out());
				jsonObj.put("min_person", rvo.getMin_person());
				jsonObj.put("max_person", rvo.getMax_person());
				jsonObj.put("room_img", rvo.getRoom_img());
				jsonObj.put("fileName", rvo.getFileName());
				jsonObj.put("orgFilename", rvo.getOrgFilename());
				jsonObj.put("fileSize", rvo.getFileSize());
				
				jsonArr.put(jsonObj);
				
			} // end of for
			
		} // end of ir
		
		return jsonArr.toString();
		
	} // end of public String JSONGetRoomDetails
	
	
	
	// 한 숙소에 대한 객실 수정하기
	@PostMapping("/updateRoomDetailEnd.trip")
	public ModelAndView updateRoomDetailEnd(@RequestParam("attach[]") List<MultipartFile> multiFileList,
											ModelAndView mav , MultipartHttpServletRequest mrequest,
											@RequestParam("str_room_detail_code") String str_room_detail_code,
											@RequestParam("str_room_img") String str_room_img,
											@RequestParam("str_room_name") String str_room_name,
											@RequestParam("str_price") String str_price,
											@RequestParam("str_min_person") String str_min_person,
											@RequestParam("str_max_person") String str_max_person,
											@RequestParam("str_check_in") String str_check_in,
											@RequestParam("str_check_out") String str_check_out,
											@RequestParam("fk_lodging_code") String fk_lodging_code) {
		
			
		String[] arr_room_detail_code = str_room_detail_code.split("\\,");
		String[] arr_room_img = str_room_img.split("\\,");
		
		
		String[] arr_room_name = str_room_name.split("\\,");
		String[] arr_price = str_price.split("\\,");
		String[] arr_min_person = str_min_person.split("\\,");
		String[] arr_max_person = str_max_person.split("\\,");
		String[] arr_check_in = str_check_in.split("\\,");
		String[] arr_check_out = str_check_out.split("\\,");
		
		
		if (arr_room_name != null && arr_room_name.length > 0) {
			// 입력된 내용이 null아니고 하나이상의 데이터가 있을때 기준을 name으로 잡은것뿐임
			
	        HttpSession session = mrequest.getSession();
	        String root = session.getServletContext().getRealPath("/");
	        String path = root + "resources" + File.separator + "images" + File.separator + "lodginglist" + File.separator + "room";

	        for (int i = 0; i < arr_room_detail_code.length; i++) {
	        	// 이전 페이지로부터 room_detail_code를 받아온 길이만큼만 update
	        	
	            if (arr_room_detail_code[i] != null && arr_room_name[i] != null) {
	            	
	                RoomDetailVO rvo = new RoomDetailVO();
	                
	                rvo.setRoom_detail_code(arr_room_detail_code[i]); // 수정할 room_detail_code set

	                String originalFilename = multiFileList.get(i).getOriginalFilename();
	                
	                String newFileName = "";
			        // WAS(톰캣)의 디스크에 저장될 파일명
			        
			        byte[] bytes = null;
			        // 첨부파일의 내용물을 담는 것이다.
			        
			        long fileSize = 0;
			        // 첨부파일의 크기 

	                try {
	                    // 기존 이미지 파일명 삭제
	                    fileManager.doFileDelete(arr_room_img[i], path);

	                    bytes = multiFileList.get(i).getBytes(); // 첨부파일의 크기 (단위는 byte임)
	                    
	                    newFileName = fileManager.doFileUpload(bytes, originalFilename, path);

	                    rvo.setRoom_img(newFileName);
	                    rvo.setFileName(newFileName);
	                    rvo.setOrgFilename(originalFilename);
	                    fileSize = multiFileList.get(i).getSize();
	                    rvo.setFileSize(String.valueOf(fileSize));
	                    rvo.setRoom_name(arr_room_name[i]);
	                    rvo.setPrice(arr_price[i]);
	                    rvo.setMin_person(Integer.parseInt(arr_min_person[i]));
	                    rvo.setMax_person(Integer.parseInt(arr_max_person[i]));
	                    rvo.setCheck_in(arr_check_in[i]);
	                    rvo.setCheck_out(arr_check_out[i]);

	                    int n = service.updateRoomDetail(rvo); // 객실 수정하기
	                    
	                    System.out.println(n + "번 객실 수정 완료");

	                } catch (Exception e) {
	                    
	                	System.out.println(i + "번째 객실 수정 실패");
	                    e.printStackTrace();
	                    
	                } // end of catch
	                
	            }// end of if 객실일련번호가 존재하면서 입력기준이 존재할때
	            
	        }// end of for 객실 수정하는 for문

	        // 수정이 아니고 새로 추가된 객실정보일때
	        for (int i = arr_room_detail_code.length; i < multiFileList.size(); i++) {
	        	// 객실일련번호가 존재하지않는 새로 추가하는 객실일때
	        	
	            RoomDetailVO rvo = new RoomDetailVO();
	            
	            rvo.setFk_lodging_code(fk_lodging_code);

	            String originalFilename = multiFileList.get(i).getOriginalFilename();
	            String newFileName = "";
		        // WAS(톰캣)의 디스크에 저장될 파일명
		        
		        byte[] bytes = null;
		        // 첨부파일의 내용물을 담는 것이다.
		        
		        long fileSize = 0;
		        // 첨부파일의 크기 

	            try {
	                bytes = multiFileList.get(i).getBytes(); // 첨부파일의 크기 (단위는 byte임)
	                
	                newFileName = fileManager.doFileUpload(bytes, originalFilename, path);

	                rvo.setRoom_img(newFileName);
	                rvo.setFileName(newFileName);
	                rvo.setOrgFilename(originalFilename);
	                fileSize = multiFileList.get(i).getSize();
	                rvo.setFileSize(String.valueOf(fileSize));

	                String room_seq = service.getRoomDetailSeq(); // 객실등록 채번해오기
	                
	                rvo.setRoom_detail_code(room_seq);

	                rvo.setRoom_name(arr_room_name[i]);
	                rvo.setPrice(arr_price[i]);
	                rvo.setMin_person(Integer.parseInt(arr_min_person[i]));
	                rvo.setMax_person(Integer.parseInt(arr_max_person[i]));
	                rvo.setCheck_in(arr_check_in[i]);
	                rvo.setCheck_out(arr_check_out[i]);

	                int n = service.insertRoomDetail(rvo); // 객실 등록하기
	                System.out.println(n + "번째 추가된 객실 등록");

	            } catch (Exception e) {
	                System.out.println(i + "번째 객실 추가 실패");
	                e.printStackTrace();
	                
	            } // end of catch
	            
	        } // end of for 추가된 객실정보 insert

	        String message = "객실 수정이 성공적으로 완료되었습니다!";
	        String loc = "myRegisterHotel.trip";

	        mav.addObject("message", message);
	        mav.addObject("loc", loc);

	        mav.setViewName("msg");

	    } else {
	    	
	        String message = "객실 수정 데이터가 정상적이지 않습니다!";
	        String loc = "javascript:history.back()";

	        mav.addObject("message", message);
	        mav.addObject("loc", loc);

	        mav.setViewName("msg");
	        
	    } // end of else

		return mav;
		
	} // end of public ModelAndView updateRoomDetailEnd 객실 수정하거나 추가된 객실 insert
	
	
	// 객실 개별 삭제하기
	@ResponseBody
	@PostMapping(value="/deleteRoomDetails.trip", produces="text/plain;charset=UTF-8")
	public String deleteRoomDetails(@RequestParam("room_detail_code") String room_detail_code) {
		
		JSONObject jsonObj = new JSONObject();
		
		if(room_detail_code !=null || !"".equals(room_detail_code)) {
			
			int n = service.deleteRoomDetail(room_detail_code); // 객실 삭제하기
			
			if (n == 1) {
	        	
	            System.out.println("객실 삭제성공");
	            jsonObj.put("result", n);
	            
	        } else {
	        	
	        	jsonObj.put("result", n);
	        	System.out.println("객실 삭제실패");
	            
	        } // end of else
			
		}else {
			
			System.out.println("뭔가 데이터가 잘못됨");
			
		} // end of else
		
	    return jsonObj.toString();
	    
	} // end of public String deleteRoomDetails
	
	
	
	// 숙소 정보 수정하는 페이지로 보내기
	@GetMapping("/editLodging.trip")
	public ModelAndView editLodging(ModelAndView mav, HttpServletRequest request,
									@RequestParam("send_lodging_code") String lodging_code,
									@RequestParam("send_companyid") String companyid) {
		
		
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		
		if(loginCompanyuser != null && companyid.equalsIgnoreCase(loginCompanyuser.getCompanyid())) {
			// 로그인 한 업체가 맞는지 확인
			
			LodgingVO lvo = service.getLodgingDetail(lodging_code);
			
			// 숙소 수정을 위한 전체 편의시설 체크박스 데이터 가져오기
			lodging_code = "";
			List<Map<String,String>> convenientList = service.getConvenientList(lodging_code);
			
			lodging_code = lvo.getLodging_code();
			List<Map<String,String>> selectedConvenientList = service.getConvenientList(lodging_code);
			
			
			mav.addObject("lvo", lvo);
			
			mav.addObject("convenientList",convenientList);
			mav.addObject("selectedConvenientList",selectedConvenientList); 
			
			mav.setViewName("/company/editLodging.tiles1");
		}
		else {
			String message = "업체 계정으로 로그인을 하지 않았거나 잘못된 로그인 정보입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	} // end of public ModelAndView editLodging
	
	
	// 받아온 정보로 숙소정보 수정하기
	@PostMapping("/editLodgingEnd.trip")
	public ModelAndView editLodgingEnd(ModelAndView mav, LodgingVO lvo, MultipartHttpServletRequest mrequest, 
									   @RequestParam ("str_convenient") String str_convenient,
									   @RequestParam ("address") String address,
									   @RequestParam ("detail_address") String detail_address) {
		
		 
		MultipartFile attach = lvo.getAttach();
	      
		if( !attach.isEmpty() ) {
			          
			HttpSession session = mrequest.getSession(); 
			String root = session.getServletContext().getRealPath("/"); 
			
			String path = root + "resources"+File.separator+"images"+File.separator+"lodginglist";     
	        // System.out.println("경로명 : " + path);
	        
	        String newFileName = "";
	        // WAS(톰캣)의 디스크에 저장될 파일명 
	         
	        byte[] bytes = null;
	        // 첨부파일의 내용물을 담는 것
	         
	        long fileSize = 0;
	        // 첨부파일의 크기 
	        
	        try {
	            bytes = attach.getBytes();
	            
	            // 기존 숙소 이미지파일 삭제하기
	            fileManager.doFileDelete(lvo.getFileName(), path);
	            
	            String originalFilename = attach.getOriginalFilename();
	            
	            // 새로 받아온 이미지파일 업로드하기
	            newFileName = fileManager.doFileUpload(bytes, originalFilename, path); 
	            
	            lvo.setFileName(newFileName);
	                     
	            lvo.setOrgFilename(attach.getOriginalFilename());
	            lvo.setMain_img(newFileName);
	                     
	            fileSize = attach.getSize();  // 첨부파일의 크기(단위는 byte임) 
	            lvo.setFileSize(String.valueOf(fileSize));
	                     
	         } catch (Exception e) {
	            e.printStackTrace();
	         }   
		}

		
		lvo.setLodging_address((address + " " + detail_address).trim());
		
		// 입력된 정보로 숙소 정보 수정하기
		int n = service.updateLodging(lvo);
		
		if(n == 1) {
			
			// 해당 숙소가 해당하는 편의시설 delete 후 insert 하기
			
			if(!str_convenient.equals("")) {
				
				Map<String,String> paraMap = new HashMap<>();
				
				paraMap.put("fk_lodging_code", lvo.getLodging_code());
				paraMap.put("str_convenient",str_convenient);
				
				// 숙소에 해당하는 편의시설 정보 삭제하기 (트랜잭션 처리로 )
				int m = 0;
				
				try {
					
					m = service.deleteInsertLodgingConvenient(paraMap);
					
				} catch (Throwable e) {
					
					System.out.println("트랜잭션 처리 오류");
					e.printStackTrace();
				}
				
				System.out.println("트랜잭션 처리 delete after insert " + m);
				
			} // 편의시설정보가 비어있지않다면
			
			String message = "숙소 정보수정 완료";
			String loc = "myRegisterHotel.trip";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		else {
			String message = "숙소 정보수정 실패";
			String loc = "index.trip";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	} // end of public ModelAndView editLodgingEnd
	
	
	// 등록된 숙소 삭제하기
	@ResponseBody
	@PostMapping(value="/JSONDeleteLodging.trip", produces="text/plain;charset=UTF-8")
	public String JSONDeleteLodging (@RequestParam("lodging_code") String lodging_code) {
		
		int n = service.deleteLodgingInfo(lodging_code);
		
		JSONObject jsonObj = new JSONObject();
		
		if(n==1) {
			
			jsonObj.put("result", n);
			
		}
		
		return jsonObj.toString();
		
	} // end of public String JSONDeleteLodging (@RequestParam("lodgingCode") String lodgingCode) {
	
	
	// === 기상청 XML 연결 하기 ===
	@GetMapping("weatherXML.trip")
	public String weatherXML() {
		
		return "weatherXML";
		// /board/src/main/webapp/WEB-INF/views/weather/weatherXML.jsp 파일을 생성한다.
		
	} // end of public String weatherXML() { 
	
	
	// 크롤링해온 축제와 행사중 현재일에 포함되는 것만 가져오기
	@ResponseBody
	@GetMapping(value="JSONcurrent_festival.trip", produces="text/plain;charset=UTF-8")
	public String current_festival() {
		
		// db에서 sysdate에 해당하는 축제가져오기
		List<Map<String,String>> festivalList = service.getCurrentFestival();
								
		JSONArray json_arr = new JSONArray();
		
		for(Map<String,String> map : festivalList) {
			
			JSONObject jsonObj = new JSONObject();
			
			jsonObj.put("festival_no", map.get("festival_no"));
			jsonObj.put("title_name", map.get("title_name"));
			jsonObj.put("img", map.get("img"));
			jsonObj.put("startdate", map.get("startdate"));
			jsonObj.put("enddate", map.get("enddate"));
			jsonObj.put("local_status", map.get("local_status"));
			jsonObj.put("link", map.get("link"));
			
			json_arr.put(jsonObj);
			
		} // end of for 
		
		return json_arr.toString();
		
	} // end of String current_festival() {
	
	
	
	// 실시간 인기글 가져오기
	@ResponseBody
	@GetMapping(value="JSONgetPopularBoard.trip", produces="text/plain;charset=UTF-8")
	public String getPopularBoard() {
		
		// 글 작성일이 3일이내인 조회수 높은 커뮤니티 글목록 가져오기
		List<BoardVO> popularBoardList = service.getPopularBoard();
								
		JSONArray json_arr = new JSONArray();
		
		for(BoardVO bvo : popularBoardList) {
			
			JSONObject jsonObj = new JSONObject();
			
			jsonObj.put("category", bvo.getCategory());
			jsonObj.put("seq", bvo.getSeq());
			jsonObj.put("subject", bvo.getSubject());
			
			json_arr.put(jsonObj);
			
		} // end of for 
		
		return json_arr.toString();
		
	} // end of String current_festival() {
	
}
