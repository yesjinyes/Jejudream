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

<style type="text/css">
p#header_title {
	font-family: "Gugi", sans-serif;
	font-weight: 400;
	font-style: normal;
}

ul.menu_bar {
	width: 35%;
}

ul.menu_bar > li {
	margin-right: 7%;
}

ul.menu_bar > li:hover {
	font-weight: bold;
	border-bottom: solid 3px #ff5000;
}

a.menu_bar_a {
	color: black !important;
}
</style>

<div style="background-color: #F5F5F5;">

	<div class="pt-2" style="width: 70%; margin: 0 auto;">
		<nav class="navbar navbar-expand-lg navbar-light" style="font-size: 0.8rem;">
			
			<div class="collapse navbar-collapse" id="inner_bar">
				
				<ul class="navbar-nav ml-auto my-2 my-lg-0" style="justify-content: ">
					<li class="nav-item">
						<a class="nav-link" href="<%=ctxPath%>/login.trip">로그인<span class="sr-only">(current)</span></a>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="registerDropdown" data-toggle="dropdown">
							회원가입
						</a>
						<div class="dropdown-menu" aria-labelledby="registerDropdown" style="margin-right: 20%;">
							<a class="dropdown-item" href="<%=ctxPath%>/memberRegister.trip">개인 회원가입</a>
							<a class="dropdown-item" href="<%=ctxPath%>/companyRegister.trip">업체 회원가입</a>
						</div>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="#">고객센터</a>
					</li>
				</ul>
			</div>
	
		</nav>
	</div>
	
	<div style="width: 70%; margin: 0 auto;">
		<nav class="navbar navbar-expand-lg navbar-light">
			
			<a class="navbar-brand mr-4" href="#" title="Jeju Dream">
				<img src="<%=ctxPath%>/resources/images/logo.png" width="80">
				<p id="header_title">제주드림</p>
			</a>
					
			<button class="navbar-toggler ml-auto" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo02" aria-controls="navbarTogglerDemo02" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
		
			<div class="collapse navbar-collapse" id="navbarTogglerDemo02">
				
				<ul class="menu_bar navbar-nav mt-2 mt-lg-0">
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="#">숙소</a>
			      </li>
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="#">맛집</a>
			      </li>
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="#">즐길거리</a>
			      </li>
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="#">커뮤니티</a>
			      </li>
			    </ul>
			    
			    
			      <form class="form-inline mt-2 mt-lg-0 mr-auto">
					    <input type="text" class="mr-sm-2" style="background-color: #F5F5F5; border-width: 0 0 1px;" placeholder="검색어를 입력하세요">
					    <button class="btn my-2 my-sm-0" type="button"><i class="fa-solid fa-magnifying-glass"></i></button>
				  </form>
				
				<ul class="navbar-nav my-2 my-lg-0">
					<li class="nav-item mr-3">
						<a class="nav-link text-center" href="#">
							<i class="fa-solid fa-cart-shopping"></i>
							<div>장바구니</div>
						</a>
					</li>
					<li class="nav-item">
						<a class="nav-link text-center" href="#">
							<i class="fa-solid fa-user"></i>
							<div>마이페이지</div>
						</a>
					</li>
				</ul>
			  
			</div>
		</nav>
	</div>

</div>




