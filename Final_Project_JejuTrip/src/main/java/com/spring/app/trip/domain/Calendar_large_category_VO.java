package com.spring.app.trip.domain;

public class Calendar_large_category_VO {

	private String lgcatgono;    // 캘린더 대분류 번호
	private String lgcatgoname;  // 캘린더 대분류 명
	/*
	 	1, '나의 일정'
	 	2, '공유받은 일정'
	 */
	public String getLgcatgono() {
		return lgcatgono;
	}
	public void setLgcatgono(String lgcatgono) {
		this.lgcatgono = lgcatgono;
	}
	
	public String getLgcatgoname() {
		return lgcatgoname;
	}
	
	public void setLgcatgoname(String lgcatgoname) {
		this.lgcatgoname = lgcatgoname;
	}
	
}
