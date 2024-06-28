package com.spring.app.trip.domain;

public class PlayVO {
	
	
	private String play_code; /* 즐길거리일련번호 */
	private String fk_play_category_code; /* 즐길거리카테고리일련번호 */
	private String fk_local_code; /* 지역코드 */
	private String play_name; /* 즐길거리 명칭 */
	private String play_content; /* 즐길거리 짧은상세정보 */
	private String play_mobile; /* 즐길거리 연락처 */
	private String play_businesshours; /* 즐길거리 운영시간 */
	private String play_address; /* 상세주소 */
	private String play_main_img; /* 대표이미지 */
	private String review_division; /* 리뷰용구분컬럼(default) C */
	
//	-----------------------------------------------------------------------
	
	private Play_categoryVO playctgvo; 
	
	public Play_categoryVO getPlayctgvo() {
		return playctgvo;
	}
	public void setPlayctgvo(Play_categoryVO playctgvo) {
		this.playctgvo = playctgvo;
	}
	
//	-----------------------------------------------------------------------
	
	
	public String getPlay_code() {
		return play_code;
	}
	public void setPlay_code(String play_code) {
		this.play_code = play_code;
	}
	public String getFk_play_category_code() {
		return fk_play_category_code;
	}
	public void setFk_play_category_code(String fk_play_category_code) {
		this.fk_play_category_code = fk_play_category_code;
	}
	public String getFk_local_code() {
		return fk_local_code;
	}
	public void setFk_local_code(String fk_local_code) {
		this.fk_local_code = fk_local_code;
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
	
	
	
}
