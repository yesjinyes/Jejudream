package com.spring.app.trip.domain;

// == 맛집 VO == //
public class FoodstoreVO {
	
	private String food_store_code;		// 맛집일련번호
	private String fk_local_code;		// 지역코드
	private String food_category;		// 맛집카테고리
	private String food_name;			// 맛집식당이름
	private String food_content;		// 맛집간단정보
	private String food_businesshours;	// 영업시간
	private String food_mobile;			// 맛집 연락처
	private String food_address;		// 상세주소
	private String food_main_img;		// 대표이미지
	private String review_division;		// 리뷰용구분컬럼(default) B
	
	
	//////////////////////////////////////////////////////////////////
	// == Getter, Setter == //
	
	public String getFood_store_code() {
		return food_store_code;
	}
	
	public void setFood_store_code(String food_store_code) {
		this.food_store_code = food_store_code;
	}
	
	public String getFk_local_code() {
		return fk_local_code;
	}
	
	public void setFk_local_code(String fk_local_code) {
		this.fk_local_code = fk_local_code;
	}
	
	public String getFood_category() {
		return food_category;
	}
	
	public void setFood_category(String food_category) {
		this.food_category = food_category;
	}
	
	public String getFood_name() {
		return food_name;
	}
	
	public void setFood_name(String food_name) {
		this.food_name = food_name;
	}
	
	public String getFood_content() {
		return food_content;
	}
	
	public void setFood_content(String food_content) {
		this.food_content = food_content;
	}
	
	public String getFood_businesshours() {
		return food_businesshours;
	}
	
	public void setFood_businesshours(String food_businesshours) {
		this.food_businesshours = food_businesshours;
	}
	
	public String getFood_mobile() {
		return food_mobile;
	}
	
	public void setFood_mobile(String food_mobile) {
		this.food_mobile = food_mobile;
	}
	
	public String getFood_address() {
		return food_address;
	}
	
	public void setFood_address(String food_address) {
		this.food_address = food_address;
	}
	
	public String getFood_main_img() {
		return food_main_img;
	}
	
	public void setFood_main_img(String food_main_img) {
		this.food_main_img = food_main_img;
	}
	
	public String getReview_division() {
		return review_division;
	}
	
	public void setReview_division(String review_division) {
		this.review_division = review_division;
	}
	
	
	
}
