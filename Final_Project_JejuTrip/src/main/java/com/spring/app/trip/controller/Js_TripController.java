package com.spring.app.trip.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.LodgingVO;
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
	
	@GetMapping("/lodging/lodgingList.trip")
    public ModelAndView lodgingList(ModelAndView mav) {
       
		List<LodgingVO> lodgingList = service.lodgingList();
		
        mav.addObject("lodgingList", lodgingList);
              
        mav.setViewName("lodging/lodgingList.tiles1");
       
        return mav; 
       
    }
	
	

}
