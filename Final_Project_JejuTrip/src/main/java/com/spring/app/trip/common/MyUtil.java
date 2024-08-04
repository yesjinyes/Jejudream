package com.spring.app.trip.common;

import javax.servlet.http.HttpServletRequest;

public class MyUtil {
	
	// *** ? 다음의 데이터까지 포함한 현재 URL 주소를 알려주는 메소드를 생성 *** //
	public static String getCurrentURL(HttpServletRequest request) {
		
		String currentURL = request.getRequestURL().toString();
		
		// System.out.println("currentURL => " + currentURL);
		// currentURL => http://localhost:9090/MyMVC/member/memberList.up
		
		String queryString =  request.getQueryString();
		// System.out.println("queryString => " + queryString);
		// 웹주소 내용 queryString ==> searchType=name&searchWord=유&sizePerPage=5&currentShowPageNo=10 
		// 이클립스 콘솔내용 queryString ==> searchType=name&searchWord=%EC%9C%A0&sizePerPage=5&currentShowPageNo=10
		// 한글이라서 인코딩, 디코딩 변환된거임 유 == %EC%9C%A0 (javascriptstudy 09-URI 참조)
		// queryString ==> null (POST 일때)
		
		if(queryString != null) {
			
			currentURL += "?" + queryString;
			// http://localhost:9090/MyMVC/member/memberList.up + ? + searchType=name&searchWord=%EC%9C%A0&sizePerPage=5&currentShowPageNo=10
		}
		
		String ctxPath = request.getContextPath();
		//     /MyMVC
		
		int beginindex = currentURL.indexOf(ctxPath) + ctxPath.length();
		// 							21     			 +     6
		// 즉, 전체경로에서 ctxPath(/MyMVC)가 시작되는 인덱스에다가 ctxPath의 글지길이를 더하면 ctxPath 이후를 구할수가 있다!
		
		
		currentURL = currentURL.substring(beginindex);
		
		// System.out.println("currentURL => " + currentURL);
		// /member/memberList.up?searchType=name&searchWord=%EC%9C%A0&sizePerPage=5&currentShowPageNo=8
		
		return currentURL;
		
	} // end of public static String getCurrentURL(HttpServletRequest request) {}
	
	
	
	
	// 이전페이지를 가져오는 메소드
	public static String getPreviousPageURL(HttpServletRequest request) {
		
        String previousPageUrl = request.getHeader("Referer");
        
        if(previousPageUrl == null) {
        	
        	previousPageUrl = "index.trip";
        	
        }
        
        return previousPageUrl;
        
    } // end of public static String getPreviousPageURL(HttpServletRequest request) {}
	
	
	
	// <> 태그를 입력받으면 내용 바꾸는 메소드
	public static String changeEtcTag(String content) {
		
		// !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!!
		content = content.replaceAll("<", "&lt");
		content = content.replaceAll(">", "&gt");

        // 입력한 내용에서 엔터는 <br>로 변환하기
		content = content.replaceAll("\r\n", "<br>");
		
		return content;
		
	} // end of public static String changEtcTag(String tag) {}

}
