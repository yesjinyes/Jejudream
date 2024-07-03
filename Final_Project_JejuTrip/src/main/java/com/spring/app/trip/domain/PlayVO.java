package com.spring.app.trip.domain;

import org.springframework.web.multipart.MultipartFile;

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
	// #172.파일을 첨부하도록 VO 수정하기
	// 먼저, 오라클에서 tbl_board 테이블에 3개 컬럼(fileName, orgFilename, fileSize)을 추가한 다음에 아래의 작업을 한다.
	    private MultipartFile attach;
	// form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
	// 조심할것은 MultipartFile attach 는 오라클 데이터베이스 tbl_board 테이블의 컬럼이 아니다.   
	// /board/src/main/webapp/WEB-INF/views/tiles1/board/add.jsp 파일에서 input type="file" 인 name 의 이름(attach)과  동일해야만 파일첨부가 가능해진다.!!!!

	    private String fileName;// WAS(톰캣)에 저장될 파일명(2026062609291535243254235235234.png) 
	    private String orgFilename; // 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
	    private String fileSize;
	    public MultipartFile getAttach() {
			return attach;
		}

		public void setAttach(MultipartFile attach) {
			this.attach = attach;
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