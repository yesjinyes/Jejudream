package com.spring.app.chatting.websockethandler;

import com.google.gson.Gson;

// === #227. (웹채팅관련9) === //  
public class MessageVO {

	private String message; // 보내줄 메시지이지만 채팅메시지만 뿐만아니라 전달하는 문자도 포함인듯
	private String type; // all 이면 전체에게 채팅메시지를 보냄. one 이면 특정 사용자에게 채팅메시지를 보냄. 
	private String to;   // 특정 웹소켓 id 
	
	public String getMessage() {
		return message;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getTo() {
		return to;
	}
	
	public void setTo(String to) {
		this.to = to;
	}
	
	
	/////////////////////////////////////////////////////////////
		
	public static MessageVO convertMessage(String source) {
	
		Gson gson = new Gson();
		/* Gson 은 Java 객체를 JSON 표현식으로 변환할 수 있게 해주는 Java 라이브러리임. 
		또한 거꾸로 JSON 표현식 형태의 String 을 Java 객체로 변환도 가능하게 해주는 라이브러리임.
	    */
	
		MessageVO messagevo = gson.fromJson(source, MessageVO.class);
		// source 는 JSON 형태로 되어진 문자열
		// gson.fromJson(source, MessageVO.class); 은 
		// JSON 형태로 되어진 문자열 source를 실제 MessageVO 객체로 변환해준다.
		// source 은 json타입의 문자열이 들어온다! 그리고 그것을 MessageVO로 바꿔준다
		
		// gson.toJson(jsonElement); 
	
		return messagevo;
	}
	
	
}
