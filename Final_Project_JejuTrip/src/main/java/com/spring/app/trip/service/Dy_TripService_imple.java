package com.spring.app.trip.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.CommentVO;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.model.Dy_TripDAO;

@Service
public class Dy_TripService_imple implements Dy_TripService {
	
	@Autowired
	private Dy_TripDAO dao;
	
    @Autowired
    private AES256 aES256;

    
    // 회원가입 처리하기
	@Override
	public int memberRegister(MemberVO mvo) {
		
		try {
			String pw = Sha256.encrypt(mvo.getPw());
			String email = aES256.encrypt(mvo.getEmail());
			String mobile = aES256.encrypt(mvo.getMobile());
			
			mvo.setPw(pw);
			mvo.setEmail(email);
			mvo.setMobile(mobile);
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = dao.memberRegister(mvo);
		
		return n;
	}


	// 일반회원 아이디 중복확인
	@Override
	public boolean useridDuplicateCheck(String userid) {
		
		boolean isExist = false;
		
		String exist_userid = dao.useridDuplicateCheck(userid);
		
		if(exist_userid != null) {
			isExist = true;
		}
		
		return isExist;
	}

	
	// 일반회원 이메일 중복확인
	@Override
	public boolean userEmailDuplicateCheck(String email) {
		
		boolean isExist = false;
		
		try {
			email = aES256.encrypt(email);
			
			String exist_email = dao.userEmailDuplicateCheck(email);
			
			if(exist_email != null) {
				isExist = true;
			}
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		return isExist;
	}


	// 로그인 처리하기 (일반회원, 관리자)
	@Override
	public ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request) {
		
		MemberVO loginuser = dao.getLoginMember(paraMap);
		
		if(loginuser != null && loginuser.getPwdchangegap() >= 3) {
			// 마지막으로 암호를 변경한 날짜가 현재 시각으로부터 3개월이 지났으면
			
			loginuser.setRequirePwdChange(true); // 로그인 시 암호를 변경하라는 alert 를 띄우도록 한다.
		}
		
		if(loginuser != null && loginuser.getLastlogingap() >= 12 && loginuser.getIdle() == 0) {
			// 마지막으로 로그인 한 날짜시간이 현재시각으로부터 1년이 지났으면 휴면으로 지정
			loginuser.setIdle(1);
			
			// tbl_member 테이블의 idle 컬럼의 값을 1로 변경하기
			dao.updateMemberIdle(paraMap);
		}
		
		if(loginuser != null && loginuser.getIdle() == 0) {
			
			try {
				String email = aES256.decrypt(loginuser.getEmail());
				String mobile = aES256.decrypt(loginuser.getMobile());
				
				loginuser.setEmail(email);
				loginuser.setMobile(mobile);
				
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			// tbl_member_loginhistory 테이블에 로그인 기록 입력하기
			dao.insert_member_loginhistory(paraMap);
		}
		
		if(loginuser == null) { // 로그인 실패 시
			String message = "아이디 또는 비밀번호가 일치하지 않습니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		} else { // DB에 아이디, 비밀번호가 존재하는 경우
			
			if(loginuser.getIdle() == 1) { // 로그인 한 지 1년이 경과한 경우

				String message = "장기 미접속으로 휴면 처리 되었습니다.\\n휴면 해제 페이지로 이동합니다.";
				String loc = request.getContextPath() + "/login/idleUpdate.trip";
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
				
			} else { // 로그인 한 지 1년 이내인 경우

				HttpSession session = request.getSession();
				
				session.setAttribute("loginuser", loginuser);
				
				if(loginuser.isRequirePwdChange()) { // 암호를 마지막으로 변경한 날짜로부터 3개월 경과한 경우
					
					String message = "비밀번호를 변경한 지 3개월이 초과되었습니다.\\n비밀번호 변경 페이지로 이동합니다.";
					String loc = request.getContextPath() + "/login/pwUpdate.trip";

					mav.addObject("message", message);
					mav.addObject("loc", loc);

					mav.setViewName("msg");

				} else { // 암호를 마지막으로 변경한 날짜가 3개월 이내인 경우
					
					String goBackURL = (String)session.getAttribute("goBackURL");
					
					if(goBackURL != null) {
						mav.setViewName("redirect:" + goBackURL);
						session.removeAttribute("goBackURL");
						
					} else {
						mav.setViewName("redirect:/index.trip"); // 시작 페이지로 이동
					}
				}
			}
			
		}
		
		return mav;
	}


	// 로그인 처리하기 (업체회원)
	@Override
	public ModelAndView companyLoginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request) {

		CompanyVO loginCompanyuser = dao.getLoginCompanyMember(paraMap);
		
		if(loginCompanyuser != null && loginCompanyuser.getPwdchangegap() >= 3) {
			// 마지막으로 암호를 변경한 날짜가 현재 시각으로부터 3개월이 지났으면
			
			loginCompanyuser.setRequirePwdChange(true); // 로그인 시 암호를 변경하라는 alert 를 띄우도록 한다.
		}
		
		if(loginCompanyuser != null && loginCompanyuser.getLastlogingap() >= 12 && loginCompanyuser.getIdle() == 0) {
			// 마지막으로 로그인 한 날짜시간이 현재시각으로부터 1년이 지났으면 휴면으로 지정
			loginCompanyuser.setIdle(1);
			
			// tbl_company 테이블의 idle 컬럼의 값을 1로 변경하기
			dao.updateCompanyIdle(paraMap);
		}
		
		if(loginCompanyuser != null && loginCompanyuser.getIdle() == 0) {
			
			try {
				String email = aES256.decrypt(loginCompanyuser.getEmail());
				String mobile = aES256.decrypt(loginCompanyuser.getMobile());
				
				loginCompanyuser.setEmail(email);
				loginCompanyuser.setMobile(mobile);
				
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			// tbl_company_loginhistory 테이블에 로그인 기록 입력하기
			dao.insert_company_loginhistory(paraMap);
		}
		
		if(loginCompanyuser == null) { // 로그인 실패 시
			String message = "아이디 또는 비밀번호가 일치하지 않습니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		} else { // DB에 아이디, 비밀번호가 존재하는 경우
			
			if(loginCompanyuser.getIdle() == 1) { // 로그인 한 지 1년이 경과한 경우

				String message = "장기 미접속으로 휴면 처리 되었습니다.\\n휴면 해제 페이지로 이동합니다.";
				String loc = request.getContextPath() + "/login/idleUpdate.trip";
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
				
			} else { // 로그인 한 지 1년 이내인 경우

				HttpSession session = request.getSession();
				
				session.setAttribute("loginCompanyuser", loginCompanyuser);
				
				if(loginCompanyuser.isRequirePwdChange()) { // 암호를 마지막으로 변경한 날짜로부터 3개월 경과한 경우
					
					String message = "비밀번호를 변경한 지 3개월이 초과되었습니다.\\n비밀번호 변경 페이지로 이동합니다.";
					String loc = request.getContextPath() + "/login/pwUpdate.trip";

					mav.addObject("message", message);
					mav.addObject("loc", loc);

					mav.setViewName("msg");

				} else { // 암호를 마지막으로 변경한 날짜가 3개월 이내인 경우
					
					String goBackURL = (String)session.getAttribute("goBackURL");
					
					if(goBackURL != null) {
						mav.setViewName("redirect:" + goBackURL);
						session.removeAttribute("goBackURL");
						
					} else {
						mav.setViewName("redirect:/index.trip"); // 시작 페이지로 이동
					}
				}
			}
			
		}
		
		return mav;
	}


	// 아이디찾기 처리하기 (일반회원, 관리자)
	@Override
	public Map<String, String> memberIdFind(Map<String, String> paraMap) {
		
		Map<String, String> findInfo = dao.memberIdFind(paraMap);
		
		return findInfo;
	}


	// 아이디찾기 처리하기 (업체회원)
	@Override
	public Map<String, String> companyIdFind(Map<String, String> paraMap) {

		Map<String, String> findInfo = dao.companyIdFind(paraMap);
		
		return findInfo;
	}


	// 사용자가 존재하는지 확인하기
	@Override
	public boolean isUserExist(Map<String, String> paraMap) {
		
		boolean isUserExist = false;
		
		try {
			String email = aES256.encrypt(paraMap.get("email"));
			paraMap.put("email", email);

			String user = dao.isExist(paraMap);
			
			if(user != null) {
				isUserExist = true;
			}
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		return isUserExist;
	}


	// 비밀번호 변경
	@Override
	public int pwUpdate(Map<String, String> paraMap) {
		
		int result = dao.pwUpdate(paraMap);
		
		return result;
	}


	// 맛집등록 - 일련번호 채번해오기
	@Override
	public String getCommonSeq() {
		
		String food_store_code = dao.getCommonSeq();
		
		return food_store_code;
	}


	// === 데이터베이스에 맛집 정보 insert 하기 ===
	@Override
	public int foodstoreRegister(FoodstoreVO fvo) {
		
		int n = dao.foodstoreRegister(fvo);
		
		return n;
	}


	// tbl_food_add_img 테이블에 추가이미지 파일명 insert 하기
	@Override
	public int insert_food_add_img(Map<String, String> paraMap) {
		
		int n = dao.insert_food_add_img(paraMap);
		
		return n;
	}


	// 기존 비밀번호와 값이 일치한지 비교하기
	@Override
	public boolean isSamePw(Map<String, String> paraMap) {
		
		boolean isSamePw = false;
		
		String result = dao.isSamePw(paraMap);
		
		if(result != null) {
			isSamePw = true;
		}
		
		return isSamePw;
	}


	// 기존의 로그인 기록 삭제하기
	@Override
	public int deleteLoginHistory(Map<String, String> paraMap) {
		
		int n = dao.deleteLoginHistory(paraMap);
		
		return n;
	}


	// 회원의 idle을 0으로 변경하기
	@Override
	public int idleUpdate(Map<String, String> paraMap) {
		
		int result = dao.idleUpdate(paraMap);
		
		return result;
	}


	// 비밀번호 변경 날짜(lastpwdchangedate)를 현재 날짜로 변경하기
	@Override
	public int updatePwdChangeDate(Map<String, String> paraMap) {
		
		int result = dao.updatePwdChangeDate(paraMap);
		
		return result;
	}

	
	// 커뮤니티 글 등록 처리하기
	@Override
	public int addBoard(BoardVO boardvo) {
		
		int n = dao.addBoard(boardvo);
		
		return n;
	}


	// 커뮤니티 글 등록 처리하기 (첨부 파일이 있는 경우)
	@Override
	public int addBoard_withFile(BoardVO boardvo) {

		int n = dao.addBoard_withFile(boardvo);
		
		return n;
	}
	
	
	// 자유게시판 총 게시물 건수 조회하기
	@Override
	public int getFreeBoardTotalCount(Map<String, String> paraMap) {
		
		int totalCount = dao.getFreeBoardTotalCount(paraMap);
		
		return totalCount;
	}


	// 커뮤니티 자유게시판 리스트 조회하기
	@Override
	public List<BoardVO> getFreeBoardList(Map<String, String> paraMap) {
		
		List<BoardVO> list = dao.getFreeBoardList(paraMap);
		
		return list;
	}


	// 글 조회수 증가와 함께 글 1개 조회하기
	@Override
	public BoardVO getViewBoard(Map<String, String> paraMap) {

		BoardVO boardvo = dao.getViewBoard(paraMap); // 글 1개 조회하기

		String login_id = paraMap.get("login_id");
		
		if(login_id != null &&
		   boardvo != null && // 글이 존재할 경우(url의 seq에 글 목록에 없는 번호를 입력했을 경우 방지)
		   !login_id.equals(boardvo.getFk_userid())) {
			// 글 조회수 증가는 로그인 한 상태에서 다른 사람의 글을 읽을 때만 증가하도록 한다.

			int n = dao.increase_readCount(boardvo.getSeq()); // 글 조회수 1 증가하기

			if(n == 1) {
				boardvo.setReadCount(String.valueOf(Integer.parseInt(boardvo.getReadCount()) + 1));
				// boardvo.getReadCount()는 String 타입이므로 덧셈 시 형변환 주의 ★
			}
		}
		
		return boardvo;
	}


	// 글 조회수 증가 없이 단순히 글 1개만 조회하기
	@Override
	public BoardVO getViewBoard_no_increase_readCount(Map<String, String> paraMap) {

		BoardVO boardvo = dao.getViewBoard(paraMap); // 글 1개 조회하기
		
		return boardvo;
	}


	// 댓글 쓰기 및 원게시물에 댓글 개수 증가하기 (Transaction 처리)
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int addComment(CommentVO commentvo) throws Throwable {
		
		int n1=0, n2=0;
		
		n1 = dao.addComment(commentvo); // 댓글 쓰기
		
		if(n1 == 1) {
			n2 = dao.updateCommentCount(commentvo.getParentSeq()); // 원게시물(tbl_board 테이블) 댓글 개수 증가
		}
		
		return n2;
	}


	// 댓글 목록 불러오기
	@Override
	public List<CommentVO> getViewComment(Map<String, String> paraMap) {
		
		List<CommentVO> commentList = dao.getViewComment(paraMap);
		
		return commentList;
	}



}
