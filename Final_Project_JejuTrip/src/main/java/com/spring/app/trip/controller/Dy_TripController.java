package com.spring.app.trip.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

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
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.FoodstoreVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.service.Dy_TripService;

@Controller
public class Dy_TripController {
	
	@Autowired
	private Dy_TripService service;

	@Autowired
	private FileManager fileManager;
	
    @Autowired
    private AES256 aES256;
	
	// 회원가입 페이지 요청
	@GetMapping("memberRegister.trip")
	public String memberRegister() {
		
		return "member/memberRegister.tiles1";
		// /WEB-INF/views/tiles1/member/memberRegister.jsp
	}
	
	
	// 일반 회원가입 처리하기
	@ResponseBody
	@PostMapping("memberRegisterEnd.trip")
	public String memberRegisterEnd(MemberVO mvo) {
		
		int n = service.memberRegister(mvo);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// 일반회원 아이디 중복확인
	@ResponseBody
	@PostMapping("useridDuplicateCheck.trip")
	public String useridDuplicateCheck(HttpServletRequest request) {
		
		String userid = request.getParameter("userid");
		
		boolean isExist = service.useridDuplicateCheck(userid);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExist", isExist);
		
		return jsonObj.toString();
	}
	
	
	// 일반회원 이메일 중복확인
	@ResponseBody
	@PostMapping("userEmailDuplicateCheck.trip")
	public String userEmailDuplicateCheck(HttpServletRequest request) {

		String email = request.getParameter("email");
		
		boolean isExist = service.userEmailDuplicateCheck(email);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExist", isExist);
		
		return jsonObj.toString();
	}
	
	
	// 로그인 페이지 요청
	@GetMapping("login.trip")
	public String login() {
		
		return "login/login.tiles1";
		// /WEB-INF/views/tiles1/login/login.jsp
	}
	
	
	// 로그인 처리하기
	@PostMapping("/loginEnd.trip")
	public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request) {

		String memberType = request.getParameter("memberType");
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		
		// === 클라이언트의 IP 주소를 알아오는 것 === //
		String clientip = request.getRemoteAddr();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("id", id);
		paraMap.put("pw", Sha256.encrypt(pw));
		paraMap.put("clientip", clientip);
		
		if("company".equals(memberType)) {
			mav = service.companyLoginEnd(paraMap, mav, request);
			
		} else {
			mav = service.loginEnd(paraMap, mav, request);
		}
		
		return mav;
	}
	
	
	// 아이디 찾기 페이지 요청
	@GetMapping("login/idFind.trip")
	public String idFind() {
		
		return "login/idFind.tiles1";
		// /WEB-INF/views/tiles1/login/idFind.jsp
	}
	
	
	// 아이디 찾기 처리하기
	@ResponseBody
	@PostMapping("/login/idFindEnd.trip")
	public String idFindEnd(HttpServletRequest request) {
		
		String memberType = request.getParameter("memberType");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		
		Map<String, String> findInfo = new HashMap<>();

		try {
			email = aES256.encrypt(email);

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("name", name);
			paraMap.put("email", email);
			
			
			if("company".equals(memberType)) {
				findInfo = service.companyIdFind(paraMap);
				
			} else {
				findInfo = service.memberIdFind(paraMap);
			}
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("findInfo", findInfo);
		
		return jsonObj.toString();
	}
	
	
	// 비밀번호 찾기 페이지 요청
	@GetMapping("login/pwFind.trip")
	public String pwFind() {
		
		return "login/pwFind.tiles1";
		// /WEB-INF/views/tiles1/login/pwFind.jsp
	}
	
	
	// 비밀번호 찾기 처리
	@ResponseBody
	@PostMapping(value="login/pwFindJSON.trip", produces="text/plain;charset=UTF-8")
	public String pwFindJSON(HttpServletRequest request) {
		
		String memberType = request.getParameter("memberType");
		String id = request.getParameter("id");
		String email = request.getParameter("email");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("memberType", memberType);
		paraMap.put("id", id);
		paraMap.put("email", email);
		
		// 사용자가 존재하는지 확인하기
		boolean isUserExist = service.isUserExist(paraMap);
		
		boolean sendMailSuccess = false; // 메일이 정상적으로 전송되었는지 유무를 알아오기 위한 용도
		
		if(isUserExist) { // 회원이 존재하는 경우

			// 인증키를 랜덤하게 생성하도록 한다.
			Random rnd = new Random();

			String certification_code = "";
			// 인증키는 영문 대문자 5글자로 생성

			char randchar = ' ';
			for (int i = 0; i < 5; i++) {
			/*
				min 부터 max 사이의 값으로 랜덤한 정수를 얻으려면
				int rndnum = rnd.nextInt(max - min + 1) + min;
				영문 대문자 'A' 부터 'Z' 까지 랜덤하게 1개를 만든다.
			*/
				randchar = (char) (rnd.nextInt('Z' - 'A' + 1) + 'A');
				certification_code += randchar;
				
			} // end of for ---------------------

			// 랜덤하게 생성한 인증코드(certification_code)를 비밀번호 찾기를 하고자 하는 사용자의 email 로 전송시킨다.
			GoogleMail mail = new GoogleMail();
			
			try {
				mail.send_certification_code(email, certification_code);
				sendMailSuccess = true;
				
				// 세션 불러오기
				HttpSession session = request.getSession();
				session.setAttribute("certification_code", certification_code);
				
			} catch (Exception e) {
				// 메일 전송이 실패한 경우
				e.printStackTrace();
			}
			
		} // end of if(isUserExist) ---------------
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isUserExist", isUserExist);
		jsonObj.put("sendMailSuccess", sendMailSuccess);
		jsonObj.put("id", id);
		jsonObj.put("email", email);
		
		return jsonObj.toString();
	}
	
	
	// 비밀번호 찾기 - 이메일 인증
	@PostMapping("login/verifyCertification.trip")
	public ModelAndView verifyCertification(ModelAndView mav, HttpServletRequest request) {
		
		String userCertificationCode = request.getParameter("userCertificationCode");
		String memberType = request.getParameter("memberType");
		String id = request.getParameter("id");
		
		HttpSession session = request.getSession();
		String certification_code = (String)session.getAttribute("certification_code");
		
		String message = "";
		String loc = "";
		
		if(certification_code.equals(userCertificationCode)) {
			message = "인증이 완료되었습니다.\\n비밀번호 변경 페이지로 이동합니다.";
			loc = request.getContextPath() + "/login/pwFindEnd.trip?memberType=" + memberType + "&id=" + id;
			
		} else {
			message = "발급된 인증코드와 일치하지 않습니다.\\n인증 코드를 다시 발급받으세요!";
			loc = request.getContextPath() + "/login/pwFind.trip";
		}
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		session.removeAttribute("certification_code");
		
		return mav;
	}
	
	
	// 비밀번호 찾기 - 비밀번호 변경
	@RequestMapping("login/pwFindEnd.trip")
	public ModelAndView pwFindEnd(ModelAndView mav, HttpServletRequest request) {
		
		String referer = request.getHeader("referer"); 
		// request.getHeader("referer"); 은 이전 페이지의 URL을 가져오는 것이다.
		
		if(referer == null) {
			// referer == null 은 웹브라우저 주소창에 URL 을 직접 입력하고 들어온 경우이다.
			mav.setViewName(request.getContextPath() + "/index.trip");
			return mav;
		}
		
		String memberType = request.getParameter("memberType");
		String id = request.getParameter("id");
		
		String method = request.getMethod();
		
		if("POST".equalsIgnoreCase(method)) {
			// "변경하기" 버튼을 클릭했을 경우
			
			String new_pw = request.getParameter("pw");
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("memberType", memberType);
			paraMap.put("id", id);
			paraMap.put("new_pw", Sha256.encrypt(new_pw));
			
			int n = service.pwUpdate(paraMap);
			
			if(n == 1) {
				String message = "비밀번호가 변경되었습니다.";
				String loc = request.getContextPath() + "/index.trip";
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
			}
			
		} else {
			
			mav.addObject("memberType", memberType);
			mav.addObject("id", id);
			
			mav.setViewName("login/pwFindEnd.tiles1");
			// /WEB-INF/views/tiles1/login/pwFindEnd.jsp			
		}
		
		return mav;
	}
	
	
	// 업체 회원가입 페이지 요청
	@GetMapping("companyRegister.trip")
	public String companyRegister() {
		
		return "company/companyRegister.tiles1";
		// /WEB-INF/views/tiles1/company/companyRegister.jsp
	}
	
	
	// 로그아웃 처리하기
	@GetMapping("logout.trip")
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {

		HttpSession session = request.getSession();
		session.invalidate();
		
		mav.setViewName("redirect:/index.trip");
		
		return mav;
	}
	
	
	// 맛집 등록 페이지 요청
	@GetMapping("admin/foodstoreRegister.trip")
	public ModelAndView requiredLogin_foodstoreRegister(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null && !"admin".equals(loginuser.getUserid())) {
			
			String message = "관리자만 접근 가능합니다.";
			String loc = request.getContextPath() + "/index.trip";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		} else {
			mav.setViewName("admin/foodstoreRegister.tiles1");
		}
		
		return mav;
	}
	
	
	// 맛집 등록 처리하기
	@ResponseBody
	@PostMapping("admin/foodstoreRegisterEnd.trip")
	public String foodstoreRegisterEnd(FoodstoreVO fvo, MultipartHttpServletRequest mrequest) {
		
		String path = "";
		
		
		// =========== !!! 대표이미지 첨부파일 업로드 시작 !!! ============ // 
		MultipartFile attach = fvo.getAttach();
	      
		if( !attach.isEmpty() ) {
			// attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우라면) 
	        
			// 1. 사용자가 보낸 첨부파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다. 
			HttpSession session = mrequest.getSession(); 
			String root = session.getServletContext().getRealPath("/"); 
			System.out.println("~~~ 확인용 webapp 의 절대경로 => " + root); 
			
			path = root + "resources" + File.separator + "images" + File.pathSeparator + "foodimg";     
	        System.out.println(path);
	        System.out.println("~~~ 확인용 path => " + path);
	        
	        
	        // 2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기  
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
	            
	            System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
	            
	            newFileName = fileManager.doFileUpload(bytes, originalFilename, path); 
	            // 첨부되어진 파일을 업로드 하는 것이다.
	            
	            //   System.out.println("~~~ 확인용 newFileName => " + newFileName); 
	            // ~~~ 확인용 newFileName => 20231124113600755016855987700.pdf 
	                     
	            
	            
	            // 3. FoodstoreVO fvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기  
	            fvo.setFileName(newFileName);
	            // WAS(톰캣)에 저장된 파일명(20231124113600755016855987700.pdf)
	            
	            fvo.setOrgFilename(fvo.getFood_name() + "_main.jpg");
	            // 페이지에서 첨부된 파일(LG_싸이킹청소기_사용설명서.pdf)을 보여줄 때 사용.
	            // 또한 사용자가 파일을 다운로드 할 때 사용되어지는 파일명으로 사용.
	            
	            fileSize = attach.getSize();  // 첨부파일의 크기(단위는 byte임) 
	            fvo.setFileSize(String.valueOf(fileSize));
	            
	         } catch (Exception e) {
	            e.printStackTrace();
	         }   
		}
		// =========== !!! 대표이미지 첨부파일 업로드 끝 !!! ============ //
		
		
		
		
		// ★★★★★ ##### 추가이미지 처리해주기 시작 ##### ★★★★★
        String attachCount = mrequest.getParameter("attachCount");
        // attachCount 가 추가이미지 파일의 개수이다.
        
