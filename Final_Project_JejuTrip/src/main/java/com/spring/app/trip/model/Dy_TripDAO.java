package com.spring.app.trip.model;

import java.util.Map;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.MemberVO;

public interface Dy_TripDAO {

	// 회원가입 처리하기
	int memberRegister(MemberVO mvo);
	
	// 일반회원 아이디 중복확인
	String useridDuplicateCheck(String userid);

	// 일반회원 이메일 중복확인
	String userEmailDuplicateCheck(String email);
	
	// 로그인 처리하기 (일반회원, 관리자)
	MemberVO getLoginMember(Map<String, String> paraMap);

	// tbl_member 테이블의 idle 컬럼의 값을 1로 변경하기
	void updateMemberIdle(Map<String, String> paraMap);

	// tbl_member_loginhistory 테이블에 로그인 기록 입력하기
	void insert_member_loginhistory(Map<String, String> paraMap);

	// 로그인 처리하기 (업체회원)
	CompanyVO getLoginCompanyMember(Map<String, String> paraMap);

	// tbl_company 테이블의 idle 컬럼의 값을 1로 변경하기
	void updateCompanyIdle(Map<String, String> paraMap);

	// tbl_company_loginhistory 테이블에 로그인 기록 입력하기
	void insert_company_loginhistory(Map<String, String> paraMap);

	// 아이디찾기 처리하기 (일반회원, 관리자)
	Map<String, String> memberIdFind(Map<String, String> paraMap);

	// 아이디찾기 처리하기 (업체회원)
	Map<String, String> companyIdFind(Map<String, String> paraMap);

	// 비밀번호찾기 시 사용자가 존재하는지 확인하기
	String pwFind(Map<String, String> paraMap);

	// 비밀번호찾기 - 비밀번호 변경
	int pwUpdate(Map<String, String> paraMap);

	// 맛집등록 - 일련번호 채번해오기
	String getCommonSeq();
	
}
