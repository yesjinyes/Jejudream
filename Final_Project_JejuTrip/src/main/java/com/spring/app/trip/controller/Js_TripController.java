package com.spring.app.trip.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.service.Js_TripService;

@Controller
public class Js_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Js_TripService service;
	/*
	@RequestMapping(value = "/lodging/lodgingList.trip")
	public String test_select (HttpServletRequest request) {
		
		
		return "/lodging/lodgingList";
	}
	*/
	
	@RequestMapping(value = "/lodging/lodgingList.trip")
    public ModelAndView play_main(ModelAndView mav) {
       
		List<PlayVO> playList = service.playList();
		
        mav.addObject("playList", playList);
              
        mav.setViewName("/lodging/lodgingList");
       
        return mav; 
       // /WEB-INF/views/play/play_main.jsp 파일 생성
    }
	
	

}
