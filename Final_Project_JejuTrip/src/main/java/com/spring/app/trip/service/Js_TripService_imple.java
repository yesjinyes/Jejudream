package com.spring.app.trip.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.model.Js_TripDAO;

@Service
public class Js_TripService_imple implements Js_TripService {
   
   @Autowired
   private Js_TripDAO dao;

   // 조건에 따른 숙소리스트 select 해오기
   @Override
   public List<Map<String,String>> lodgingList(Map<String, Object> paraMap) {
      
      List<Map<String,String>> lodgingList = dao.lodgingList(paraMap);
      
      return lodgingList;
   }

   
   // 숙소리스트에서 조건에 따른 숙소 개수 구해오기
   @Override
   public int getLodgingTotalCount(Map<String, Object> paraMap) {
		
	   int totalCount = dao.getLodgingTotalCount(paraMap);
	   
	   return totalCount;
	   
   } // end of public int getLodgingTotalCount(Map<String, Object> paraMap) {

   
   // 숙소리스트에 표현할 편의시설 목록 구해오기
   @Override
   public List<String> getConvenientList() {
	   
	   List<String> convenientList = dao.getConvenientList();
	   
	   return convenientList;
	   
   } // end of public List<String> getConvenientList() {


   // 숙소의상세정보만 가져오기
   @Override
   public LodgingVO getLodgingDetail(String lodgingCode) {
	   
	   LodgingVO lodgingDetail = dao.getLodgingDetail(lodgingCode);
	
	   return lodgingDetail;
	   
	} // end of public LodgingVO getLodgingDetail(String lodgingCode) {


	// 숙소의 객실 정보 가져오기
	@Override
	public List<Map<String, String>> getRoomDetail(String lodgingCode) {
		
		List<Map<String, String>> roomDetailList = dao.getRoomDetail(lodgingCode);
		
		return roomDetailList;
		
	} // end of public List<Map<String, String>> getRoomDetail(String lodgingCode) { 
}   
