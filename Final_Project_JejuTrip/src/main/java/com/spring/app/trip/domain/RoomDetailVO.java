package com.spring.app.trip.domain;

// == 객실상세 VO == //
public class RoomDetailVO {

	
	private String room_detail_code;	// 숙소객실일련번호
	private String fk_lodging_code;		// 숙소일련번호
	private String room_name;			// 객실이름
	private String price;				// 객실가격
	private String check_in;			// 체크인시간
	private String check_out;			// 체크아웃시간
	private int room_stock;				// 객실수량
	private int min_person;				// 기존인원
	private int max_person;				// 최대인원
	
	
    //////////////////////////////////////////////////////////////////
    // == Getter, Setter == //
	
	public String getRoom_detail_code() {
		return room_detail_code;
	}
	public void setRoom_detail_code(String room_detail_code) {
		this.room_detail_code = room_detail_code;
	}
	public String getFk_lodging_code() {
		return fk_lodging_code;
	}
	public void setFk_lodging_code(String fk_lodging_code) {
		this.fk_lodging_code = fk_lodging_code;
	}
	public String getRoom_name() {
		return room_name;
	}
	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getCheck_in() {
		return check_in;
	}
	public void setCheck_in(String check_in) {
		this.check_in = check_in;
	}
	public String getCheck_out() {
		return check_out;
	}
	public void setCheck_out(String check_out) {
		this.check_out = check_out;
	}
	public int getRoom_stock() {
		return room_stock;
	}
	public void setRoom_stock(int room_stock) {
		this.room_stock = room_stock;
	}
	public int getMin_person() {
		return min_person;
	}
	public void setMin_person(int min_person) {
		this.min_person = min_person;
	}
	public int getMax_person() {
		return max_person;
	}
	public void setMax_person(int max_person) {
		this.max_person = max_person;
	}

	

	
	
	
	
	
	
}
