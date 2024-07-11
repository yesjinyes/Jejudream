<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
	div.container {
		margin-bottom: 5%;
	}
	
	h4 {
		font-size: 1.5em;
	}
	
	span#category {
		width: 5%;
		border: solid 0px red;
		padding: 0.5% 0.8%;
		border-radius: 15px;
		background-color: #ff7433;
		color: white;
		font-size: 0.9rem;
	}
	
	div#content {
		border: solid 0px red;
		padding: 5% 2%; 
	}
	
	div#comment {
		border-bottom: solid 1px #ccc;
	}
	
	div.options-menu {
		background-color: white;
		border: solid 1px #ccc;
		padding: 2px;
		width: 55%;
		text-align: center;
		margin-left: 46%;
	}
	
	div.more-options span:hover {
		cursor: pointer;
		font-weight: bold;
	}
	
	div#commentPageBar > ul {
		list-style: none;
	}
	
	div#commentPageBar > ul li {
		display: inline-block;
		font-size: 12pt;
		border: solid 0px red;
		text-align: center;
		color: #666666;
	}
	
	div#commentPageBar > ul li:hover {
		font-weight: bold;
		color: black;
		cursor: pointer;
	}
	
	div#commentPageBar a {
		text-decoration: none !important; /* 페이지바의 a 태그에 밑줄 없애기 */
	}
</style>

<script type="text/javascript">
	
	$(document).ready(function() {
		
		
		
		
		
		
		
		// ===== 댓글 메뉴 =====
		$("div.options-menu").hide();
		
		$("div.more-options > span").click(function(e) {
			e.stopPropagation(); // 이벤트 버블링 방지
        	$(this).next("div.options-menu").toggle();
		});
		
		// 메뉴 외부를 클릭하면 메뉴를 숨기기
	    $(document).click(function() {
	        $("div.options-menu").hide();
	    });

	    // 메뉴 내부를 클릭하면 메뉴가 닫히지 않도록
	    $("div.options-menu").click(function(e) {
	        e.stopPropagation();
	    });
	    
	}); // end of $(document).ready(function() {}) ---------------------
	
</script>

<div style="background-color: rgba(242, 242, 242, 0.4); border: solid 1px rgba(242, 242, 242, 0.4);">
	
	<div class="container" id="addBoardDiv">
		
		<div class="board-info mt-5 mb-5" style="width: 80%; margin: 0 auto;">
		
			<div>
				<hr style="border: 0; height: 2px; background-color: black; margin-bottom: 3%;">
				<div class="ml-2">
					<span id="category">자유게시판</span>
					<h4 class="mt-4 mb-4">제주도 여행 코스 추천해주세요</h4>
					<div class="d-flex justify-content-between" style="font-size: 0.9rem;">
						<div>
							<span>작성자 : 김다영</span>&nbsp;&nbsp;|&nbsp;
							<span>작성일 : 2024-07-10 16:48</span>&nbsp;&nbsp;|&nbsp;
							<span>조회수 : 3</span>
						</div>
						<div class="mr-2 d-flex justify-content-end" style="width: 10%;">
							<span>수정</span>&nbsp;&nbsp;|&nbsp;&nbsp;
							<span>삭제</span>
						</div>
					</div>
				</div>
				<hr>
			</div>
			
			<div id="content">
				<p><span style="font-size: 12pt;">안녕하세요~! 제주도 여행 코스 추천 부탁드려요</span>&nbsp;</p>
				<p><span style="font-size: 12pt;">&nbsp;</span></p>
				<p><span style="font-size: 12pt;">맛집도 같이 소개해주시면 좋아요</span></p>
			</div>
			
			<hr>
		</div>
		
		<div class="comment-info mt-3 mb-5" style="width: 80%; margin: 0 auto;">
			<div id="comment" class="d-flex" style="padding: 1.5% 0">
				<div style="width: 90%; padding: 1.5% 0">
					<span class="d-block font-weight-bold mb-2">김라영</span>
					<span class="d-block mb-2">저도 궁금합니다.<br>대댓 부탁드려용 🍒</span>
					<span class="d-block mb-2" style="font-size: 0.8rem; color: #8c8c8c;">2024-07-11 10:36</span>
					<button type="button" class="btn" style="border: solid 1px #8c8c8c; font-size: 0.8rem; padding: 3px 6px;">답글</button>
				</div>
				<div class="more-options" style="width: 10%; padding-top: 1.5%; text-align: right;">
					<span><i class="fa-solid fa-ellipsis-vertical"></i></span>
					<div class="options-menu">
						<span class="d-block mb-1">수정</span>
						<span class="d-block">삭제</span>
					</div>
				</div>
			</div>
			<div id="comment" class="d-flex" style="padding: 1.5% 0">
				<div style="width: 90%; padding: 1.5% 0">
					<span class="d-block font-weight-bold mb-2">김라영</span>
					<span class="d-block mb-2">관광지 탭을 참조해보세요!</span>
					<span class="d-block mb-2" style="font-size: 0.8rem; color: #8c8c8c;">2024-07-11 10:36</span>
					<button type="button" class="btn" style="border: solid 1px #8c8c8c; font-size: 0.8rem; padding: 3px 6px;">답글</button>
				</div>
				<div class="more-options" style="width: 10%; padding-top: 1.5%; text-align: right;">
					<span><i class="fa-solid fa-ellipsis-vertical"></i></span>
					<div class="options-menu">
						<span class="d-block mb-1">수정</span>
						<span class="d-block">삭제</span>
					</div>
				</div>
			</div>
			
			<div id="commentPageBar" class="text-center mt-3 mb-5" style="width: 80%; margin: 0 auto;">
				<ul>
					<li style='width: 4%;'>◀◀</li>
					<li style='width: 4%;'>◀</li>
					<li class='font-weight-bold' style='width: 3%; color: #ff5000;'>1</li>
					<li style='width: 3%;'>2</li>
					<li style='width: 3%;'>3</li>
					<li style='width: 3%;'>4</li>
					<li style='width: 3%;'>5</li>
					<li style='width: 3%;'>6</li>
					<li style='width: 3%;'>7</li>
					<li style='width: 3%;'>8</li>
					<li style='width: 3%;'>9</li>
					<li style='width: 3%;'>10</li>
					<li style='width: 4%;'>▶</li>
					<li style='width: 4%;'>▶▶</li>
				</ul>
			</div>
			
			<div style="border: solid 1px #a6a6a6; padding: 1.5% 1%">
				<span class="d-block mb-2">배인혁</span>
				<textarea class="mb-2" style="width: 100%; height: 100px; border: none; background-color: rgba(242, 242, 242, 0.3);" placeholder="댓글을 작성해주세요."></textarea>
				<div style="text-align: right;"><button type="button" class="btn btn-info">등록</button></div>
			</div>
		</div>
		
		<div class="text-center">
			<button type="button" id="addBoardBtn" class="btn btn-success mr-3">전체 목록</button>
			<button type="button" id="goBackBtn" class="btn btn-secondary">검색된 결과 목록</button>
		</div>
	
	</div>

</div>