package com.spring.app.trip.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.PlayVO;

@Component
@Repository	
public class Js_TripDAO_imple implements Js_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	@Override
	public List<LodgingVO> lodgingList() {
		
		List<LodgingVO> lodgingList = sqlsession.selectList("js_trip.lodgingList");
		return lodgingList;
	}

}
