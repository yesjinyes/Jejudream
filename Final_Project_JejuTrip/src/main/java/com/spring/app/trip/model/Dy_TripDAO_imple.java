package com.spring.app.trip.model;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.CompanyVO;
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

	
	// 일반회원 아이디 중복확인
	@Override
	public String useridDuplicateCheck(String userid) {
		
		String exist_userid = sqlsession.selectOne("dy_trip.useridDuplicateCheck", userid);
		
		return exist_userid;
	}
	
	
	// 일반회원 이메일 중복확인
	@Override
	public String userEmailDuplicateCheck(String email) {
		
		String exist_email = sqlsession.selectOne("dy_trip.userEmailDuplicateCheck", email);
		
		return exist_email;
	}

	
	// 로그인 처리하기 (일반회원, 관리자)
	@Override
	public MemberVO getLoginMember(Map<String, String> paraMap) {

		MemberVO loginuser = sqlsession.selectOne("dy_trip.getLoginMember", paraMap);
		
		return loginuser;
	}


	// tbl_member 테이블의 idle 컬럼의 값을 1로 변경하기
	@Override
	public void updateMemberIdle(Map<String, String> paraMap) {
		sqlsession.update("dy_trip.updateMemberIdle", paraMap);
		
	}


	// tbl_member_loginhistory 테이블에 로그인 기록 입력하기
	@Override
	public void insert_member_loginhistory(Map<String, String> paraMap) {

		sqlsession.insert("dy_trip.insert_member_loginhistory", paraMap);
	}


	// 로그인 처리하기 (업체회원)
	@Override
	public CompanyVO getLoginCompanyMember(Map<String, String> paraMap) {

		CompanyVO loginCompanyuser = sqlsession.selectOne("dy_trip.getLoginCompanyMember", paraMap);
		
		return loginCompanyuser;
	}


	// tbl_company 테이블의 idle 컬럼의 값을 1로 변경하기
	@Override
	public void updateCompanyIdle(Map<String, String> paraMap) {
		
		sqlsession.update("dy_trip.updateCompanyIdle", paraMap);
		
	}


	// tbl_company_loginhistory 테이블에 로그인 기록 입력하기
	@Override
	public void insert_company_loginhistory(Map<String, String> paraMap) {
		
		sqlsession.insert("dy_trip.insert_company_loginhistory", paraMap);
	}


	// 아이디찾기 처리하기 (일반회원, 관리자)
	@Override
	public Map<String, String> memberIdFind(Map<String, String> paraMap) {
		
		Map<String, String> findInfo = sqlsession.selectOne("dy_trip.memberIdFind", paraMap);
		
		return findInfo;
	}


	// 아이디찾기 처리하기 (업체회원)
	@Override
	public Map<String, String> companyIdFind(Map<String, String> paraMap) {

		Map<String, String> findInfo = sqlsession.selectOne("dy_trip.companyIdFind", paraMap);
		
		return findInfo;
	}


	// 비밀번호찾기 시 사용자가 존재하는지 확인하기
	@Override
	public String pwFind(Map<String, String> paraMap) {
		
		String user = "";
		
		if("company".equals(paraMap.get("memberType"))) {
			user = sqlsession.selectOne("dy_trip.companyPwFind", paraMap);
			
		} else {
			user = sqlsession.selectOne("dy_trip.memberPwFind", paraMap);
		}
		
		return user;
	}


	// 비밀번호찾기 - 비밀번호 변경
	@Override
	public int pwUpdate(Map<String, String> paraMap) {
		
		int result = 0;
		
		if("company".equals(paraMap.get("memberType"))) {
			result = sqlsession.update("dy_trip.companyPwUpdate", paraMap);
			
		} else {
			result = sqlsession.update("dy_trip.memberPwUpdate", paraMap);
		}
		
		return result;
	}
	

}
