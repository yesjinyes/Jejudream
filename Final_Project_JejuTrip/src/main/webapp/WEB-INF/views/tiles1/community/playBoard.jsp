<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>    

<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/community/community_main.css" />

<style type="text/css">
div.container {
	background-color: none;
}

table#playBoard {
	font-size: 1.2rem;
	margin-bottom: 10%;
}

table#playBoard > thead {
	background-color: #f2f2f2;
}

table#playBoard > tbody > tr {
	font-weight: normal;
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
	cursor: pointer;
}

div#pageBar a {
	text-decoration: none !important; /* 페이지바의 a 태그에 밑줄 없애기 */
}

</style>

<script type="text/javascript">

	$(document).ready(function(){

		// 커뮤니티 카테고리 탭 
		$('input[name="category"]').change(function(e) {
	    	if($(e.target).val() == "") {
	    		location.href = "<%=ctxPath%>/communityMain.trip";
	    		
	    	} else if($(e.target).val() == "1") {
	    		location.href = "<%=ctxPath%>/community/freeBoard.trip";
	    		
	    	} else if($(e.target).val() == "2") {
	    		location.href = "<%=ctxPath%>/community/lodgingBoard.trip";
	    		
	    	} else if($(e.target).val() == "3") {
	    		location.href = "<%=ctxPath%>/community/playBoard.trip";
	    		
	    	} else if($(e.target).val() == "4") {
	    		location.href = "<%=ctxPath%>/community/foodBoard.trip";
	    		
	    	}
	    });
		
		
		// 글제목 hover 이벤트
		$("span.subject").hover(function(e) { // mouseover
			$(e.target).addClass("subjectStyle");
			
		}, function(e) { // mouseout
			$(e.target).removeClass("subjectStyle");
			
		});

		
		// 게시판 검색
		$("input:text[name='searchWord']").bind("keyup", function(e) {
			if(e.keyCode == 13) {
				goSearch();
			}
		});

		// 검색 시 검색 조건, 검색어 값 유지시키기
		if(${not empty requestScope.paraMap}) {
			
			$("select[name='searchType']").val("${requestScope.paraMap.searchType}");
			$("input:text[name='searchWord']").val("${requestScope.paraMap.searchWord}");
		}
		
	});// end of $(document).ready(function(){})-------------------
	
	
	// 게시판 검색
	function goSearch() {
		
		const searchWord = $("input[name='searchWord']").val().trim();
		
		if(searchWord == "") {
			alert("검색어를 입력하세요!");
			return;
		}
		
		const frm = document.searchFrm;
		frm.submit();
		
	} // end of function goSearch() -------------------
	
	
	// 게시판 상세보기
	function goView(seq) {
	
    	const goBackURL = "${requestScope.goBackURL}";
    	
    	const frm = document.goViewFrm;
		frm.seq.value = seq;
		frm.category.value = "3";
		frm.goBackURL.value = goBackURL;		

		if(${not empty requestScope.paraMap}) { // 검색 조건이 있을 경우
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		  
		frm.method = "post";
		frm.action = "<%=ctxPath%>/community/viewBoard.trip";
		frm.submit();
		
	} // end of function goView(seq) ------------------------------
	
	
</script>



<!-- === 상단 카테고리 탭 === -->
<div id="category" class="d-flex justify-content-between">
   
   	<h2>커뮤니티</h2>
   	
	<div class="tabs">
		<input type="radio" id="radio-1" name="category" value="" />
		<label class="tab" for="radio-1">커뮤니티 전체</label>
		
		<input type="radio" id="radio-2" name="category" value="1" />
		<label class="tab" for="radio-2">자유게시판</label>
		
		<input type="radio" id="radio-3" name="category" value="2" />
		<label class="tab" for="radio-3">숙박</label>
		
		<input type="radio" id="radio-4" name="category" value="3" checked />
		<label class="tab" for="radio-4">관광지,체험</label>
		
		<input type="radio" id="radio-5" name="category" value="4" />
		<label class="tab" for="radio-5">맛집</label>
		
		<span class="glider"></span>
	</div>
	<%--
	<div class="search">
		<input type="text" id="inputSearch" placeholder="검색어 입력">
		<img id="imgSearch" src="<%= ctxPath%>/resources/images/community/search.png">
	</div>
	--%>
	
	<div style="width: 7%;">
		<button type="button" id="writeBtn" class="btn" onclick="location.href='<%=ctxPath%>/community/addBoard.trip'">글쓰기</button>
	</div>
</div>


<div class="container" style="margin: 3% auto; width: 100%; height: 800px;">

	<form name="searchFrm">
		<div class="d-flex mb-5">
			<select class="mr-3" name="searchType" style="width: 7%;">
				<option value="subject">글제목</option>
				<option value="content">글내용</option>
				<option value="name">작성자</option>
			</select>
			
			<input type="text" id="boardSearch" class="mr-3" name="searchWord" />
			<button type="button" id="searchBtn" class="btn" onclick="goSearch()">
				<i class="fa-solid fa-magnifying-glass"></i>&nbsp;검색
			</button>
		</div>
	</form>
	
	<div>
	<table id="playBoard" class="table table-hover" style="width: 100%;">
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
			<c:if test="${not empty requestScope.playBoardList}">
				<c:forEach var="boardvo" items="${requestScope.playBoardList}" varStatus="status">
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
									<span class="subject" onclick="goView('${boardvo.seq}')">
										${boardvo.subject}&nbsp;
										<span style="color: #ff5000; font-size: 1rem; font-weight: bold;">
											[${boardvo.commentCount}]
										</span>
									</span>
								</c:if>
								
								<c:if test="${boardvo.commentCount == 0}">
									<span class="subject" onclick="goView('${boardvo.seq}')">${boardvo.subject}</span>
								</c:if>
							</c:if>
							
							<%-- 첨부파일이 있는 경우 --%>
							<c:if test="${not empty boardvo.fileName}">
								<c:if test="${boardvo.commentCount > 0}">
									<span class="subject" onclick="goView('${boardvo.seq}')">
										${boardvo.subject}
										<i class="fa-solid fa-paperclip" style="color: green; font-size: 1rem;"></i>
										<span style="color: #ff5000; font-size: 1rem; font-weight: bold;">
											[${boardvo.commentCount}]
										</span>
									</span>
								</c:if>
								
								<c:if test="${boardvo.commentCount == 0}">
									<span class="subject" onclick="goView('${boardvo.seq}')">
										${boardvo.subject}
										<i class="fa-solid fa-paperclip" style="color: green; font-size: 1rem;"></i>
									</span>
								</c:if>
							</c:if>
						</td>
						<td align="center">${boardvo.name}</td>
						<td align="center">${boardvo.regDate}</td>
						<td align="center">${boardvo.readCount}</td>
					</tr>
				</c:forEach>
			</c:if>
			
			<c:if test="${empty requestScope.playBoardList}">
				<tr>
					<td colspan="5" style="text-align: center;">데이터가 없습니다.</td>
				</tr>
			</c:if>
		
		</tbody>
	</table>
	</div>
	
	<div id="pageBar" class="text-center" style="width: 80%; margin: 0 auto;">
		${requestScope.pageBar}
	</div>

</div>


<%-- === #132. 페이징 처리된 후 특정 글제목을 클릭하여 상세내용을 본 이후
     //        사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
     //        현재 페이지 주소를 뷰단으로 넘겨준다.  --%>
<form name='goViewFrm'>
	<input type="hidden" name="seq" />
	<input type="hidden" name="category" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form>

