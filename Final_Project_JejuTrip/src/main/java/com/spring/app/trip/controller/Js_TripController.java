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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.service.Js_TripService;

@Controller
public class Js_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Js_TripService service;
	
	
	@GetMapping("/lodgingList.trip")
    public ModelAndView lodgingList(ModelAndView mav, HttpServletRequest request) {
       
		// 숙소리스트에 표현할 편의시설 목록 구해오기
		List<String> convenientList =  service.getConvenientList();
		
		
		mav.addObject("convenientList", convenientList);
        mav.setViewName("lodging/lodgingList.tiles1");
       
        return mav; 
       
    } // end of public ModelAndView lodgingList(ModelAndView mav, HttpServletRequest request) {
	
	
	@ResponseBody
	@GetMapping(value="/updateLodgingList.trip", produces="text/plain;charset=UTF-8")
    public String lodgingList(HttpServletRequest request,
							  @RequestParam(defaultValue = "") String str_category,
							  @RequestParam(defaultValue = "") String str_convenient,
							  @RequestParam(defaultValue = "") String str_local,
							  @RequestParam(defaultValue = "") String searchWord,
							  @RequestParam(defaultValue = "") String currentShowPageNo,
							  @RequestParam(defaultValue = "") String sort) {
		/*
		System.out.println("~~ 확인용 str_category " + str_category);
		System.out.println("~~ 확인용 str_convenient " + str_convenient);
		System.out.println("~~ 확인용 str_local " + str_local);
		System.out.println("~~ 확인용 searchWord " + searchWord);
		System.out.println("~~ 확인용 currentShowPageNo " + currentShowPageNo);
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
			
			paraMap.put("searchWord", searchWord);
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
		
		// System.out.println("~~~~ 확인용 sort : " + sort);
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
	
	
	
	@PostMapping("/lodgingDetail.trip")
	public ModelAndView lodingDetail(ModelAndView mav, HttpServletRequest request, LodgingVO lvo) {
		
		String lodgingCode = lvo.getLodging_code();
		
		// System.out.println("~~~ 확인용 : " + lodgingCode);
		
		LodgingVO lodgingDetail = service.getLodgingDetail(lodgingCode);
		// 숙소의 상세정보만 가져오기
		
		
		
		
		List<Map<String,String>> roomDetailList = service.getRoomDetail(lodgingCode);
		// 숙소의 객실 정보 가져오기
		
		mav.addObject("roomDetailList", roomDetailList);
		
		
		mav.addObject("lodgingDetail", lodgingDetail);
		mav.setViewName("lodging/lodgingDetail.tiles1");
		
		return mav;
		
	} // end of public ModelAndView lodingDetail(ModelAndView mav) (숙소 상세화면)
	
	

}
