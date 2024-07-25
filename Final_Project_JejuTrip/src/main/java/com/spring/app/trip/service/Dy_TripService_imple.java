package com.spring.app.trip.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
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
	
	
	// 커뮤니티 게시판 총 게시물 건수 조회하기
	@Override
	public int getBoardTotalCount(Map<String, String> paraMap) {
		
		int totalCount = dao.getBoardTotalCount(paraMap);
		
		return totalCount;
	}


	// 커뮤니티 게시판 리스트 조회하기
	@Override
	public List<BoardVO> getBoardList(Map<String, String> paraMap) {
		
		List<BoardVO> list = dao.getBoardList(paraMap);
		
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
		
		if("".equals(commentvo.getFk_seq())) { // 원댓글일 경우
			
			int groupno = dao.getGroupnoMax() + 1;
			// groupno 컬럼의 값은 groupno 컬럼의 최대값(max)+1 로 해야 한다.
			
			commentvo.setGroupno(String.valueOf(groupno));
		}
		
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


	// 게시물당 댓글 총 개수 (페이징 처리 시 보여주는 순번을 나타내기 위함)
	@Override
	public int getCommentTotalCount(String parentSeq) {

		int totalCount = dao.getCommentTotalCount(parentSeq);
		
		return totalCount;
	}


	// 커뮤니티 글 수정 페이지 요청
	@Override
	public ModelAndView updateBoard(ModelAndView mav, HttpServletRequest request) {
		
		String seq = request.getParameter("seq");
		
		try {
			Integer.parseInt(seq);
			
			BoardVO boardvo = dao.getBoardInfo(seq);
			// 글번호에 대한 글 조회하기
			
			if(boardvo == null) {
//				System.out.println("~~~ 확인용 : 글이 없다");
				mav.setViewName("redirect:/communityMain.trip");
				
			} else {
				
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				
				if(loginuser != null && !(boardvo.getFk_userid().equals(loginuser.getUserid()))) {
					// 글번호에 대한 글이 로그인한 사용자의 글이 아니라면
					
//					System.out.println("~~~ 확인용 : 내 글이 아니다");
					mav.setViewName("redirect:/communityMain.trip");
					
				} else {
//					System.out.println("~~~ 확인용 : 내 글이 맞다");				
					
					mav.addObject("boardvo", boardvo);
					mav.setViewName("community/updateBoard.tiles1");
				}
				
			}
			
		} catch (NumberFormatException e) { // url에 존재하지 않는 글번호를 입력한 경우
//			System.out.println("~~~ 확인용 : 시퀀스가 이상하다");
			
			mav.setViewName("redirect:/communityMain.trip");
		}
		
		return mav;
	}


	// 파일 첨부가 없는 글 수정하기
	@Override
	public int updateBoardEnd(BoardVO boardvo) {
		
		int n = dao.updateBoardEnd(boardvo);
		
		return n;
	}


	// 파일 첨부가 있는 글 수정하기
	@Override
	public int updateBoard_withFile(BoardVO boardvo) {
		
		int n = dao.updateBoard_withFile(boardvo);
		
		return n;
	}


	// 커뮤니티 글 삭제 처리하기
	@Override
	public int deleteBoard(Map<String, String> paraMap) {
		
		int n = 0;
		
		BoardVO boardvo = dao.getBoardInfo(paraMap.get("seq"));
		
		if(boardvo == null) {
			return n;
			
		} else {
			if(!(paraMap.get("login_id").equals(boardvo.getFk_userid()))) {
				return n;
				
			} else {
				n = dao.deleteBoard(paraMap);
			}
		}
		
		return n;
	}


	// 댓글번호에 대한 댓글이 있는지 조회하기
	@Override
	public CommentVO getCommentInfo(String seq) {
		
		CommentVO commentvo = dao.getCommentInfo(seq);
		
		return commentvo;
	}


	// 커뮤니티 댓글 수정
	@Override
	public int updateComment(Map<String, String> paraMap) {
		
		int n = dao.updateComment(paraMap);
		
		return n;
	}


	// 커뮤니티 댓글 삭제 (Transaction 처리)
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int deleteComment(Map<String, String> paraMap) throws Throwable {
		
		int n1=0, n2=0;
		
		// 댓글 삭제
		n1 = dao.deleteComment(paraMap.get("seq"));
		
		if(n1 == 1) {
			// 댓글 삭제 시 해당 글의 댓글 개수 1 감소
			n2 = dao.decreaseCommentCount(paraMap.get("parentSeq"));
		}
		
		return n1*n2;
	}


	// 게시판 댓글 개수 알아오기
	@Override
	public int getCommentCount(String seq) {
		
		int commentCount = dao.getCommentCount(seq);
		
		return commentCount;
	}


	// 맛집 등록 시 중복 검사
	@Override
	public boolean isExistFoodstore(Map<String, String> paraMap) {
		
		boolean isExist = dao.isExistFoodstore(paraMap);
		
		return isExist;
	}


	// 업체 마이페이지에서 예약내역 Excel 파일로 다운받기
	@Override
	public void reservationList_to_Excel(Map<String, String> paraMap, Model model) {
		
		SXSSFWorkbook workbook = new SXSSFWorkbook();
		
		// 시트 생성
	    SXSSFSheet sheet = workbook.createSheet(paraMap.get("company_name") + " 숙소 예약내역");
		
	    // 시트 열 너비 설정
	    sheet.setColumnWidth(0, 2500); // 예약번호
	    sheet.setColumnWidth(1, 5000); // 숙소명
	    sheet.setColumnWidth(2, 9500); // 룸타입
	    sheet.setColumnWidth(3, 2000); // 고객명
	    sheet.setColumnWidth(4, 3000); // 체크인
	    sheet.setColumnWidth(5, 3000); // 체크아웃
	    sheet.setColumnWidth(6, 2500); // 총객실수
	    sheet.setColumnWidth(7, 3000); // 예약된객실수
	    sheet.setColumnWidth(8, 3000); // 잔여객실수
	    sheet.setColumnWidth(9, 2500); // 예약상태
	    
	    // 행의 위치를 나타내는 변수 
	    int rowLocation = 0;
	    
	    CellStyle mergeRowStyle =  workbook.createCellStyle();
	    mergeRowStyle.setAlignment(HorizontalAlignment.CENTER);
	    mergeRowStyle.setVerticalAlignment(VerticalAlignment.CENTER);
	    
	    CellStyle headerStyle = workbook.createCellStyle();
	    headerStyle.setAlignment(HorizontalAlignment.CENTER);
	    headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
	    
	 // CellStyle 배경색(ForegroundColor)만들기
	    mergeRowStyle.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
	    mergeRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND); // SOLID_FOREGROUND은 실선
	    
	    headerStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
	    headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    
        // Cell 폰트(Font) 설정하기
        // 폰트 적용을 위해 POI 라이브러리의 Font 객체를 생성해준다.
        // 해당 객체의 세터를 사용해 폰트를 설정해준다. 대표적으로 글씨체, 크기, 색상, 굵기만 설정한다.
        // 이후 CellStyle의 setFont 메소드를 사용해 인자로 폰트를 넣어준다.
        Font mergeRowFont = workbook.createFont(); // import org.apache.poi.ss.usermodel.Font; 으로 한다.
        mergeRowFont.setFontName("나눔바른고딕");
        mergeRowFont.setFontHeight((short)500);
        mergeRowFont.setColor(IndexedColors.WHITE.getIndex());
        mergeRowFont.setBold(true);
        
        mergeRowStyle.setFont(mergeRowFont);	// row스타일에 폰트 스타일 넣음
	    
        // CellStyle 테두리 Border
        // 테두리는 각 셀마다 상하좌우 모두 설정해준다.
        // setBorderTop, Bottom, Left, Right 메소드와 인자로 POI라이브러리의 BorderStyle 인자를 넣어서 적용한다.
        headerStyle.setBorderTop(BorderStyle.THICK);
	    headerStyle.setBorderBottom(BorderStyle.THICK);
	    headerStyle.setBorderLeft(BorderStyle.THIN);
	    headerStyle.setBorderRight(BorderStyle.THIN);
        
	    // === Cell Merge 셀 병합시키기 ===
	    // 병합할 행 만들기
	    Row mergeRow = sheet.createRow(rowLocation);  // 엑셀에서 행의 시작은 0 부터 시작한다. 
        
	    // 병합할 행에 제목으로 셀을 만들어 셀에 스타일을 주기
    	for(int i=0; i<10; i++) {
	    		
			Cell cell = mergeRow.createCell(i);
			
			cell.setCellStyle(mergeRowStyle);
			cell.setCellValue(paraMap.get("company_name") + " 숙소 예약내역");
			
    	} // end of for-------------------------
        
    	// 셀 병합하기
	    sheet.addMergedRegion(new CellRangeAddress(rowLocation, rowLocation, 0, 9)); // 시작 행, 끝 행, 시작 열, 끝 열 

	    ///////////////////////////////////////////////////////////////////////////////////////////////
	    

	    // 헤더 행 생성
        Row headerRow = sheet.createRow(++rowLocation); // 엑셀에서 행의 시작은 0 부터 시작한다.

        // 해당 행의 첫번째 열 셀 생성
        Cell headerCell = headerRow.createCell(0); // 엑셀에서 열의 시작은 0 부터 시작한다.
        headerCell.setCellValue("예약번호");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 두번째 열 셀 생성
        headerCell = headerRow.createCell(1);
        headerCell.setCellValue("숙소명");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 세번째 열 셀 생성
        headerCell = headerRow.createCell(2);
        headerCell.setCellValue("룸타입");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 네번째 열 셀 생성
        headerCell = headerRow.createCell(3);
        headerCell.setCellValue("고객명");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 다섯번째 열 셀 생성
        headerCell = headerRow.createCell(4);
        headerCell.setCellValue("체크인");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 여섯번째 열 셀 생성
        headerCell = headerRow.createCell(5);
        headerCell.setCellValue("체크아웃");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 일곱번째 열 셀 생성
        headerCell = headerRow.createCell(6);
        headerCell.setCellValue("총객실수");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 여덟번째 열 셀 생성
        headerCell = headerRow.createCell(7);
        headerCell.setCellValue("예약된객실수");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 여덟번째 열 셀 생성
        headerCell = headerRow.createCell(8);
        headerCell.setCellValue("잔여객실수");
        headerCell.setCellStyle(headerStyle);
        
        // 해당 행의 여덟번째 열 셀 생성
        headerCell = headerRow.createCell(9);
        headerCell.setCellValue("예약상태");
        headerCell.setCellStyle(headerStyle);

        
        // ==== HR사원정보 내용에 해당하는 행 및 셀 생성하기 ==== //
        Row bodyRow = null;
        Cell bodyCell = null;
        
        // 업체 숙소 예약내역 불러오기
        List<Map<String, String>> reservationList = dao.getReservationList(paraMap);
        
        for(int i=0; i<reservationList.size(); i++) {

        	Map<String, String> rsvMap = reservationList.get(i);
        	
	    	// 행 생성
	        bodyRow = sheet.createRow(i + (rowLocation+1));
	    	
	        // 데이터 예약번호 표시
            bodyCell = bodyRow.createCell(0);
            bodyCell.setCellValue(rsvMap.get("reservation_code")); 
            
            // 데이터 숙소명 표시
            bodyCell = bodyRow.createCell(1);
            bodyCell.setCellValue(rsvMap.get("lodging_name")); 
            
            // 데이터 룸타입 표시
            bodyCell = bodyRow.createCell(2);
            bodyCell.setCellValue(rsvMap.get("room_name")); 
            
            // 데이터 고객명 표시
            bodyCell = bodyRow.createCell(3);
            bodyCell.setCellValue(rsvMap.get("user_name")); 
            
            // 데이터 체크인 표시
            bodyCell = bodyRow.createCell(4);
            bodyCell.setCellValue(rsvMap.get("check_in")); 
            
            // 데이터 체크아웃 표시
            bodyCell = bodyRow.createCell(5);
            bodyCell.setCellValue(rsvMap.get("check_out")); 
            
            // 데이터 총객실수 표시
            bodyCell = bodyRow.createCell(6);
            bodyCell.setCellValue(Integer.parseInt(rsvMap.get("room_stock"))); 
            
            // 데이터 예약된객실수 표시
            bodyCell = bodyRow.createCell(7);
            bodyCell.setCellValue(Integer.parseInt(rsvMap.get("count"))); 
            
            // 데이터 잔여객실수 표시
            bodyCell = bodyRow.createCell(8);
            bodyCell.setCellValue(Integer.parseInt(rsvMap.get("room_stock")) - Integer.parseInt(rsvMap.get("count"))); 
            
            // 데이터 예약상태 표시
            bodyCell = bodyRow.createCell(9);
            
            switch (rsvMap.get("status")) {
				case "0":
					bodyCell.setCellValue("승인대기");
					break;
				
				case "1":
					bodyCell.setCellValue("확정");
					break;
					
				case "2":
					bodyCell.setCellValue("취소");
					break;
					
			} // end of switch --------------------
            
        } // end of for ---------------------------------------

        model.addAttribute("locale", Locale.KOREA);
        model.addAttribute("workbook", workbook);
        model.addAttribute("workbookName", paraMap.get("company_name") + " 숙소 예약내역");
    	
	}
	
}
