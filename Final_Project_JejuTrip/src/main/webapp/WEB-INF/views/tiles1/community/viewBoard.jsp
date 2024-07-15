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
	
	span#updateBoard:hover,
	span#deleteBoard:hover {
		cursor: pointer;
		opacity: 0.7;
	}
	
	div#content {
		border: solid 0px red;
		padding: 5% 2%; 
	}
	
	div#cmtInfoBtn {
		cursor: pointer;
	}
	
	.cmt-no-drop {
		border: solid 1px #a6a6a6;
		color: #666;
	}
	
	.cmt-dropdown {
		border: solid 1px #ff7433;
		color: #ff7433;
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
		text-align: center;
		padding: 0;
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
	
	form[name='addCommentFrm'] textarea:focus {
		outline: none;
	}
	
	button#addCommentBtn {
		border: solid 1px #737373;
	}
	
	span.move {
		font-weight: 600;
	}
	
	span.move:hover {
		cursor: pointer;
		opacity: 0.7;
	}
</style>

<script type="text/javascript">
	
	$(document).ready(function() {
		
		$("div.comment-info").hide();
		
		$("div#cmtInfoBtn").click(function() {
			$("div.comment-info").toggle();
			
			if ($("div.comment-info").is(":visible")) {
	            $(this).removeClass("cmt-no-drop");
	            $(this).addClass("cmt-dropdown");
	            $("div#cmtDropdownBar > i").removeClass("fa-angle-down");
	            $("div#cmtDropdownBar > i").addClass("fa-angle-up");
	        } else {
	            $(this).removeClass("cmt-dropdown");
	            $(this).addClass("cmt-no-drop");
	            $("div#cmtDropdownBar > i").removeClass("fa-angle-up");
	            $("div#cmtDropdownBar > i").addClass("fa-angle-down");
	        }
		});
		
		
		
		
		
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
	
	
	// === 이전글, 다음글 보기 ===
	function goView(seq) {

    	const goBackURL = "${requestScope.goBackURL}";
    	
    	const frm = document.goViewFrm;
		frm.seq.value = seq;
		frm.goBackURL.value = goBackURL;		

		if(${not empty requestScope.paraMap}) { // 검색 조건이 있을 경우
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		  
		frm.method = "post";
		frm.action = "<%=ctxPath%>/community/viewBoard_2.trip";
		frm.submit();
		
	} // end of function goView(seq) -------------------
	
</script>

<div style="background-color: rgba(242, 242, 242, 0.4); border: solid 1px rgba(242, 242, 242, 0.4);">
	
	<div class="container" id="addBoardDiv">
		
		<div class="board-info mt-5 mb-5" style="width: 80%; margin: 0 auto;">
		
			<div>
				<hr style="border: 0; height: 2px; background-color: black; margin-bottom: 3%;">
				<div class="ml-2">
					<span id="category">${requestScope.boardvo.category}</span>
					<h4 class="mt-4 mb-4">${requestScope.boardvo.subject}</h4>
					<div class="d-flex justify-content-between" style="font-size: 0.9rem;">
						<div>
							<span>작성자 : ${requestScope.boardvo.name}</span>&nbsp;&nbsp;|&nbsp;
							<span>작성일 : ${requestScope.boardvo.regDate}</span>&nbsp;&nbsp;|&nbsp;
							<span>조회수 : ${requestScope.boardvo.readCount}</span>
						</div>
						<c:if test="${not empty sessionScope.loginuser}">
							<c:if test="${requestScope.boardvo.fk_userid == sessionScope.loginuser.userid}">
								<div class="mr-2 d-flex justify-content-end" style="width: 10%;">
									<span id="updateBoard">수정</span>&nbsp;&nbsp;|&nbsp;&nbsp;
									<span id="deleteBoard">삭제</span>
								</div>
							</c:if>
						</c:if>
						<c:if test="${not empty sessionScope.loginCompanyuser}">
							<c:if test="${requestScope.boardvo.fk_userid == sessionScope.loginCompanyuser.companyid}">
								<div class="mr-2 d-flex justify-content-end" style="width: 10%;">
									<span id="updateBoard">수정</span>&nbsp;&nbsp;|&nbsp;&nbsp;
									<span id="deleteBoard">삭제</span>
								</div>
							</c:if>
						</c:if>
					</div>
				</div>
				<hr>
			</div>
			
			<div id="content">
				${requestScope.boardvo.content}
			</div>
			
			<hr>
		</div>
		
		<div style="width: 80%; margin: 0 auto;">
			<div id="cmtInfoBtn" class="cmt-no-drop text-center d-flex justify-content-between" style="width: 13%; padding: 0.5%;">
				<div>
					<i class="fa-solid fa-comment-dots"></i>
					댓글 쓰기&nbsp;
				</div>
				<div id="cmtDropdownBar"><i class="fa-solid fa-angle-down"></i></div>
			</div>
		</div>
		
		<div class="comment-info mb-5" style="width: 80%; margin: 0 auto;">
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
					<li style='width: 4%; font-size: 0.8rem;'>◀◀</li>
					<li style='width: 4%; font-size: 0.8rem;'>◀</li>
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
					<li style='width: 4%; font-size: 0.8rem;'>▶</li>
					<li style='width: 4%; font-size: 0.8rem;'>▶▶</li>
				</ul>
			</div>
			
			<c:if test="${not empty sessionScope.loginuser || not empty sessionScope.loginCompanyuser}">
				<form name="addCommentFrm">
					<div style="border: solid 1px #a6a6a6; margin-top: 10%; padding: 1.5% 1%">
						<c:if test="${not empty sessionScope.loginuser}">
							<span class="d-block mb-2 font-weight-bold">${sessionScope.loginuser.user_name}</span>
						</c:if>
						<c:if test="${not empty sessionScope.loginCompanyuser}">
							<span class="d-block mb-2 font-weight-bold">${sessionScope.loginCompanyuser.company_name}</span>
						</c:if>
						<textarea class="mb-2" style="width: 100%; height: 100px; border: none; background-color: rgba(242, 242, 242, 0.3);" placeholder="댓글을 작성해주세요."></textarea>
						<div style="text-align: right;"><button type="button" class="btn" id="addCommentBtn">등록</button></div>
					</div>
				</form>
			</c:if>
		</div>
		
		<div style="width: 80%; margin: 7% auto;">
			<c:if test="${not empty requestScope.boardvo.previousseq}">
				<div class="mb-3"><span class="mr-4">이전글</span><span class="move" onclick="goView('${requestScope.boardvo.previousseq}')">${requestScope.boardvo.previoussubject}</span></div>
			</c:if>
			<c:if test="${not empty requestScope.boardvo.nextseq}">
				<div class="mb-3"><span class="mr-4">다음글</span><span class="move" onclick="goView('${requestScope.boardvo.nextseq}')">${requestScope.boardvo.nextsubject}</span></div>
			</c:if>
		</div>
		
		<div class="text-center">
			<c:if test="${requestScope.boardvo.category == '자유게시판'}">
				<button type="button" class="btn btn-success mr-3" onclick="javascript:location.href='<%=ctxPath%>/community/freeBoard.trip'">전체 목록</button>
			</c:if>
			<button type="button" class="btn btn-secondary">검색된 결과 목록</button>
		</div>
	
	</div>

</div>


<%-- === #138. 이전글, 다음글 보기 === --%>
<form name='goViewFrm'>
	<input type="hidden" name="seq" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form> 


