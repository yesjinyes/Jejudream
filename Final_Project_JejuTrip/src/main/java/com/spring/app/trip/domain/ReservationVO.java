package com.spring.app.trip.domain;



public class ReservationVO { 

	//예약 VO
	
	private String reservation_code; 		// 예약일련번호 
	private String fk_userid; 				// 아이디 
	private String fk_room_detail_code; 	// 숙소객실일련번호 
	private String reservation_date; 		// 예약일자 
	private String check_in; 				// 체크인일자 
	private String check_out; 				// 체크아웃일자 
	private String reservation_price; 		// 예약가격 
	
	
	
	
	
	public String getReservation_code() {
		return reservation_code;
	}
	public void setReservation_code(String reservation_code) {
		this.reservation_code = reservation_code;
	}
	public String getFk_userid() {
		return fk_userid;
	}
	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}
	public String getFk_room_detail_code() {
		return fk_room_detail_code;
	}
	public void setFk_room_detail_code(String fk_room_detail_code) {
		this.fk_room_detail_code = fk_room_detail_code;
	}
	public String getReservation_date() {
		return reservation_date;
	}
	public void setReservation_date(String reservation_date) {
		this.reservation_date = reservation_date;
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
	public String getReservation_price() {
		return reservation_price;
	}
	public void setReservation_price(String reservation_price) {
		this.reservation_price = reservation_price;
	}
	
	
	
	
	
	
	
	
}
