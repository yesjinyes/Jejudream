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
	width: 40%;
}

ul.menu_bar > li {
	margin-right: 7%;
}

ul.menu_bar > li:hover {
	font-weight: bold;
}

.menu_bar_line {
    width: 0;
    height: 3px;
    background-color: #ff5000;
    transition: width 0.3s ease-out;
    margin: 0 auto;
}

a.menu_bar_a {
	color: black !important;
	font-size: 1.2rem;
}

li.user_menu:hover {
	font-weight: bold;
}

input:focus {
    outline: none;
}

</style>

<script type="text/javascript">
$(document).ready(function() {
    
    // 초기 상태 설정
    $("div.menu_bar_line").css("width", "0");
    
    $(document).on("mouseenter", "ul.menu_bar > li", function() {
        var $line = $(this).find("div.menu_bar_line");
        $line.css("width", "100%");
    });
    
    $(document).on("mouseleave", "ul.menu_bar > li", function() {
        var $line = $(this).find("div.menu_bar_line");
        $line.css("width", "0");
    });
    
});
</script>

<div style="background-color: #F5F5F5;">

	<div class="pt-2" style="width: 70%; margin: 0 auto;">
		<nav class="navbar navbar-expand-lg navbar-light" style="font-size: 0.8rem;">
			
			<div class="collapse navbar-collapse" id="inner_bar">
				
				<ul class="navbar-nav ml-auto my-2 my-lg-0">
					<c:if test="${empty sessionScope.loginuser && empty sessionScope.loginCompanyuser}">
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
					</c:if>
					
					<c:if test="${not empty sessionScope.loginuser || not empty sessionScope.loginCompanyuser}">
						<c:if test="${not empty sessionScope.loginuser}">
							<li class="nav-item">
								<a class="nav-link" href="#">${sessionScope.loginuser.user_name}님 로그인 중...</a>
							</li>
						</c:if>
						<c:if test="${not empty sessionScope.loginCompanyuser}">
							<li class="nav-item">
								<a class="nav-link" href="#">${sessionScope.loginCompanyuser.company_name} 업체 로그인 중...</a>
							</li>
						</c:if>
						<li class="nav-item">
							<a class="nav-link" href="<%=ctxPath%>/logout.trip">로그아웃</a>
						</li>
					</c:if>
					
					<li class="nav-item">
						<a class="nav-link" href="#">고객센터</a>
					</li>
				</ul>
			</div>
	
		</nav>
	</div>
	
	<div style="width: 70%; margin: 0 auto;">
		<nav class="navbar navbar-expand-lg navbar-light">
			
			<a class="navbar-brand mr-4" href="<%=ctxPath%>/index.trip" title="Jeju Dream">
				<img src="<%=ctxPath%>/resources/images/logo.png" width="80">
				<p id="header_title">제주드림</p>
			</a>
					
			<button class="navbar-toggler ml-auto" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo02" aria-controls="navbarTogglerDemo02" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
		
			<div class="collapse navbar-collapse" id="navbarTogglerDemo02">
				
				<ul class="menu_bar navbar-nav mt-2 mt-lg-0">
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="<%=ctxPath%>/lodgingList.trip">숙소</a>
			        <div class="menu_bar_line"></div>
			      </li>
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="<%=ctxPath%>/foodstoreList.trip">맛집</a>
			        <div class="menu_bar_line"></div>
			      </li>
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="<%=ctxPath%>/playMain.trip">즐길거리</a>
			        <div class="menu_bar_line"></div>
			      </li>
			      <li class="nav-item">
			        <a class="nav-link menu_bar_a" href="<%=ctxPath%>/communityMain.trip">커뮤니티</a>
			        <div class="menu_bar_line"></div>
			      </li>
			    </ul>
			    
			    
			      <form class="form-inline mt-2 mt-lg-0 mr-auto">
					    <input type="text" class="mr-sm-2" style="background-color: #F5F5F5; border-width: 0 0 2px;" placeholder="검색어를 입력하세요">
					    <button class="btn my-2 my-sm-0" type="button"><i class="fa-solid fa-magnifying-glass"></i></button>
				  </form>
				
				<ul class="navbar-nav my-2 my-lg-0">
					
					<c:if test="${not empty sessionScope.loginCompanyuser}">
						<li class="user_menu nav-item mr-3">
							<a class="nav-link text-center" href="<%=ctxPath%>/registerHotel.trip?companyid=${sessionScope.loginCompanyuser.companyid}">
								<i class="fa-solid fa-check"></i>
								<div>숙소등록</div>
							</a>
						</li>
					</c:if>
					
					<c:if test="${sessionScope.loginuser.userid == 'admin'}">
						<li class="user_menu nav-item mr-3">
							<a class="nav-link text-center" href="<%=ctxPath%>/admin/foodstoreRegister.trip">
								<i class="fa-solid fa-utensils"></i>
								<div>맛집등록</div>
							</a>
						</li>
						<li class="user_menu nav-item mr-3">
							<a class="nav-link text-center" href="<%=ctxPath%>/screeningRegister.trip">
								<i class="fa-solid fa-check"></i>
								<div>신청검토</div>
							</a>
						</li>
					</c:if>
					
					<c:if test="${empty sessionScope.loginCompanyuser && sessionScope.loginuser.userid != 'admin'}">
						<li class="user_menu nav-item mr-3">
							<a class="nav-link text-center" href="#">
								<i class="fa-solid fa-cart-shopping"></i>
								<div>장바구니</div>
							</a>
						</li>
					</c:if>
					
					<li class="user_menu nav-item">
						<a class="nav-link text-center" href="<%=ctxPath%>/requiredLogin_goMypage.trip">
							<i class="fa-solid fa-user"></i>
							<div>마이페이지</div>
						</a>
					</li>
				</ul>
			  
			</div>
		</nav>
	</div>

</div>




