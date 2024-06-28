package com.spring.app.trip.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.model.Dy_TripDAO;

@Service
public class Dy_TripService_imple implements Dy_TripService {
	
	@Autowired
	private Dy_TripDAO dao;
	
    @Autowired
    private AES256 aES256;

    
    // 회원가입 처리하기
	@Override
	public int memberRegister(MemberVO mvo) {
		
		try {
			String pw = Sha256.encrypt(mvo.getPw());
			String email = aES256.encrypt(mvo.getEmail());
			String mobile = aES256.encrypt(mvo.getMobile());
			
			mvo.setPw(pw);
			mvo.setEmail(email);
			mvo.setMobile(mobile);
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = dao.memberRegister(mvo);
		
		return n;
	}


	// 로그인 처리하기 (일반회원, 관리자)
	@Override
	public ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request) {
		
		MemberVO loginuser = dao.getLoginMember(paraMap);
		
		return mav;
	}

}
