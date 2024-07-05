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

}
