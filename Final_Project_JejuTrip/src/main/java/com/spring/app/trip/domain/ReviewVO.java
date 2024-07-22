package com.spring.app.trip.domain;

public class ReviewVO {

	private String review_code; 		// 리뷰일련번호 
	private String fk_userid; 			// 아이디 
	private String parent_code; 		// 부모일련번호
	private String review_content; 		// 리뷰내용
	private String registerday; 		// 리뷰작성일자 
	private String review_division_R; 	// 리뷰구분 A,B,C 
	
	//select 용 
	private String rno;
	
	public String getReview_code() {
		return review_code;
	}
	public void setReview_code(String review_code) {
		this.review_code = review_code;
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
	public String getReview_content() {
		return review_content;
	}
	public void setReview_content(String review_content) {
		this.review_content = review_content;
	}
	public String getRegisterday() {
		return registerday;
	}
	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	public String getReview_division_R() {
		return review_division_R;
	}
	public void setReview_division_R(String review_division_R) {
		this.review_division_R = review_division_R;
	}
	public String getRno() {
		return rno;
	}
	public void setRno(String rno) {
		this.rno = rno;
	}
	
	
}
