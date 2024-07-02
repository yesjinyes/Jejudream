package com.spring.app.trip.domain;

// == 즐길거리 VO == //
public class PlayVO {

	private String play_code;			// 즐길거리일련번호
	private String local_status;		// 지역코드
	private String play_category;		// 즐길거리카테고리
	private String play_name;			// 즐길거리 명칭
	private String play_content;		// 즐길거리 짧은상세정보
	private String play_mobile;			// 즐길거리 연락처
	private String play_businesshours;	// 즐길거리 운영시간
	private String play_address;		// 상세주소
	private String play_main_img;		// 대표이미지
	private String review_division;		// 리뷰용구분컬럼(default) C
	
//	-----------------------------------------------------------------------
	/*
	private Play_categoryVO playctgvo; 
	
	public Play_categoryVO getPlayctgvo() {
		return playctgvo;
	}
	public void setPlayctgvo(Play_categoryVO playctgvo) {
		this.playctgvo = playctgvo;
	}
	*/
	
//	-----------------------------------------------------------------------
	
	//////////////////////////////////////////////////////////////////
	// == Getter, Setter == //
	
	public String getPlay_code() {
		return play_code;
	}
	
	public void setPlay_code(String play_code) {
		this.play_code = play_code;
	}
	
	
	public String getPlay_category() {
		return play_category;
	}
	
	public void setPlay_category(String play_category) {
		this.play_category = play_category;
	}
	
	public String getPlay_name() {
		return play_name;
	}
	
	public void setPlay_name(String play_name) {
		this.play_name = play_name;
	}
	
	public String getPlay_content() {
		return play_content;
	}
	
	public void setPlay_content(String play_content) {
		this.play_content = play_content;
	}
	
	public String getPlay_mobile() {
		return play_mobile;
	}
	
	public void setPlay_mobile(String play_mobile) {
		this.play_mobile = play_mobile;
	}
	
	public String getPlay_businesshours() {
		return play_businesshours;
	}
	
	public void setPlay_businesshours(String play_businesshours) {
		this.play_businesshours = play_businesshours;
	}

	public String getPlay_address() {
		return play_address;
	}
	
	public void setPlay_address(String play_address) {
		this.play_address = play_address;
	}
	
	public String getPlay_main_img() {
		return play_main_img;
	}
	
	public void setPlay_main_img(String play_main_img) {
		this.play_main_img = play_main_img;
	}
	
	public String getReview_division() {
		return review_division;
	}
	
	public void setReview_division(String review_division) {
		this.review_division = review_division;
	}

	public String getLocal_status() {
		return local_status;
	}

	public void setLocal_status(String local_status) {
		this.local_status = local_status;
	}
	
	
}