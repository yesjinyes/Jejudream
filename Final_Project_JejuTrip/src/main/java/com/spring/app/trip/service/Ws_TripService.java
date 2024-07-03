package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;

public interface Ws_TripService {

	int companyRegister(CompanyVO cvo);// 회사 회원가입을 위한 service 메소드 생성
	int companyIdCheck(String companyid);// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드 생성
	int companyEmailCheck(String email);// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	int registerHotelEnd(LodgingVO lodgingvo);// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	List<LodgingVO> select_lodgingvo(String choice_status);	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	int screeningRegisterEnd(Map<String, String> paraMap);// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.

}
