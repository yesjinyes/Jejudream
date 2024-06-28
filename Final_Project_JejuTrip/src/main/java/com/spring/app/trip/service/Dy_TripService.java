package com.spring.app.trip.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.MemberVO;

public interface Dy_TripService {

	// 회원가입 처리하기
	int memberRegister(MemberVO mvo);

	// 로그인 처리하기 (일반회원, 관리자)
	ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request);

}
