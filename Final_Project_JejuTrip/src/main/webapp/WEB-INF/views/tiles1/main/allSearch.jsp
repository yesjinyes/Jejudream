<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	String ctxPath = request.getContextPath();
%>

<style>
    .card {
        margin-bottom: 1.5rem; /* 각 카드 아래에 마진 추가 */
        overflow: hidden; /* 카드 영역을 벗어나는 이미지 부분을 숨김 */
    }
	
    .card-img-top {
        transition: transform 0.3s ease; /* 애니메이션 효과 추가 */
    }
    
    .card:hover .card-img-top {
        transform: scale(1.1); /* 1.1배 확대 */
    }
    
    .card:hover {
    	cursor: pointer;
    }
</style>

<div class="container" style="width: 70%; margin: 0 auto;">
	<div class="mt-5 mb-5">
		<div style="margin-bottom: 7%;">
			<span style="font-size: 1.5rem;"><span class="font-weight-bold">'${requestScope.searchWord}'</span> 검색결과</span>
			&nbsp;&nbsp;<span class="font-weight-bold" style="font-size: 1.2rem; color: #ff7433;">${requestScope.allCount}개</span>
		</div>
		
		<%-- 숙박 검색 결과 --%>
		<c:if test="${not empty requestScope.lodgingList}">
			<div id="lodgingDiv">
				<span style="font-size: 1.2rem; font-weight: 600;">숙박&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.lodgingCount}개</span></span>
				
				<div id="lodgingList" class="row mt-3">
					<c:forEach var="lodging" items="${requestScope.lodgingList}">
						<div class="col-md-3">
							<div class="card">
			                    <img src="<%=ctxPath%>/resources/images/lodginglist/${lodging.main_img}" class="card-img-top" height="200px">
			                    <div class="card-body">
			                        <h5 class="card-title">
			                        	<c:choose>
			                        		<c:when test="${fn:length(lodging.lodging_name) gt 13}">
			                        			${fn:substring(lodging.lodging_name, 0, 10)}...
			                        		</c:when>
			                        		<c:otherwise>
						                        ${lodging.lodging_name}
			                        		</c:otherwise>
			                        	</c:choose>
			                        </h5>
			                        <h6 class="card-subtitle mb-2 text-muted">${lodging.local_status}</h6>
			                        <p class="card-text">726,000 원</p>
			                    </div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<c:if test="${requestScope.lodgingCount gt 8}">
					<div class="text-center">
						<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
							더보기
							<i class="fa-solid fa-chevron-down ml-2"></i>
						</div>
					</div>
				</c:if>
			</div>
		</c:if>
		
		<%-- 맛집 검색 결과 --%>
		<c:if test="${not empty requestScope.foodstoreList}">
			<div id="foodstoreDiv" style="margin-top: 7%;">
				<span style="font-size: 1.2rem; font-weight: 600;">맛집&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.foodstoreCount}개</span></span>
				
				<div id="foodstoreList" class="row mt-3">
					<c:forEach var="foodstore" items="${requestScope.foodstoreList}">
						<div class="col-md-3">
							<div class="card">
			                    <img src="<%=ctxPath%>/resources/images/foodimg/${foodstore.orgFilename}" class="card-img-top" height="200px">
			                    <div class="card-body">
			                        <h5 class="card-title">
		                        		<c:choose>
			                        		<c:when test="${fn:length(foodstore.food_name) gt 12}">
			                        			${fn:substring(foodstore.food_name, 0, 9)}...
			                        		</c:when>
			                        		<c:otherwise>
						                        ${foodstore.food_name}
			                        		</c:otherwise>
			                        	</c:choose>
			                        </h5>
			                        <h6 class="card-subtitle mb-2 text-muted">${foodstore.local_status}</h6>
			                        <p class="card-text">${foodstore.food_category}</p>
			                    </div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<c:if test="${requestScope.foodstoreCount gt 8}">
					<div class="text-center">
						<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
							더보기
							<i class="fa-solid fa-chevron-down ml-2"></i>
						</div>
					</div>
				</c:if>
			</div>
		</c:if>
		
		<%-- 즐길거리 검색 결과 --%>
		<c:if test="${not empty requestScope.playList}">
			<div id="playDiv" style="margin-top: 7%;">
				<span style="font-size: 1.2rem; font-weight: 600;">즐길거리&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.playCount}개</span></span>
				
				<div id="playList" class="row mt-3">
					<c:forEach var="play" items="${requestScope.playList}">
						<div class="col-md-3">
							<div class="card">
			                    <img src="<%=ctxPath%>/resources/images/play/${play.play_main_img}" class="card-img-top" height="200px">
			                    <div class="card-body">
			                        <h5 class="card-title">
			                        	<c:choose>
			                        		<c:when test="${fn:length(play.play_name) gt 13}">
			                        			${fn:substring(play.play_name, 0, 10)}...
			                        		</c:when>
			                        		<c:otherwise>
						                        ${play.play_name}
			                        		</c:otherwise>
			                        	</c:choose>
			                        </h5>
			                        <h6 class="card-subtitle mb-2 text-muted">${play.local_status}</h6>
			                        <p class="card-text">${play.play_category}</p>
			                    </div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<c:if test="${requestScope.playCount gt 8}">
					<div class="text-center">
						<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
							더보기
							<i class="fa-solid fa-chevron-down ml-2"></i>
						</div>
					</div>
				</c:if>
			</div>
		</c:if>
		
		<%-- 커뮤니티 검색 결과 --%>
		<c:if test="${not empty requestScope.boardList}">
			<div id="communityDiv" style="margin-top: 7%;">
				<span style="font-size: 1.2rem; font-weight: 600;">커뮤니티&nbsp;<span class="font-weight-bold" style="font-size: 1rem; color: #ff7433;">${requestScope.boardCount}개</span></span>
				
				<div id="communityList" class="row mt-3">
					<c:forEach var="board" items="${requestScope.boardList}">
						<div class="col-md-3">
							<div class="card">
		                    	<div class="card-body">
								    <h5 class="card-title">
								    	<c:choose>
								    		<c:when test="${fn:length(board.subject) gt 26}">
											    ${fn:substring(board.subject, 0, 23)}...
								    		</c:when>
								    		<c:otherwise>
											    ${board.subject}
								    		</c:otherwise>
								    	</c:choose>
								    </h5>
								    <h6 class="card-subtitle mt-2 mb-2 text-muted">
								    	<c:if test="${board.category == 1}">자유게시판</c:if>
								    	<c:if test="${board.category == 2}">숙박</c:if>
								    	<c:if test="${board.category == 3}">관광지,체험</c:if>
								    	<c:if test="${board.category == 4}">맛집</c:if>
								    </h6>
								    <%-- <p class="card-text">${board.content}</p> --%>
						  		</div>
			                </div>
						</div>
					</c:forEach>
				</div>
				
				<c:if test="${requestScope.boardCount gt 8}">
					<div class="text-center">
						<div style="border: solid 1px #ccc; height:70px; width: 30%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
							더보기
							<i class="fa-solid fa-chevron-down ml-2"></i>
						</div>
					</div>
				</c:if>
			</div>
		</c:if>
		
		<%--검색 결과가 모두 없을 경우 --%>
		<c:if test="${empty requestScope.lodgingList && empty requestScope.foodstoreList &&
		 			  empty requestScope.playList && empty requestScope.boardList}">
			<div class="text-center" style="font-size: 1.5rem; margin: 10% 0 20% 0;">
				<span>검색 결과가 없습니다</span>
				<i class="fa-regular fa-face-sad-tear" style="color: #ff7433;"></i>
				<span class="d-block" style="font-size: 1rem; color: #999;">다른 검색어를 입력하시거나 철자와 띄어쓰기를 확인해보세요.</span>
			</div>
		</c:if>
		
	</div>

</div>