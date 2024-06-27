package com.spring.app.trip.domain;

public class FoodStoreVO {
	
	private String food_store_code; 		// 맛집일련번호 
	private String fk_food_category_code; 	// 맛집카테고리 일련번호
	private String fk_local_code; 			// 지역코드 
	private String food_address; 			// 상세주소 
	private String food_main_img; 			// 대표이미지 
	private String review_division; 		// 리뷰용구분컬럼(default) B
	
	
	
	public String getFood_store_code() {
		return food_store_code;
	}
	public void setFood_store_code(String food_store_code) {
		this.food_store_code = food_store_code;
	}
	public String getFk_food_category_code() {
		return fk_food_category_code;
	}
	public void setFk_food_category_code(String fk_food_category_code) {
		this.fk_food_category_code = fk_food_category_code;
	}
	public String getFk_local_code() {
		return fk_local_code;
	}
	public void setFk_local_code(String fk_local_code) {
		this.fk_local_code = fk_local_code;
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
