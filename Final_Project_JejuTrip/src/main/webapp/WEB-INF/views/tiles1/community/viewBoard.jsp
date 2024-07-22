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
	
	button#fileDownload:hover {
		color: #ff5000 !important;
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
	
	div.comment {
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
	
	div.comment-info textarea:focus {
		outline: none;
	}
	
	button#addCommentBtn,
	button#replyCommentBtn {
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
		
		goViewComment(1); // 댓글 목록 불러오기
		
		$("div.comment-info").hide();
		
		$(document).on("div#cmtInfoBtn", "click", function() {})
		
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
		
		$(document).on("click", "div.more-options > span", function(e) {
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
	    
	    
	    // 댓글 내용 엔터 클릭 시 댓글 쓰기
	    $("textarea[name='content']").keyup(function(e) {
	    	if(e.keyCode == 13) {
	    		goAddComment();
	    	}
	    });
	    
	    
	    // === 글 삭제 모달 ===
	    $('#deleteBoardModal').on('shown.bs.modal', function () {
	        $("input[name='pw']").trigger('focus');
	    });
	    
	    $('#deleteBoardModal').on('hidden.bs.modal', function () {
	        $("input[name='pw']").val("");
	    });
	    
	    $("input[name='pw']").keyup(function(e) {
	    	if(e.keyCode == 13) {
	    		goDeleteBoard("${requestScope.boardvo.seq}");
	    	}
	    });
	    
	    
	    // 내 댓글에서 '수정' 버튼을 누를 경우 (댓글 수정)
	    $(document).on("click", "span#updateComment", function(e) {
	    	
	        // 클릭된 span#updateComment 요소에 대한 댓글 최상위 div
	        const commentDiv = $(this).parent().parent().parent();
	        
	        // 원래 commentDiv의 html을 저장
	        const originalHtml = commentDiv.html();
	        
	        const seq = commentDiv.find("input#cmt_seq").val();
	        const orgContent = commentDiv.find("span#cmt_content");
	        const orgContentText = orgContent.text();
	        
	        let v_html = `<div style="border: solid 1px #a6a6a6; width: 97%; margin: 0 auto; padding: 1.5% 1%">
	        				 <div class="d-flex justify-content-between">
		        				 <span class="d-block mb-2">
		        				 <%--
		        				 	<input type="hidden" name="seq" value="\${seq}">
		        				 	<input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}">
		        				 --%>
		        				 	<input type="text" class="font-weight-bold" name="name" value="${sessionScope.loginuser.user_name}" style="border: none; background-color: #FAFAFA;" readonly>
		        				 </span>
		        				 <button type="button" class="btn cancel-btn" style="padding: 0 0.5% 0 0;">취소</button>
	        				 </div>
	        				 <textarea class="mb-2" id="new_content" style="width: 100%; height: 80px; border: none; background-color: #fafafa;" placeholder="댓글을 작성해주세요.">\${orgContentText}</textarea>
	 						 <div style="text-align: right;"><button type="button" class="btn" id="updateCommentBtn" style="border: solid 1px #737373;">수정</button></div>
	        			  </div>`;
	        
	        commentDiv.html(v_html);
	        
	     	// new_content에 포커스 될 때 커서를 맨 끝으로 이동
            setTimeout(function() {
		        const textarea = $("textarea#new_content");
		        textarea.focus();
		        const val = textarea.val();
		        textarea.val('').val(val); // 텍스트 영역의 값을 업데이트 하여 커서를 끝으로 이동
		    }, 0);
	        
	     	
	        // 취소 버튼 클릭 이벤트 추가
	        commentDiv.find(".cancel-btn").on("click", function() {
	            commentDiv.html(originalHtml);
	        });
	        
	        
	        // 댓글내용에서 엔터 클릭 시
	        $("textarea#new_content").keyup(function(e) {
	        	if(e.keyCode == 13) {
	        		$("button#updateCommentBtn").click();
	        	}
	        });
	        
	        
	        // 댓글 수정
	        $("button#updateCommentBtn").click(function() {
	        	
	        	const new_content = $("textarea#new_content").val().trim();
	        	
	        	if(new_content == "") {
	        		alert("댓글 내용을 입력하세요!");
	        		return;
	        	}
	        	
	        	$.ajax({
	        		url: "<%=ctxPath%>/community/updateComment.trip",
	        		data: {
						"seq": seq,
	        			"new_content": new_content
	        		},
	        		type: "post",
	        		dataType: "json",
	        		success: function(json) {
	        			if(json.n == 1) {
	        				// 현재 수정한 댓글이 있는 페이지를 보여준다.
	        				const currentShowPageNo = commentDiv.parent().find("input.currentShowPageNo").val();
	        				goViewComment(currentShowPageNo);
	        			}
	        		},
	        		error: function(request, status, error){
      					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      		      	}
	        	});
	        	
	        });
	    }); // end of $(document).on("click", "span#updateComment", function(e) {}) ------------------
	    
	    
	    // 내 댓글에서 '삭제' 버튼을 누를 경우 (댓글 삭제)
	    $(document).on("click", "span#deleteComment", function(e) {
	    	
	    	// 클릭된 span#deleteComment 요소에 대한 댓글 최상위 div
	        const commentDiv = $(this).parent().parent().parent();
	    	
	        const seq = commentDiv.find("input#cmt_seq").val();
			
	        if(confirm("댓글을 삭제하시겠습니까?")) {
	        	
	        	$.ajax({
	        		url: "<%=ctxPath%>/community/deleteComment.trip",
	        		data: {
	        			"seq": seq,
	        			"parentSeq": "${requestScope.boardvo.seq}"
	        		},
	        		type: "post",
	        		dataType: "json",
	        		success: function(json) {
	        			if(json.n == 1) {
	        				updateCommentCount();
	        				goViewComment(1);
	        			}
	        		},
	        		error: function(request, status, error){
      					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      		      	}
	        	});
	        }
	    	
	    }); // end of $(document).on("click", "span#deleteComment", function(e) {}) ---------------------------
	    
	    
	 	// 댓글의 '답글' 버튼 클릭 시 댓글 작성창 추가
	    $(document).on("click", ".reply-btn", function() {
	        // 기존에 열려있는 댓글 작성창이 있으면 제거
	        $("form[name='replyCommentFrm']").remove();

	        // 클릭된 '답글' 버튼의 부모 요소를 찾음
	        const replyAreaDiv = $(this).closest('.comment').find('.reply-area');

	        // 댓글 작성창 HTML
	        const replyForm = `
	        	<form name="replyCommentFrm">
	        	<div class="d-flex justify-content-between mb-3">
	        		<i class="fa-solid fa-reply"></i>
					<div style="border: solid 1px #a6a6a6; width: 95%; padding: 1.5% 1%; background-color: #f2f2f2;">
						<span class="d-block mb-2">
							<c:if test="${not empty sessionScope.loginuser}">
								<input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}">
								<input type="text" class="font-weight-bold" name="name" value="${sessionScope.loginuser.user_name}" style="border: none; background-color: #f2f2f2;" readonly>
							</c:if>
						</span>
						<textarea class="mb-2" id="reply_content" name="content" style="width: 100%; height: 80px; border: none; background-color: #f2f2f2;" placeholder="답글을 작성해주세요."></textarea>
						<input type="hidden" name="parentSeq" value="${requestScope.boardvo.seq}" readonly />
						<input type="hidden" name="fk_seq" value="${requestScope.boardvo.seq}" readonly />
						<div style="text-align: right;"><button type="button" class="btn" id="replyCommentBtn">등록</button></div>
					</div>
				</div>
				</form>
	        `;
			
	        replyAreaDiv.html(replyForm);
	    });
	    
	    
	    // 답댓글 등록
	    $(document).on("click", "button#replyCommentBtn", function(e) {
	    	
			const reply_content = $("textarea#reply_content").val().trim();
			
			if(reply_content == "") {
				alert("답글 내용을 입력하세요!");
				return;
			}
			
	    	const fk_seq = $(this).closest(".comment").find("input#cmt_seq").val();
//	    	alert(fk_seq);
	    	
	    	const queryString = $("form[name='replyCommentBtn']").serialize();
	    	
			$.ajax({
				url: "<%=ctxPath%>/community/addComment.trip",
				data: queryString,
				type: "post",
				dataType: "json",
				success: function(json) {
					
					if(json.n == 1) {
//						alert("댓글 등록 성공!");
						updateCommentCount();
						goViewComment(1); // 페이징 처리한 댓글 읽어오기
					}

					$("textarea[name='content']").val(""); // 댓글 칸 내용 비우기
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
	    });
	    
	    
	}); // end of $(document).ready(function() {}) ---------------------
	
	
	// === 글 삭제 ===
	function goDeleteBoard(seq) {
		
		const pw = $("input[name='pw']").val().trim();
		
		if(pw == "") {
			alert("글암호를 입력하세요!");
			return;
		}
		
		if(pw != "${requestScope.boardvo.pw}") {
			alert("글암호가 일치하지 않습니다.\n다시 입력해 주세요.");
			$("input[name='pw']").val("").focus();
			return;
		}
		
		if(confirm("글을 삭제하시겠습니까?")) {
			$.ajax({
				url: "<%=ctxPath%>/community/deleteBoard.trip",
				data: {
					"seq": seq,
					"pw": pw,
					"login_id": "${sessionScope.loginuser.userid}"
				},
				type: "post",
				dataType: "json",
				success: function(json) {
					if(json.n == 1) {
						alert("글이 삭제되었습니다.");
						
						if(${requestScope.boardvo.category} == 1) {
							location.href = "<%=ctxPath%>/community/freeBoard.trip";
							
						} else if(${requestScope.boardvo.category} == 2) {
							location.href = "<%=ctxPath%>/community/lodgingBoard.trip";
							
						} else if(${requestScope.boardvo.category} == 3) {
							location.href = "<%=ctxPath%>/community/playBoard.trip";
							
						} else if(${requestScope.boardvo.category} == 4) {
							location.href = "<%=ctxPath%>/community/foodBoard.trip";
							
						}
					}
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
		}
	} // end of function goDeleteBoard(seq) ---------------------------------
	
	
	// === 이전글, 다음글 보기 ===
	function goView(seq) {

    	const goBackURL = "${requestScope.goBackURL}";
    	
    	const frm = document.goViewFrm;
		frm.seq.value = seq;
		frm.category.value = "${requestScope.boardvo.category}";
		frm.goBackURL.value = goBackURL;		
		
		if(${not empty requestScope.paraMap}) { // 검색 조건이 있을 경우
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		
		frm.method = "post";
		frm.action = "<%=ctxPath%>/community/viewBoard_2.trip";
		frm.submit();
		
	} // end of function goView(seq) ------------------------------------
	
	
	// === 첨부파일 다운로드 받기 ===
	function goFileDownload(seq, category) {
		
		if(${empty sessionScope.loginuser && empty sessionScope.loginCompanyuser}) {
			alert("로그인 후 다운로드가 가능합니다.");
			return;
			
		} else {
			location.href = "<%=ctxPath%>/fileDownload.trip?seq=" + seq + "&category=" + category;
		}
		
	} // end of function goFileDownload(seq, category) --------------------
	
	
	// === 댓글 쓰기 ===
	function goAddComment() {
		
		const comment_content = $("textarea[name='content']").val().trim();
		
		if(comment_content == "") {
			alert("댓글 내용을 입력하세요!");
			return;
		}
		
		const queryString = $("form[name='addCommentFrm']").serialize();
		
		$.ajax({
			url: "<%=ctxPath%>/community/addComment.trip",
			data: queryString,
			type: "post",
			dataType: "json",
			success: function(json) {
				
				if(json.n == 1) {
//					alert("댓글 등록 성공!");
					updateCommentCount();
					goViewComment(1); // 페이징 처리한 댓글 읽어오기
				}

				$("textarea[name='content']").val(""); // 댓글 칸 내용 비우기
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	} // end of function goAddComment() -----------------
	
	
	// 댓글 목록 보기 (+페이징 처리)
	function goViewComment(currentShowPageNo) {
		
		$.ajax({
			url: "<%=ctxPath%>/community/viewComment.trip",
			data: {
				"parentSeq":"${requestScope.boardvo.seq}",
				"currentShowPageNo":currentShowPageNo
			},
			dataType: "json",
			success: function(json) {
				
				let v_html = ``;
				
				if(json.length > 0) {
					$.each(json, function(index, item) {
						
						v_html += `<div id="comment\${index}" class="comment">
									<div class="d-flex" style="padding: 1.5% 0">
				  					 <div style="width: 90%; padding: 1.5% 0">
										<div class="mb-2 d-flex align-items-center">
											<img src="<%=ctxPath%>/resources/images/logo_circle.png" width="30">
											<span class="font-weight-bold" style="margin-left: 1%; font-size: 1rem;">\${item.name}</span>
										</div>
										<input type="hidden" id="cmt_seq" value="\${item.seq}">
										<input type="hidden" id="cmt_userid" value="\${item.fk_userid}">
										<span class="d-block mb-2" id="cmt_content">\${item.content}</span>
										<span class="d-block mb-2" id="cmt_regDate" style="font-size: 0.8rem; color: #8c8c8c;">\${item.regdate}</span>
										<button type="button" class="btn reply-btn" style="border: solid 1px #8c8c8c; font-size: 0.8rem; padding: 3px 6px;">답글</button>
									 </div>`;
						
						if(${sessionScope.loginuser != null} && 
							("${sessionScope.loginuser.userid}" == item.fk_userid)) {
										 
							v_html += `  <div class="more-options" style="width: 10%; padding-top: 1.5%; text-align: right;">
											<span><i class="fa-solid fa-ellipsis-vertical"></i></span>
											<div class="options-menu" style="display: none;">
												<span id="updateComment" class="d-block mb-1">수정</span>
												<span id="deleteComment" class="d-block">삭제</span>
											</div>
										 </div>`;
						}
						
						v_html += `		<input type="hidden" value="\${currentShowPageNo}" class="currentShowPageNo">
							   		  </div>
								   	  <div class="reply-area"></div>
								   </div>`;
						
					}); // end of $.each() -------------------------------------------------
					
					$("div#commentList").html(v_html);
					
					const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
					
					makeCommentPageBar(currentShowPageNo, totalPage);
				}
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	} // end of function goViewComment(currentShowPageNo) ------------------
	
	
	// 댓글 페이지바 만들기
	function makeCommentPageBar(currentShowPageNo, totalPage) {
		
		const blockSize = 10;
		
		let loop = 1;
		
		let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		let pageBar_HTML = "<ul>";
		
		// [맨처음][이전] 만들기
		if(pageNo != 1) {
			pageBar_HTML += "<li style='width: 4%; font-size: 0.8rem;'><a href='javascript:goViewComment(1)'>◀◀</a></li>";
			pageBar_HTML += "<li style='width: 4%; font-size: 0.8rem;'><a href='javascript:goViewComment("+ (pageNo-1) + ")'>◀</a></li>";
		}
		
		while(!(loop > blockSize || pageNo > totalPage)) {
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li class='font-weight-bold' style='width: 3%; color: #ff5000;'>" + pageNo + "</li>";
				
			} else {
				pageBar_HTML += "<li style='width: 3%;'><a href='javascript:goViewComment(" + pageNo + ")'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
		} // end of while() -------------------------
		
		// [다음][마지막] 만들기
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li style='width: 4%; font-size: 0.8rem;'><a href='javascript:goViewComment("+ pageNo + ")'>▶</a></li>";
			pageBar_HTML += "<li style='width: 4%; font-size: 0.8rem;'><a href='javascript:goViewComment("+ totalPage + ")'>▶▶</a></li>";
		}

		pageBar_HTML += "</ul>";
		
		$("div#commentPageBar").html(pageBar_HTML);
		
	} // end of function makeCommentPageBar(currentShowPageNo, totalPage) --------------
	
	
	// 댓글 개수 업데이트하기
	function updateCommentCount() {
	    $.ajax({
	        url: "<%=ctxPath%>/community/getCommentCount.trip",
	        data: {
	            "seq": "${requestScope.boardvo.seq}"
	        },
	        type: "post",
	        dataType: "json",
	        success: function(json) {
	            	if(json.commentCount > 0) {
		                $('span#commentText').html(`댓글 \${json.commentCount}`);
	            		
	            	} else {
		                $('span#commentText').html(`댓글 쓰기`);
	            	}
	        },
	        error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
	    });
	} // end of function updateCommentCount() -----------------------
	
	

	
</script>

<div style="background-color: rgba(242, 242, 242, 0.4); border: solid 1px rgba(242, 242, 242, 0.4);">
	
	<div class="container" id="addBoardDiv">
		
		<div class="board-info mt-5 mb-5" style="width: 80%; margin: 0 auto;">
		
			<div>
				<hr style="border: 0; height: 2px; background-color: black; margin-bottom: 3%;">
				<div class="ml-2">
					<span id="category">
						<c:if test="${requestScope.boardvo.category == 1}">자유게시판</c:if>
						<c:if test="${requestScope.boardvo.category == 2}">숙박</c:if>
						<c:if test="${requestScope.boardvo.category == 3}">관광지&nbsp;/&nbsp;체험</c:if>
						<c:if test="${requestScope.boardvo.category == 4}">맛집</c:if>
						<c:if test="${requestScope.boardvo.category == 5}">구인</c:if>
					</span>
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
									<span id="updateBoard" onclick="location.href='<%=ctxPath%>/community/updateBoard.trip?seq=${requestScope.boardvo.seq}'">수정</span>&nbsp;&nbsp;|&nbsp;&nbsp;
									<span id="deleteBoard" data-toggle="modal" data-target="#deleteBoardModal">삭제</span>
								</div>
							</c:if>
						</c:if>
					</div>
				</div>
				<hr>
			</div>
			
			<%-- 글 삭제 모달 --%>
			<div class="modal fade" id="deleteBoardModal" data-backdrop="static" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModalLabel">글 삭제</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body mt-3 mb-3">
							<label>글 암호 입력</label>
							<input type="password" name="pw" maxlength="4" class="ml-2" style="width: 50%; height: 40px; border-radius: none; border: solid 1px #ccc;">
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-danger" onclick="goDeleteBoard('${requestScope.boardvo.seq}')">삭제</button>
						</div>
					</div>
				</div>
			</div>


			<div id="content">
				${requestScope.boardvo.content}
			</div>
			
			<c:if test="${not empty requestScope.boardvo.fileName}">
				<div id="attachFile" class="d-flex justify-content-between align-items-center" style="border: solid 1px #ccc; margin-bottom: 5%; padding: 1.5%;">
					<div>
						<i class="fa-regular fa-folder" style="font-size: 1.2rem;"></i>
						<span class="ml-2">${requestScope.boardvo.orgFilename}</span>
					</div>
					<div>
						<button type="button" id="fileDownload" class="btn" onclick="goFileDownload('${requestScope.boardvo.seq}', '${requestScope.boardvo.category}')" style="padding: 0; color: #808080;">
							<i class="fa-solid fa-download" style="font-size: 1.2rem;"></i>
						</button>
					</div>
				</div>
			</c:if>
			
			<hr>
		</div>
		
		<div style="width: 80%; margin: 0 auto;">
			<div id="cmtInfoBtn" class="cmt-no-drop text-center d-flex justify-content-between" style="width: 13%; padding: 0.5%;">
				<div>
					<i class="fa-solid fa-comment-dots"></i>
					<span id="commentText">
						<c:if test="${requestScope.boardvo.commentCount == 0}">댓글 쓰기</c:if>
						<c:if test="${requestScope.boardvo.commentCount > 0}">댓글 ${requestScope.boardvo.commentCount}</c:if>
					</span>
				</div>
				<div id="cmtDropdownBar"><i class="fa-solid fa-angle-down"></i></div>
			</div>
		</div>
		
		<div class="comment-info mb-5" style="width: 80%; margin: 0 auto;">
			<div id="commentList"></div>

			<div id="commentPageBar" class="text-center mt-3 mb-5" style="width: 80%; margin: 0 auto 10% auto;">
			</div>
			
			<c:if test="${not empty sessionScope.loginuser}">
				<form name="addCommentFrm">
					<div class="mt-2" style="border: solid 1px #a6a6a6; padding: 1.5% 1%">
						<span class="d-block mb-2">
							<c:if test="${not empty sessionScope.loginuser}">
								<input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}">
								<input type="text" class="font-weight-bold" name="name" value="${sessionScope.loginuser.user_name}" style="border: none; background-color: #FAFAFA;" readonly>
							</c:if>
						</span>
						<textarea class="mb-2" name="content" style="width: 100%; height: 100px; border: none; background-color: #fafafa;" placeholder="댓글을 작성해주세요."></textarea>
						<input type="hidden" name="parentSeq" value="${requestScope.boardvo.seq}" readonly />
						<div style="text-align: right;"><button type="button" class="btn" id="addCommentBtn" onclick="goAddComment()">등록</button></div>
					</div>
				</form>
			</c:if>
			
			<c:if test="${empty sessionScope.loginuser && empty sessionScope.loginCompanyuser}">
				<div class="mt-3" style="border: solid 1px #a6a6a6; padding: 1.5% 1%">
					<textarea class="mb-2" style="width: 100%; height: 100px; border: none; background-color: rgba(242, 242, 242, 0.3);" placeholder="댓글을 작성하려면 로그인하세요." onclick="javascript:location.href='<%=ctxPath%>/login.trip'" readonly></textarea>
				</div>
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
			<c:if test="${requestScope.boardvo.category == 1}">
				<button type="button" class="btn btn-success mr-3" onclick="javascript:location.href='<%=ctxPath%>/community/freeBoard.trip'">전체 목록</button>
			</c:if>
			<c:if test="${requestScope.boardvo.category == 2}">
				<button type="button" class="btn btn-success mr-3" onclick="javascript:location.href='<%=ctxPath%>/community/lodgingBoard.trip'">전체 목록</button>
			</c:if>
			<c:if test="${requestScope.boardvo.category == 3}">
				<button type="button" class="btn btn-success mr-3" onclick="javascript:location.href='<%=ctxPath%>/community/playBoard.trip'">전체 목록</button>
			</c:if>
			<c:if test="${requestScope.boardvo.category == 4}">
				<button type="button" class="btn btn-success mr-3" onclick="javascript:location.href='<%=ctxPath%>/community/foodBoard.trip'">전체 목록</button>
			</c:if>
			
			<c:if test="${not empty requestScope.goBackURL}">
				<button type="button" class="btn btn-secondary" onclick="javascript:location.href='<%=ctxPath%>${requestScope.goBackURL}'">검색된 결과 목록</button>
			</c:if>
		</div>
	
	</div>

</div>


<%-- === #138. 이전글, 다음글 보기 === --%>
<form name='goViewFrm'>
	<input type="hidden" name="seq" />
	<input type="hidden" name="category" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form>


