package com.spring.app.trip.domain;

public class FaqVO {

	
	private String faq_seq;			// FAQ글번호
	private String faq_category;	// 카테고리
	private String faq_question;	// 질문
	private String faq_answer;		// 답변
	
	/////////////////////////////////////////////////////
	
	// == Getter, Setter == //
	
	public String getFaq_seq() {
		return faq_seq;
	}
	public void setFaq_seq(String faq_seq) {
		this.faq_seq = faq_seq;
	}
	public String getFaq_category() {
		return faq_category;
	}
	public void setFaq_category(String faq_category) {
		this.faq_category = faq_category;
	}
	public String getFaq_question() {
		return faq_question;
	}
	public void setFaq_question(String faq_question) {
		this.faq_question = faq_question;
	}
	public String getFaq_answer() {
		return faq_answer;
	}
	public void setFaq_answer(String faq_answer) {
		this.faq_answer = faq_answer;
	}
	
	
	
	
	
}
