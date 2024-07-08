package com.spring.app.trip.domain;

import org.springframework.web.multipart.MultipartFile;

// == 숙소 VO == //
public class LodgingVO {

	private String lodging_code;		// 숙소일련번호
	private String local_status;		// 지역코드
	private String lodging_category;	// 숙소카테고리
	private String fk_companyid;		// 업체아이디
	private String lodging_name;		// 숙소이름
	private String lodging_tell;		// 숙소연락처
	private String lodging_content;		// 숙소설명
	private String lodging_address;		// 상세주소
	private String review_division;		// 리뷰용구분컬럼(default) A
	private String main_img;			// 메인 이미지
	private String status;				// 숙소 심사 상태 구분
	private String Feedback_msg;
	
	
	private MultipartFile attach;
	/* form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 
         	진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
                              조심할것은 MultipartFile attach 는 오라클 데이터베이스 tbl_board 테이블의 컬럼이 아니다.   
       /board/src/main/webapp/WEB-INF/views/tiles1/board/add.jsp 파일에서 input type="file" 인 name 의 이름(attach)과  동일해야만 파일첨부가 가능해진다.!!!!
    */
	
	private String fileName;
	
	private String orgFilename;
	
	private String fileSize;
	
	
	
    //////////////////////////////////////////////////////////////////
    // == Getter, Setter == //
	public String getLodging_code() {
		return lodging_code;
	}
	
	public void setLodging_code(String lodging_code) {
		this.lodging_code = lodging_code;
	}

	public String getLodging_category() {
		return lodging_category;
	}

	public void setLodging_category(String lodging_category) {
		this.lodging_category = lodging_category;
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
	

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getOrgFilename() {
		return orgFilename;
	}

	public void setOrgFilename(String orgFilename) {
		this.orgFilename = orgFilename;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
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

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}

	public String getMain_img() {
		return main_img;
	}

	public void setMain_img(String main_img) {
		this.main_img = main_img;
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getFeedback_msg() {
		return Feedback_msg;
	}

	public void setFeedback_msg(String feedback_msg) {
		Feedback_msg = feedback_msg;
	}
	
	
}