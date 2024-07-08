package com.spring.app.trip.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
//			System.out.println("~~~ 확인용 webapp 의 절대경로 => " + root); 
			
			path = root + "resources" + File.separator + "images" + File.separator + "foodimg";     
	        System.out.println(path);
//	        System.out.println("~~~ 확인용 path => " + path);
	        // ~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Final_Project_JejuTrip\resources\images\foodimg
	        
	        
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
	            
//	            System.out.println("~~~ 확인용 originalFilename => " + originalFilename);
	            // ~~~ 확인용 originalFilename => 513텐동.jpg
	            
	            newFileName = fileManager.doFileUpload(bytes, originalFilename, path); 
	            // 첨부되어진 파일을 업로드 하는 것이다.
	            
//	            System.out.println("~~~ 확인용 newFileName => " + newFileName);
	            // ~~~ 확인용 newFileName => 20240705173146189696448103000.jpg
	                     
	            
	            
	            // 3. FoodstoreVO fvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기  
	            fvo.setFileName(newFileName);
	            // WAS(톰캣)에 저장된 파일명(20240705173146189696448103000.jpg)
	            
	            fvo.setOrgFilename(originalFilename);
	            // 페이지에서 첨부된 파일(513텐동.jpg)을 보여줄 때 사용.
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
        
        // MultipartHttpServletRequest를 사용하여 추가 이미지 파일 처리
        List<MultipartFile> files = new ArrayList<>();
        
        // files 리스트에 추가 이미지 파일 추가
        for (int i = 0; i < n_attachCount; i++) {
        	
            MultipartFile file = mrequest.getFile("attach" + i);
            if (file != null) {
                files.add(file);
            }
        }
        
        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                try {
                    String originalFilename = file.getOriginalFilename();
//                  System.out.println("~~~ 확인용 originalFilename => " + originalFilename);
                    // ~~~ 확인용 originalFilename => 513텐동_추가1.jpg
                    // ~~~ 확인용 originalFilename => 513텐동_추가2.jpg
                    // ~~~ 확인용 originalFilename => 513텐동_추가3.jpg
                    
                    // 새로운 파일명 생성
                    String newFilename = originalFilename.substring(0, originalFilename.lastIndexOf(".")); // 확장자를 뺀 파일명
                    newFilename += "_" + String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); // 년월일시분초
                    newFilename += System.nanoTime(); // 나노초
                    newFilename += originalFilename.substring(originalFilename.lastIndexOf(".")); // 확장자 붙이기
                    
