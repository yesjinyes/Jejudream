package com.spring.app.trip.controller;


import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.common.GoogleMail;
import com.spring.app.trip.common.MyUtil;
import com.spring.app.trip.domain.Calendar_schedule_VO;
import com.spring.app.trip.domain.Calendar_small_category_VO;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.service.Ws_TripService;

@Controller
public class Ws_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Ws_TripService service;
	
	@Autowired
	private FileManager fileManager;
	
	@Autowired
    private AES256 aES256;
	
	private String extractFileName(String partHeader) {
        for(String cd : partHeader.split("\\;")) {
           if(cd.trim().startsWith("filename")) {
              String fileName = cd.substring(cd.indexOf("=") + 1).trim().replace("\"", ""); 
              int index = fileName.lastIndexOf(File.separator);// File.separator란 OS가 Windows 이라면 \ 이고 Mac, Linux, Unix 이라면 / 을 말하는 것이다. 
              return fileName.substring(index + 1);
           }
        }
        return null;
    }// end of private String extractFileName(String partHeader)-------------------
	
	@GetMapping("/index.trip") 
	public ModelAndView readComment(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		int i = 0;
		if(loginuser != null) {
			i = service.get_new_chatting(loginuser.getUserid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			if(i==0) {
				i = service.get_from_admin_chatting_exist(loginuser.getUserid());
			}
		}
		else if(loginCompanyuser != null) {
			i = service.get_new_chatting(loginCompanyuser.getCompanyid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
		}
		mav.addObject("i",i);
		mav.setViewName("main/main.tiles1");
		
		return mav;
	}
	
	// 가입하려는 기업 아이디가 존재하는 아이디인지 사용가능한 아이디인지 검사하는 메소드
	@ResponseBody
	@PostMapping("/companyIdCheck.trip")
	public String companyIdCheck(HttpServletRequest request) {
		String companyid = request.getParameter("companyid");
		int n = service.companyIdCheck(companyid); // 가입하려는 아이디가 존재하는 아이디인지 체크하는 메소드 생성
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	}// end of public String companyRegisterEnd(CompanyVO cvo) {
	
	// 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
	@ResponseBody
	@PostMapping("companyEmailCheck.trip")
	public String companyEmailCheck(HttpServletRequest request) {
		String email = request.getParameter("email");
		int n = service.companyEmailCheck(email); // 가입하려는 기업 이메일이 존재하는 이메일인지 사용가능한 이메일인지 확인하는 메소드
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	}// end of public String companyRegisterEnd(CompanyVO cvo) {
	
	
	// 회사 회원가입을 위한 ajax 메소드 생성
	@ResponseBody
	@PostMapping("/companyRegisterEnd.trip")
	public String companyRegisterEnd(CompanyVO cvo) {
		
		int n = service.companyRegister(cvo); // 회사 회원가입을 위한 service 메소드 생성
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		return jsonObj.toString();
		
	}
	
	// === 기업이 숙소 등록을 하기위한 웹 페이지로 이동 === // 
	@GetMapping("/registerHotel.trip")
	public ModelAndView registerHotel(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		
		if(loginCompanyuser != null && request.getParameter("companyid").equalsIgnoreCase(loginCompanyuser.getCompanyid())) {
			// 로그인 한 회사가 자기 회사의 업체를 등록하는 경우
			
			List<Map<String,String>> mapList = service.select_convenient();// 편의시설 체크박스를 만들기 위해 DB에 있는 편의시설 테이블에서 편의시설 종류를 select 해온다.
			
			mav.addObject("mapList",mapList); // select 해온 편의시설 목록을 view 페이지로 넘겨준다.
			mav.setViewName("company/registerHotel.tiles1");
		}
		else {
			String message = "업체 계정으로 로그인을 하지 않았거나 잘못된 로그인 정보입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	}
	
	// === 기업이 숙소 등록을 신청했을때 해당 숙소정보를 DB에 insert === // 
	@ResponseBody
	@PostMapping("/registerHotelEnd.trip")
	public ModelAndView registerHotelEnd(ModelAndView mav,LodgingVO lodgingvo, MultipartHttpServletRequest mrequest, HttpServletRequest request) {
		
		// =========== !!! 첨부파일 업로드 시작 !!! ============ // 
		MultipartFile attach = lodgingvo.getAttach();
	      
		if( !attach.isEmpty() ) {
			// attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우라면) 
	         
			/*
	            1. 사용자가 보낸 첨부파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다. 
	            >>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
	                              우리는 WAS의 webapp/resources/files 라는 폴더로 지정해준다.
	                              조심할 것은  Package Explorer 에서  files 라는 폴더를 만드는 것이 아니다.       
			 */
			// WAS 의 webapp 의 절대경로를 알아와야 한다. 
	                  
			HttpSession session = mrequest.getSession(); 
			String root = session.getServletContext().getRealPath("/"); 
			
			// System.out.println("~~~ 확인용 webapp 의 절대경로 => " + root); 
			// ~~~ 확인용 webapp 의 절대경로 => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\
			
			String path = root + "resources"+File.separator+"images"+File.separator+"lodginglist";     
	        System.out.println(path);
	        /* File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
	                            운영체제가 Windows 이라면 File.separator 는  "\" 이고,
	                            운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
	         */
	                  
	        // path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
	        //   System.out.println("~~~ 확인용 path => " + path);
	        //  ~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files 
	                  
	        /*
	             2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기  
	         */
	        String newFileName = "";
	        // WAS(톰캣)의 디스크에 저장될 파일명 
	         
	        byte[] bytes = null;
	        // 첨부파일의 내용물을 담는 것
	         
	        long fileSize = 0;
	        // 첨부파일의 크기 
	         
	         
	        try {
	            bytes = attach.getBytes();
	            // 첨부파일의 내용물을 읽어오는 것
	            
	            String originalFilename = attach.getOriginalFilename();
	            // attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다.
	            
	            //   System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
	            // ~~~ 확인용 originalFilename => LG_싸이킹청소기_사용설명서.pdf 
	            
	            newFileName = fileManager.doFileUpload(bytes, originalFilename, path); 
	            // 첨부되어진 파일을 업로드 하는 것이다.
	            
	            //   System.out.println("~~~ 확인용 newFileName => " + newFileName); 
	            // ~~~ 확인용 newFileName => 20231124113600755016855987700.pdf 
	                     
	                  
	            /*
	                3. CommentVO commentvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기  
	            */
	            lodgingvo.setFileName(newFileName);
	            // WAS(톰캣)에 저장된 파일명(20231124113600755016855987700.pdf)
	                     
	            lodgingvo.setOrgFilename(lodgingvo.getLodging_name()+"_main.jpg");
	            // 게시판 페이지에서 첨부된 파일(LG_싸이킹청소기_사용설명서.pdf)을 보여줄 때 사용.
	            // 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
	                     
	            fileSize = attach.getSize();  // 첨부파일의 크기(단위는 byte임) 
	            lodgingvo.setFileSize(String.valueOf(fileSize));
	                     
	         } catch (Exception e) {
	            e.printStackTrace();
	         }   
		}
		// =========== !!! 첨부파일 업로드 끝 !!! ============ //;
		
		// === insert를 위한 시퀀스 번호 채번해오기 === //
		String seq = service.getSeq();
		
		// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
		String address = mrequest.getParameter("address");
		String detail_address = mrequest.getParameter("detail_address");
		
		lodgingvo.setLodging_address(address + " " + detail_address);
		
		HttpSession session = mrequest.getSession();
		CompanyVO loginuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		lodgingvo.setFk_companyid(loginuser.getCompanyid());
		lodgingvo.setLodging_code(seq);
		
		int n = service.registerHotelEnd(lodgingvo);
		
		if(n == 1) {
			
			// === 숙소정보에 따른 편의시설 정보 insert 해주기 === //
			String str_convenient = request.getParameter("str_convenient");
			if(!str_convenient.equals("")) {
				Map<String,String> paraMap = new HashMap<>();
				paraMap.put("seq",seq);
				paraMap.put("str_convenient",str_convenient);
				service.insert_convenient(paraMap);
			}
			
			String message = "숙소 등록 신청이 성공적으로 완료되었습니다.";
			String loc = "index.trip";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		else {
			String message = "숙소 등록 신청에 실패했습니다.";
			String loc = "index.trip";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	}
	
	// === 관리자가 업체가 신청한 숙소 목록을 조회하고 승인 혹은 반려를 할 수 있는 처리 페이지로 이동 === //
	@GetMapping("/screeningRegister.trip")
	public ModelAndView screeningRegister(ModelAndView mav, HttpServletRequest request) {
		
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null && loginuser.getUserid().equals("admin")) {
			// 관리자가 등록 심사를 할 경우 
			mav.setViewName("admin/screeningRegister.tiles1");
			
			// === 편의시설 정보를 가져와서 view 페이지에 표출시켜주기위한 List select === //
			List<Map<String,String>> mapList = service.select_convenient_list();
			
			mav.addObject("mapList",mapList);
			
			String choice_status = request.getParameter("choice_status");
			if(choice_status == null || choice_status.equals("전체")) {
				choice_status = "";
			}
			
			String str_currentShowPageNo = request.getParameter("currentShowPageNo");
			
			// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.
			// 총 게시물 건수(totalCount)는  검색조건이 있을 때와 없을때로 나뉘어진다.
			int totalCount = 0;        // 총 게시물 건수
			int sizePerPage = 3;      // 한 페이지당 보여줄 게시물 건수 
			int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
			int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
			
			// 총 게시물 건수(totalCount)
			totalCount = service.getTotalCount(choice_status);
			
			// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
			// 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
			totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
			
			if(str_currentShowPageNo == null) {
				// 게시판에 보여지는 초기화면
				
				currentShowPageNo = 1;
			}
			
			else {
				
				try {
					currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
					
					if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
						// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
						// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우 
						currentShowPageNo = 1;
					}
					
				} catch (NumberFormatException e) {
					// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하여 장난친 경우 
					currentShowPageNo = 1; 
				}
			}
			
			int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
			int endRno = startRno + sizePerPage - 1; // 끝 행번호
			
			Map<String,String> paraMap = new HashMap<>();
			
			paraMap.put("startRno", String.valueOf(startRno));
			paraMap.put("endRno", String.valueOf(endRno));
			paraMap.put("choice_status",choice_status);
			
			List<LodgingVO> lodgingvoList = service.select_lodgingvo(paraMap);// 숙소 등록을 신청한 업체중 심사중인 모든 업체들 불러오기
			
			int blockSize = 10;
			// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
			/*
				             1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
				[맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
				[맨처음][이전]  21 22 23
			*/
			
			int loop = 1;
			/*
		    	loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		    */
			
			int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
			// *** !! 공식이다. !! *** //
			
		/*
		    1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 이다.
		    11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.
		    21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
		    
		    currentShowPageNo         pageNo
		   ----------------------------------
		         1                      1 = ((1 - 1)/10) * 10 + 1
		         2                      1 = ((2 - 1)/10) * 10 + 1
		         3                      1 = ((3 - 1)/10) * 10 + 1
		         4                      1
		         5                      1
		         6                      1
		         7                      1 
		         8                      1
		         9                      1
		         10                     1 = ((10 - 1)/10) * 10 + 1
		        
		         11                    11 = ((11 - 1)/10) * 10 + 1
		         12                    11 = ((12 - 1)/10) * 10 + 1
		         13                    11 = ((13 - 1)/10) * 10 + 1
		         14                    11
		         15                    11
		         16                    11
		         17                    11
		         18                    11 
		         19                    11 
		         20                    11 = ((20 - 1)/10) * 10 + 1
		         
		         21                    21 = ((21 - 1)/10) * 10 + 1
		         22                    21 = ((22 - 1)/10) * 10 + 1
		         23                    21 = ((23 - 1)/10) * 10 + 1
		         ..                    ..
		         29                    21
		         30                    21 = ((30 - 1)/10) * 10 + 1
		*/
			
			String pageBar = "<ul style='list-style:none;'>";
			String url = "screeningRegister.trip";
			
			// === [맨처음][이전] 만들기 === //
			if(pageNo != 1) {
				pageBar += "<li class='fist_page'><a href='"+url+"?choice_status="+choice_status+"&currentShowPageNo=1'>맨처음</a></li>";
				pageBar += "<li class='before_page'><a href='"+url+"?choice_status="+choice_status+"&currentShowPageNo="+(pageNo-1)+"'>이전</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar += "<li class='choice_page_no'><a href='"+url+"?choice_status="+choice_status+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li class='next_page_no'><a href='"+url+"?choice_status="+choice_status+"&currentShowPageNo="+pageNo+"'>다음</a></li>";
				pageBar += "<li class='last_page_no'><a href='"+url+"?choice_status="+choice_status+"&currentShowPageNo="+totalPage+"'>마지막</a></li>"; 
			}
			
			pageBar += "</ul>";
			
			mav.addObject("pageBar", pageBar);
			mav.addObject("lodgingvoList",lodgingvoList);
			mav.addObject("choice_status",choice_status);
			
		}
		else {
			// 관리자가 아닌 계정이 들어올 경우
			String message = "잘못된 접근입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
		
	}
	
	// === 관리자가 처리한 결과에 따라 DB에 있는 status 값이 변경되게 만들어준다. === // 
	@ResponseBody
	@PostMapping("/screeningRegisterEnd.trip")
	public String screeningRegisterEnd(HttpServletRequest request) {
		
		String lodging_code = request.getParameter("lodging_code");
		String status = request.getParameter("status");
		String feedback_msg = request.getParameter("feedback_msg");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("lodging_code",lodging_code);
		paraMap.put("status",status);
		paraMap.put("feedback_msg",feedback_msg);
		
		int n = service.screeningRegisterEnd(paraMap); // 관리자가 숙소 등록 요청에 답한대로 DB를 업데이트 시켜준다.
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	}
	
	
	// === 관리자가 처리한 결과에 따라 DB에 있는 status 값이 변경되게 만들어준다. === // 
	@GetMapping("/requiredLogin_goMypage.trip")
	public ModelAndView requiredLogin_goMypage(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		if(loginuser != null && loginuser.getUserid().equals("admin")) {
			// 로그인한 유저가 개인 유저이면서 그 아이디가 관리자 아이디라면
			mav.setViewName("mypage/admin/mypageMain.tiles1");
			
			int PlayCount = service.getTotalPlayCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			int FoodstoreCount = service.getTotalFoodstoreCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			int lodgingCount = service.getTotalLodgingCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("lodging_cnt",lodgingCount);
			mav.addObject("foodstore_cnt",FoodstoreCount);
			mav.addObject("play_cnt",PlayCount);
			
		}
		else if(loginuser != null && !loginuser.getUserid().equals("admin")) {
			// 로그인한 유저가 개인 유저이면서 그 아이디가 일반 회원의 아이디라면
			mav.setViewName("mypage/member/mypageMain.tiles1");
			
			List<String> user_reservation_status = service.select_user_all_reservation(loginuser.getUserid());// 회원의 예약 목록을 가져와서 status별로 카운트를 해준다.
			int all_reservation = 0;
			int ready_reservation = 0;
			int success_reservation = 0;
			int fail_reservation = 0;
			for(String status : user_reservation_status) {
				
				++all_reservation;
				if(status.equals("0")) {
					++ready_reservation;
				}
				else if(status.equals("1")) {
					++success_reservation;
				}
				else if(status.equals("2")) {
					++fail_reservation;
				}
			}
			mav.addObject("all_reservation",all_reservation);
			mav.addObject("ready_reservation",ready_reservation);
			mav.addObject("success_reservation",success_reservation);
			mav.addObject("fail_reservation",fail_reservation);
		}
		else if(loginCompanyuser != null) {
			// 로그인한 유저가 기업 유저라면
			
			// 기업이 소유하고있는 호텔의 총 예약건을 읽어온다.
			List<Map<String,String>> reservationList = service.select_company_all_Reservation(loginCompanyuser.getCompanyid());

			int all_reservation = 0;
			int ready_reservation = 0;
			int success_reservation = 0;
			int fail_reservation = 0;
			for(Map<String,String> reservationMap : reservationList) {
				
				++all_reservation;
				if(reservationMap.get("status").equals("0")) {
					++ready_reservation;
				}
				else if(reservationMap.get("status").equals("1")) {
					++success_reservation;
				}
				else if(reservationMap.get("status").equals("2")) {
					++fail_reservation;
				}
			}
			mav.addObject("all_reservation",all_reservation);
			mav.addObject("ready_reservation",ready_reservation);
			mav.addObject("success_reservation",success_reservation);
			mav.addObject("fail_reservation",fail_reservation);
			mav.setViewName("mypage/company/mypageMain.tiles1");
		}
		
		return mav;
		
	}
	
	// === 업체 계정으로 마이페이지에서 숙소등록신청현황버튼을 클릭했을 때 view 페이지로 연결시키기 === //
	@GetMapping("/myRegisterHotel.trip")
	public ModelAndView requiredLogin_myRegisterHotel(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		
		// 숙소 테이블에서 해당 업체의 신청건수, 승인건수, 반려 건수를 각각 알아온다.
		List<Map<String,String>> mapList = service.select_count_registerHotel(loginCompanyuser.getCompanyid());
		
		boolean check_zero = false;
		boolean check_one = false;
		boolean check_two = false;
		
		for(Map<String,String> map : mapList) {
			if(map.get("status").equals("0")) {
				check_zero = true;
			}
			else if(map.get("status").equals("1")) {
				check_one = true;
			}
			else if(map.get("status").equals("2")) {
				check_two = true;
			}
		}
		
		if(!check_zero) {
			Map<String,String> map = new HashMap<>();
			map.put("status", "0");
			map.put("count_status", "0");
			mapList.add(map);
		}
		if(!check_one) {
			Map<String,String> map = new HashMap<>();
			map.put("status", "1");
			map.put("count_status", "0");
			mapList.add(map);
		}
		if(!check_two) {
			Map<String,String> map = new HashMap<>();
			map.put("status", "2");
			map.put("count_status", "0");
			mapList.add(map);
		}
		
		int total_count = 0;
		for(Map<String,String> map:mapList) {
			total_count += Integer.parseInt(map.get("count_status"));
		}
		Map<String,String> map = new HashMap<>();
		map.put("status", "4");
		map.put("count_status",String.valueOf(total_count));
		mapList.add(map);
		
		// 로그인 한 기업의 신청 목록을 읽어와서 view 페이지에 목록으로 뿌려주기 위한 select
		List<LodgingVO> lodgingvoList = service.select_loginCompany_lodgingvo(loginCompanyuser.getCompanyid());
		
		mav.addObject("lodgingvoList",lodgingvoList);
		mav.addObject("mapList",mapList);
		mav.setViewName("mypage/company/myRegisterHotel.tiles1");
		return mav;
	}
	
	// === 업체가 신청한 호텔에 대한 상세 정보를 보여주기위해 DB에서 읽어온다. === // 
	@ResponseBody
	@PostMapping("/selectRegisterHotelJSON.trip")
	public String selectRegisterHotelJSON(HttpServletRequest request) {
		
		String lodging_code = request.getParameter("lodging_code");
		
		
		LodgingVO lodgingvo = service.selectRegisterHotelJSON(lodging_code); // 업체가 신청한 호텔에 대한 상세 정보를 보여주기위해 DB에서 읽어온다.
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("lodging_name", lodgingvo.getLodging_name());
		jsonObj.put("lodging_category", lodgingvo.getLodging_category());
		jsonObj.put("local_status", lodgingvo.getLocal_status());
		jsonObj.put("lodging_tell", lodgingvo.getLodging_tell());
		jsonObj.put("lodging_content", lodgingvo.getLodging_content());
		jsonObj.put("lodging_address", lodgingvo.getLodging_address());
		jsonObj.put("main_img", lodgingvo.getMain_img());
		jsonObj.put("status", lodgingvo.getStatus());
		jsonObj.put("feedback_msg", lodgingvo.getFeedback_msg());
		
		return jsonObj.toString();
		
	}
	
	@GetMapping("/show_userList.trip")
	public ModelAndView show_userList(HttpServletRequest request, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser.getUserid().equals("admin")) {
			
			int count_all_member = service.getTotalMemberCount();// 모든 회원의 정보를 읽어오는 메소드 생성
			int count_all_company = service.getTotalCompanyCount();// 모든 기업의 정보를 읽어오는 메소드 생성
			
			mav.addObject("count_all_member",count_all_member);
			mav.addObject("count_all_company",count_all_company);
			mav.addObject("count_all_user",count_all_member+count_all_company);
			mav.setViewName("mypage/admin/userList.tiles1");
		}
		else {
			String message = "잘못된 접근입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	@ResponseBody
	@PostMapping(value="/MemberListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String MemberListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		List<MemberVO> memberList = service.select_member_all(paraMap); 
		int totalCount = service.getTotalMemberCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(memberList != null) {
			for(MemberVO member : memberList) {
				JSONObject jsonObj = new JSONObject();      
				jsonObj.put("userid", member.getUserid()); 
				jsonObj.put("email", member.getEmail());
				jsonObj.put("user_name", member.getUser_name()); 
				jsonObj.put("mobile", member.getMobile()); 
				jsonObj.put("address", member.getAddress());
				jsonObj.put("detail_address", member.getDetail_address());
				jsonObj.put("gender", member.getGender());
				jsonObj.put("registerday", member.getRegisterday());
				jsonObj.put("status", member.getStatus());
				jsonObj.put("idle", member.getIdle());
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	
	@ResponseBody
	@PostMapping(value="/CompanyListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String CompanyListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		List<CompanyVO> companyList = service.select_Company_all(paraMap); 
		int totalCount = service.getTotalCompanyCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(companyList != null) {
			for(CompanyVO company : companyList) {
				JSONObject jsonObj = new JSONObject();      
				jsonObj.put("companyid", company.getCompanyid());
				jsonObj.put("company_name", company.getCompany_name());
				jsonObj.put("email", company.getEmail());
				jsonObj.put("mobile", company.getMobile());
				jsonObj.put("registerday", company.getRegisterday());
				jsonObj.put("status", company.getStatus());
				jsonObj.put("idle", company.getIdle());
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	
	// 한 유저의 상세 정보를 가져와서 json 타입으로 뿌려준다.
	@ResponseBody
	@PostMapping(value="/selectUserJSON.trip", produces="text/plain;charset=UTF-8") 
	public String selectUserJSON(HttpServletRequest request) {

		String userid = request.getParameter("userid"); 
		
		MemberVO member = service.select_detailMember(userid);// 아이디를 토대로 회사 정보를 가져온다.
		
		JSONObject jsonObj = new JSONObject(); 
		
		if(member == null) {
			// 가져온 정보가 null 이라면 읽어오는 계정이 member가 아니라는 소리이므로 company 테이블에서 정보를 읽어와야 한다.
			CompanyVO company = service.select_detailCompany(userid);// 아이디를 토대로 회사 정보를 가져온다.
			
			if(company != null) {
				     
				jsonObj.put("companyid", company.getCompanyid());
				jsonObj.put("company_name", company.getCompany_name());
				jsonObj.put("email", company.getEmail());
				jsonObj.put("mobile", company.getMobile());
				jsonObj.put("registerday", company.getRegisterday());
				jsonObj.put("status", company.getStatus());
				jsonObj.put("idle", company.getIdle());
				jsonObj.put("type", "company");
			}
			
		}
		else {
			if(member != null) {
				
				jsonObj.put("userid", member.getUserid());
				jsonObj.put("user_name", member.getUser_name());
				jsonObj.put("email", member.getEmail());
				jsonObj.put("mobile", member.getMobile());
				jsonObj.put("address", member.getAddress());
				jsonObj.put("detail_address", member.getDetail_address());
				jsonObj.put("birthday", member.getBirthday());
				jsonObj.put("gender", member.getGender());
				jsonObj.put("registerday", member.getRegisterday());
				jsonObj.put("status", member.getStatus());
				jsonObj.put("idle", member.getIdle());
				jsonObj.put("type", "member");	
				
			}
		}
		return jsonObj.toString(); 	
	}
	
	@GetMapping("/admin_chart.trip")
	public ModelAndView admin_chart(HttpServletRequest request, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser.getUserid().equals("admin")) {
			
			mav.setViewName("mypage/admin/admin_chart.tiles1");
		}
		else {
			String message = "잘못된 접근입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	// 매년 호텔 예약건수를 찾아와서 차트화 시켜준다
	@ResponseBody
	@GetMapping(value="/get_year_reservation_hotel_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_year_reservation_hotel_chart(HttpServletRequest request) {
		
		String lodging_code = request.getParameter("lodging_code");
		List<Map<String,String>> mapList = service.get_year_reservation_hotel_chart(lodging_code);// 매년 호텔 예약건수를 찾아와서 차트화 시켜주기위한 정보 가져오기
		
		JSONArray jsonArr = new JSONArray();
		
		for(int i=2015;i<=2024;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist = false;
			for(Map<String,String> map : mapList) {
				if(map.get("reservation_year").equals(String.valueOf(i))) {
					is_exist = true;
					jsonObj.put("line_year_CNT", map.get("CNT"));
				}
			}
			if(!is_exist) {
				jsonObj.put("line_year_CNT", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 선택한 년도의 매월 예약건수를 가져와서 차트화 시켜준다.
	@ResponseBody
	@GetMapping(value="/get_month_reservation_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_month_reservation_chart(HttpServletRequest request) {
		
		String choice_year = request.getParameter("choice_year");
		String companyid = request.getParameter("companyid");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("choice_year", choice_year);
		paraMap.put("companyid", companyid);
		List<Map<String,String>> mapList = service.get_month_reservation_chart(paraMap);// 선택한 년도의 매월 예약건수를 가져와서 차트화 시켜준다.

		JSONArray jsonArr = new JSONArray();
		String str_i = "";
		for(int i=1;i<=12;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist = false;
			for(Map<String,String> map : mapList) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("reservation_month").equals(choice_year+"-"+str_i)) {
					is_exist = true;
					jsonObj.put("CNT", map.get("CNT"));
				}
			}
			if(!is_exist) {
				jsonObj.put("CNT", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 선택한 년도의 일별 예약건수를 가져와서 차트화 시켜준다.
	@ResponseBody
	@GetMapping(value="/get_day_reservation_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_day_reservation_chart(HttpServletRequest request) {
		
		String choice_month = request.getParameter("choice_month");
		
		if(Integer.parseInt(choice_month)<10) {
			choice_month = "0"+choice_month;
		}
		String companyid = request.getParameter("companyid");
		
		String choice_month_last_day = service.get_last_day(choice_month); // 내가 선택한 월이 있다면 그 월의 마지막 날을 구해준다.
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("choice_month_last_day",choice_month_last_day);
		paraMap.put("choice_month", choice_month);
		paraMap.put("companyid", companyid);
		List<Map<String,String>> mapList = service.get_day_reservation_chart(paraMap);// 선택한 월에서 매일의 예약건수를 가져와서 차트화 시켜준다.

		int day = Integer.parseInt(choice_month_last_day.substring(8));
		JSONArray jsonArr = new JSONArray();
		String str_i = "";
		for(int i=1;i<=day;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist = false;
			for(Map<String,String> map : mapList) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("reservation_day").equals(choice_month_last_day.substring(0,8)+str_i)) {
					is_exist = true;
					jsonObj.put("CNT", map.get("CNT"));
				}
			}
			if(!is_exist) {
				jsonObj.put("CNT", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 매년 로그인 한 유저의 로그인 수를 가져와서 차트화 시켜준다.
	@ResponseBody
	@GetMapping(value="/get_year_login_member_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_year_login_member_chart(HttpServletRequest request) {
		
		 
		
		List<Map<String,String>> mapList = service.get_year_login_member_chart();// 매년 가입자 수 통계를 내기 위한 차트 값 가져오기
		
		JSONArray jsonArr = new JSONArray();
		
		for(int i=2015;i<=2024;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist = false;
			for(Map<String,String> map : mapList) {
				if(map.get("line_year").equals(String.valueOf(i))) {
					is_exist = true;
					jsonObj.put("line_year_CNT", map.get("line_CNT"));
				}
			}
			if(!is_exist) {
				jsonObj.put("line_year_CNT", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 선택한 년도의 매월 로그인 한 유저의 로그인 수를 가져와서 차트화 시켜준다.
	@ResponseBody
	@GetMapping(value="/get_month_login_member_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_month_login_member_chart(HttpServletRequest request) {
		
		String choice_year = request.getParameter("choice_year");
		List<Map<String,String>> mapList = service.get_month_login_member_chart(choice_year);// 매달 가입자 수 통계를 내기 위한 차트 값 가져오기

		JSONArray jsonArr = new JSONArray();
		String str_i = "";
		for(int i=1;i<=12;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist = false;
			for(Map<String,String> map : mapList) {
				if(i<10) {
					str_i = "0"+i;
				}
				if(map.get("line_month").equals(choice_year+"-"+str_i)) {
					is_exist = true;
					jsonObj.put("line_month_CNT", map.get("line_CNT"));
				}
			}
			if(!is_exist) {
				jsonObj.put("line_month_CNT", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 전체 연령대 차트에 사용할 정보 가져오기
	@ResponseBody
	@GetMapping(value="/user_age_group_chart.trip", produces="text/plain;charset=UTF-8") 
	public String user_age_group_chart(HttpServletRequest request) {
		
		List<Map<String,String>> mapList = service.user_age_group_chart();// 사용자 연령대 차트에 사용할 정보 가져오기

		JSONArray jsonArr = new JSONArray();
		for(Map<String,String> map : mapList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("ageGroup", map.get("ageGroup"));
			jsonObj.put("PERCNTAGE", map.get("PERCNTAGE"));
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 전체 성별 차트에 사용할 정보 가져오기
	@ResponseBody
	@GetMapping(value="/user_gender_chart.trip", produces="text/plain;charset=UTF-8") 
	public String user_gender_chart(HttpServletRequest request) {
		
		List<Map<String,String>> mapList = service.user_gender_chart();// 사용자 성별 차트에 사용할 정보 가져오기

		JSONArray jsonArr = new JSONArray();
		for(Map<String,String> map : mapList) {
			JSONObject jsonObj = new JSONObject();
			if(map.get("gender").equals("1")) {
				jsonObj.put("gender", "남성");
			}
			else if(map.get("gender").equals("2")) {
				jsonObj.put("gender", "여성");
			}
			jsonObj.put("PERCNTAGE", map.get("PERCNTAGE"));
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 페이징 처리한 숙소 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/LodgingListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String LodgingListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		List<LodgingVO> lodgingList = service.select_lodging(paraMap); // 숙소  테이블에서 기본적인 정보 목록을 가져온다.
		int totalCount = service.getTotalLodgingCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(lodgingList != null) {
			for(LodgingVO lodging : lodgingList) {
				JSONObject jsonObj = new JSONObject();      
				jsonObj.put("lodging_code", lodging.getLodging_code());
				jsonObj.put("lodging_name", lodging.getLodging_name());
				jsonObj.put("lodging_tell", lodging.getLodging_tell());
				jsonObj.put("lodging_address", lodging.getLodging_address());
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	// 페이징 처리한 숙소 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/FoodstoreJSON.trip", produces="text/plain;charset=UTF-8") 
	public String FoodstoreJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		List<FoodstoreVO> foodstoreList = service.select_foodstore(paraMap); // 맛집  테이블에서 기본적인 정보 목록을 가져온다.
		int totalCount = service.getTotalFoodstoreCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(foodstoreList != null) {
			for(FoodstoreVO foodstore : foodstoreList) {
				JSONObject jsonObj = new JSONObject();      
				
				jsonObj.put("food_store_code", foodstore.getFood_store_code());
				jsonObj.put("food_name", foodstore.getFood_name());
				jsonObj.put("food_mobile", foodstore.getFood_mobile());
				jsonObj.put("food_address", foodstore.getFood_address());
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	// 페이징 처리한 숙소 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/PlayJSON.trip", produces="text/plain;charset=UTF-8") 
	public String PlayJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		List<PlayVO> playList = service.select_play(paraMap); //즐길거리  테이블에서 기본적인 정보 목록을 가져온다.
		int totalCount = service.getTotalPlayCount(); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(playList != null) {
			for(PlayVO play : playList) {
				JSONObject jsonObj = new JSONObject();      
				jsonObj.put("play_code", play.getPlay_code());
				jsonObj.put("play_name", play.getPlay_name());
				jsonObj.put("play_mobile", play.getPlay_mobile());
				jsonObj.put("play_address", play.getPlay_address());
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	@GetMapping("company_chart.trip")
	public ModelAndView company_chart(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		
		if(loginCompanyuser!=null) {
			
			mav.setViewName("mypage/company/company_chart.tiles1");
		}
		else {
			String message = "잘못된 접근입니다.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	// 매년 업체의 수익를 찾아와서 차트화 시켜준다
	@ResponseBody
	@GetMapping(value="/get_year_profit_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_year_profit_chart(HttpServletRequest request) {
		
		String companyid = request.getParameter("companyid");
		List<Map<String,String>> mapList_all = service.get_year_profit_chart(companyid);// 매년 총업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
		List<Map<String,String>> mapList_success = service.get_year_profit_chart_success(companyid);// 매년 승인된 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
		List<Map<String,String>> mapList_fail = service.get_year_profit_chart_fail(companyid);// 매년 취소 업체수익을 찾아와서 차트화 시켜주기위한 정보 가져오기
		JSONArray jsonArr = new JSONArray();
		for(int i=2015;i<=2024;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist_all = false;
			boolean is_exist_success = false;
			boolean is_exist_fail = false;
			for(Map<String,String> map : mapList_all) {
				if(map.get("year").equals(String.valueOf(i))) {
					is_exist_all = true;
					
					jsonObj.put("all_profit", map.get("all_profit"));
				}
			}
			if(!is_exist_all) {
				jsonObj.put("all_profit", "0");
			}
			///////////////////////////////////////////////////////
			for(Map<String,String> map : mapList_success) {
				if(map.get("year").equals(String.valueOf(i))) {
					is_exist_success = true;
					
					jsonObj.put("success_profit", map.get("success_profit"));
				}
			}
			if(!is_exist_success) {
				jsonObj.put("success_profit", "0");
			}
			///////////////////////////////////////////////////////
			for(Map<String,String> map : mapList_fail) {
				if(map.get("year").equals(String.valueOf(i))) {
					is_exist_fail = true;
					
					jsonObj.put("fail_profit", map.get("fail_profit"));
				}
			}
			if(!is_exist_fail) {
				jsonObj.put("fail_profit", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	
	// 선택한 년도의 매월 매출액을 가져와서 차트화 시켜준다.
	@ResponseBody
	@GetMapping(value="/get_month_profit_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_month_profit_chart(HttpServletRequest request) {
		
		String choice_year = request.getParameter("choice_year");
		String companyid = request.getParameter("companyid");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("choice_year", choice_year);
		paraMap.put("companyid", companyid);
		List<Map<String,String>> mapList_all = service.get_month_profit_chart(paraMap);// 선택한 년도의 매월 매출액을 가져와서 차트화 시켜준다.
		List<Map<String,String>> mapList_success = service.get_month_profit_chart_succeess(paraMap);// 선택한 년도의 매월 승인매출액을 가져와서 차트화 시켜준다.
		List<Map<String,String>> mapList_fail = service.get_month_profit_chart_fail(paraMap);// 선택한 년도의 매월 취소금액을 가져와서 차트화 시켜준다.

		JSONArray jsonArr = new JSONArray();
		String str_i = "";
		for(int i=1;i<=12;i++) {
			JSONObject jsonObj = new JSONObject();
			boolean is_exist_all = false;
			boolean is_exist_success = false;
			boolean is_exist_fail = false;
			for(Map<String,String> map : mapList_all) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("year").equals(choice_year+"-"+str_i)) {
					is_exist_all = true;
					jsonObj.put("profit_all", map.get("profit_all"));
				}
			}
			if(!is_exist_all) {
				jsonObj.put("profit_all", "0");
			}
			
			/////////////////////////////////////////////////////////////////
			
			for(Map<String,String> map : mapList_success) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("year").equals(choice_year+"-"+str_i)) {
					is_exist_success = true;
					jsonObj.put("profit_success", map.get("profit_success"));
				}
			}
			if(!is_exist_success) {
				jsonObj.put("profit_success", "0");
			}
			
			/////////////////////////////////////////////////////////////////
			
			for(Map<String,String> map : mapList_fail) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("year").equals(choice_year+"-"+str_i)) {
					is_exist_fail = true;
					jsonObj.put("profit_fail", map.get("profit_fail"));
				}
			}
			if(!is_exist_fail) {
				jsonObj.put("profit_fail", "0");
			}
			
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 선택한 월의 일별 매출액을 가져와서 차트화 시켜준다.
	@ResponseBody
	@GetMapping(value="/get_day_profit_chart.trip", produces="text/plain;charset=UTF-8") 
	public String get_day_profit_chart(HttpServletRequest request) {
		
		String choice_month = request.getParameter("choice_month");
		
		if(Integer.parseInt(choice_month)<10) {
			choice_month = "0"+choice_month;
		}
		String companyid = request.getParameter("companyid");
		
		String choice_month_last_day = service.get_last_day(choice_month); // 내가 선택한 월이 있다면 그 월의 마지막 날을 구해준다.
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("choice_month_last_day",choice_month_last_day);
		paraMap.put("choice_month", choice_month);
		paraMap.put("companyid", companyid);
		List<Map<String,String>> mapList_all = service.get_day_profit_chart(paraMap);// 선택한 월에서 매일의 매출액을 가져와서 차트화 시켜준다.
		List<Map<String,String>> mapList_success = service.get_day_profit_chart_success(paraMap);// 선택한 월에서 매일의 승인된 매출액을 가져와서 차트화 시켜준다.
		List<Map<String,String>> mapList_fail = service.get_day_profit_chart_fail(paraMap);// 선택한 월에서 매일의 취소금액을 가져와서 차트화 시켜준다.

		int day = Integer.parseInt(choice_month_last_day.substring(8));
		JSONArray jsonArr = new JSONArray();
		String str_i = "";
		for(int i=1;i<=day;i++) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("day", i);
			boolean is_exist_all = false;
			boolean is_exist_success = false;
			boolean is_exist_fail = false;
			for(Map<String,String> map : mapList_all) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("day").equals(choice_month_last_day.substring(0,8)+str_i)) {
					is_exist_all = true;
					jsonObj.put("profit", map.get("profit"));
				}
			}
			if(!is_exist_all) {
				jsonObj.put("profit", "0");
			}
			
			////////////////////////////////////////////////////////////////////////////
			
			for(Map<String,String> map : mapList_success) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("day").equals(choice_month_last_day.substring(0,8)+str_i)) {
					is_exist_success = true;
					jsonObj.put("profit_success", map.get("profit_success"));
				}
			}
			if(!is_exist_success) {
				jsonObj.put("profit_success", "0");
			}
			
			//////////////////////////////////////////////////////////////////////////////
			
			for(Map<String,String> map : mapList_fail) {
				if(i<10) {
					str_i = "0"+i;
				}
				else {
					str_i = String.valueOf(i);
				}
				if(map.get("day").equals(choice_month_last_day.substring(0,8)+str_i)) {
					is_exist_fail = true;
					jsonObj.put("profit_fail", map.get("profit_fail"));
				}
			}
			if(!is_exist_fail) {
				jsonObj.put("profit_fail", "0");
			}
			jsonArr.put(jsonObj);
		}
		
		return jsonArr.toString(); 	
	}
	
	// 페이징 처리한 숙소예약신청 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/reservationListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String reservationListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("companyid", request.getParameter("companyid"));
		paraMap.put("status", request.getParameter("status"));
		// 기업이 소유하고있는 호텔의 총 예약건을 페이징 처리 해서 읽어온다.
		List<Map<String,String>> reservationList = service.select_company_all_Reservation_paging(paraMap);
		int totalCount = service.getTotalreservationCount(paraMap); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(reservationList != null) {
			for(Map<String,String> reservationMap : reservationList) {
				JSONObject jsonObj = new JSONObject(); 
				
				// 예약일자마다의 객실 잔여석을 알아오기 위함이다.
				String count = service.select_reservation_Count(reservationMap);
				int remain = Integer.parseInt(reservationMap.get("room_stock")) - Integer.parseInt(count);
				
				jsonObj.put("lodging_name", reservationMap.get("lodging_name"));
				jsonObj.put("user_name", reservationMap.get("user_name"));
				jsonObj.put("room_detail_code", reservationMap.get("room_detail_code"));
				jsonObj.put("check_in", reservationMap.get("check_in"));
				jsonObj.put("check_out", reservationMap.get("check_out"));
				jsonObj.put("room_stock", reservationMap.get("room_stock"));
				jsonObj.put("status", reservationMap.get("status"));
				jsonObj.put("reservation_code", reservationMap.get("reservation_code"));
				jsonObj.put("room_name", reservationMap.get("room_name"));
				jsonObj.put("count", count);
				jsonObj.put("remain", remain);
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	// 페이징 처리한 숙소예약신청 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/goChangeReservationStatusJSON.trip", produces="text/plain;charset=UTF-8") 
	public String goChangeReservationStatusJSON(HttpServletRequest request) {

		String reservation_code = request.getParameter("reservation_code");
		String status = request.getParameter("status");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("reservation_code", reservation_code);
		paraMap.put("status", status);
		int result = service.updateReservationStatus(paraMap); // 업체가 처리한 결과에 따라 reservation테이블에 status값 바꿔주기
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		if(result == 1 && status.equals("1")) {
			String email = service.get_user_email(reservation_code); // 회원의 이메일을 읽어온다.
			
			boolean sendMailSuccess = false; // 메일이 정상적으로 전송되었는지 유무를 알아오기 위한 용도
            
            GoogleMail mail = new GoogleMail();
            
            Map<String,String> emailMap = service.get_email_map(reservation_code);// 바우처에 입력할 정보를 가져오기 위해 예약정보등을 가져온다.
    		
            DecimalFormat df = new DecimalFormat("#,###");
            
            System.out.println(request.getContextPath()+"/resources/images/lodginglist/room/"+emailMap.get("room_img"));
            
            String r_html = "<div style=\"border:solid 1px black; width:80%; margin:auto;\">";
            r_html += "<div style=\"font-size:30pt; font-weight:bold; text-align:center;\">"+emailMap.get("lodging_name")+"<span style=\"float:right; font-size:15pt; margin-right: 10px;\">No."+emailMap.get("reservation_code")+"</span></div>";
            r_html += "<hr>";
            r_html += "<div><img style=\"width:250px; margin-left:50px;\" src='http://127.0.0.1:9090/JejuDream/resources/images/lodginglist/room/"+emailMap.get("room_img")+"'/></div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">ROOM : "+emailMap.get("room_name")+"</div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">NAME : "+emailMap.get("user_name")+"</div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">TEL : "+emailMap.get("lodging_tell")+"</div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">ADDERESS : "+emailMap.get("lodging_address")+"</div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">CHECK IN : "+emailMap.get("check_in")+"</div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">CHECK OUT : "+emailMap.get("check_out")+"</div>";
            r_html += "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px; margin-bottom:10px;\">PRICE : "+df.format(Integer.parseInt(emailMap.get("reservation_price")))+" 원 </div>";
            r_html += "</div>";
            
            try {
	            mail.send_change_reservation_status(email, r_html);
	            sendMailSuccess = true;
	            
            }catch(Exception e) {
            	// 메일 전송이 실패한 경우 
                e.printStackTrace();
                sendMailSuccess = false; // 메일 전송 실패했음을 기록함.
            }
			jsonObj.put("email_send_result", sendMailSuccess);
		}
		else if (result == 1 && status.equals("2")) {
			String email = service.get_user_email(reservation_code); // 회원의 이메일을 읽어온다.
			
			boolean sendMailSuccess = false; // 메일이 정상적으로 전송되었는지 유무를 알아오기 위한 용도
            
            GoogleMail mail = new GoogleMail();
            
            String r_html = "<div style=\"font-size:15pt; font-weight:bold; margin-left: 50px; margin-top: 10px;\">예약에 실패했습니다 해당 업체로 문의 바랍니다.</div>";
            
            try {
	            mail.send_change_reservation_status(email, r_html);
	            sendMailSuccess = true;
	            
            }catch(Exception e) {
            	// 메일 전송이 실패한 경우 
                e.printStackTrace();
                sendMailSuccess = false; // 메일 전송 실패했음을 기록함.
            }
			jsonObj.put("email_send_result", sendMailSuccess);
		}
		
		
		return jsonObj.toString();
	}
	
	// 페이징 처리한 숙소예약신청 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/userReservationListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String userReservationListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
		/*
		     currentShowPageNo      startRno     endRno
		    --------------------------------------------
		         1 page        ===>    1           10
		         2 page        ===>    11          20
		         3 page        ===>    21          30
		         4 page        ===>    31          40
		         ......                ...         ...
		 */
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("userid", request.getParameter("userid"));
		paraMap.put("status", request.getParameter("status"));
		// 개인회원이 한 예약정보를 페이징처리하여 읽어온다.
		List<Map<String,String>> reservationList = service.select_user_all_Reservation_paging(paraMap);
		int totalCount = service.getTotalUserReservationCount(paraMap); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(reservationList != null) {
			for(Map<String,String> reservationMap : reservationList) {
				JSONObject jsonObj = new JSONObject(); 
				
				// 예약일자마다의 객실 잔여석을 알아오기 위함이다.
				String count = service.select_reservation_Count(reservationMap);
				int remain = Integer.parseInt(reservationMap.get("room_stock")) - Integer.parseInt(count);
				
				jsonObj.put("lodging_name", reservationMap.get("lodging_name"));
				jsonObj.put("user_name", reservationMap.get("user_name"));
				jsonObj.put("room_detail_code", reservationMap.get("room_detail_code"));
				jsonObj.put("check_in", reservationMap.get("check_in"));
				jsonObj.put("check_out", reservationMap.get("check_out"));
				jsonObj.put("room_stock", reservationMap.get("room_stock"));
				jsonObj.put("status", reservationMap.get("status"));
				jsonObj.put("reservation_code", reservationMap.get("reservation_code"));
				jsonObj.put("room_name", reservationMap.get("room_name"));
				jsonObj.put("count", count);
				jsonObj.put("remain", remain);
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); // "[{"seq":1, "fk_userid":"seoyh","name":서영학,"content":"첫번째 댓글입니다. ㅎㅎㅎ","regdate":"2024-06-18 15:36:31"}]"
		                           // 또는
		                           // "[]"		
		
	}
	
	@GetMapping("editProfile.trip")
	public ModelAndView editProfile(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null) {
			mav.setViewName("mypage/member/editProfile.tiles1");
		}
		return mav;
	}
	
	// 로그인한 유저 자기자신의 이메일을 제외한 다른 사람의 이메일중 중복값이 있는 지 알아오기.
	@ResponseBody
	@PostMapping(value="/userEmailDuplicateCheckEdit.trip", produces="text/plain;charset=UTF-8") 
	public String userEmailDuplicateCheckEdit(HttpServletRequest request) {

		String email = request.getParameter("email");
		HttpSession session = request.getSession();
		MemberVO membervo = (MemberVO)session.getAttribute("loginuser");
		String userid = membervo.getUserid();
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("email", email);
		paraMap.put("userid", userid);
		
		boolean isExist = service.userEmailDuplicateCheckEdit(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExist", isExist);
		
		return jsonObj.toString();
		
	}
	
	// 멤버 정보 수정하기
	@ResponseBody
	@PostMapping(value="/memberEditEnd.trip", produces="text/plain;charset=UTF-8") 
	public String memberEditEnd(MemberVO membervo, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		membervo.setUserid(loginuser.getUserid());
		int n = service.update_member_info(membervo);// 입력한 값으로 회원 정보를 수정한다.
		if(n == 1) {
			try {
				loginuser.setUser_name(membervo.getUser_name());
				loginuser.setEmail(aES256.decrypt(membervo.getEmail()));
				loginuser.setAddress(membervo.getAddress());
				loginuser.setDetail_address(membervo.getDetail_address());
				loginuser.setMobile(aES256.decrypt(membervo.getMobile()));
				loginuser.setBirthday(membervo.getBirthday());
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		return jsonObj.toString();
		
	}
	
	@GetMapping("my_schedule.trip")
	public ModelAndView my_schedule(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null) {
			mav.setViewName("mypage/member/my_schedule.tiles1");
		}
		return mav;
	}
	
	// === 모든 캘린더(사내캘린더, 내캘린더, 공유받은캘린더)를 불러오는것 ===
	@ResponseBody
	@RequestMapping(value="/selectSchedule.trip", produces="text/plain;charset=UTF-8")
	public String selectSchedule(HttpServletRequest request) {
		
		// 등록된 일정 가져오기
		
		String fk_userid = request.getParameter("fk_userid");
				
		List<Calendar_schedule_VO> scheduleList = service.selectSchedule(fk_userid);
		
		JSONArray jsArr = new JSONArray();
		
		if(scheduleList != null && scheduleList.size() > 0) {
			
			for(Calendar_schedule_VO svo : scheduleList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("subject", svo.getSubject());
				jsObj.put("startdate", svo.getStartdate());
				jsObj.put("enddate", svo.getEnddate());
				jsObj.put("color", svo.getColor());
				jsObj.put("scheduleno", svo.getScheduleno());
				jsObj.put("fk_lgcatgono", svo.getFk_lgcatgono());
				jsObj.put("fk_smcatgono", svo.getFk_smcatgono());
				jsObj.put("fk_userid", svo.getFk_userid());
				jsObj.put("joinuser", svo.getJoinuser());
				
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		
		}
		
		return jsArr.toString();
	}
	
	// === 일정상세보기 ===
	@RequestMapping(value="/schedule/detailSchedule.trip")
	public ModelAndView detailSchedule(ModelAndView mav, HttpServletRequest request) {
		
		String scheduleno = request.getParameter("scheduleno");
		
		// 검색하고 나서 취소 버튼 클릭했을 때 필요함
		String listgobackURL_schedule = request.getParameter("listgobackURL_schedule");
		mav.addObject("listgobackURL_schedule",listgobackURL_schedule);

		
		// 일정상세보기에서 일정수정하기로 넘어갔을 때 필요함
		String gobackURL_detailSchedule = MyUtil.getCurrentURL(request);
		mav.addObject("gobackURL_detailSchedule", gobackURL_detailSchedule);
		
		try {
			Integer.parseInt(scheduleno);
			Map<String,String> map = service.detailSchedule(scheduleno);
			mav.addObject("map", map);
			mav.setViewName("mypage/member/detailSchedule.tiles1");
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/my_schedule.action");
		}
		
		return mav;
	}
	
	
	// === 내 캘린더에서 내캘린더 소분류  보여주기 ===
	@ResponseBody
	@GetMapping(value="/schedule/showMyCalendar.trip", produces="text/plain;charset=UTF-8") 
	public String showMyCalendar(HttpServletRequest request) {
		
		String fk_userid = request.getParameter("fk_userid");
		
		List<Calendar_small_category_VO> calendar_small_category_VO_CompanyList = service.showMyCalendar(fk_userid);
		
		JSONArray jsonArr = new JSONArray();
		
		if(calendar_small_category_VO_CompanyList != null) {
			for(Calendar_small_category_VO smcatevo : calendar_small_category_VO_CompanyList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("smcatgono", smcatevo.getSmcatgono());
				jsObj.put("smcatgoname", smcatevo.getSmcatgoname());
				jsonArr.put(jsObj);
			}
		}
		
		return jsonArr.toString();
	}
	
	// === 검색 기능 === //
	@GetMapping("/schedule/searchSchedule.trip")
	public ModelAndView searchSchedule(HttpServletRequest request, ModelAndView mav) { 
		
		List<Map<String,String>> scheduleList = null;
		
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String fk_userid = request.getParameter("fk_userid");  // 로그인한 사용자id
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		String str_sizePerPage = request.getParameter("sizePerPage");
	
		String fk_lgcatgono = request.getParameter("fk_lgcatgono");
		
		if(searchType==null || (!"subject".equals(searchType) && !"content".equals(searchType)  && !"joinuser".equals(searchType))) {  
			searchType="";
		}
		
		if(searchWord==null || "".equals(searchWord) || searchWord.trim().isEmpty()) {  
			searchWord="";
		}
		
		if(startdate==null || "".equals(startdate)) {
			startdate="";
		}
		
		if(enddate==null || "".equals(enddate)) {
			enddate="";
		}
			
		if(str_sizePerPage == null || "".equals(str_sizePerPage) || 
		   !("10".equals(str_sizePerPage) || "15".equals(str_sizePerPage) || "20".equals(str_sizePerPage))) {
				str_sizePerPage ="10";
		}
		
		if(fk_lgcatgono == null ) {
			fk_lgcatgono="";
		}
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("fk_userid", fk_userid);
		paraMap.put("str_sizePerPage", str_sizePerPage);

		paraMap.put("fk_lgcatgono", fk_lgcatgono);
		
		int totalCount=0;          // 총 게시물 건수		
		int currentShowPageNo=0;   // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함.
		int totalPage=0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)  
		int sizePerPage = Integer.parseInt(str_sizePerPage);  // 한 페이지당 보여줄 행의 개수
		int startRno=0;            // 시작 행번호
	    int endRno=0;              // 끝 행번호 
	    
	    // 총 일정 검색 건수(totalCount)
	    totalCount = service.getTotalScheduleCount(paraMap);
	//  System.out.println("~~~ 확인용 총 일정 검색 건수 totalCount : " + totalCount);
      
	    totalPage = (int)Math.ceil((double)totalCount/sizePerPage); 

		if(str_currentShowPageNo == null) {
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1;
				}
			} catch (NumberFormatException e) {
				currentShowPageNo=1;
			}
		}
		
		startRno = ((currentShowPageNo - 1 ) * sizePerPage) + 1;
	    endRno = startRno + sizePerPage - 1;
	      
	    paraMap.put("startRno", String.valueOf(startRno));
	    paraMap.put("endRno", String.valueOf(endRno));
	    	   
	    scheduleList = service.scheduleListSearchWithPaging(paraMap);
	    // 페이징 처리한 캘린더 가져오기(검색어가 없다라도 날짜범위 검색은 항시 포함된 것임)
	    
		mav.addObject("paraMap", paraMap);
		// 검색대상 컬럼과 검색어를 유지시키기 위한 것임.
		
		// === 페이지바 만들기 === //
		int blockSize= 5;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	   
		String pageBar = "<ul style='list-style:none;'>";
		
		String url = "searchSchedule.action";
		
		// === [맨처음][이전] 만들기 ===
		if(pageNo!=1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?startdate="+startdate+"&enddate="+enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_userid="+fk_userid+"&fk_lgcatgono="+fk_lgcatgono+"&sizePerPage="+sizePerPage+"&currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?startdate="+startdate+"&enddate="+enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_userid="+fk_userid+"&fk_lgcatgono="+fk_lgcatgono+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
		while(!(loop>blockSize || pageNo>totalPage)) {
			
			if(pageNo==currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?startdate="+startdate+"&enddate="+enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_userid="+fk_userid+"&fk_lgcatgono="+fk_lgcatgono+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
			}
			
			loop++;
			pageNo++;
		}// end of while--------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?startdate="+startdate+"&enddate="+enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_userid="+fk_userid+"&fk_lgcatgono="+fk_lgcatgono+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?startdate="+startdate+"&enddate="+enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_userid="+fk_userid+"&fk_lgcatgono="+fk_lgcatgono+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
		}
		pageBar += "</ul>";
		
		mav.addObject("pageBar",pageBar);
		
		String listgobackURL_schedule = MyUtil.getCurrentURL(request);
	//	System.out.println("~~~ 확인용 검색 listgobackURL_schedule : " + listgobackURL_schedule);
		
		mav.addObject("listgobackURL_schedule",listgobackURL_schedule);
		mav.addObject("scheduleList", scheduleList);
		mav.setViewName("mypage/member/searchSchedule.tiles1");

		return mav;
	}
	
	// === 풀캘린더에서 날짜 클릭할 때 발생하는 이벤트(일정 등록창으로 넘어간다) ===
	@PostMapping("/schedule/insertSchedule.trip")
	public ModelAndView insertSchedule(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { 
		
		// form 에서 받아온 날짜
		String chooseDate = request.getParameter("chooseDate");
		
		mav.addObject("chooseDate", chooseDate);
		mav.setViewName("mypage/member/insertSchedule.tiles1");
		
		return mav;
	}
	
	// === 일정 등록하기 ===
	@PostMapping("/schedule/registerSchedule_end.trip")
	public ModelAndView registerSchedule_end(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String startdate= request.getParameter("startdate");
   	    
		String enddate = request.getParameter("enddate");
		String subject = request.getParameter("subject");
		String fk_lgcatgono= "1";
		String fk_smcatgono = request.getParameter("fk_smcatgono");
		String color = request.getParameter("color");
		String place = request.getParameter("place");
		String joinuser = request.getParameter("joinuser");
		
		String content = request.getParameter("content");
		String fk_userid = request.getParameter("fk_userid");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		paraMap.put("subject", subject);
		paraMap.put("fk_lgcatgono",fk_lgcatgono);
		paraMap.put("fk_smcatgono", fk_smcatgono);
		paraMap.put("color", color);
		paraMap.put("place", place);
		
		paraMap.put("joinuser", joinuser);
		
		paraMap.put("content", content);
		paraMap.put("fk_userid", fk_userid);
		
		int n = service.registerSchedule_end(paraMap);

		if(n == 0) {
			mav.addObject("message", "일정 등록에 실패하였습니다.");
		}
		else {
			mav.addObject("message", "일정 등록에 성공하였습니다.");
		}
		
		mav.addObject("loc", request.getContextPath()+"/my_schedule.trip");
		
		mav.setViewName("msg");
		
		return mav;
	}
	
	// === 일정 수정하기 ===
	@PostMapping("/schedule/editSchedule.trip")
	public ModelAndView editSchedule(ModelAndView mav, HttpServletRequest request) {
		
		String scheduleno= request.getParameter("scheduleno");
   		
		try {
			Integer.parseInt(scheduleno);
			
			String gobackURL_detailSchedule = request.getParameter("gobackURL_detailSchedule");
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			Map<String,String> map = service.detailSchedule(scheduleno);
			
			if( !loginuser.getUserid().equals( map.get("FK_USERID") ) ) {
				String message = "다른 사용자가 작성한 일정은 수정이 불가합니다.";
				String loc = "javascript:history.back()";
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				mav.setViewName("msg");
			}
			else {
				mav.addObject("map", map);
				mav.addObject("gobackURL_detailSchedule", gobackURL_detailSchedule);
				
				mav.setViewName("mypage/member/editSchedule.tiles1");
			}
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/my_schedule.trip");
		}
		
		return mav;
		
	}
	
	// === 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기 ===
	@ResponseBody
	@RequestMapping(value="/schedule/insertSchedule/searchJoinUserList.trip", produces="text/plain;charset=UTF-8")
	public String searchJoinUserList(HttpServletRequest request) {
		
		String joinUserName = request.getParameter("joinUserName");
		
		// 공유자 명단 불러오기
		List<MemberVO> joinUserList = service.searchJoinUserList(joinUserName);

		JSONArray jsonArr = new JSONArray();
		if(joinUserList != null && joinUserList.size() > 0) {
			for(MemberVO mvo : joinUserList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("userid", mvo.getUserid());
				jsObj.put("user_name", mvo.getUser_name());
				
				jsonArr.put(jsObj);
			}
		}
		
		return jsonArr.toString();
		
	}
	
	// === 일정 수정 완료하기 ===
	@PostMapping("/schedule/editSchedule_end.trip")
	public ModelAndView editSchedule_end(Calendar_schedule_VO svo, HttpServletRequest request, ModelAndView mav) {
		
		try {
			 int n = service.editSchedule_end(svo);
			 
			 if(n==1) {
				 mav.addObject("message", "일정을 수정하였습니다.");
				 mav.addObject("loc", request.getContextPath()+"/my_schedule.trip");
			 }
			 else {
				 mav.addObject("message", "일정 수정에 실패하였습니다.");
				 mav.addObject("loc", "javascript:history.back()");
			 }
			 
			 mav.setViewName("msg");
		} catch (Throwable e) {	
			e.printStackTrace();
			mav.setViewName("redirect:/my_schedule.trip");
		}
			
		return mav;
	}
	
	
	// === 일정삭제하기 ===
	@ResponseBody
	@PostMapping("/schedule/deleteSchedule.trip")
	public String deleteSchedule(HttpServletRequest request) throws Throwable {
		
		String scheduleno = request.getParameter("scheduleno");
				
		int n = service.deleteSchedule(scheduleno);
		
		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
			
		return jsObj.toString();
	}
	
	// 예약 코드를 가지고 업체아이디와 업체명을 가져오기
	@ResponseBody
	@PostMapping("/getCompanyIdAndNameJSON.trip")
	public String getCompanyIdAndNameJSON(HttpServletRequest request) throws Throwable {
		String reservation_code = request.getParameter("reservation_code");
		
		Map<String,String> map = service.getCompanyIdAndLodgingNameToTblReservationCode(reservation_code);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("companyid", map.get("companyid"));
		jsonObj.put("lodging_name", map.get("lodging_name"));
		return jsonObj.toString();
	}
	
	// === #222. (웹 채팅 관련4) === // 
	@GetMapping("/reservationChatToCompany.trip")
	public String reservationChatToCompany(HttpServletRequest request, HttpServletResponse response) {
		
		service.update_chattinglog(request.getParameter("reservation_code"));// 채팅 로그 테이블에 해당 예약건에 관련한 채팅을 읽음처리한다.
		
		String reservation_code = request.getParameter("reservation_code");
		// 해당 예약에 관련된 companyid를 가져와야한다.
		
		String companyid = request.getParameter("companyid");
		
		String chatting_key = reservation_code + "_" + request.getParameter("userid") + "_" + companyid;
		String status = request.getParameter("status");
		HttpSession session = request.getSession();
		if(status.equals("1")) {
			MemberVO chattinguser = new MemberVO();
			chattinguser.setUser_name(request.getParameter("name"));
			chattinguser.setUserid(request.getParameter("userid"));
			session.setAttribute("chattinguser", chattinguser);
		}
		else {
			MemberVO chattinguser = new MemberVO();
			chattinguser.setUser_name(request.getParameter("lodging_name"));
			chattinguser.setUserid(request.getParameter("companyid"));
			session.setAttribute("chattinguser", chattinguser);
		}
		
		session.setAttribute("chatting_key", chatting_key);
		session.setAttribute("status", status);
		
		return "chatting";
	}
	
	
	// === #222. (웹 채팅 관련4) === // 
	@GetMapping("/ChatToAdmin.trip")
	public String ChatToAdmin(HttpServletRequest request, HttpServletResponse response) {
		
		// service.update_chattinglog(request.getParameter("reservation_code"));// 채팅 로그 테이블에 해당 예약건에 관련한 채팅을 읽음처리한다.
		
		String chatting_key = request.getParameter("userid") + "_admin";
		String status = request.getParameter("status");
		HttpSession session = request.getSession();
		if(status.equals("3")) {
			MemberVO chattinguser = new MemberVO();
			chattinguser.setUser_name(request.getParameter("name"));
			chattinguser.setUserid(request.getParameter("userid"));
			session.setAttribute("chattinguser", chattinguser);
		}
		else if(status.equals("4")){
			MemberVO chattinguser = new MemberVO();
			chattinguser.setUser_name("관리자");
			chattinguser.setUserid(request.getParameter("admin"));
			session.setAttribute("chattinguser", chattinguser);
		}
		
		session.setAttribute("chatting_key", chatting_key);
		session.setAttribute("status", status);
		
		return "chatting";
	}
	
	@GetMapping("/support.trip")
	public ModelAndView support(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		int newChattingCnt = 0;
		if(loginuser != null && loginuser.getUserid().equals("admin")) {
			// 로그인한 유저가 개인 유저이면서 그 아이디가 관리자 아이디라면
			newChattingCnt = service.get_new_chatting_admin(loginuser.getUserid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			mav.addObject("newChattingCnt",newChattingCnt);
			mav.setViewName("mypage/admin/support.tiles1");
		}
		else if(loginuser != null && !loginuser.getUserid().equals("admin")) {
			// 로그인한 유저가 개인 유저이면서 그 아이디가 일반 회원의 아이디라면
			mav.setViewName("mypage/member/support.tiles1");
			newChattingCnt = service.get_new_chatting(loginuser.getUserid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			if(newChattingCnt == 0) {
				newChattingCnt = service.get_from_admin_chatting_exist(loginuser.getUserid());// 관리자 채팅이 있는지 없는지도 확인해본다.
			}
			mav.addObject("newChattingCnt",newChattingCnt);
		}
		else if(loginCompanyuser != null){
			// 로그인한 유저가 기업유저라면
			mav.setViewName("mypage/company/support.tiles1");
			newChattingCnt = service.get_new_chatting(loginCompanyuser.getCompanyid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			mav.addObject("newChattingCnt",newChattingCnt);
		}
		
		return mav;
		
	}
	
	@GetMapping("/mypage_company_chatting.trip")
	public ModelAndView mypage_company_chatting(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
		int newChattingCnt = 0;
		int allChattingCnt = 0;
		if(loginCompanyuser != null){
			// 로그인한 유저가 기업유저라면
			newChattingCnt = service.get_new_chatting(loginCompanyuser.getCompanyid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			allChattingCnt = service.get_all_chatting(loginCompanyuser.getCompanyid());// 로그인을 했을 때 모든 채팅의 개수를 읽어온다.
			mav.addObject("newChattingCnt",newChattingCnt);
			mav.addObject("allChattingCnt",allChattingCnt);
		}
		
		mav.setViewName("mypage/company/mypage_company_chatting.tiles1");
		return mav;
	}
	
	
	// 페이징 처리한 업체의 채팅 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/companyAllChattingListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String companyAllChattingListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("companyid", request.getParameter("companyid"));
		paraMap.put("status", request.getParameter("status"));
		// 기업으로 온 모든 채팅 목록을 읽어온다.
		List<Map<String,String>> chattingList = service.select_company_all_chatting_paging(paraMap);
		int totalCount = service.getTotalCompanyChattingCount(paraMap); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(chattingList != null) {
			for(Map<String,String> reservationMap : chattingList) {
				JSONObject jsonObj = new JSONObject(); 
				
				jsonObj.put("fk_reservation_code", reservationMap.get("fk_reservation_code"));
				jsonObj.put("lodging_name", reservationMap.get("lodging_name"));
				jsonObj.put("room_name", reservationMap.get("room_name"));
				jsonObj.put("user_name", reservationMap.get("user_name"));
				jsonObj.put("chatting_date", reservationMap.get("chatting_date"));
				jsonObj.put("status", reservationMap.get("status"));
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); 
	}
	
	// 채팅에 해당하는 고객 아이디와 이름을 가져온다.
	@ResponseBody
	@PostMapping(value="/getMemberIdAndNameJSON.trip", produces="text/plain;charset=UTF-8") 
	public String getMemberIdAndNameJSON(HttpServletRequest request) {

		String reservation_code = request.getParameter("reservation_code");
		
		Map<String,String> map = service.getMemberIdAndNameToTblReservationCode(reservation_code);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("userid", map.get("userid"));
		jsonObj.put("user_name", map.get("user_name"));
		jsonObj.put("lodging_name", map.get("lodging_name"));
		return jsonObj.toString();
	}
	
	
	@GetMapping("/mypage_member_chatting.trip")
	public ModelAndView mypage_member_chatting(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int newChattingCnt = 0;
		int allChattingCnt = 0;
		int get_from_admin_chatting_exist = 0;
		if(loginuser != null){
			// 로그인한 유저가 기업유저라면
			newChattingCnt = service.get_new_chatting(loginuser.getUserid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			if(newChattingCnt == 0) {
				newChattingCnt = service.get_from_admin_chatting_exist(loginuser.getUserid());// 관리자 채팅이 있는지 없는지도 확인해본다.
			}
			allChattingCnt = service.get_all_chatting(loginuser.getUserid());// 로그인을 했을 때 모든 채팅의 개수를 읽어온다.
			get_from_admin_chatting_exist = service.get_from_admin_chatting_exist(loginuser.getUserid());// 새로 온 관리자 메세지가 있는지 확인한다.
			mav.addObject("newChattingCnt",newChattingCnt);
			mav.addObject("allChattingCnt",allChattingCnt);
			mav.addObject("get_from_admin_chatting_exist",get_from_admin_chatting_exist);
		}
		
		mav.setViewName("mypage/member/mypage_member_chatting.tiles1");
		return mav;
	}
	
	// 페이징 처리한 업체의 채팅 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/memberAllChattingListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String memberAllChattingListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("userid", request.getParameter("userid"));
		paraMap.put("status", request.getParameter("status"));
		// 회원으로 온 모든 채팅 목록을 읽어온다.
		List<Map<String,String>> chattingList = service.select_member_all_chatting_paging(paraMap);
		int totalCount = service.getTotalMemberChattingCount(paraMap); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(chattingList != null) {
			for(Map<String,String> reservationMap : chattingList) {
				JSONObject jsonObj = new JSONObject(); 
				
				jsonObj.put("fk_reservation_code", reservationMap.get("fk_reservation_code"));
				jsonObj.put("lodging_name", reservationMap.get("lodging_name"));
				jsonObj.put("room_name", reservationMap.get("room_name"));
				jsonObj.put("user_name", reservationMap.get("user_name"));
				jsonObj.put("chatting_date", reservationMap.get("chatting_date"));
				jsonObj.put("status", reservationMap.get("status"));
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); 
	}
	
	@GetMapping("/mypage_admin_chatting.trip")
	public ModelAndView mypage_admin_chatting(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int newChattingCnt = 0;
		int allChattingCnt = 0;
		if(loginuser != null && loginuser.getUserid().equals("admin")){
			// 로그인한 유저가 관리자라면
			newChattingCnt = service.get_new_chatting_admin(loginuser.getUserid());// 로그인을 하고 메인에 들어갔을 때 새로 온 채팅이 있는지 확인해준다.
			allChattingCnt = service.get_all_chatting_admin(loginuser.getUserid());// 로그인을 했을 때 모든 채팅의 개수를 읽어온다.
			mav.addObject("newChattingCnt",newChattingCnt);
			mav.addObject("allChattingCnt",allChattingCnt);
		}
		
		mav.setViewName("mypage/admin/mypage_admin_chatting.tiles1");
		return mav;
	}
	
	
	// 페이징 처리한 업체의 채팅 리스트 가져오기
	@ResponseBody
	@PostMapping(value="/adminAllChattingListJSON.trip", produces="text/plain;charset=UTF-8") 
	public String adminAllChattingListJSON(HttpServletRequest request) {

		String currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
		int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("userid", request.getParameter("userid"));
		paraMap.put("status", request.getParameter("status"));
		// 관리자로 온 모든 채팅 목록을 읽어온다.
		List<Map<String,String>> chattingList = service.select_admin_all_chatting_paging(paraMap);
		int totalCount = service.getTotalAdminChattingCount(paraMap); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		JSONArray jsonArr = new JSONArray(); // [] 
		if(chattingList != null) {
			for(Map<String,String> reservationMap : chattingList) {
				JSONObject jsonObj = new JSONObject(); 
				jsonObj.put("from_id", reservationMap.get("from_id"));
				jsonObj.put("user_name", reservationMap.get("user_name"));
				jsonObj.put("chatting_date", reservationMap.get("chatting_date"));
				jsonObj.put("status", reservationMap.get("status"));
				
				jsonObj.put("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
				
				jsonArr.put(jsonObj);
			}// end of for-----------------------
		}
		
		
		return jsonArr.toString(); 
	}
	
	// 유저 아이디로 이름 가져오기
	@ResponseBody
	@PostMapping(value="/getMemberNameToFrom_IdJSON.trip", produces="text/plain;charset=UTF-8") 
	public String getMemberNameToFrom_IdJSON(HttpServletRequest request) {
		String userid = request.getParameter("from_id");
		
		String user_name = service.getUserName(userid);
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("user_name", user_name);
		
		return jsonObj.toString(); 
	}
	
	// 유저 아이디로 이름 가져오기
	@ResponseBody
	@PostMapping(value="/SendImageToChatting.trip", produces="text/plain;charset=UTF-8") 
	public String SendImageToChatting(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		ServletContext svlCtx = session.getServletContext();
        String uploadFileDir = svlCtx.getRealPath("/images/chattingImg");
        
     // == 파일을 업로드 해준다 == // 
        String pimage1 = null;
        String pimage2 = null;
        String prdmanual_systemFileName = null;
        String prdmanual_originFileName = null;
        
        String attachCount = request.getParameter("attachCount");
        // attachCount 가 추가이미지 파일의 개수이다. null "1" ~ "10"
        int n_attachCount = 0;
        if(attachCount!=null) {
        	n_attachCount = Integer.parseInt(attachCount);
        }
        String[] arr_attachFileName = new String[n_attachCount]; // 추가이미지 파일명들을 저장시키는 용도
        int idx_attach = 0;
        Collection<Part> parts = request.getParts();
        // getParts()를 사용하여 form 태그로 부터 넘어온 데이터들을 각각의 Part로 하나하나씩 받는다.
        
        /*
            Part
           -----------------------------------------------------------------------------------------------------------------
            메소드                                                설명
           -----------------------------------------------------------------------------------------------------------------
            public InputStream getInputStream()         Part에 대한 InputStream을 리턴한다. 직접 데이터를 꺼내어 올때 사용한다. 
            throws IOException;

            public String getContentType()              Content-Type을 리턴해준다.
                                                        예를들어, 파일의 image/jpeg 또는 application/pdf 와 같은것을 말한다.

            public String getName()                     파라미터명을 리턴해준다.

            public String getSubmittedFileName()        업로드한 파일명을 리턴해준다. servlet 3.1(톰캣버전 8.5 이후)부터 사용 가능하다.

            public long getSize();                      파일의 크기를 byte단위로 리턴해준다.
            
            public void write(String fileName)          임시저장되어 있는 파일 데이터를 복사하여 fileName 에 지정한 경로로 저장해준다.  
            throws IOException                          임시저장 되어있는 파일데이터가 메모리상에 있든 디스크에 있든 신경쓰지 않아도 된다.
            
            public void delete()                        임시저장된 파일 데이터를 제거해준다.  
            throws IOException                          HTTP요청이 처리되고 나면 자동으로 제거되지만 그 전에 메모리나 디스크 자원을 아끼고 싶다면 수동으로 제거할 수 있다. 
            
            public String getHeader(String name)        Part로부터 지정한 name헤더값을 리턴해준다.    
           ------------------------------------------------------------------------------------------------------------------

        */
        
        for(Part part:parts) {
        	System.out.printf(">> 확인용   파라미터(name)명 : %s, contentType : %s, size : %d bytes \n"
                                           , part.getName(), part.getContentType(), part.getSize());
       
        /*
			>> 확인용   파라미터(name)명 : fk_cnum, contentType : null, size : 1 bytes 
			>> 확인용   파라미터(name)명 : pname, contentType : null, size : 12 bytes 
			>> 확인용   파라미터(name)명 : pcompany, contentType : null, size : 12 bytes 
			>> 확인용   파라미터(name)명 : pimage1, contentType : image/png, size : 232401 bytes 
			>> 확인용   파라미터(name)명 : pimage2, contentType : image/png, size : 19171 bytes 
			>> 확인용   파라미터(name)명 : prdmanualFile, contentType : application/octet-stream, size : 0 bytes 
			>> 확인용   파라미터(name)명 : pqty, contentType : null, size : 1 bytes 
			>> 확인용   파라미터(name)명 : price, contentType : null, size : 3 bytes 
			>> 확인용   파라미터(name)명 : saleprice, contentType : null, size : 3 bytes 
			>> 확인용   파라미터(name)명 : fk_snum, contentType : null, size : 1 bytes 
			>> 확인용   파라미터(name)명 : pcontent, contentType : null, size : 3 bytes 
			>> 확인용   파라미터(name)명 : point, contentType : null, size : 3 bytes 
			>> 확인용   파라미터(name)명 : attachCount, contentType : null, size : 1 bytes 
			>> 확인용   파라미터(name)명 : attach0, contentType : image/jpeg, size : 57641 bytes 
			>> 확인용   파라미터(name)명 : attach1, contentType : image/jpeg, size : 41931 bytes 
			>> 확인용   파라미터(name)명 : attach2, contentType : image/jpeg, size : 48901 bytes 
			>> 확인용   파라미터(name)명 : attach3, contentType : image/jpeg, size : 58889 bytes 
         */
        
            if(part.getHeader("Content-Disposition").contains("filename=")) { // form 태그에서 전송되어온 것이 파일일 경우
            	// Content-Disposition 이란?
				// 일반적인 HTTP 응답에서 Content-Disposition 헤더는 컨텐츠가 브라우저로 보여지는 웹페이지 자체이거나,
				// 아니면 컨텐츠가 attachment 로써 다운로드 되어질 용도로 쓰이는 것인지를 알려주는 헤더이다.
				// 첨부파일은 Header 부분에 Content-Disposition 설정을 아래와 같이 설정해준다.
				// Content-Disposition: attachment; filename="filename.jpg"
				
				// 그래서, 업로드한 파일명을 구하려면 Content-Disposition 헤더의 값을 사용한다.
            	
            	String fileName = extractFileName(part.getHeader("Content-Disposition"));
            	
            	if(part.getSize()>0) {
            		// System.out.println("~~~ 확인용  업로드한 파일명 :  " + fileName);
            		/*
						~~~ 확인용  업로드한 파일명 :  berkelekle심플라운드01.jpg
						~~~ 확인용  업로드한 파일명 :  berkelekle심플V넥02.jpg
						~~~ 확인용  업로드한 파일명 :  Electrolux냉장고_사용설명서.pdf
						~~~ 확인용  업로드한 파일명 :  berkelekle단가라포인트03.jpg
						~~~ 확인용  업로드한 파일명 :  berkelekle덩크04.jpg
						~~~ 확인용  업로드한 파일명 :  berkelekle트랜디05.jpg
						~~~ 확인용  업로드한 파일명 :  berkelekle디스트리뷰트06.jpg
            		 */
            		
            		// 서버에 저장할 새로운 파일명을 만든다.
                    // 서버에 저장할 새로운 파일명이 동일한 파일명이 되지 않고 고유한 파일명이 되도록 하기 위해
                    // 현재의 년월일시분초에다가 현재 나노세컨즈nanoseconds 값을 결합하여 확장자를 붙여서 만든다.
            		String newFilename = fileName.substring(0, fileName.lastIndexOf(".")); // 확장자를 뺀 파일명 알아오기
            		
            		newFilename += "_"+String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance());
            		newFilename += System.nanoTime();
            		newFilename += fileName.substring(fileName.lastIndexOf(".")); // 확장자 붙이기
            		// System.out.println("확인용 newFilename : " + newFilename);
            		/*
						확인용 newFilename : berkelekle심플라운드01_202405211027545306612935300.jpg
						확인용 newFilename : berkelekle심플V넥02_202405211027545306614329000.jpg
						확인용 newFilename : LG_싸이킹청소기_사용설명서_202405211027545306614479900.pdf
						확인용 newFilename : berkelekle단가라포인트03_202405211027545306614628900.jpg
						확인용 newFilename : berkelekle덩크04_202405211027545306614860300.jpg
						확인용 newFilename : berkelekle트랜디05_202405211027545306615014300.jpg
						확인용 newFilename : berkelekle디스트리뷰트06_202405211027545306615155100.jpg
            		 */
            		
            		// >>> 파일을 지정된 디스크 경로에 저장해준다. 이것이 바로 파일을 업로드 해주는 작업이다. <<<
                    
            		// System.out.println(uploadFileDir + File.separator + newFilename);
            		/*
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\berkelekle심플라운드01_202405211033435655490746600.jpg
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\berkelekle심플V넥02_202405211033435655491084600.jpg
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\LG_싸이킹청소기_사용설명서_202405211033435655491198300.pdf
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\berkelekle단가라포인트03_202405211033435655491309200.jpg
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\berkelekle덩크04_202405211033435655491409200.jpg
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\berkelekle트랜디05_202405211033435655491509300.jpg
						C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images\berkelekle디스트리뷰트06_202405211033435655491608700.jpg
            		 */
            		
            		
            		part.write(uploadFileDir + File.separator + newFilename);
            		
            		// >>> 임시저장된 파일 데이터를 제거해준다. <<<
            		// @MultipartConfig(location="C:\\NCS\\workspace_jsp\\MyMVC\\images_temp_upload",
            		// fileSizeThreshold = 1024) 와 같이 설정되었다면 C:\\NCS\\workspace_jsp\\MyMVC\\images_temp_upload 폴더에 임시 저장된 파일을 제거해야한다.
            		
            		part.delete();
            		
            		if("pimage1".equals(part.getName())) {
                        pimage1 = newFilename;
                    }
                    
                    else if("pimage2".equals(part.getName())) {
                    	pimage2 = newFilename;
                    }
                    
                    else if("prdmanualFile".equals(part.getName())) {
                    	prdmanual_systemFileName = newFilename;
                    	prdmanual_originFileName = fileName;
                    }
                    
                    else if(part.getName().startsWith("attach") ) {
                    	arr_attachFileName[idx_attach++] = newFilename;
                    }
            	}// end of if(part.getSize()>0) {
            }// end of if(part.getHeader("Content-Disposition").contains("filename=")) { // form 태그에서 전송되어온 것이 파일일 경우
            
        }// end of for(Part part:parts) {
        
		return "";
	}
	
}
