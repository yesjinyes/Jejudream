<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
    //    /MyMVC
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%-- Required meta tags --%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- 직접 만든 CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/main/main.css" />

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 

<%-- JQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		$("a.nav-link").bind("click",function(e){
			$("a.nav-link").css({"color":"#838383"});
			$(e.target).css({"color":"#FF5000"})
		})
	})// end of $(document).ready(function(){
</script>

</head>
<body>
	<div class="main_header">
		<div class="main_header_menu">
			<img class="main_icon" src="<%=ctxPath%>/resources/images/main/main_icon.jpg"/>
			<a href="#">숙소</a>
			<a href="#">먹거리</a>
			<a href="#">즐길거리</a>
			<a href="<%=ctxPath%>/community_main.trip">커뮤니티</a>
			<a class="login"href="<%=ctxPath%>/login.trip">로그인</a>
		</div>
	</div>
	<div class="main_video_div">
		<video class="main_video" autoplay muted loop>
			<source src="<%= ctxPath %>/resources/images/main/main.mp4" type="video/mp4">
		</video>
	</div>
	<!-- 메인페이지 여행지 추천 배너 -->
	<div class="main_recommend">
		<div class="main_recommend_title"><span style="color:orange;">제주도</span> 여행 정보📌</div>
		<a href="https://korean.visitkorea.or.kr/detail/rem_detail.do?cotid=fd4c27e6-05a0-45b2-816b-f680b544f5b4"><img src="<%=ctxPath%>/resources/images/main/main_recommend.jpg"/></a>
		<div class="main_recommend_banner" style="display: flex;">
				<a href="https://www.visitjeju.net/kr/detail/view?contentsid=CONT_000000000500731"><img src="<%=ctxPath%>/resources/images/main/olle_market.jpg"/></a>
				<a href="https://www.jicexpo.com/"><img src="<%=ctxPath%>/resources/images/main/mandarin_party.png"/></a>
		</div>
	</div>

	<!-- 호텔 컨텐츠 시작 -->
	<div class="main_hotel">
		<div class="jeju_hotel">
			<div class="jeju_hotel_title">HOTEL</div>
			<div><img src="<%=ctxPath%>/resources/images/main/hotel1.jpg"/></div>
			<div><img src="<%=ctxPath%>/resources/images/main/hotel2.jpg"/></div>
			<div><img src="<%=ctxPath%>/resources/images/main/hotel3.jpg"/></div>
		</div>
		<div class="jeju_resort"></div>
		<div class="jeju_airbnb"></div>
	</div>
	<!-- 호텔 컨텐츠 끝 -->

</body>
</html>