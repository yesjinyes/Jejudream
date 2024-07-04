package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;

public interface Ws_TripDAO {

	int companyRegister(CompanyVO cvo);// 회사 회원가입을 위한 메소드 생성
	int companyIdCheck(String companyid);// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드
	int companyEmailCheck(String encrypt);// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	int registerHotelEnd(LodgingVO lodgingvo);// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	List<LodgingVO> select_lodgingvo(Map<String, String> paraMap);	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	int screeningRegisterEnd(Map<String, String> paraMap);// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
	int getTotalCount(String choice_status);// 총 게시물 건수(totalCount)
	List<Map<String, String>> select_convenient();// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
	String getSeq();// insert 를 위해 seq 채번 해오기
	void insert_convenient(Map<String, String> paraMap);// 숙소정보에 따른 편의시설 정보 insert 해주기

}
