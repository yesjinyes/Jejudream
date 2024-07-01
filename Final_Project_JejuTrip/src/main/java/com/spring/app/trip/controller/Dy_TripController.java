package com.spring.app.trip.controller;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonObject;
import com.spring.app.trip.common.AES256;
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
	
	// 비밀번호 찾기 후 변경 페이지 요청 (임시!!)
	@GetMapping("login/pwFindEnd.trip")
	public String pwFindEnd() {
		
		return "login/pwFindEnd.tiles1";
		// /WEB-INF/views/tiles1/login/pwFindEnd.jsp
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
}
