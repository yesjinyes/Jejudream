package com.spring.app.trip.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.MemberVO;

public interface Dy_TripService {

	// 회원가입 처리하기
	int memberRegister(MemberVO mvo);
	
	// 일반회원 아이디 중복확인
	boolean useridDuplicateCheck(String userid);
	
	// 일반회원 이메일 중복확인
	boolean userEmailDuplicateCheck(String email);

	// 로그인 처리하기 (일반회원, 관리자)
	ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request);

	// 로그인 처리하기 (업체회원)
	ModelAndView companyLoginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request);

	// 아이디찾기 처리하기 (일반회원, 관리자)
	Map<String, String> memberIdFind(Map<String, String> paraMap);

	// 아이디찾기 처리하기 (업체회원)
	Map<String, String> companyIdFind(Map<String, String> paraMap);

	// 비밀번호찾기 시 사용자가 존재하는지 확인하기
	boolean isUserExist(Map<String, String> paraMap);

	// 비밀번호찾기 - 비밀번호 변경
	int pwUpdate(Map<String, String> paraMap);

	// 맛집등록 - 일련번호 채번해오기
	String getCommonSeq();

	// === 데이터베이스에 맛집 정보 insert 하기 ===
	int foodstoreRegister(FoodstoreVO fvo);
}
