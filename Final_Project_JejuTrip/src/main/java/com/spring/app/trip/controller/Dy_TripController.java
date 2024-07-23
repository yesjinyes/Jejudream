package com.spring.app.trip.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
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

import org.json.JSONArray;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.app.trip.common.MyUtil;
import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.common.GoogleMail;
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.BoardVO;
import com.spring.app.trip.domain.CommentVO;
import com.spring.app.trip.domain.CompanyVO;
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
	@GetMapping("/memberRegister.trip")
	public String memberRegister() {
		
		return "member/memberRegister.tiles1";
		// /WEB-INF/views/tiles1/member/memberRegister.jsp
	}
	
	
	// 일반 회원가입 처리하기
	@ResponseBody
	@PostMapping("/memberRegisterEnd.trip")
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
        } // end of for --------------------------------
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

		} else if(n1 == 1 && n_attachCount == 0) {
			jsonObj.put("result", 1);
			
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
	public String idleUpdateEndJSON(@RequestParam(defaultValue="") String memberType,
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
	
	
	// 비밀번호 변경 3개월 초과 시 띄우는 페이지 요청
	@GetMapping("login/pwUpdate.trip")
	public String pwUpdate() {
		
		return "login/pwUpdate.tiles1";
	}
	
	
	// 비밀번호 변경 3개월 초과 시 비밀번호 변경하기
	@ResponseBody
	@PostMapping(value="login/pwUpdateEndJSON.trip", produces="text/plain;charset=UTF-8")
	public String pwUpdateEndJSON(HttpServletRequest request,
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
			int result = service.pwUpdate(paraMap);
			
			if(result == 1) {
				
				// 다시 로그인하게 하기 위해서 세션 삭제
				HttpSession session = request.getSession();
				session.invalidate();
				
				jsonObj.put("isOK", true);
			}
		}
		
		return jsonObj.toString();
	}
	
	
	// 비밀번호 변경 3개월 초과 시 띄우는 페이지에서 '다음에 변경하기'를 눌렀을 경우
	@PostMapping("login/cancelPwUpdate.trip")
	public ModelAndView cancelPwUpdate(ModelAndView mav, 
									   @RequestParam(defaultValue="") String memberType,
									   @RequestParam(defaultValue="") String id) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("memberType", memberType);
		paraMap.put("id", id);
		
		if(id != "") {
			// 비밀번호 변경 날짜(lastpwdchangedate)를 현재 날짜로 변경하기 (현재로부터 3개월 뒤에 다시 변경 안내를 띄우기 위해)
			int result = service.updatePwdChangeDate(paraMap);
			
			if(result == 1) {
				mav.setViewName("redirect:/index.trip");
			}
		}
		
		return mav;
	}
	
	
	// 커뮤니티 자유게시판 페이지 요청
	@GetMapping("community/freeBoard.trip")
	public ModelAndView freeBoard(ModelAndView mav, HttpServletRequest request) {
		
		List<BoardVO> freeBoardList = null;
		
		// === #69. 글조회수(readCount)증가 (DML문 update)는
		//          반드시 목록보기에 와서 해당 글제목을 클릭했을 경우에만 증가되고,
		//          웹브라우저에서 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다.
		//          이것을 하기 위해서는 session 을 사용하여 처리하면 된다.
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(searchType == null) {
			searchType = "";
		}
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("category", "1");
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		// 총 게시물 건수(totalCount)
		totalCount = service.getBoardTotalCount(paraMap);
		
		totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
		
		if(str_currentShowPageNo == null) {
			// 게시판에 보여지는 초기화면
			
			currentShowPageNo = 1;
			
		} else {
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

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// 커뮤니티 게시판 리스트 조회하기
		freeBoardList = service.getBoardList(paraMap);
		mav.addObject("freeBoardList", freeBoardList);

		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) ||
		   "content".equals(searchType) ||
		   "name".equals(searchType)) {
			
			mav.addObject("paraMap", paraMap);
		}
		
		

		// ==== #129. 페이지바 만들기 ==== //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul>";
		String url = "freeBoard.trip";

		// === [맨처음][이전] 만들기 === //
		if(pageNo != 1) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>◀◀</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>◀</a></li>"; 
		}

		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li class='font-weight-bold' style='width: 3%; color: #ff5000;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='width: 3%;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------

		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>▶</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>▶▶</a></li>"; 
		}
		
		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);
		// ==== #129. 페이지바 만들기 끝 ==== //

		
		// === #131. 페이징 처리된 후 특정 글제목을 클릭하여 상세내용을 본 이후
		//           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
		//           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);
		
		// '페이징 처리 시 보여주는 순번'에 필요한 변수들
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);
		
		mav.setViewName("community/freeBoard.tiles1");
		
		return mav;
	}
	
	
	// 커뮤니티 글 등록 페이지 요청
	@GetMapping("community/addBoard.trip")
	public String requiredLogin_addBoard(HttpServletRequest request, HttpServletResponse response) {
		
		return "community/addBoard.tiles1";
	}
	
	
	// 커뮤니티 글 등록 처리하기
	@PostMapping("community/addBoardEnd.trip")
	public ModelAndView addBoardEnd(ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = boardvo.getAttach();
		
		if(attach != null) {
			
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/"); 
			// WAS의 webapp의 절대경로
			
			String path = root + "resources" + File.separator + "images" + File.separator + "community";
			// 첨부파일을 저장할 폴더 경로
			
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

//				System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
	            // ~~~ 확인용 originalFilename => 제주 서부권 관광지 추천 목록.txt
				
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
				// 첨부된 파일을 업로드하기
				
//				System.out.println("~~~ 확인용 newFileName => " + newFileName);
				// ~~~ 확인용 newFileName => 20240716144933108266728291000.txt
				
				boardvo.setFileName(newFileName);
				// WAS(톰캣)에 저장될 파일명 (20240716144933108266728291000.txt)
				
				boardvo.setOrgFilename(originalFilename);
				// 게시판 페이지에서 첨부된 파일을 보여줄 때 사용.
	            // 또한 사용자가 파일을 다운로드 할 때 사용되는 파일명으로 사용.
				
				fileSize = attach.getSize(); // 첨부파일의 크기 (단위는 byte이다.)
				boardvo.setFileSize(String.valueOf(fileSize));
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		int n = 0;
		
		if(attach.isEmpty()) { // 파일 첨부가 없는 경우
			n = service.addBoard(boardvo); // <== 파일첨부가 없는 글쓰기
			
		} else { // 파일 첨부가 있는 경우
			n = service.addBoard_withFile(boardvo);
		}
		
		if(n == 1) {
			mav.addObject("message", "글 등록이 성공되었습니다.");
			mav.addObject("loc", mrequest.getContextPath() + "/communityMain.trip");
			
		} else {
			mav.addObject("message", "글 등록에 실패하였습니다.\\n메인 페이지로 돌아갑니다.");
			mav.addObject("loc", mrequest.getContextPath() + "/index.trip");
		}
		
		mav.setViewName("msg");
		
		return mav;
	}
	
	
	// === 스마트에디터. 드래그앤드롭을 이용한 다중 사진 파일 업로드  ===
	@PostMapping("image/multiplePhotoUpload.trip")
	public void multiplePhotoUpload(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources" + File.separator + "images" + File.separator + "community";

//		System.out.println("~~~ 확인용 path => " + path);
		// ~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Final_Project_JejuTrip\resources\images\community
	
		File dir = new File(path);
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		try {
			String filename = request.getHeader("file-name"); // 파일명(문자열)을 받는다 - 일반 원본파일명
			// 네이버 스마트에디터를 사용한 파일업로드 시 싱글파일업로드와 다르게 멀티파일업로드는 파일명이 header 속에 담겨져 넘어오게 되어 있다.
			 
//			System.out.println(">>> 확인용 filename ==> " + filename);
			// >>> 확인용 filename ==> %EA%B0%88%EC%B9%98%EC%9D%8C%EC%8B%9D%EC%A0%90%20%EA%B6%81%EC%84%9C%EC%B2%B4.jpg 
	        
			InputStream is = request.getInputStream(); // is는 네이버 스마트 에디터를 사용하여 사진첨부하기 된 이미지 파일

			String newFilename = fileManager.doFileUpload(is, filename, path);

			String ctxPath = request.getContextPath(); // /JejuDream

			String strURL = "";
			strURL += "&bNewLine=true&sFileName=" + newFilename;
			strURL += "&sFileURL=" + ctxPath + "/resources/images/community/" + newFilename;

			// === 웹브라우저 상에 사진 이미지를 쓰기 === //
			PrintWriter out = response.getWriter();
			out.print(strURL);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 게시판 상세 페이지 요청
	@RequestMapping("community/viewBoard.trip")
	public ModelAndView viewBoard(ModelAndView mav, HttpServletRequest request,
								  @RequestParam(defaultValue="") String seq,
								  @RequestParam(defaultValue="") String category,
								  @RequestParam(defaultValue="") String goBackURL,
								  @RequestParam(defaultValue="") String searchType,
								  @RequestParam(defaultValue="") String searchWord) {
		
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		// redirect 되어서 넘어온 데이터가 있는지 꺼내본다.

		if(inputFlashMap != null) { // redirect 되어서 넘어온 데이터가 있다면
			
			@SuppressWarnings("unchecked") // 경고 표시를 하지 말라는 뜻이다.
			Map<String, String> redirect_map = (Map<String, String>) inputFlashMap.get("redirect_map");
			// "redirect_map" 값은  /view_2.action 에서  redirectAttr.addFlashAttribute("키", 밸류값); 을 할 때 준 "키" 이다. 
			// "키" 값을 주어서 redirect 되어서 넘어온 데이터를 꺼내어 온다.
			// "키" 값을 주어서 redirect 되어서 넘어온 데이터의 값은 Map<String, String> 이므로 Map<String, String> 으로 casting 해준다.
			
			seq = redirect_map.get("seq");
			category = redirect_map.get("category");
			
			// === #143. 이전글제목, 다음글제목 보기 시작 ===
			searchType = redirect_map.get("searchType"); // 무조건 영어이므로 URL Decode 필요없음
			
			try {
				searchWord = URLDecoder.decode(redirect_map.get("searchWord"), "UTF-8"); // 한글데이터가 포함되어 있으면 반드시 한글로 복구해 주어야 한다.
				goBackURL = URLDecoder.decode(redirect_map.get("goBackURL"), "UTF-8"); // 한글데이터가 포함되어 있으면 반드시 한글로 복구해 주어야 한다.
				
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			// === #143. 이전글제목, 다음글제목 보기 끝 ===
			
		}

		mav.addObject("goBackURL", goBackURL);
		
		try {
			Integer.parseInt(seq);
		 /* 
		     "이전글제목" 또는 "다음글제목" 을 클릭하여 특정글을 조회한 후 새로고침(F5)을 한 경우는   
		         원본이 /view_2.action 을 통해서 redirect 되어진 경우이므로 form 을 사용한 것이 아니라서   
		     "양식 다시 제출 확인" 이라는 alert 대화상자가 뜨지 않는다. 
		         그래서  request.getParameter("seq"); 은 null 이 된다. 
		         즉, 글번호인 seq 가 null 이 되므로 DB 에서 데이터를 조회할 수 없게 된다.     
		         또한 seq 는 null 이므로 Integer.parseInt(seq); 을 하면  NumberFormatException 이 발생하게 된다. 
		 */

			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			CompanyVO loginCompanyuser = (CompanyVO)session.getAttribute("loginCompanyuser");
			
			String login_id = null;
			
			if(loginuser != null) {
				login_id = loginuser.getUserid();
				
			} else if(loginCompanyuser != null) {
				login_id = loginCompanyuser.getCompanyid();
			}
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);
			paraMap.put("category", category);
			paraMap.put("login_id", login_id);

			// >>> 글목록에서 검색된 글내용일 경우 이전글제목, 다음글제목은 검색된 결과물 내의 이전글과 다음글이 나오도록 하기 위한 것이다. <<< //
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);

			// === #68. !!! 중요 !!! 
	        //     글 1개를 보여주는 페이지 요청은 select 와 함께 
			//     DML문(지금은 글조회수 증가인 update문)이 포함되어 있다.
			//     이럴 경우 웹브라우저에서 페이지 새로고침(F5)을 했을 때 DML문이 실행되어
			//     매번 글 조회수 증가가 발생한다.
			//     따라서 웹브라우저에서 페이지 새로고침(F5)을 했을 때는
			//     단순히 select만 해주고 DML문(지금은 글조회수 증가인 update문)은 
			//     실행하지 않도록 해 주어야 한다. !!! === //

			// 글목록보기 에서 session.setAttribute("readCountPermission", "yes"); 해두었다.
			BoardVO boardvo = null;

			if("yes".equals( (String)session.getAttribute("readCountPermission") )) {
				// 글목록보기인 /freeBoard.trip 페이지를 클릭한 다음에 특정글을 조회해온 경우이다.
				
				boardvo = service.getViewBoard(paraMap);
				// 글 조회수 증가와 함께 글 1개 조회하기

				session.removeAttribute("readCountPermission");
				// 중요!! session 에 저장된 readCountPermission 을 삭제한다. 
				
			} else {
				// 글목록에서 특정 글제목을 클릭하여 본 상태에서
			    // 웹브라우저에서 새로고침(F5)을 클릭한 경우이다.

				boardvo = service.getViewBoard_no_increase_readCount(paraMap);
				// 글 조회수 증가 없이 단순히 글 1개만 조회하기

				if(boardvo == null) {
					mav.setViewName("redirect:/communityMain.trip");
					return mav;
				}
				
			}
			
			mav.addObject("boardvo", boardvo);
			
			// === #140. 이전글제목, 다음글제목 보기 ===
			mav.addObject("paraMap", paraMap);
			
			mav.setViewName("community/viewBoard.tiles1");
			
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/communityMain.trip");
		}
		
		return mav;
	}
	
	
	// 게시판 상세(이전글, 다음글)
	@PostMapping("community/viewBoard_2.trip")
	public ModelAndView viewBoard_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr,
									@RequestParam(defaultValue="") String seq,
									@RequestParam(defaultValue="") String category,
									@RequestParam(defaultValue="") String goBackURL,
									@RequestParam(defaultValue="") String searchType,
									@RequestParam(defaultValue="") String searchWord) {
		
		try {
			searchWord = URLEncoder.encode(searchWord, "UTF-8");
			goBackURL = URLEncoder.encode(goBackURL, "UTF-8");
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		// ==== redirect(GET방식) 시 데이터를 넘길 때 GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 시작 ==== //
		Map<String, String> redirect_map = new HashMap<>();
		redirect_map.put("seq", seq);
		redirect_map.put("category", category);
		
		// === #142. 이전글, 다음글 보기 시작 ===
		redirect_map.put("goBackURL", goBackURL);
		redirect_map.put("searchType", searchType);
		redirect_map.put("searchWord", searchWord);
		// === #142. 이전글, 다음글 보기 끝 ===

		redirectAttr.addFlashAttribute("redirect_map", redirect_map);
		// redirectAttr.addFlashAttribute("키", 밸류값); 으로 사용하는데 오로지 1개의 데이터만 담을 수 있으므로 여러 개의 데이터를 담으려면 Map 을 사용해야 한다.

		mav.setViewName("redirect:/community/viewBoard.trip");
		// ==== redirect(GET방식) 시 데이터를 넘길 때 GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 끝 ==== //
		
		return mav;
	}
	
	
	// 댓글 쓰기
	@ResponseBody
	@PostMapping(value="community/addComment.trip", produces="text/plain;charset=UTF-8")
	public String addComment(CommentVO commentvo) {
		
		int n = 0;
		
		if(commentvo.getFk_seq() == null) { // 원댓글일 경우
			
			commentvo.setFk_seq("");
		}
		
		try {
			n = service.addComment(commentvo);
			// 댓글 쓰기 및 원게시물에 댓글 개수 증가하기
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	

	// 댓글 목록 불러오기
	@ResponseBody
	@GetMapping(value="community/viewComment.trip", produces="text/plain;charset=UTF-8")
	public String viewComment(@RequestParam(defaultValue = "") String parentSeq,
							  @RequestParam(defaultValue = "") String currentShowPageNo) {
		
		if("".equals(currentShowPageNo)) {
			currentShowPageNo = "1";
		}
		
		int sizePerPage = 5;
		
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1;
		int endRno = startRno + sizePerPage - 1;
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("parentSeq", parentSeq);
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		List<CommentVO> commentList = service.getViewComment(paraMap);
		int totalCount = service.getCommentTotalCount(parentSeq); // 페이징 처리 시 보여주는 순번을 나타내기 위함

		JSONArray jsonArr = new JSONArray();
		
		if(commentList != null) {
			
			for(CommentVO cmtvo : commentList) {
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("seq", cmtvo.getSeq());
				jsonObj.put("fk_userid", cmtvo.getFk_userid());
				jsonObj.put("name", cmtvo.getName());
				jsonObj.put("content", cmtvo.getContent());
				jsonObj.put("regdate", cmtvo.getRegDate());
				jsonObj.put("status", cmtvo.getStatus());
				jsonObj.put("groupno", cmtvo.getGroupno());
				jsonObj.put("fk_seq", cmtvo.getFk_seq());
				jsonObj.put("depthno", cmtvo.getDepthno());
				
				jsonObj.put("totalCount", totalCount); // 페이징 처리 시 보여주는 순번을 나타내기 위함
				jsonObj.put("sizePerPage", sizePerPage); // 페이징 처리 시 보여주는 순번을 나타내기 위함
				
				jsonArr.put(jsonObj);
			}
		}
		
		return jsonArr.toString();
	}
	
	
	// 커뮤니티 숙박 페이지 요청
	@GetMapping("community/lodgingBoard.trip")
	public ModelAndView lodgingBoard(ModelAndView mav, HttpServletRequest request) {
		
		List<BoardVO> lodgingBoardList = null;
		
		// === #69. 글조회수(readCount)증가 (DML문 update)는
		//          반드시 목록보기에 와서 해당 글제목을 클릭했을 경우에만 증가되고,
		//          웹브라우저에서 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다.
		//          이것을 하기 위해서는 session 을 사용하여 처리하면 된다.
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(searchType == null) {
			searchType = "";
		}
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("category", "2");
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		// 게시판 총 게시물 건수(totalCount)
		totalCount = service.getBoardTotalCount(paraMap);
		
		totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
		
		if(str_currentShowPageNo == null) {
			// 게시판에 보여지는 초기화면
			
			currentShowPageNo = 1;
			
		} else {
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

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// 커뮤니티 게시판 리스트 조회하기
		lodgingBoardList = service.getBoardList(paraMap);
		mav.addObject("lodgingBoardList", lodgingBoardList);

		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) ||
		   "content".equals(searchType) ||
		   "name".equals(searchType)) {
			
			mav.addObject("paraMap", paraMap);
		}
		
		

		// ==== #129. 페이지바 만들기 ==== //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul>";
		String url = "lodgingBoard.trip";

		// === [맨처음][이전] 만들기 === //
		if(pageNo != 1) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>◀◀</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>◀</a></li>"; 
		}

		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li class='font-weight-bold' style='width: 3%; color: #ff5000;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='width: 3%;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------

		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>▶</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>▶▶</a></li>"; 
		}
		
		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);
		// ==== #129. 페이지바 만들기 끝 ==== //

		
		// === #131. 페이징 처리된 후 특정 글제목을 클릭하여 상세내용을 본 이후
		//           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
		//           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);
		
		// '페이징 처리 시 보여주는 순번'에 필요한 변수들
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);
		
		mav.setViewName("community/lodgingBoard.tiles1");
		
		return mav;
	}
	
	
	// 커뮤니티 관광지,체험 페이지 요청
	@GetMapping("community/playBoard.trip")
	public ModelAndView playBoard(ModelAndView mav, HttpServletRequest request) {
		
		List<BoardVO> playBoardList = null;
		
		// === #69. 글조회수(readCount)증가 (DML문 update)는
		//          반드시 목록보기에 와서 해당 글제목을 클릭했을 경우에만 증가되고,
		//          웹브라우저에서 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다.
		//          이것을 하기 위해서는 session 을 사용하여 처리하면 된다.
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(searchType == null) {
			searchType = "";
		}
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("category", "3");
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		// 게시판 총 게시물 건수(totalCount)
		totalCount = service.getBoardTotalCount(paraMap);
		
		totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
		
		if(str_currentShowPageNo == null) {
			// 게시판에 보여지는 초기화면
			
			currentShowPageNo = 1;
			
		} else {
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
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// 커뮤니티 게시판 리스트 조회하기
		playBoardList = service.getBoardList(paraMap);
		mav.addObject("playBoardList", playBoardList);
		
		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) ||
				"content".equals(searchType) ||
				"name".equals(searchType)) {
			
			mav.addObject("paraMap", paraMap);
		}
		
		
		
		// ==== #129. 페이지바 만들기 ==== //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul>";
		String url = "playBoard.trip";
		
		// === [맨처음][이전] 만들기 === //
		if(pageNo != 1) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>◀◀</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>◀</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li class='font-weight-bold' style='width: 3%; color: #ff5000;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='width: 3%;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>▶</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>▶▶</a></li>"; 
		}
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		// ==== #129. 페이지바 만들기 끝 ==== //
		
		
		// === #131. 페이징 처리된 후 특정 글제목을 클릭하여 상세내용을 본 이후
		//           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
		//           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);
		
		// '페이징 처리 시 보여주는 순번'에 필요한 변수들
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);
		
		mav.setViewName("community/playBoard.tiles1");
		
		return mav;
	}
	
	
	// 커뮤니티 맛집 페이지 요청
	@GetMapping("community/foodBoard.trip")
	public ModelAndView foodBoard(ModelAndView mav, HttpServletRequest request) {
		
		List<BoardVO> foodBoardList = null;
		
		// === #69. 글조회수(readCount)증가 (DML문 update)는
		//          반드시 목록보기에 와서 해당 글제목을 클릭했을 경우에만 증가되고,
		//          웹브라우저에서 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다.
		//          이것을 하기 위해서는 session 을 사용하여 처리하면 된다.
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo"); 
		
		if(searchType == null) {
			searchType = "";
		}
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("category", "4");
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		// 게시판 총 게시물 건수(totalCount)
		totalCount = service.getBoardTotalCount(paraMap);
		
		totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
		
		if(str_currentShowPageNo == null) {
			// 게시판에 보여지는 초기화면
			
			currentShowPageNo = 1;
			
		} else {
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
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// 커뮤니티 게시판 리스트 조회하기
		foodBoardList = service.getBoardList(paraMap);
		mav.addObject("foodBoardList", foodBoardList);
		
		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) ||
				"content".equals(searchType) ||
				"name".equals(searchType)) {
			
			mav.addObject("paraMap", paraMap);
		}
		
		
		
		// ==== #129. 페이지바 만들기 ==== //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul>";
		String url = "foodBoard.trip";
		
		// === [맨처음][이전] 만들기 === //
		if(pageNo != 1) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>◀◀</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>◀</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li class='font-weight-bold' style='width: 3%; color: #ff5000;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='width: 3%;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>▶</a></li>";
			pageBar += "<li style='width: 4%; font-size: 0.8rem;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>▶▶</a></li>"; 
		}
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		// ==== #129. 페이지바 만들기 끝 ==== //
		
		
		// === #131. 페이징 처리된 후 특정 글제목을 클릭하여 상세내용을 본 이후
		//           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
		//           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);
		
		// '페이징 처리 시 보여주는 순번'에 필요한 변수들
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);
		
		mav.setViewName("community/foodBoard.tiles1");
		
		return mav;
	}
	
	
	@GetMapping("fileDownload.trip")
	public void requiredLogin_fileDownload(HttpServletRequest request, HttpServletResponse response,
										   @RequestParam(defaultValue="") String seq,
										   @RequestParam(defaultValue="") String category) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq);
		paraMap.put("category", category);
		paraMap.put("searchType", "");
		paraMap.put("searchWord", "");
		
		// **** 웹브라우저에 출력하기 시작 ****
		response.setContentType("text/html; charset=UTF-8"); // 한글 깨짐 방지
		
		PrintWriter out = null;
		
		try {
			Integer.parseInt(seq);
			
			BoardVO boardvo = service.getViewBoard_no_increase_readCount(paraMap);
			
			if(boardvo == null || (boardvo != null && boardvo.getFileName() == null)) {
				// 시퀀스에 해당하는 글이 없거나, 첨부파일이 없는 글일 경우
				
				out = response.getWriter();
				
				out.println("<script type='text/javascript'>alert('글번호가 존재하지 않거나, 첨부파일이 없는 글이므로 다운로드 할 수 없습니다.'); history.back();</script>");
				return;
				
			} else {
				// 정상적으로 다운로드가 가능한 경우
				
				String fileName = boardvo.getFileName();
				String orgFilename = boardvo.getOrgFilename();

				// 첨부파일이 저장되어 있는 WAS 디스크 경로를 알아야 다운로드 할 수 있다.
				HttpSession session = request.getSession();
				String root = session.getServletContext().getRealPath("/");
				
				String path = root + "resources" + File.separator + "images" + File.separator + "community";
				
				// === 파일 다운로드 하기 ===
				boolean flag = false; // 파일 다운로드 성공 여부를 알려주는 용도
				flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				
				if(!flag) {
					// 다운로드가 실패한 경우
					
					out = response.getWriter();
					out.println("<script type='text/javascript'>alert('파일 다운로드가 실패되었습니다.'); history.back();</script>");
				}
			}
			
		} catch (NumberFormatException | IOException e) {
			
			try {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('파일을 다운로드 할 수 없습니다.'); history.back();</script>");
				
			} catch (IOException e2) {
				e2.printStackTrace();
			}
		}
		
	}
	
	
	// 커뮤니티 글 수정 페이지 요청
	@GetMapping("community/updateBoard.trip")
	public ModelAndView requiredLogin_updateBoard(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav = service.updateBoard(mav, request);
		
		return mav;
	}
	
	
	// 커뮤니티 글 수정하기
	@ResponseBody
	@PostMapping(value="community/updateBoardEnd.trip", produces="text/plain;charset=UTF-8")
	public String updateBoardEnd(BoardVO boardvo, MultipartHttpServletRequest mrequest) {

		MultipartFile attach = boardvo.getAttach();
		
		if(attach != null) {
			
			HttpSession session = mrequest.getSession(); 
			String root = session.getServletContext().getRealPath("/"); 
			
			String path = root + "resources" + File.separator + "images" + File.separator + "community";
			
			
			String newFileName = "";
			// WAS(톰캣)의 디스크에 저장될 파일명
			
			byte[] bytes = null;
			// 첨부파일의 내용물을 담는 것
			
			long fileSize = 0;
			// 첨부파일의 크기

			try {
				String orgFile = mrequest.getParameter("orgFile");
//				System.out.println("~~~ 확인용 원래 첨부파일 : " + orgFile);
				
				if(orgFile != null) {
					// 파일 변경을 위해 기존에 올려뒀던 파일 지우기
					fileManager.doFileDelete(orgFile, path);
				}
				
				
				bytes = attach.getBytes();
				// 추가한 첨부파일의 내용물을 읽어오는 것
				
				String originalFilename = attach.getOriginalFilename();

				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
				// 첨부된 파일을 업로드하기
				
				boardvo.setFileName(newFileName);
				
				boardvo.setOrgFilename(originalFilename);
				
				fileSize = attach.getSize();
				boardvo.setFileSize(String.valueOf(fileSize));
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		int n = 0;
		
		if(attach.isEmpty()) { // 파일 첨부가 없는 경우
			n = service.updateBoardEnd(boardvo); // <== 파일첨부가 없는 글 수정
			
		} else { // 파일 첨부가 있는 경우
			n = service.updateBoard_withFile(boardvo);
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);

		return jsonObj.toString();
	}
	
	
	// 커뮤니티 글 삭제 처리하기
	@ResponseBody
	@PostMapping(value="community/deleteBoard.trip", produces="text/plain;charset=UTF-8")
	public String deleteBoard(@RequestParam(defaultValue = "") String seq,
							  @RequestParam(defaultValue = "") String pw,
							  @RequestParam(defaultValue = "") String login_id) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq);
		paraMap.put("pw", pw);
		paraMap.put("login_id", login_id);
		
		int n = service.deleteBoard(paraMap);

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);

		return jsonObj.toString();
	}
	
	
	// 커뮤니티 댓글 수정
	@ResponseBody
	@PostMapping(value="community/updateComment.trip", produces="text/plain;charset=UTF-8")
	public String requiredLogin_updateComment(HttpServletRequest request, HttpServletResponse response,
											  @RequestParam(defaultValue = "") String seq,
											  @RequestParam(defaultValue = "") String new_content) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		int n = 0;
		
		// 댓글번호에 대한 댓글이 있는지 조회하기
		CommentVO commentvo = service.getCommentInfo(seq);
		
		if(commentvo != null && loginuser.getUserid().equals(commentvo.getFk_userid())) {
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);
			paraMap.put("new_content", new_content);
			
			// 댓글 수정
			n = service.updateComment(paraMap);
			
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// 커뮤니티 댓글 삭제
	@ResponseBody
	@PostMapping(value="community/deleteComment.trip", produces="text/plain;charset=UTF-8")
	public String requiredLogin_deleteComment(HttpServletRequest request, HttpServletResponse response,
											  @RequestParam(defaultValue = "") String seq,
											  @RequestParam(defaultValue = "") String parentSeq) {
		
		int n = 0;
		
		// 댓글번호에 대한 댓글이 있는지 조회하기
		CommentVO commentvo = service.getCommentInfo(seq);
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(commentvo != null && loginuser.getUserid().equals(commentvo.getFk_userid())) {
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);
			paraMap.put("parentSeq", parentSeq);
			
			try {
				n = service.deleteComment(paraMap);
				
			} catch (Throwable e) {
				e.printStackTrace();
			}			
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// 게시판 댓글 개수 알아오기 
	@ResponseBody
	@PostMapping(value="community/getCommentCount.trip", produces="text/plain;charset=UTF-8")
	public String getCommentCount(@RequestParam(defaultValue = "") String seq) {
		
		int commentCount = 0;
		
		try {
			Integer.parseInt(seq);
			commentCount = service.getCommentCount(seq);
			
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("commentCount", commentCount);
		
		return jsonObj.toString();
	}
	
	
	
	
	
}
