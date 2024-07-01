package com.spring.app.trip.domain;

// == 업체 VO == //
public class CompanyVO {

	
    private String companyid;			// 업체아이디
    private String company_name;		// 업체명
    private String pw;					// 비밀번호
    private String email;				// 이메일
    private String mobile;				// 연락처
    private String registerday;			// 가입일자
    private String lastpwdchangedate;	// 마지막암호변경일자
    private int status;					// 회원탈퇴유무
    private int idle;					// 휴면유무
    
    
    // select 용
	private int pwdchangegap; 
	private int lastlogingap;
	private boolean requirePwdChange = false;
    
    //////////////////////////////////////////////////////////////////
    // == Getter, Setter == //
    
	public String getCompanyid() {
		return companyid;
	}
	
	public void setCompanyid(String companyid) {
		this.companyid = companyid;
	}
	
	public String getCompany_name() {
		return company_name;
	}
	
	public void setCompany_name(String company_name) {
		this.company_name = company_name;
	}
	
	public String getPw() {
		return pw;
	}
	
	public void setPw(String pw) {
		this.pw = pw;
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
    
	
	
}
