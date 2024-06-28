<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">

p#footer_title {
	font-family: "Gugi", sans-serif;
	font-weight: 400;
	font-size: 36pt;
	font-style: normal;
}

ul.footer-ul {
	list-style: none;
	padding: 0;
}

ul.footer-ul > li {
	margin-right: 3%;
}

a:link,
a:visited,
a:hover {
	color: #999999;
	text-decoration: none;
}

</style>

<div style="background-color: #383838; color: #999999;">
	<div class="pt-5 pb-5 d-flex" style="width: 70%; margin: 0 auto;">
	
		<div class="d-inline-block">
			<div>
				<p id="footer_title" style="font-size: 1.2rem;">제주드림 Jeju Dream</p>
				<img src="<%=ctxPath%>/resources/images/logo_circle.png" width="80">
			</div>
		</div>
		
		<div class="d-inline-block ml-auto" style="width: 70%;">
			<div>
				<ul class="footer-ul d-flex">
					<li><a href="#">사이트 소개</a></li>
					<li><a href="#">사업제휴</a></li>
					<li><a href="#">개인정보취급방침</a></li>
					<li><a href="#">이용약관</a></li>
					<li><a href="#">수집거부</a></li>
					<li><a href="#">고객센터</a></li>
				</ul>
				TEL : 02-123-4567&nbsp;&nbsp;|&nbsp;&nbsp;E-MAIL : jejudream@final.co.kr
			</div>
			<div style="margin-top: 4%; padding: 0; font-size: 0.8rem;">
				Copyright © Jeju Dream Co. All Rights Reserved.
			</div>
		</div>
		
	</div>
</div>     