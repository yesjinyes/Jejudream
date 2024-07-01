package com.spring.app.trip.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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


	// 일반회원 아이디 중복확인
	@Override
	public boolean useridDuplicateCheck(String userid) {
		
		boolean isExist = false;
		
		String exist_userid = dao.useridDuplicateCheck(userid);
		
		if(exist_userid != null) {
			isExist = true;
		}
		
		return isExist;
	}

	
	// 일반회원 이메일 중복확인
	@Override
	public boolean userEmailDuplicateCheck(String email) {
		
		boolean isExist = false;
		
		try {
			email = aES256.encrypt(email);
			
			String exist_email = dao.userEmailDuplicateCheck(email);
			
			if(exist_email != null) {
				isExist = true;
			}
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		return isExist;
	}


	// 로그인 처리하기 (일반회원, 관리자)
	@Override
	public ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request) {
		
		MemberVO loginuser = dao.getLoginMember(paraMap);
		
		if(loginuser != null && loginuser.getPwdchangegap() >= 3) {
			// 마지막으로 암호를 변경한 날짜가 현재 시각으로부터 3개월이 지났으면
			
			loginuser.setRequirePwdChange(true); // 로그인 시 암호를 변경하라는 alert 를 띄우도록 한다.
		}
		
		if(loginuser != null && loginuser.getLastlogingap() >= 12 && loginuser.getIdle() == 0) {
			// 마지막으로 로그인 한 날짜시간이 현재시각으로부터 1년이 지났으면 휴면으로 지정
			loginuser.setIdle(1);
			
			// 회원의 idle 컬럼의 값을 1로 변경하기
			dao.updateIdle(paraMap);
		}
		
		if(loginuser != null && loginuser.getIdle() == 0) {
			
			try {
				String email = aES256.decrypt(loginuser.getEmail());
				String mobile = aES256.decrypt(loginuser.getMobile());
				
				loginuser.setEmail(email);
				loginuser.setMobile(mobile);
				
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			// 로그인 기록 테이블에 기록 입력하기
			dao.insert_loginhistory(paraMap);
		}
		
		if(loginuser == null) { // 로그인 실패 시
			String message = "아이디 또는 비밀번호가 일치하지 않습니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		} else { // DB에 아이디, 비밀번호가 존재하는 경우
			
			if(loginuser.getIdle() == 1) { // 로그인 한 지 1년이 경과한 경우

				String message = "로그인을 한 지 1년이 지나 휴면상태가 되었습니다.\\n관리자에게 문의 바랍니다.";
				String loc = request.getContextPath() + "/main.trip";
				// 추후에 휴면 계정을 풀어주는 페이지로 이동하기
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
				
			} else { // 로그인 한 지 1년 이내인 경우

				HttpSession session = request.getSession();
				
				session.setAttribute("loginuser", loginuser);
				
				if(loginuser.isRequirePwdChange()) { // 암호를 마지막으로 변경한 날짜로부터 3개월 경과한 경우
					
					String message = "비밀번호를 변경하신지 3개월이 지났습니다.\\n암호를 변경하는 것을 추천합니다.";
					String loc = request.getContextPath() + "/main.trip";
					// 추후에 비밀번호 변경 페이지로 이동하기

					mav.addObject("message", message);
					mav.addObject("loc", loc);

					mav.setViewName("msg");

				} else { // 암호를 마지막으로 변경한 날짜가 3개월 이내인 경우
					
					String goBackURL = (String)session.getAttribute("goBackURL");
					
					if(goBackURL != null) {
						mav.setViewName("redirect:" + goBackURL);
						session.removeAttribute("goBackURL");
						
					} else {
						mav.setViewName("redirect:/main.trip"); // 시작 페이지로 이동
					}
				}
			}
			
		}
		
		
		return mav;
	}



}
