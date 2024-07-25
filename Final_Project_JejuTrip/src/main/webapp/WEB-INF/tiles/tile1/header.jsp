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

#weather {
    display: flex;
    align-items: center;
}

.weather-icon {
    width: 24px; /* 원하는 크기로 설정 */
    height: 24px; /* 원하는 크기로 설정 */
    margin-right: 8px; /* 텍스트와 아이콘 사이의 간격 */
}

.weather-text {
    font-size: 14px; /* 원하는 폰트 크기로 설정 */
}
</style>

<script type="text/javascript">

let t_html = ``;

$(document).ready(function() {
	
	whatWeather();
    
	// 1분마다 whatWeather 함수 호출
    setInterval(whatWeather, 60000);
	
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
    
    
    // 검색창 엔터 시 전체 검색
    $("input#searchWord").keyup(function(e) {
    	if(e.keyCode == 13) {
    		goSearch(e);
    	}
    });
    
}); // end of $(document).ready(function() {}) -------------------------



function whatWeather(){
	
	let icon_src;
	let local_text;
	let local_desc;
	let local_icon;
	let local_ta;
	
	let v_html = ``;
	
	$.ajax({
		url:"<%= ctxPath%>/weatherXML.trip",
		type:"get",
		dataType:"xml",
		success:function(xml){
			const rootElement = $(xml).find(":root"); // 맨꼭대기 태그를 찾아준다!
			
			const weather = rootElement.find("weather"); 
			const updateTime = $(weather).attr("year")+"/"+$(weather).attr("month")+"/"+$(weather).attr("day")+" "+$(weather).attr("hour")+":00"; 
		
			const localArr = rootElement.find("local");
		
		    
		    // ====== XML 을 JSON 으로 변경하기  시작 ====== //
				var jsonObjArr = [];
			// ====== XML 을 JSON 으로 변경하기  끝 ====== //    
		        
		    for(let i=0; i<localArr.length; i++){
		    	
		    	let local = $(localArr).eq(i);
		    	
				let icon = "";  
				
				if(local.attr("stn_id") == "184"){
					// 위치가 제주시일 경우의 api 받아오기
					
					local_icon = $(local).attr("icon");
			    	local_ta = $(local).attr("ta");
			    	local_text = $(local).text();
			    	local_desc = $(local).attr("desc");
					
					switch (local.attr("desc")) {
					
					case "구름많음":
					case "흐림":
					    icon = "흐린슉슉이.png";
					    break;
					    
					case "맑음":
					case "구름조금":	
						icon = "맑음슉슉이.png";
					    break;
					    
					case "천둥번개":
					case "소나기":	
						icon = "번개슉슉이.png";
					    break;    
					    
					case "비":
					case "가끔 비":
					case "한때 비":
					case "비 또는 눈":
						icon = "비오는슉슉이.png";
					    break;
					    
					case "눈":
					case "눈 또는 비":
					case "가끔 눈":
					case "한때 눈":
						icon = "눈슉슉이.png";
					    break;     
					  
					default:
					    icon = "logo.png";
					
					} // end of switch
					
					icon_src = "<%= ctxPath%>/resources/images/" + icon;
					
					v_html += `<span class="weather-text">\${local_text}</span>
								<img src="<%= ctxPath%>/resources/images/weather/\${local_icon}.png" alt="Weather Icon" class="weather-icon">
        						<span class="weather-text">\${local_desc} \${local_ta}°C</span>`;
					
					
				} // end of if 제주
		    	
				if(local.attr("stn_id") == "189"){
					
					local_icon = $(local).attr("icon");
			    	local_ta = $(local).attr("ta");
			    	local_text = $(local).text();
			    	local_desc = $(local).attr("desc");
					
			    	v_html += `<span>&nbsp;&nbsp;/&nbsp;&nbsp;</span><span class="weather-text">\${local_text}</span>
									<img src="<%= ctxPath%>/resources/images/weather/\${local_icon}.png" alt="Weather Icon" class="weather-icon">
									<span class="weather-text">\${local_desc} \${local_ta}°C</span>`;
					
				} // end of if 서귀포
				
		    }// end of for------------------------ 
		    
		    $("div#weather").html(v_html);
		    
		    $("img#weatherlogo").attr("src",icon_src);
		
		},// end of success: function(xml){ }------------------
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
		
		
	}); // end of $.ajax weather
	
}// end of function showWeather()--------------------


// === 전체 검색 ===
function goSearch(event) {
	
	if(event) {
		event.preventDefault();
	}
	
	const searchWord = $("input#searchWord").val().trim();
	
	if(searchWord == "") {
		alert("검색어를 입력하세요!");
	 	return false; // false를 반환하여 폼 제출을 막음
	}
	
	const frm = document.allSearchFrm;
	frm.action = "<%=ctxPath%>/allSearch.trip";
	frm.submit();
	return true; // true를 반환하여 폼 제출을 허용
}

</script>

<div style="background-color: #F5F5F5;">

	<div class="pt-2" style="width: 70%; margin: 0 auto;">
		<nav class="navbar navbar-expand-lg navbar-light" style="font-size: 0.8rem;">
			
			<div class="collapse navbar-collapse" id="inner_bar">
			
				<div id="weather"></div>&nbsp;&nbsp;<span id="wtime" style="color:gray; font-size:8pt; align-self: end;"></span>
				
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
						<a class="nav-link" href="<%=ctxPath%>/support.trip">고객센터</a>
					</li>
				</ul>
			</div>
	
		</nav>
	</div>
	
	<div style="width: 70%; margin: 0 auto;">
		<nav class="navbar navbar-expand-lg navbar-light">
			
			<a class="navbar-brand mr-4" href="<%=ctxPath%>/index.trip" title="Jeju Dream">
				<img id="weatherlogo" src="<%=ctxPath%>/resources/images/logo.png" width="80">
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
			    
			    
			      <form name="allSearchFrm" class="form-inline mt-2 mt-lg-0 mr-auto" onsubmit="return goSearch(event)">
					    <input type="text" id="searchWord" name="searchWord" class="mr-sm-2" style="background-color: #F5F5F5; border-width: 0 0 2px;" placeholder="검색어를 입력하세요">
					    <button id="searchBtn" class="btn my-2 my-sm-0" type="button" onclick="goSearch(event)"><i class="fa-solid fa-magnifying-glass"></i></button>
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
					
					<li class="user_menu nav-item">
						<a class="nav-link text-center" href="<%=ctxPath%>/requiredLogin_goMypage.trip">
							<c:if test="${requestScope.i > 0}"><div style="float:right; width:10px; height:10px; border-radius:50%; background-color: red;"></div></c:if>
							<i class="fa-solid fa-user"></i>
							<div>마이페이지</div>
						</a>
					</li>
				</ul>
			  
			</div>
		</nav>
	</div>

</div>




