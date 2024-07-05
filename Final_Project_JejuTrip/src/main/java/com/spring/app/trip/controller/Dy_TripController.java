package com.spring.app.trip.controller;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.AES256;
import com.spring.app.trip.common.GoogleMail;
import com.spring.app.trip.common.Sha256;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.service.Dy_TripService;

@Controller
public class Dy_TripController {
	
	@Autowired
	private Dy_TripService service;
	
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
	@PostMapping("login/pwFindJSON.trip")
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
	public String foodstoreRegisterEnd() {
		
		
		
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj.toString();
	}
	
}
