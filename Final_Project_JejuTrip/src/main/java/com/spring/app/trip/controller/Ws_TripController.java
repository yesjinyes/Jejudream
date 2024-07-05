package com.spring.app.trip.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.service.Ws_TripService;

@Controller
public class Ws_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Ws_TripService service;
	
	@Autowired
	private FileManager fileManager;
	
	@GetMapping("/index.trip") 
	public ModelAndView readComment(ModelAndView mav) {
		
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
		
		if(loginuser != null && loginuser.getUserid().equals("admin")) {
			// 로그인한 유저가 개인 유저이면서 그 아이디가 관리자 아이디라면
			mav.setViewName("mypage/admin/mypageMain.tiles1");
		}
		else if(loginuser != null && !loginuser.getUserid().equals("admin")) {
			// 로그인한 유저가 개인 유저이면서 그 아이디가 일반 회원의 아이디라면
			mav.setViewName("mypage/member/mypageMain.tiles1");
		}
		else {
			// 로그인한 유저가 기업 유저라면
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
	
}
