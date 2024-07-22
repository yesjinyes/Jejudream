package com.spring.app.trip.domain;

// == #82. 댓글용 VO 생성하기
//	    오라클에서 tbl_comment 테이블을 생성한다.
//    또한 tbl_board 테이블에 commentCount 컬럼을 추가한다. =====
public class CommentVO {
	
	// field
	private String seq;			// 댓글번호
	private String fk_userid;	// 사용자ID
	private String name;		// 성명
	private String content;		// 댓글내용
	private String regDate;		// 작성일자
	private String parentSeq;	// 원게시물 글번호
	private String status;		// 글삭제여부
	
	private String groupno;		// 그룹번호
	
	private String fk_seq;		// 원댓글번호
	
	private String depthno;		// 답댓글일 경우 원댓글의 depthno + 1
								// 원댓글일 경우 depthno는 0

/*	
	private MultipartFile attach;
   
	private String fileName;    // WAS(톰캣)에 저장될 파일명
	private String orgFilename; // 원래 파일명
 	private String fileSize;    // 파일크기
*/
	
	// method
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
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getRegDate() {
		return regDate;
	}
	
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	public String getParentSeq() {
		return parentSeq;
	}
	
	public void setParentSeq(String parentSeq) {
		this.parentSeq = parentSeq;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

	public String getGroupno() {
		return groupno;
	}

	public void setGroupno(String groupno) {
		this.groupno = groupno;
	}

	public String getFk_seq() {
		return fk_seq;
	}

	public void setFk_seq(String fk_seq) {
		this.fk_seq = fk_seq;
	}

	public String getDepthno() {
		return depthno;
	}

	public void setDepthno(String depthno) {
		this.depthno = depthno;
	}
	
}
