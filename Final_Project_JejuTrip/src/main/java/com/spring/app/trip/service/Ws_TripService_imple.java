package com.spring.app.trip.service;


import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.model.Ws_TripDAO;
@Service
public class Ws_TripService_imple implements Ws_TripService {
	
	@Autowired
	private Ws_TripDAO dao;

	@Autowired
    private AES256 aES256;
	
	// 회사 회원가입을 위한 service 메소드 생성
	@Override
	public int companyRegister(CompanyVO cvo) {
		try {
			String pw = Sha256.encrypt(cvo.getPw());
			String email = aES256.encrypt(cvo.getEmail());
			String mobile = aES256.encrypt(cvo.getMobile());
			
			cvo.setPw(pw);
			cvo.setEmail(email);
			cvo.setMobile(mobile);
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = dao.companyRegister(cvo);
		return n;
	}// end of public int companyRegister(CompanyVO cvo) {
	
	// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드
	@Override
	public int companyIdCheck(String companyid) {
		int n = dao.companyIdCheck(companyid);
		return n;
	}// end of public int companyIdCheck(String companyid) {
	
	// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	@Override
	public int companyEmailCheck(String email) {
		int n = 0;
		try {
			n = dao.companyEmailCheck(aES256.encrypt(email));
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return n;
	}// end of public int companyEmailCheck(String email) {
	
	// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	@Override
	public int registerHotelEnd(LodgingVO lodgingvo) {
		int n = dao.registerHotelEnd(lodgingvo);
		return n;
	}// end of public int registerHotelEnd(LodgingVO lodgingvo) {
	
	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	@Override
	public List<LodgingVO> select_lodgingvo(Map<String, String> paraMap) {
		List<LodgingVO> lodgingvoList = dao.select_lodgingvo(paraMap);
		return lodgingvoList;
	}// end of public LodgingVO select_all_lodgingvo() {
	
	// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
	@Override
	public int screeningRegisterEnd(Map<String, String> paraMap) {
		int n = dao.screeningRegisterEnd(paraMap);
		return n;
	}// end of public int screeningRegisterEnd(Map<String, String> paraMap) {
	
	// 총 게시물 건수(totalCount)
	@Override
	public int getTotalCount(String choice_status) {
		int totalCount = dao.getTotalCount(choice_status);
		return totalCount;
	}// end of public int getTotalCount(String choice_status) {
	
	// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
	@Override
	public List<Map<String, String>> select_convenient() {
		List<Map<String,String>> mapList = dao.select_convenient();
		return mapList;
	}

	// === insert 를 위해 seq 채번해오기 === // 
	@Override
	public String getSeq() {
		String seq = dao.getSeq();
		return seq;
	}
	
	// 숙소정보에 따른 편의시설 정보 insert 해주기
	@Override
	public void insert_convenient(Map<String, String> paraMap) {
		dao.insert_convenient(paraMap);
		
	}
	
	//편의시설 정보를 가져와서 view 페이지에 표출시켜주기위한 List select
	@Override
	public List<Map<String, String>> select_convenient_list() {
		List<Map<String,String>> mapList = dao.select_convenient_list();
		return mapList;
	}
	
	// 숙소 테이블에서 해당 업체의 신청건수, 승인건수, 반려 건수를 각각 알아온다.
	@Override
	public List<Map<String, String>> select_count_registerHotel(String companyid) {
		List<Map<String,String>> mapList = dao.select_count_registerHotel(companyid);
		return mapList;
	}
	
	// 로그인 한 기업의 신청 목록을 읽어와서 view 페이지에 목록으로 뿌려주기 위한 select
	@Override
	public List<LodgingVO> select_loginCompany_lodgingvo(String companyid) {
		List<LodgingVO> lodgingvo = dao.select_loginCompany_lodgingvo(companyid);
		return lodgingvo;
	}
	
	// 업체가 신청한 호텔에 대한 상세 정보를 보여주기위해 DB에서 읽어온다.
	@Override
	public LodgingVO selectRegisterHotelJSON(String lodging_code) {
		LodgingVO lodgingvo = dao.selectRegisterHotelJSON(lodging_code);
		return lodgingvo;
	}
	
	// 모든 회원의 정보를 읽어오는 메소드 생성
	@Override
	public List<MemberVO> select_member_all(Map<String, String> paraMap) {
		List<MemberVO> memberList = dao.select_member_all(paraMap);
		
		for(MemberVO member : memberList) {
			try {
				member.setEmail(aES256.decrypt(member.getEmail()));
				member.setMobile(aES256.decrypt(member.getMobile()));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return memberList;
	}
	
	// 모든 기업의 정보를 읽어오는 메소드 생성
	@Override
	public List<CompanyVO> select_Company_all(Map<String, String> paraMap) {
		List<CompanyVO> companyList = dao.select_Company_all(paraMap);
		
		for(CompanyVO company : companyList) {
			try {
				company.setEmail(aES256.decrypt(company.getEmail()));
				company.setMobile(aES256.decrypt(company.getMobile()));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return companyList;
	}
	
	// member 테이블의 총 행 개수 알아오기
	@Override
	public int getTotalMemberCount() {
		int count = dao.getTotalMemberCount();
		return count;
	}
	
	// company 테이블의 총 행 개수 알아오기
	@Override
	public int getTotalCompanyCount() {
		int count = dao.getTotalCompanyCount();
		return count;
	}

}
