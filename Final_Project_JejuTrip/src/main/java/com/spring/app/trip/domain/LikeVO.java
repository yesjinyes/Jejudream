package com.spring.app.trip.domain;

public class LikeVO {
	
	private String fk_userid;         /* 아이디 */
	private String parent_code; 	  /* 부모일련번호 */
	private String like_division_R;   /* 좋아요구분 A,B,C */
	
	
	
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
	public String getLike_division_R() {
		return like_division_R;
	}
	public void setLike_division_R(String like_division_R) {
		this.like_division_R = like_division_R;
	}

	
	

}
