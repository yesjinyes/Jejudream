package com.spring.app.trip.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
		
		@ResponseBody
		@GetMapping(value = "playMain.trip")
		public ModelAndView play_main(ModelAndView mav, HttpServletRequest request) {
			
			
			List<PlayVO> playList = service.playList();
			
			mav.addObject("playList", playList);
			mav.setViewName("play/playMain.tiles1");
			
			return mav; 
			// /WEB-INF/views/tiles1/play/play_main.jsp 파일 생성
			
			
		}

}
