package com.spring.app.trip.model;

import java.util.List;
import java.util.Map;

import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.CommentVO;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
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

	// 사용자가 존재하는지 확인하기
	String isExist(Map<String, String> paraMap);

	// 비밀번호 변경
	int pwUpdate(Map<String, String> paraMap);

	// 맛집등록 - 일련번호 채번해오기
	String getCommonSeq();

	// === 데이터베이스에 맛집 정보 insert 하기 ===
	int foodstoreRegister(FoodstoreVO fvo);

	// tbl_food_add_img 테이블에 추가이미지 파일명 insert 하기
	int insert_food_add_img(Map<String, String> paraMap);

	// 기존 비밀번호와 값이 일치한지 비교하기
	String isSamePw(Map<String, String> paraMap);

	// 기존의 로그인 기록 삭제하기
	int deleteLoginHistory(Map<String, String> paraMap);

	// 회원의 idle을 0으로 변경하기
	int idleUpdate(Map<String, String> paraMap);

	// 비밀번호 변경 날짜(lastpwdchangedate)를 현재 날짜로 변경하기
	int updatePwdChangeDate(Map<String, String> paraMap);

	// 커뮤니티 글 등록 처리하기
	int addBoard(BoardVO boardvo);
	
	// 커뮤니티 글 등록 처리하기 (첨부 파일이 있는 경우)
	int addBoard_withFile(BoardVO boardvo);

	// 커뮤니티 게시판 총 게시물 건수 조회하기
	int getBoardTotalCount(Map<String, String> paraMap);
	
	// 커뮤니티 게시판 리스트 조회하기
	List<BoardVO> getBoardList(Map<String, String> paraMap);

	// 글 1개 조회하기
	BoardVO getViewBoard(Map<String, String> paraMap);

	// 글 조회수 1 증가하기
	int increase_readCount(String seq);

	// 댓글 쓰기
	int addComment(CommentVO commentvo);

	// 댓글 쓰기 - 원게시물(tbl_board 테이블) 댓글 개수 증가
	int updateCommentCount(String parentSeq);

	// 댓글 목록 불러오기
	List<CommentVO> getViewComment(Map<String, String> paraMap);

	// 게시물당 댓글 총 개수 (페이징 처리 시 보여주는 순번을 나타내기 위함)
	int getCommentTotalCount(String parentSeq);

	// 글번호에 대한 글 조회하기
	BoardVO getBoardInfo(String seq);

	// 파일 첨부가 없는 글 수정하기
	int updateBoardEnd(BoardVO boardvo);

	// 파일 첨부가 있는 글 수정하기
	int updateBoard_withFile(BoardVO boardvo);

	// 커뮤니티 글 삭제 처리하기
	int deleteBoard(Map<String, String> paraMap);

	// 댓글번호에 대한 댓글이 있는지 조회하기
	CommentVO getCommentInfo(String seq);

	// 커뮤니티 댓글 수정
	int updateComment(Map<String, String> paraMap);

	// 커뮤니티 댓글 삭제
	int deleteComment(String seq);

	// 커뮤니티 댓글 삭제 시 해당 글의 댓글 개수 1 감소
	int decreaseCommentCount(String parentSeq);

	
}
