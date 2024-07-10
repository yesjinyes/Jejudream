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
	margin-bottom: 20%;
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



</style>

<script type="text/javascript">

	$(document).ready(function(){
	    	
	});// end of $(document).ready(function(){})-------------------
	
</script>


<div class="container" style="margin: 3% auto; width: 100%; height: 500px;">

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
			
		</tbody>
	</table>
</div>

	
	
	