package com.spring.app.trip.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;

@Component
@Repository
public class Ws_TripDAO_imple implements Ws_TripDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 회사 회원가입을 위한 메소드 생성
	@Override
	public int companyRegister(CompanyVO cvo) {
		int n = sqlsession.insert("ws_trip.companyRegister",cvo);
		return n;
	}// end of public int companyRegister(CompanyVO cvo) {
	
	// 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드
	@Override
	public int companyIdCheck(String companyid) {
		String select_companyid = sqlsession.selectOne("ws_trip.companyIdCheck",companyid);
		if(select_companyid != null) {
			return 1;
		}
		else {
			return 0;
		}
	}// end of public int companyIdCheck(String companyid) {
	
	// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	@Override
	public int companyEmailCheck(String email) {
		String select_companyEmail = sqlsession.selectOne("ws_trip.companyEmailCheck",email);
		if(select_companyEmail != null) {
			return 1;
		}
		else {
			return 0;
		}
	}// end of public int companyEmailCheck(String encrypt) {
	
	// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
	@Override
	public int registerHotelEnd(LodgingVO lodgingvo) {
		int n = sqlsession.insert("ws_trip.registerHotelEnd",lodgingvo);
		return n;
	}// end of public int registerHotelEnd(LodgingVO lodgingvo) {
	
	// 숙소 등록을 신청한 업체중 선택한 카테고리에 해당하는 모든 업체들 불러오기
	@Override
	public List<LodgingVO> select_lodgingvo(Map<String, String> paraMap) {
		List<LodgingVO> lodgingvoList = sqlsession.selectList("ws_trip.select_lodgingvo",paraMap);
		return lodgingvoList;
	}// end of public LodgingVO select_all_lodgingvo() {
	
	// 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
	@Override
	public int screeningRegisterEnd(Map<String, String> paraMap) {
		int n = sqlsession.update("ws_trip.screeningRegisterEnd",paraMap);
		return n;
	}
	
	// 총 게시물 건수(totalCount)
	@Override
	public int getTotalCount(String choice_status) {
		int total_count = sqlsession.selectOne("ws_trip.getTotalCount",choice_status);
		return total_count;
	}// end of public int getTotalCount(String choice_status) {
	
	// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
	@Override
	public List<Map<String, String>> select_convenient() {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.select_convenient");
		return mapList;
	}

	// insert 하기위해 seq 채번해오기
	@Override
	public String getSeq() {
		String seq = sqlsession.selectOne("ws_trip.getSeq");
		return seq;
	}
	
	// 숙소정보에 따른 편의시설 정보 insert 해주기
	@Override
	public void insert_convenient(Map<String, String> paraMap) {
		String str_convenient = paraMap.get("str_convenient");
		String[] arr_convenient = str_convenient.split(",");
		String seq = paraMap.get("seq");
		paraMap = new HashMap<>();
		paraMap.put("seq",seq);
		for(int i=0; i<arr_convenient.length; i++) {
			
			String convenient_code = arr_convenient[i];
			paraMap.put("convenient_code", convenient_code);
			sqlsession.insert("ws_trip.insert_convenient",paraMap);
		}
		
	}
	
	//편의시설 정보를 가져와서 view 페이지에 표출시켜주기위한 List select
	@Override
	public List<Map<String, String>> select_convenient_list() {
		List<Map<String,String>> mapList = sqlsession.selectList("ws_trip.select_convenient_list");
		return mapList;
	}

}
