package com.spring.app.trip.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.CommentVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.MemberVO;

public interface Dy_TripService {

	// 회원가입 처리하기
	int memberRegister(MemberVO mvo);
	
	// 일반회원 아이디 중복확인
	boolean useridDuplicateCheck(String userid);
	
	// 일반회원 이메일 중복확인
	boolean userEmailDuplicateCheck(String email);

	// 로그인 처리하기 (일반회원, 관리자)
	ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request);

	// 로그인 처리하기 (업체회원)
	ModelAndView companyLoginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request);

	// 아이디찾기 처리하기 (일반회원, 관리자)
	Map<String, String> memberIdFind(Map<String, String> paraMap);

	// 아이디찾기 처리하기 (업체회원)
	Map<String, String> companyIdFind(Map<String, String> paraMap);

	// 사용자가 존재하는지 확인하기
	boolean isUserExist(Map<String, String> paraMap);

	// 비밀번호 변경
	int pwUpdate(Map<String, String> paraMap);

	// 맛집등록 - 일련번호 채번해오기
	String getCommonSeq();

	// === 데이터베이스에 맛집 정보 insert 하기 ===
	int foodstoreRegister(FoodstoreVO fvo);

	// tbl_food_add_img 테이블에 추가이미지 파일명 insert 하기
	int insert_food_add_img(Map<String, String> paraMap);

	// 기존 비밀번호와 값이 일치한지 비교하기
	boolean isSamePw(Map<String, String> paraMap);

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
	
	// 커뮤니티 게시판 리스트 조회하기
	List<BoardVO> getBoardList(Map<String, String> paraMap);

	// 커뮤니티 게시판 총 게시물 건수 조회하기
	int getBoardTotalCount(Map<String, String> paraMap);

	// 글 조회수 증가와 함께 글 1개 조회하기
	BoardVO getViewBoard(Map<String, String> paraMap);

	// 글 조회수 증가 없이 단순히 글 1개만 조회하기
	BoardVO getViewBoard_no_increase_readCount(Map<String, String> paraMap);

	// 댓글 쓰기 및 원게시물에 댓글 개수 증가하기 (Transaction 처리)
	int addComment(CommentVO commentvo) throws Throwable;

	// 댓글 목록 불러오기
	List<CommentVO> getViewComment(Map<String, String> paraMap);

	// 게시물당 댓글 총 개수 (페이징 처리 시 보여주는 순번을 나타내기 위함)
	int getCommentTotalCount(String parentSeq);

	// 커뮤니티 글 수정 페이지 요청
	ModelAndView updateBoard(ModelAndView mav, HttpServletRequest request);

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

	// 커뮤니티 댓글 삭제 (Transaction 처리)
	int deleteComment(Map<String, String> paraMap) throws Throwable;
	
}
