package com.spring.app.trip.service;


import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.model.Ws_TripDAO;
@Service
public class Ws_TripService_imple implements Ws_TripService {
	
	@Autowired
	private Ws_TripDAO dao;

	@Autowired
    private AES256 aES256;
	
	// 회사 회원가입을 위한 service 메소드 생성
	@Override
	public int companyRegister(CompanyVO cvo) {
		try {
			String pw = Sha256.encrypt(cvo.getPw());
			String email = aES256.encrypt(cvo.getEmail());
			String mobile = aES256.encrypt(cvo.getMobile());
			
			cvo.setPw(pw);
			cvo.setEmail(email);
			cvo.setMobile(mobile);
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = dao.companyRegister(cvo);
		return n;
	}// end of public int companyRegister(CompanyVO cvo) {
	
	// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드
	@Override
	public int companyIdCheck(String companyid) {
		int n = dao.companyIdCheck(companyid);
		return n;
	}// end of public int companyIdCheck(String companyid) {
	
	// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	@Override
	public int companyEmailCheck(String email) {
		int n = 0;
		try {
			n = dao.companyEmailCheck(aES256.encrypt(email));
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return n;
	}// end of public int companyEmailCheck(String email) {

}
