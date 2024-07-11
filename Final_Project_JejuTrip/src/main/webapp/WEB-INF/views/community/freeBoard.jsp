<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>    

<style type="text/css">
div.container {
	background-color: none;
}

table#freeBoard {
	font-size: 1.2rem;
	margin-bottom: 10%;
}

table#freeBoard > thead {
	background-color: #f2f2f2;
}

input#boardSearch {
	/* background-color: rgba(242, 242, 242, 0.3); */
	/* border-width: 0 0 1px; */
	width: 30%;
}

button#searchBtn {
	border-color: #ff5000;
	color: #ff5000;
}

button#searchBtn:hover {
	background-color: #ff5000;
	color: white;
}

.subjectStyle {
	font-weight: bold;
	cursor: pointer;
}

div#pageBar > ul {
	list-style: none;
}

div#pageBar > ul li {
	display: inline-block;
	font-size: 12pt;
	border: solid 0px red;
	text-align: center;
	color: #666666;
}

div#pageBar > ul li:hover {
	font-weight: bold;
	color: black;
}

div#pageBar a {
	text-decoration: none !important; /* 페이지바의 a 태그에 밑줄 없애기 */
}

</style>

<script type="text/javascript">

	$(document).ready(function(){

		// 글제목 hover 이벤트
		$("span.subject").hover(function(e) { // mouseover
			$(e.target).addClass("subjectStyle");
			
		}, function(e) { // mouseout
			$(e.target).removeClass("subjectStyle");
			
		});
		
	});// end of $(document).ready(function(){})-------------------
	
</script>


<div class="container" style="margin: 3% auto; width: 100%; height: 700px;">

	<form name="searchFrm">
		<div class="d-flex mb-5">
			<select class="mr-3" name="searchType" style="width: 7%;">
				<option value="subject">글제목</option>
				<option value="content">글내용</option>
				<option value="name">작성자</option>
			</select>
			
			<input type="text" id="boardSearch" class="mr-3" name="searchWord" />
			<button type="button" id="searchBtn" class="btn">
				<i class="fa-solid fa-magnifying-glass"></i>&nbsp;검색
			</button>
		</div>
	</form>
	
	<table id="freeBoard" class="table table-hover" style="width: 100%;">
		<thead>
			<tr>
				<th style="width: 7%;  text-align: center;">순번</th>
				<th style="width: 50%; text-align: center;">제목</th>
				<th style="width: 10%;  text-align: center;">성명</th>
				<th style="width: 20%; text-align: center;">날짜</th>
				<th style="width: 8%;  text-align: center;">조회수</th>
			</tr>
		</thead>
		
		<tbody>
			<c:if test="${not empty requestScope.freeBoardList}">\
				<c:forEach var="boardvo" items="${requestScope.freeBoardList}" varStatus="status">
					<tr>
						<td align="center">
							${(requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (status.index)}
							<%-- >>> 페이징 처리 시 보여주는 순번 공식 <<<
								데이터개수 - (페이지번호 - 1) * 1페이지당보여줄개수 - 인덱스번호 => 순번  --%>
						</td>
						<td>
							<%-- 첨부파일이 없는 경우 --%>
							<c:if test="${empty boardvo.fileName}">
							
								<c:if test="${boardvo.commentCount > 0}">
									<span onclick="goView('${boardvo.seq}')">
										${boardvo.subject}&nbsp;
										<span style="color: #ff5000; font-size: 1rem; font-weight: bold;">
											[${boardvo.commentCount}]
										</span>
									</span>
								</c:if>
								
								<c:if test="${boardvo.commentCount == 0}">
									<span onclick="goView('${boardvo.seq}')">${boardvo.subject}</span>
								</c:if>
							</c:if>
							
							<%-- 첨부파일이 있는 경우 --%>
							<c:if test="${not empty boardvo.fildName}">
								<c:if test="${boardvo.commentCount > 0}">
									<span onclick="goView('${boardvo.seq}')">
										${boardvo.subject}&nbsp;
										<i class="fa-regular fa-image" style="color: green; font-size: 1rem;"></i>
										&nbsp;
										<span style="color: #ff5000; font-size: 1rem; font-weight: bold;">
											[${boardvo.commentCount}]
										</span>
									</span>
								</c:if>
								
								<c:if test="${boardvo.commentCount == 0}">
									<span onclick="goView('${boardvo.seq}')">
										${boardvo.subject}&nbsp;
										<i class="fa-regular fa-image" style="color: green; font-size: 1rem;"></i>
									</span>
								</c:if>
							</c:if>
						</td>
						<td>${boardvo.name}</td>
						<td>${boardvo.regDate}</td>
						<td>${boardvo.readCount}</td>
					</tr>
				</c:forEach>
			</c:if>
			
			<c:if test="${empty requestScope.boardList}">
				<tr>
					<td colspan="5" style="text-align: center;">데이터가 없습니다.</td>
				</tr>
			</c:if>
		
			<%--
			<tr>
				<td align="center">5</td>
				<td>제주도 여행 코스 추천해 주세요</td>
				<td align="center">김다영</td>
				<td align="center">2024-07-09 16:48</td>
				<td align="center">2</td>
			</tr>
			<tr>
				<td align="center">4</td>
				<td>뚜벅이를 위한 버스 투어가 있을까요? <span style="color: #ff5000; font-size: 1rem; font-weight: bold;">[10]</span></td>
				<td align="center">김다영</td>
				<td align="center">2024-07-09 16:48</td>
				<td align="center">14</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td>제주도 해수욕장 파라솔 관련 문의</td>
				<td align="center">김다영</td>
				<td align="center">2024-07-09 16:48</td>
				<td align="center">1</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>안내 책자를 받고 싶어요</td>
				<td align="center">김다영</td>
				<td align="center">2024-07-09 16:48</td>
				<td align="center">5</td>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>제주도 도민들이 인정하는 관광지&nbsp;
					<i class="fa-regular fa-image" style="color: green; font-size: 1rem;"></i>
				</td>
				<td align="center">김다영</td>
				<td align="center">2024-07-09 16:48</td>
				<td align="center">7</td>
			</tr>
			--%>
		</tbody>
	</table>
	
	<div id="pageBar" class="text-center mb-5" style="width: 80%; margin: 0 auto;">
		${requestScope.pageBar}
	</div>
</div>

	
	
	