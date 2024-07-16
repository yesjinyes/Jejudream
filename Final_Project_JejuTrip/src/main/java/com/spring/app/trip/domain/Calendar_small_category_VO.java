package com.spring.app.trip.domain;

public class Calendar_small_category_VO {
	private String smcatgono;     // 캘린더 소분류 번호
	private String fk_lgcatgono;  // 캘린더 대분류 번호
	private String smcatgoname;   // 캘린더 소분류 명
	
	/*
	 	smcatgono 	fk_lgcatgono	smcatgoname
	  		1			1				숙소
	  		2			1				맛집
	  		3			1				즐길거리
	  		4			2				숙소
	  		5			2				맛집
	  		6			2				즐길거리
	 */
	
	public String getSmcatgono() {
		return smcatgono;
	}
	
	public void setSmcatgono(String smcatgono) {
		this.smcatgono = smcatgono;
	}
	
	
	
	public String getFk_lgcatgono() {
		return fk_lgcatgono;
	}
	
	public void setFk_lgcatgono(String fk_lgcatgono) {
		this.fk_lgcatgono = fk_lgcatgono;
	}
	
	public String getSmcatgoname() {
		return smcatgoname;
	}
	
	public void setSmcatgoname(String smcatgoname) {
		this.smcatgoname = smcatgoname;
	}
	
	
	
}