//                  System.out.println("==== 확인용 실제 업로드 될 newFilename : " + newFilename);
                    // ==== 확인용 실제 업로드 될 newFilename : 513텐동_추가1_20240705173146189696448854500.jpg
                    // ==== 확인용 실제 업로드 될 newFilename : 513텐동_추가2_20240705173146189696453558100.jpg
                    // ==== 확인용 실제 업로드 될 newFilename : 513텐동_추가3_20240705173146189696457130300.jpg
                    
                    // 파일 업로드
                    byte[] bytes = file.getBytes();
                    
                    File uploadFile = new File(path + File.separator + newFilename);
                    try (FileOutputStream fos = new FileOutputStream(uploadFile)) {
                        fos.write(bytes);
                    }
                    
                    arr_attachFileName[idx_attach++] = newFilename;
                    
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
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
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("fk_food_store_code", food_store_code);
			// food_store_code 은 위에서 채번 해 온 일련번호이다.
			
        	int cnt = 0;
			
        	// === 추가이미지파일이 있다면 tbl_food_add_img 테이블에 추가이미지 파일명 insert 하기 === //
        	for(int i=0; i<n_attachCount; i++) {

        		String food_add_img = arr_attachFileName[i];
        		paraMap.put("food_add_img", food_add_img);	

        		// tbl_food_add_img 테이블에 추가이미지 파일명 insert 하기
        		int attach_insert_result = service.insert_food_add_img(paraMap);
        		
        		if(attach_insert_result == 1) {
        			cnt++;
        		}
        		
        	} // end of for -----------------------------------
        	
			if (cnt == n_attachCount) { // cnt가 추가이미지파일 개수와 같은지 (다 insert가 잘 되었는지)
				jsonObj.put("result", 1);

			} else {
				jsonObj.put("result", 0);
			}

		} else {
			jsonObj.put("result", 0);
		}
		
		return jsonObj.toString();
	} // end of public String foodstoreRegisterEnd(...) -----------------------------------
	
	
	// 휴면 해제 페이지 요청
	@GetMapping("login/idleUpdate.trip")
	public String idleUpdate() {
		
		return "login/idleUpdate.tiles1";
		// /WEB-INF/views/tiles1/login/idleUpdate.jsp
	}
	
	
	@ResponseBody
	@PostMapping(value="login/emailCertifyJSON.trip", produces="text/plain;charset=UTF-8")
	public String emailCertifyJSON(HttpServletRequest request) {
		
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
				mail.sendCode_idleUpdate(email, certification_code);
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
	
	
	// 휴면 해제 - 이메일 인증
	@PostMapping("login/emailCertification.trip")
	public ModelAndView emailCertification(ModelAndView mav, HttpServletRequest request) {
		
		String userCertificationCode = request.getParameter("userCertificationCode");
		String memberType = request.getParameter("memberType");
		String id = request.getParameter("id");
		
		HttpSession session = request.getSession();
		String certification_code = (String)session.getAttribute("certification_code");
		
		String message = "";
		String loc = "";
		
		if(certification_code.equals(userCertificationCode)) {
			message = "인증이 완료되었습니다.\\n비밀번호 변경 페이지로 이동합니다.";
			loc = request.getContextPath() + "/login/idleUpdateEnd.trip?memberType=" + memberType + "&id=" + id;
			
		} else {
			message = "발급된 인증코드와 일치하지 않습니다.\\n인증 코드를 다시 발급받으세요!";
			loc = request.getContextPath() + "/login/idleUpdate.trip";
		}
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		session.removeAttribute("certification_code");
		
		return mav;
	}
	
	
	// 휴면 해제 - 비밀번호 변경 페이지 요청
	@GetMapping("login/idleUpdateEnd.trip")
	public ModelAndView idleUpdateEnd(ModelAndView mav, HttpServletRequest request) {
		
		String memberType = request.getParameter("memberType");
		String id = request.getParameter("id");
		
		mav.addObject("memberType", memberType);
		mav.addObject("id", id);
		
		mav.setViewName("login/idleUpdateEnd.tiles1");
		// /WEB-INF/views/tiles1/login/idleUpdateEnd.jsp
		
		return mav;
	}
	
	
	// 휴면 해제 - 비밀번호 변경 처리하기
	@ResponseBody
	@PostMapping(value="login/idleUpdateEndJSON.trip", produces="text/plain;charset=UTF-8")
	public String idleUpdateEndJSON(HttpServletRequest request,
									@RequestParam(defaultValue="") String memberType,
									@RequestParam(defaultValue="") String id,
									@RequestParam(defaultValue="") String new_pw) {

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("memberType", memberType);
		paraMap.put("id", id);
		paraMap.put("new_pw", Sha256.encrypt(new_pw));
		
		// 기존 비밀번호와 값이 일치한지 비교하기
		boolean isSamePw = service.isSamePw(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		
		if(isSamePw) { // 새 비밀번호가 기존 비밀번호와 같다면
			jsonObj.put("isOK", false);
			
		} else {
			// 비밀번호 변경
			int n1 = service.pwUpdate(paraMap);
			
			if(n1 == 1) {
				
				// 기존의 로그인 기록 삭제하기
				int n2 = service.deleteLoginHistory(paraMap);
				
				if(n2 != 0) {
					// 회원의 idle을 0으로 변경하기
					int result = service.idleUpdate(paraMap);
					
					if(result == 1) {
						jsonObj.put("isOK", true);
					}
				}
			}
		}
		
		return jsonObj.toString();
	}
	
}
