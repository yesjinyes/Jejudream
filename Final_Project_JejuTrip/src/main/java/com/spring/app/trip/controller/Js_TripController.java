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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.LodgingVO;
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
	
	@GetMapping("/lodgingList.trip")
    public ModelAndView lodgingList(ModelAndView mav, HttpServletRequest request) {
       
		      
        mav.setViewName("lodging/lodgingList.tiles1");
       
        return mav; 
       
    }
	
	
	@ResponseBody
	@GetMapping(value="/updateLodgingList.trip", produces="text/plain;charset=UTF-8")
    public String lodgingList(HttpServletRequest request,
							  @RequestParam(defaultValue = "") String str_deptId,
							  @RequestParam(defaultValue = "") String gender) {
       
		
		
		
		
		
		List<LodgingVO> lodgingList = service.lodgingList();
		
		JSONArray jsonArr = new JSONArray();
              
        if(lodgingList != null) {
        	
        	for(LodgingVO lvo : lodgingList ) {
        		
        		JSONObject jsonObj = new JSONObject();
        		
        		jsonObj.put("main_img", lvo.getMain_img());
        		jsonObj.put("lodging_name",lvo.getLodging_name());
        		jsonObj.put("lodging_category",lvo.getLodging_category());
        		jsonObj.put("lodging_address",lvo.getLodging_address());
        		jsonObj.put("local_status",lvo.getLocal_status());
        		
        		jsonArr.put(jsonObj);
        		
        	}// end of for
        	
        } // end of if 
       
        return jsonArr.toString(); 
       
    }
	
	

}
