<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
    //    /MyMVC
%>

<%-- 직접 만든 CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/main/main.css" />
<script type="text/javascript">
	$(document).ready(function(){
		$("a.nav-link").bind("click",function(e){
			$("a.nav-link").css({"color":"#838383"});
			$(e.target).css({"color":"#FF5000"})
		})
	})// end of $(document).ready(function(){
</script>

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
			<a href="https://www.visitjeju.net/kr/themtour/view?contentsid=CNTS_300000000013053"><img src="<%=ctxPath%>/resources/images/main/jeju_flower.jpg"/></a>
			<div id="carouselExampleIndicators" class="carousel slide main_recommend_carousel" data-ride="carousel">
				<ol class="carousel-indicators">
					<li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
					<li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
				</ol>
				<div class="carousel-inner">
					<div class="carousel-item active">
						<a href="https://www.visitjeju.net/kr/themtour/view?contentsid=CNTS_300000000013053"><img src="<%= ctxPath %>/resources/images/main/olle_market.jpg" class="d-block w-100" alt="..."></a>
					</div>
					<div class="carousel-item">
						<img src="<%= ctxPath %>/resources/images/main/mandarin_party.png" class="d-block w-100" alt="...">		      
					</div>
				</div>
				<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="sr-only">Prefvious</span>
				</a>
				<a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"></span>
					<span class="sr-only">Next</span>
				</a>
			</div>
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
		<div class="jeju_resort">
			<div><img src="<%=ctxPath%>/resources/images/main/jeju_resort1.jpg"/></div>
			<div><img src="<%=ctxPath%>/resources/images/main/jeju_resort2.png"/></div>
			<div><img src="<%=ctxPath%>/resources/images/main/jeju_resort3.jpg"/></div>
			<div class="jeju_hotel_title">RESORT</div>
		</div>
		<div class="jeju_airbnb">
			<div class="jeju_hotel_title">AIR BNB</div>
			<div><img src="<%=ctxPath%>/resources/images/main/airbnb1.jpg"/></div>
			<div><img src="<%=ctxPath%>/resources/images/main/airbnb2.jpg"/></div>
			<div><img src="<%=ctxPath%>/resources/images/main/airbnb3.jpg"/></div>
		</div>
	</div>
	<!-- 호텔 컨텐츠 끝 -->
