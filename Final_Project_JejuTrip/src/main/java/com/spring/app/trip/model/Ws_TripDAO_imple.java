package com.spring.app.trip.model;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.CompanyVO;

@Component
@Repository
public class Ws_TripDAO_imple implements Ws_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 회사 회원가입을 위한 메소드 생성
	@Override
	public int companyRegister(CompanyVO cvo) {
		int n = sqlsession.insert("ws_trip.companyRegister",cvo);
		return n;
	}// end of public int companyRegister(CompanyVO cvo) {

}
