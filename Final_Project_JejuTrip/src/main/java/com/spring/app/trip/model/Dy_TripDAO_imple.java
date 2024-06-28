package com.spring.app.trip.model;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.MemberVO;

@Repository
public class Dy_TripDAO_imple implements Dy_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	
	// 회원가입 처리하기
	@Override
	public int memberRegister(MemberVO mvo) {
		
		int n = sqlsession.insert("dy_trip.memberRegister", mvo);
		
		return n;
	}
	

}
