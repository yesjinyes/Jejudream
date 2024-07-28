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

<div class="container" style="width: 70%; margin: 0 auto;">
	<div class="mt-5 mb-5">
		<div style="margin-bottom: 7%;">
			<span style="font-size: 1.5rem;"><span class="font-weight-bold">'${requestScope.searchWord}'</span> 검색결과</span>
			&nbsp;&nbsp;<span class="font-weight-bold" style="font-size: 1.2rem; color: #ff7433;">${requestScope.allCount}개</span>
		</div>
		
		<c:if test="${not empty requestScope.lodgingList}">
			<div id="lodgingDiv">
				<span style="font-size: 1.2rem; font-weight: 600;">숙박&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.lodgingCount}개</span></span>
				
				<div id="lodgingList" class="row mt-3">
					<c:forEach var="lodging" items="${requestScope.lodgingList}">
						<div class="col-md-3">
							<div class="card">
			                    <img src="<%=ctxPath%>/resources/images/lodginglist/${lodging.main_img}" class="card-img-top">
			                    <div class="card-body">
			                        <h5 class="card-title">${lodging.lodging_name}</h5>
			                        <h6 class="card-subtitle mb-2 text-muted">${lodging.local_status}</h6>
			                        <p class="card-text">726,000 원</p>
			                    </div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<div class="text-center">
					<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
						더보기
						<i class="fa-solid fa-chevron-down ml-2"></i>
					</div>
				</div>
			</div>
		</c:if>
		
		<c:if test="${not empty requestScope.foodstoreList}">
			<div id="foodstoreDiv" style="margin-top: 7%;">
				<span style="font-size: 1.2rem; font-weight: 600;">맛집&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.foodstoreCount}개</span></span>
				
					<div id="foodstoreList" class="row mt-3">
						<c:forEach var="foodstore" items="${requestScope.foodstoreList}">
							<div class="col-md-3">
								<div class="card">
				                    <img src="<%=ctxPath%>/resources/images/foodimg/${foodstore.orgFilename}" class="card-img-top">
				                    <div class="card-body">
				                        <h5 class="card-title">${foodstore.food_name}</h5>
				                        <h6 class="card-subtitle mb-2 text-muted">${foodstore.local_status}</h6>
				                        <p class="card-text">${foodstore.food_category}</p>
				                    </div>
				                </div>
							</div>
						</c:forEach>
					</div>
				
				<div class="text-center">
					<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
						더보기
						<i class="fa-solid fa-chevron-down ml-2"></i>
					</div>
				</div>
			</div>
		</c:if>
		
		<c:if test="${not empty requestScope.playList}">
			<div id="playDiv" style="margin-top: 7%;">
				<span style="font-size: 1.2rem; font-weight: 600;">즐길거리&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.playCount}개</span></span>
				
				<div id="playList" class="row mt-3">
					<c:forEach var="play" items="${requestScope.playList}">
						<div class="col-md-3">
							<div class="card">
			                    <img src="<%=ctxPath%>/resources/images/play/${play.play_main_img}" class="card-img-top">
			                    <div class="card-body">
			                        <h5 class="card-title">${play.play_name}</h5>
			                        <h6 class="card-subtitle mb-2 text-muted">${play.local_status}</h6>
			                        <p class="card-text">${play.play_category}</p>
			                    </div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<div class="text-center">
					<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
						더보기
						<i class="fa-solid fa-chevron-down ml-2"></i>
					</div>
				</div>
			</div>
		</c:if>
		
		<c:if test="${not empty requestScope.boardList}">
			<div id="communityDiv" style="margin-top: 7%;">
				<span style="font-size: 1.2rem; font-weight: 600;">커뮤니티&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.boardCount}개</span></span>
				
				<div id="communityList" class="row mt-3">
					<c:forEach var="board" items="${requestScope.boardList}">
						<div class="col-md-3">
							<div class="card">
		                    	<div class="card-body">
								    <h5 class="card-title">${board.subject}</h5>
								    <h6 class="card-subtitle mb-2 text-muted">${board.category}</h6>
								    <p class="card-text">${board.content}</p>
						  		</div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<div class="text-center">
					<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
						더보기
						<i class="fa-solid fa-chevron-down ml-2"></i>
					</div>
				</div>
			</div>
		</c:if>
		
	</div>

</div>