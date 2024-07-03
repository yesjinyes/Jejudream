package com.spring.app.trip.service;

import java.util.List;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;

public interface Ws_TripService {

	int companyRegister(CompanyVO cvo);// 회사 회원가입을 위한 service 메소드 생성
	int companyIdCheck(String companyid);// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드 생성
	int companyEmailCheck(String email);// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	int registerHotelEnd(LodgingVO lodgingvo);// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	List<LodgingVO> select_all_lodgingvo();// 숙소 등록을 신청한 업체중 심사중인 모든 업체들 불러오기

}
