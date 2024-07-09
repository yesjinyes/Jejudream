package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.LodgingVO;


@Component
@Repository	
public class Js_TripDAO_imple implements Js_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 조건에 따른 숙소리스트 select 해오기
	@Override
	public List<Map<String,String>> lodgingList(Map<String, Object> paraMap) {
		
		List<Map<String,String>> lodgingList = sqlsession.selectList("js_trip.lodgingList" , paraMap);
		return lodgingList;
	}

	
	// 숙소리스트에서 조건에 따른 숙소 개수 구해오기
	@Override
	public int getLodgingTotalCount(Map<String, Object> paraMap) {
		
		int totalCount = sqlsession.selectOne("js_trip.getLodgingTotalCount", paraMap);
		
		return totalCount;
		
	} // end of public int getLodgingTotalCount(Map<String, String> paraMap) {} 


	// 숙소리스트에 표현할 편의시설 목록 구해오기
	@Override
	public List<String> getConvenientList() {
		
		List<String> convenientList = sqlsession.selectList("js_trip.getConvenientList");
		
		return convenientList;
		
	} // end of public List<String> getConvenientList() { 


	// 숙소의상세정보만 가져오기
	@Override
	public LodgingVO getLodgingDetail(String lodgingCode) {
		
		LodgingVO lodgingDetail = sqlsession.selectOne("js_trip.getLodgingDetail",lodgingCode);
		
		return lodgingDetail;
	} // end of public LodgingVO getLodgingDetail(String lodgingCode) {


	// 숙소의 객실 정보 가져오기
	@Override
	public List<Map<String, String>> getRoomDetail(String lodgingCode) {
		
		List<Map<String, String>> roomDetailList = sqlsession.selectList("js_trip.getRoomDetail", lodgingCode);
		
		return roomDetailList;
		
	} // end of public List<Map<String, String>> getRoomDetail(String lodgingCode) { 

}
