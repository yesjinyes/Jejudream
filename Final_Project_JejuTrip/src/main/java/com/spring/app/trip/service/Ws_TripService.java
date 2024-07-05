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
	List<LodgingVO> select_lodgingvo(Map<String, String> paraMap);	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	int screeningRegisterEnd(Map<String, String> paraMap);// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
	int getTotalCount(String choice_status);// 총 게시물 건수(totalCount)
	List<Map<String, String>> select_convenient();// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
	String getSeq();// 시퀀스 채번해오기
	void insert_convenient(Map<String, String> paraMap);// 숙소정보에 따른 편의시설 정보 insert 해주기
	List<Map<String, String>> select_convenient_list();// 편의시설 정보를 가져와서 view 페이지에 표출시켜주기위한 List select
	List<Map<String, String>> select_count_registerHotel(String companyid);// 숙소 테이블에서 해당 업체의 신청건수, 승인건수, 반려 건수를 각각 알아온다.
	List<LodgingVO> select_loginCompany_lodgingvo(String companyid);		// 로그인 한 기업의 신청 목록을 읽어와서 view 페이지에 목록으로 뿌려주기 위한 select
	LodgingVO selectRegisterHotelJSON(String lodging_code);// 업체가 신청한 호텔에 대한 상세 정보를 보여주기위해 DB에서 읽어온다.

}