        int n_attachCount = 0;
        
        if(attachCount != null) {
        	n_attachCount = Integer.parseInt(attachCount); // 추가 이미지 파일 개수(int)
        }
        
        String[] arr_attachFileName = new String[n_attachCount]; // 추가이미지 파일명들을 저장시키는 용도
        int idx_attach = 0; // 배열 arr_attachFileName 인덱스
        

        Collection<Part> parts = mrequest.getParts(); // form태그에 있는 input 태그 포함 첨부파일 전부를 받아오는 것
        											  // 태그에 name 값이 없어도 받아올 수 있다.
        
        for(Part part : parts) {
        	
        	if(part.getHeader("Content-Disposition").contains("filename=")) { // form 태그에서 전송되어온 것이 파일일 경우
        		
        		String fileName = extractFileName(part.getHeader("Content-Disposition")); // 파일명 구해오기
        		
        		if(part.getSize() > 0) {
        			
        			// 서버에 저장할 새로운 파일명을 만든다.
                    // 서버에 저장할 새로운 파일명이 동일한 파일명이 되지 않고 고유한 파일명이 되도록 하기 위해
                    // 현재의 년월일시분초에 현재 나노세컨즈nanoseconds 값을 결합하여 확장자를 붙여서 만든다.
        			String newFilename = fileName.substring(0, fileName.lastIndexOf(".")); // 확장자를 뺀 파일명 알아오기
        			
        			newFilename += "_" + String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); // 년월일시분초
        			newFilename += System.nanoTime(); // 나노초
        			newFilename += fileName.substring(fileName.lastIndexOf(".")); // 확장자 붙이기
        			
        			// >>> 파일을 지정된 디스크 경로에 저장해준다. 이것이 바로 파일을 업로드 해주는 작업이다. <<<
                    part.write(path + File.separator + newFilename);
                    
                    // >>> 임시저장된 파일 데이터를 제거해준다. <<<
                    /* 즉,
                    @MultipartConfig(location = "C:\\NCS\\workspace_jsp\\MyMVC\\images_temp_upload",
           				 fileSizeThreshold = 1024) // 이 크기 값(1024 byte)을 넘지 않으면 업로드된 데이터를 메모리상에 가지고 있지만, 이 값을 넘는 경우 위의 location 으로 지정된 경로에 임시파일로 저장된다.  
           										   // 메모리상에 저장된 파일 데이터는 언젠가 제거된다. 하지만 크기가 큰 파일을 메모리상에 올리게 되면 서버에 부하를 줄 수 있으므로 적당한 크기를 지정해주고, 그 크기 이상의 파일은 임시파일로 저장하는 것이 좋다.    
           										   // 만약에 기재하지 않으면 기본값은 0 이다. 0 을 쓰면 무조건 임시디렉토리에 저장된다.
           			와 같이 설정되었다면
           			C:\\NCS\\workspace_jsp\\MyMVC\\images_temp_upload 폴더에 임시저장된 파일을 제거해야 한다.
                    */
                    part.delete();
                    
					if (part.getName().startsWith("attach")) {
						arr_attachFileName[idx_attach++] = newFilename;
					}
					
        		}
        		
        	} // end of if(part.getHeader("Content-Disposition").contains("filename=")) ---------------
        	
        } // end of for(Part part : parts) ---------------------------------
        // ★★★★★ ##### 추가이미지 처리해주기 끝 ##### ★★★★★
        
        
        
        
		// !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!!
		String food_content = fvo.getFood_content();
		food_content = food_content.replaceAll("<", "&lt");
		food_content = food_content.replaceAll(">", "&gt");

        // 입력한 내용에서 엔터는 <br>로 변환하기
		food_content = food_content.replaceAll("\r\n", "<br>");
        
		fvo.setFood_content(food_content);
		
		
		
		// 일련번호 채번 해오기
		String food_store_code = service.getCommonSeq();
		fvo.setFood_store_code(food_store_code);
		
		
		JSONObject jsonObj = new JSONObject();
		
		// === 데이터베이스에 맛집 정보 insert 하기 ===
		int n1 = service.foodstoreRegister(fvo);
		
		if(n1 == 1 && n_attachCount > 0) {
			

        	// int cnt = 0;
			
			/* for문 안에서
        	
			// int attach_insert_result = service.insert_foodstore_addImg(paraMap);
			if(attach_insert_result == 1) {
				cnt++;
			}
			
			*/
			
			// if(cnt == n_attachCount) { // cnt가 추가이미지파일 개수와 같은지 (다 insert가 잘 되었는지)
        	//	jsonObj.put("n", 1);
			//
        	// } else {
			//	jsonObj.put("n", 0);
			// }
			
		} else {
			jsonObj.put("n", 0);
		}
		
		return jsonObj.toString();
	}
	
	// 파일명만 추출하는 메소드
	private String extractFileName(String partHeader) {
		for (String cd : partHeader.split("\\;")) {
			
			if (cd.trim().startsWith("filename")) {
				String fileName = cd.substring(cd.indexOf("=") + 1).trim().replace("\"", "");
				int index = fileName.lastIndexOf(File.separator);
				
				return fileName.substring(index + 1);
			}
		}
		
		return null;
	} // end of private String extractFileName(String partHeader) -------------------
	
	
}
