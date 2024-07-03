package com.spring.app.trip.model;



import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.PlayVO;
@Component
@Repository
public class Hs_TripDAO_imple implements Hs_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	//즐길거리 List
	@Override
	public List<PlayVO> playList() {
		List<PlayVO> playList = sqlsession.selectList("hs_trip.playList_1");
		return playList;
	}
	
	@Override
	public List<PlayVO> playList(Map<String, String> paraMap) {
		List<PlayVO> playList = sqlsession.selectList("hs_trip.playList",paraMap);
		return playList;
	}

	@Override
	public List<PlayVO> getPlayListByCategory(Map<String, String> paraMap) {
		List<PlayVO> playList = sqlsession.selectList("hs_trip.getPlayListByCategory",paraMap);
		return playList;
	}

	@Override
	public int registerPlayEnd(PlayVO playvo) {
		int n = sqlsession.insert("hs_trip.registerPlayEnd",playvo);
		return n;
	}


}
