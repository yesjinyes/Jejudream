package com.spring.app.trip.domain;

import org.springframework.web.multipart.MultipartFile;

public class BoardVO {
	
	// field
	private String seq;          // 글번호 
	private String fk_userid; 	 // 사용자ID
	private String name; 		 // 글쓴이
	private String subject; 	 // 글제목
	private String content; 	 // 글내용
	private String pw; 			 // 글암호
	private String readCount; 	 // 글조회수
	private String regDate; 	 // 글쓴시간
	private String status; 		 // 글삭제여부 1:사용가능한 글, 0:삭제된글

	/*
	private String previousseq;  	// 이전글번호
	private String previoussubject; // 이전글제목
	private String nextseq; 		// 다음글번호
	private String nextsubject; 	// 다음글제목
	*/
	
	private String commentCount; // 댓글수
	
	private MultipartFile attach;
	
	private String fileName; // WAS(톰캣)에 저장될 파일명
	private String orgFilename; // 실제 파일명
	private String fileSize; // 파일 크기
	
	private String category; // 글 카테고리 (1:자유게시판, 2:숙박, 3:관광지/체험, 4:맛집, 5:구인)


	// method
	public BoardVO() {}
	
	public BoardVO(String seq, String fk_userid, String name, String subject, String content, String pw,
			String readCount, String regDate, String status) {

		this.seq = seq;
		this.fk_userid = fk_userid;
		this.name = name;
		this.subject = subject;
		this.content = content;
		this.pw = pw;
		this.readCount = readCount;
		this.regDate = regDate;
		this.status = status;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getReadCount() {
		return readCount;
	}

	public void setReadCount(String readCount) {
		this.readCount = readCount;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(String commentCount) {
		this.commentCount = commentCount;
	}

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

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}
	
	
	
}
