<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> <!-- Spring security taglib을 사용 --> 
--%>

<%-- ===== #27. tile1 중 header 페이지 만들기 (#26. 은 실수로 기입하지 않아서 없음) ===== --%> 
<%
	String ctxPath = request.getContextPath();

    // === #195. (웹채팅관련3) === 
    // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) === 
    
    InetAddress inet = InetAddress.getLocalHost();
 // String serverIP = inet.getHostAddress();
     
 // System.out.println("serverIP : " + serverIP);
 // serverIP : 172.18.80.1

    String serverIP = "192.168.10.101";
 // String serverIP = "211.238.142.72"; 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다. 
 
    // === 서버 포트번호 알아오기 === //
    int portnumber = request.getServerPort();
 // System.out.println("portnumber : " + portnumber);
 // portnumber : 9090
 
    String serverName = "http://"+serverIP+":"+portnumber;
 // System.out.println("serverName : " + serverName);
 // serverName : http://172.18.80.1:9090
%>

<div id="_header">
	
	<div class="re_header">
		<div class="inner">
			<div class="header-top">
				<div class="box__usermenu">
					<ul class="list__usermenu">
						
						
						
							<li class="list-item">
								<a class="link__usermenu" href="javascript:fn_login();">로그인</a>
							</li>
							<li class="list-item">
								<a class="link__usermenu" href="/web/signUp00.do">회원가입</a>
							</li>
						
						<li class="list-item">
							<a class="link__usermenu" href="/web/coustmer/viewCorpPns.do?menuIndex=2">입점신청</a>
						</li>
						<li class="list-item">
							<a class="link__usermenu" href="/web/coustmer/qaList.do">고객센터</a>
						</li>
					</ul>
				</div>
				<nav class="navbar navbar-light bg-light">
				  <a class="navbar-brand" href="#" title="Jeju Dream">
				    <img src="<%=ctxPath%>/resources/images/logo.png" width="100" height="100" alt="JejuDream">
				  </a>
				</nav>
				<div class="srh_area">
					
					<form name="totalSearchForm" id="totalSearchForm" onSubmit="return false;">
						<fieldset>
							<legend class="for-a11y"> 검색</legend>
							<div class="top_search" >
								<input name="search" id="search" title="검색어 입력" class="form_input" value="" onkeydown="javascript:if(event.keyCode==13){fn_searBtClick();}" placeholder="검색어를 입력해주세요">
								<button type="button" title="검색" class="srh_btn" id="searBT" onclick="javascript:fn_searBtClick();">
									<img src="/images/web/r_main/srh_btn.png" alt="검색">
								</button>
							</div>
						</fieldset>
					</form>
				</div>
				<div class="util_menu">
					<ul>
						
						<li class="promotion more">
							<a href="/web/evnt/prmtPlanList.do">
								<span class="ico"></span>
								<span class="txt">기획전/이벤트</span>
							</a>
						</li>
						
						<li class="cart more">
							<a href="/web/cart.do">
								<span class="ico">&nbsp;</span>
								<span class="cnt" id="headCartCnt">0</span>
								<span class="txt">장바구니</span>
							</a>
						</li>
						<li class="mypage more">
							<a href="/web/mypage/rsvList.do">
								<span class="ico">&nbsp;</span>
								<span class="txt">마이탐나오</span>
							</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="gnb2">
		<div class="inner">
			<div class="box__service-all">
				<ul class="menu">
					<li><a href="/web/av/mainList.do">항공</a></li>
					
					<li><a href="/web/stay/jeju.do">숙소</a></li>
					<li><a href="/web/rentcar/jeju.do">렌트카</a></li>
					<li><a href="/web/tour/jeju.do?sCtgr=C200">관광지</a></li>
					<li><a href="/web/tour/jeju.do?sCtgr=C300">맛집</a></li>
					<li><a href="/web/sp/packageList.do">여행사 상품</a></li>
					<li><a href="/web/goods/jeju.do">특산/기념품</a></li>
					
					
					<li><a href="/web/sv/sixIntro.do">제주 농부의 장</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
