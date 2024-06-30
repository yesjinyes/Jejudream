package com.spring.app.trip.model;

import java.util.Map;

import com.spring.app.trip.domain.MemberVO;

public interface Dy_TripDAO {

	// 회원가입 처리하기
	int memberRegister(MemberVO mvo);

	// 로그인 처리하기 (일반회원, 관리자)
	MemberVO getLoginMember(Map<String, String> paraMap);

	// 회원의 idle 컬럼의 값을 1로 변경하기
	void updateIdle(Map<String, String> paraMap);

	// 로그인 기록 테이블에 기록 입력하기
	void insert_loginhistory(Map<String, String> paraMap);

}
