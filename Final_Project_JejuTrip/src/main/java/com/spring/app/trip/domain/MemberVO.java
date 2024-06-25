package com.spring.app.trip.domain;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MemberVO {
	

	private String userid;			/* 아이디 */
	private String pw;				/* 비밀번호 */
	private String user_name;		/* 성명 */
	private String email;			/* 이메일 */
	private String mobile;			/* 휴대폰번호 */
	private String address;			/* 주소 */
	private String detail_address;	/* 상세주소 */
	private String birthday;		/* 생년월일 */
	private String gender;			/* 성별 */
	private String registerday;		/* 가입일자 */
	private String lastpwdchangedate;/* 마지막암호변경일자 */
	private int status;				/* 회원탈퇴유무 */
	private int idle;				/* 휴면유무 */
	private String userimg;			/* 유저이미지 */
	
	
	// < select 용도 시작>
	private int pwdchangegap; 
	private int lastlogingap;
	private boolean requirePwdChange = false;
	// 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지났으면 true
    // 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지나지 않았으면 false
	
	// < select 용도 끝>
	
	
	

	public int getPwdchangegap() {
		return pwdchangegap;
	}

	public void setPwdchangegap(int pwdchangegap) {
		this.pwdchangegap = pwdchangegap;
	}

	public int getLastlogingap() {
		return lastlogingap;
	}

	public void setLastlogingap(int lastlogingap) {
		this.lastlogingap = lastlogingap;
	}

	public boolean isRequirePwdChange() {
		return requirePwdChange;
	}

	public void setRequirePwdChange(boolean requirePwdChange) {
		this.requirePwdChange = requirePwdChange;
	}
	
	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getDetail_address() {
		return detail_address;
	}

	public void setDetail_address(String detail_address) {
		this.detail_address = detail_address;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getRegisterday() {
		return registerday;
	}

	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}

	public String getLastpwdchangedate() {
		return lastpwdchangedate;
	}

	public void setLastpwdchangedate(String lastpwdchangedate) {
		this.lastpwdchangedate = lastpwdchangedate;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getIdle() {
		return idle;
	}

	public void setIdle(int idle) {
		this.idle = idle;
	}

	public String getUserimg() {
		return userimg;
	}

	public void setUserimg(String userimg) {
		this.userimg = userimg;
	}

	public int getAge() { // 만나이 구하기
		
		int age = 0;
		
		// 회원의 올해생일이 현재날짜 보다 이전이라면 
		// 만나이 = 현재년도 - 회원의 태어난년도 
		
		// 회원의 올해생일이 현재날짜 보다 이후이라면
		// 만나이 = 현재년도 - 회원의 태어난년도 - 1
		
		Date now = new Date(); // 현재시각
		SimpleDateFormat sdfmt = new SimpleDateFormat("yyyyMMdd");
		String str_now = sdfmt.format(now); // "20231018"
		
		// 회원의 올해생일(문자열 타입)
		String str_now_birthday = str_now.substring(0, 4) + birthday.substring(5,7) + birthday.substring(8); 
		//   System.out.println("회원의 올해생일(문자열 타입) : " + str_now_birthday);
		// 회원의 올해생일(문자열 타입) : 20231020
		
		// 회원의 태어난년도
		int birth_year = Integer.parseInt(birthday.substring(0, 4));
		
		// 현재년도
		int now_year = Integer.parseInt(str_now.substring(0, 4)); 
		
		try {
			Date now_birthday = sdfmt.parse(str_now_birthday); // 회원의 올해생일(연월일) 날짜 타입 
			now = sdfmt.parse(str_now); // 오늘날짜(연월일) 날짜타입
			
			if(now_birthday.before(now)) {
				// 회원의 올해생일이 현재날짜 보다 이전이라면
				//   System.out.println("~~~~ 생일 지남");
				age = now_year - birth_year; 
				// 나이 = 현재년도 - 회원의 태어난년도
			}
			else {
				// 회원의 올해생일이 현재날짜 보다 이후이라면
				//   System.out.println("~~~~ 생일 아직 지나지 않음");
				age = now_year - birth_year - 1;
				// 나이 = 현재년도 - 회원의 태어난년도 - 1
			}
		
		} catch (ParseException e) {
		
		}
		
		return age;
		
	}// end of public int getAge() { // 만나이 구하기
	
	

}
