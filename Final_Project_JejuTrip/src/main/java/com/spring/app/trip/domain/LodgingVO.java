package com.spring.app.trip.domain;

// == 숙소 VO == //
public class LodgingVO {

	
	private String lodging_code;				// 숙소일련번호
	private String fk_local_code;			  	// 지역코드
	private String fk_lodging_category_code;	// 숙소카테고리일련번호
	private String fk_companyid;				// 업체아이디
	private String lodging_name;				// 숙소이름
	private String lodging_tell;				// 숙소연락처
	private String lodging_content;				// 숙소설명
	private String lodging_address;				// 상세주소
	private String main_img;					// 대표이미지
	private String review_division;				// 리뷰용구분컬럼(default) A
	
	
    //////////////////////////////////////////////////////////////////
    // == Getter, Setter == //
	
	public String getLodging_code() {
		return lodging_code;
	}
	
	public void setLodging_code(String lodging_code) {
		this.lodging_code = lodging_code;
	}
	
	public String getFk_local_code() {
		return fk_local_code;
	}
	
	public void setFk_local_code(String fk_local_code) {
		this.fk_local_code = fk_local_code;
	}
	
	public String getFk_lodging_category_code() {
		return fk_lodging_category_code;
	}
	
	public void setFk_lodging_category_code(String fk_lodging_category_code) {
		this.fk_lodging_category_code = fk_lodging_category_code;
	}
	
	public String getFk_companyid() {
		return fk_companyid;
	}
	
	public void setFk_companyid(String fk_companyid) {
		this.fk_companyid = fk_companyid;
	}
	
	public String getLodging_name() {
		return lodging_name;
	}
	
	public void setLodging_name(String lodging_name) {
		this.lodging_name = lodging_name;
	}
	
	public String getLodging_tell() {
		return lodging_tell;
	}
	
	public void setLodging_tell(String lodging_tell) {
		this.lodging_tell = lodging_tell;
	}
	
	public String getLodging_content() {
		return lodging_content;
	}
	
	public void setLodging_content(String lodging_content) {
		this.lodging_content = lodging_content;
	}
	
	public String getLodging_address() {
		return lodging_address;
	}
	
	public void setLodging_address(String lodging_address) {
		this.lodging_address = lodging_address;
	}
	
	public String getMain_img() {
		return main_img;
	}
	
	public void setMain_img(String main_img) {
		this.main_img = main_img;
	}
	
	public String getReview_division() {
		return review_division;
	}
	
	public void setReview_division(String review_division) {
		this.review_division = review_division;
	}
	
	
}