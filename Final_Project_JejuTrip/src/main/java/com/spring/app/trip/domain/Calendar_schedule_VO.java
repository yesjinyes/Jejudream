package com.spring.app.trip.domain;

public class Calendar_schedule_VO {

	private String scheduleno; 				// 일정관리 번호
	private String startdate; 				// 시작일자
	private String enddate; 				// 종료일자
	private String subject; 				// 제목
	private String color; 					// 색상
	private String place; 					// 장소
	private String joinuser; 				// 공유자
	private String parent_code;				// 부모코드
	private String schedule_divison; 		// A == 숙소, B == 맛집, C==즐길거리
	private String content; 				// 내용
	private String fk_smcatgono; 			// 캘린더 소분류 번호
	private String fk_lgcatgono; 			// 캘린더 대분류 번호
	private String fk_userid; 				// 캘린더 일정 작성자 유저아이디

	public String getScheduleno() {
		return scheduleno;
	}

	public void setScheduleno(String scheduleno) {
		this.scheduleno = scheduleno;
	}

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}

	public String getJoinuser() {
		return joinuser;
	}

	public void setJoinuser(String joinuser) {
		this.joinuser = joinuser;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getFk_smcatgono() {
		return fk_smcatgono;
	}

	public void setFk_smcatgono(String fk_smcatgono) {
		this.fk_smcatgono = fk_smcatgono;
	}

	public String getFk_lgcatgono() {
		return fk_lgcatgono;
	}

	public void setFk_lgcatgono(String fk_lgcatgono) {
		this.fk_lgcatgono = fk_lgcatgono;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getParent_code() {
		return parent_code;
	}

	public void setParent_code(String parent_code) {
		this.parent_code = parent_code;
	}

	public String getSchedule_divison() {
		return schedule_divison;
	}

	public void setSchedule_divison(String schedule_divison) {
		this.schedule_divison = schedule_divison;
	}
	
	
	
	

}
