<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<style>
    .card {
        margin-bottom: 1.5rem; /* 각 카드 아래에 마진 추가 */
    }
</style>

<div class="container" style="border: solid 1px red; width: 70%; margin: 0 auto;">
	<div class="mt-5 mb-5">
		<div style="border: solid 1px blue; margin-bottom: 10%;">
			<span style="font-size: 1.5rem;"><span class="font-weight-bold">'제주'</span> 검색결과</span>
			&nbsp;&nbsp;<span class="font-weight-bold" style="font-size: 1.2rem; color: #ff7433;">150개</span>
		</div>
		
		<div id="lodgingDiv">
			<span style="font-size: 1.2rem; font-weight: 600;">숙박&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">37개</span></span>
			
			<div id="lodgindList" class="row mt-3">
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
				<div class="col-md-3">
					<div class="card">
	                    <img src="<%=ctxPath%>/resources/images/lodginglist/그라벨호텔 제주_main.jpg" class="card-img-top" alt="호텔1">
	                    <div class="card-body">
	                        <h5 class="card-title">그라벨호텔 제주</h5>
	                        <p class="card-text">726,000 원</p>
	                    </div>
	                </div>
				</div>
				
			</div>
		</div>
	</div>

</div>