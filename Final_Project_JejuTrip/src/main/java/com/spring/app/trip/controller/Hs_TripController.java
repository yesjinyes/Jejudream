package com.spring.app.trip.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.service.Hs_TripService;

@Controller
public class Hs_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Hs_TripService service;
	
	// === 커뮤니티 메인 페이지 보이기 === //
		@GetMapping("mypageMain.trip")
		public String mypage_main(HttpServletRequest request) {
			return "mypage/mypageMain.tiles1"; 
			// /WEB-INF/views/tiles1/mypage/mypageMain.jsp 파일 생성
		}
		
		
		@GetMapping("reservations.trip")
		public String reservation(HttpServletRequest request) {
			return "mypage/reservations.tiles1"; 
			// /WEB-INF/views/mypage/reservations.jsp 파일 생성
		}
		
		
		@GetMapping("edit_profile.trip")
		public String edit_profile(HttpServletRequest request) {
			return "mypage/edit_profile.tiles1"; 
			// /WEB-INF/views/mypage/edit_profile.jsp 파일 생성
		}
		
		/*@GetMapping("cash_points.trip")
		public String cash_points(HttpServletRequest request) {
			return "mypage/cash_points"; 
			// /WEB-INF/views/mypage/cash_points.jsp 파일 생성
		}*/
		
		@GetMapping("review.trip")
		public String review(HttpServletRequest request) {
			return "mypage/review.tiles1"; 
			// /WEB-INF/views/mypage/review.jsp 파일 생성
		}
		
		@GetMapping("support.trip")
		public String support(HttpServletRequest request) {
			return "mypage/support.tiles1"; 
			// /WEB-INF/views/mypage/support.jsp 파일 생성
		}
		
		
		
		@GetMapping(value = "playMain.trip", produces = "text/plain;charset=UTF-8")
		public ModelAndView play_main(ModelAndView mav, HttpServletRequest request) {
			List<PlayVO> playList = service.playList();
			
			mav.addObject("playList", playList);
			mav.setViewName("play/playMain.tiles1");
			
			return mav;
		}
		
		//카테고리별로 데이터 가져오기 JSON
		@ResponseBody
		@GetMapping(value = "playMainJSON.trip", produces = "text/plain;charset=UTF-8")
		public String play_mainJSON( HttpServletRequest request) {
			
			//--------------스크롤 페이징----------------------//
			String start = request.getParameter("start");
		    String len = request.getParameter("len");
		    String end = String.valueOf(Integer.parseInt(start) + Integer.parseInt(len) - 1); // 1 + 8 = 9 - 1 = 8
		    //--------------스크롤 페이징----------------------//

		    String category = request.getParameter("category");
		    System.out.println(category);
		    
		    Map<String, String> paraMap = new HashMap<>();
		    paraMap.put("start", start); // "1"  "9"  "17"  "25"  "33"
		    paraMap.put("end", end); // end => start + len - 1; 
		    paraMap.put("category", category); 
		    
			List<PlayVO> playList;
			
			if (category == null || category.equals("전체")) {
	            playList = service.playList(paraMap); // 모든 항목 가져오기
	        } else {
	            playList = service.getPlayListByCategory(paraMap); // 카테고리에 따른 항목 가져오기
	        }
			
			
			JSONArray jsonArr = new JSONArray();
			if(playList != null) {
				for(PlayVO playvo : playList) {
					JSONObject jsonObj = new JSONObject(); //{}
					jsonObj.put("play_category",playvo.getPlay_category()); 
					jsonObj.put("play_name",playvo.getPlay_name() );
					jsonObj.put("play_content",playvo.getPlay_content() ); 
					jsonObj.put("play_mobile",playvo.getPlay_mobile() ); 
					jsonObj.put("play_businesshours",playvo.getPlay_businesshours() ); 
					jsonObj.put("play_address",playvo.getPlay_address() ); 
					jsonObj.put("play_main_img",playvo.getPlay_main_img() ); 
					
		
					jsonArr.put(jsonObj);
				}
				//System.out.println("json" + jsonArr);
			}
			return jsonArr.toString();
		 
		}

}