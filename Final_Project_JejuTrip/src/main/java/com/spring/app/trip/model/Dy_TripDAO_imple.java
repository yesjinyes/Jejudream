package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.CommentVO;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
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
	public String isExist(Map<String, String> paraMap) {
		
		String user = "";
		
		if("company".equals(paraMap.get("memberType"))) {
			user = sqlsession.selectOne("dy_trip.isCompanyExist", paraMap);
			
		} else {
			user = sqlsession.selectOne("dy_trip.isMemberExist", paraMap);
		}
		
		return user;
	}


	// 비밀번호 변경
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


	// 맛집등록 - 일련번호 채번해오기
	@Override
	public String getCommonSeq() {
		
		String food_store_code = sqlsession.selectOne("dy_trip.getCommonSeq");
		
		return food_store_code;
	}


	// === 데이터베이스에 맛집 정보 insert 하기 ===
	@Override
	public int foodstoreRegister(FoodstoreVO fvo) {
		
		int n = sqlsession.insert("dy_trip.foodstoreRegister", fvo);
		
		return n;
	}


	// tbl_food_add_img 테이블에 추가이미지 파일명 insert 하기
	@Override
	public int insert_food_add_img(Map<String, String> paraMap) {
		
		int n = sqlsession.insert("dy_trip.insert_food_add_img", paraMap);
		
		return n;
	}


	// 기존 비밀번호와 값이 일치한지 비교하기
	@Override
	public String isSamePw(Map<String, String> paraMap) {
		
		String result = "";
		
		if("company".equals(paraMap.get("memberType"))) {
			result = sqlsession.selectOne("dy_trip.isSamePwCompany", paraMap);
			
		} else {
			result = sqlsession.selectOne("dy_trip.isSamePwMember", paraMap);
		}
		
		return result;
	}


	// 기존의 로그인 기록 삭제하기
	@Override
	public int deleteLoginHistory(Map<String, String> paraMap) {
		
		int n = 0;
		
		if("company".equals(paraMap.get("memberType"))) {
			n = sqlsession.delete("dy_trip.deleteCompanyLoginHistory", paraMap.get("id"));
			
		} else {
			n = sqlsession.delete("dy_trip.deleteMemberLoginHistory", paraMap.get("id"));
		}
		
		return n;
	}


	// 회원의 idle을 0으로 변경하기
	@Override
	public int idleUpdate(Map<String, String> paraMap) {

		int result = 0;
		
		if("company".equals(paraMap.get("memberType"))) {
			result = sqlsession.update("dy_trip.companyIdleUpdate", paraMap.get("id"));
			
		} else {
			result = sqlsession.update("dy_trip.memberIdleUpdate", paraMap.get("id"));
		}
		
		return result;
	}


	// 비밀번호 변경 날짜(lastpwdchangedate)를 현재 날짜로 변경하기
	@Override
	public int updatePwdChangeDate(Map<String, String> paraMap) {
		
		int result = 0;
		
		if("company".equals(paraMap.get("memberType"))) {
			result = sqlsession.update("dy_trip.updateCompanyPwdChangeDate", paraMap.get("id"));
			
		} else {
			result = sqlsession.update("dy_trip.updateMemberPwdChangeDate", paraMap.get("id"));
		}
		
		return result;
	}
	// 커뮤니티 글 등록 처리하기
	@Override
	public int addBoard(BoardVO boardvo) {
		
		int n = sqlsession.insert("dy_trip.addBoard", boardvo);
		
		return n;
	}


	// 커뮤니티 글 등록 처리하기 (첨부 파일이 있는 경우)
	@Override
	public int addBoard_withFile(BoardVO boardvo) {
		
		int n = sqlsession.insert("dy_trip.addBoard_withFile", boardvo);
		
		return n;
	}

	
	// 커뮤니티 게시판 총 게시물 건수 조회하기
	@Override
	public int getBoardTotalCount(Map<String, String> paraMap) {
		
		int totalCount = sqlsession.selectOne("dy_trip.getBoardTotalCount", paraMap);
		
		return totalCount;
	}
	
	
	// 커뮤니티 게시판 리스트 조회하기
	@Override
	public List<BoardVO> getBoardList(Map<String, String> paraMap) {
		
		List<BoardVO> list = sqlsession.selectList("dy_trip.getBoardList", paraMap);
		
		return list;
	}


	// 글 1개 조회하기
	@Override
	public BoardVO getViewBoard(Map<String, String> paraMap) {

		BoardVO boardvo = sqlsession.selectOne("dy_trip.getViewBoard", paraMap);
		
		return boardvo;
	}


	// 글 조회수 1 증가하기
	@Override
	public int increase_readCount(String seq) {

		int n = sqlsession.update("dy_trip.increase_readCount", seq);
		
		return n;
	}


	// 댓글 쓰기
	@Override
	public int addComment(CommentVO commentvo) {
		
		int n = sqlsession.insert("dy_trip.addComment", commentvo);
		
		return n;
	}


	// 댓글 쓰기 - 원게시물(tbl_board 테이블) 댓글 개수 증가
	@Override
	public int updateCommentCount(String parentSeq) {
		
		int n = sqlsession.update("dy_trip.updateCommentCount", parentSeq);
		
		return n;
	}


	// 댓글 목록 불러오기
	@Override
	public List<CommentVO> getViewComment(Map<String, String> paraMap) {
		
		List<CommentVO> commentList = sqlsession.selectList("dy_trip.getViewComment", paraMap);
		
		return commentList;
	}


	// 게시물당 댓글 총 개수 (페이징 처리 시 보여주는 순번을 나타내기 위함)
	@Override
	public int getCommentTotalCount(String parentSeq) {

		int totalCount = sqlsession.selectOne("dy_trip.getCommentTotalCount", parentSeq);
		
		return totalCount;
	}


	// 글번호에 대한 글 조회하기
	@Override
	public BoardVO getBoardInfo(String seq) {
		
		BoardVO boardvo = sqlsession.selectOne("dy_trip.getBoardInfo", seq);
		
		return boardvo;
	}


	// 파일 첨부가 없는 글 수정하기
	@Override
	public int updateBoardEnd(BoardVO boardvo) {
		
		int n = sqlsession.update("dy_trip.updateBoardEnd", boardvo);
		
		return n;
	}


	// 파일 첨부가 있는 글 수정하기
	@Override
	public int updateBoard_withFile(BoardVO boardvo) {
		
		int n = sqlsession.update("dy_trip.updateBoard_withFile", boardvo);
		
		return n;
	}


	// 커뮤니티 글 삭제 처리하기 (status를 0으로 update 하기)
	@Override
	public int deleteBoard(Map<String, String> paraMap) {

		int n = sqlsession.update("dy_trip.deleteBoard", paraMap);
		
		return n;
	}


	// 댓글번호에 대한 댓글이 있는지 조회하기
	@Override
	public CommentVO getCommentInfo(String seq) {
		
		CommentVO commentvo = sqlsession.selectOne("dy_trip.getCommentInfo", seq);
		
		return commentvo;
	}


	// 커뮤니티 댓글 수정
	@Override
	public int updateComment(Map<String, String> paraMap) {
		
		int n = sqlsession.update("dy_trip.updateComment", paraMap);
		
		return n;
	}


	// 커뮤니티 댓글 삭제
	@Override
	public int deleteComment(String seq) {
		
		int n = sqlsession.update("dy_trip.deleteComment", seq);
		
		return n;
	}


	// 커뮤니티 댓글 삭제 시 해당 글의 댓글 개수 1 감소
	@Override
	public int decreaseCommentCount(String parentSeq) {
		
		int n = sqlsession.update("dy_trip.decreaseCommentCount", parentSeq);
		
		return n;
	}


	// 게시판 댓글 개수 알아오기
	@Override
	public int getCommentCount(String seq) {
		
		int commentCount = sqlsession.selectOne("dy_trip.getCommentCount", seq);
		
		return commentCount;
	}


	// 댓글  groupno 컬럼의 최대값 구하기
	@Override
	public int getGroupnoMax() {
		
		int maxGroupno = sqlsession.selectOne("dy_trip.getGroupnoMax");
		
		return maxGroupno;
	}


	// 맛집 등록 시 중복 검사
	@Override
	public boolean isExistFoodstore(Map<String, String> paraMap) {
		
		boolean isExist = false;
		
		String food_store_code = sqlsession.selectOne("dy_trip.isExistFoodstore", paraMap);
		
		if(food_store_code != null) {
			isExist = true;
		}
		
		return isExist;
	}
	

}
