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

	div#addBoardDiv input {
		background-color: rgba(242, 242, 242, 0.3);
		border: none;
	}
	
	select[name='category'] {
		background-color: #FAFAFA;
		border-radius: 5px 5px;
		outline: none;
	}
</style>

<script type="text/javascript">
	
	// 전역변수
	var obj = [];
		
	$(document).ready(function() {
		
		<%-- === #166.-2 스마트 에디터 구현 시작 === --%>
		//스마트에디터 프레임생성
		nhn.husky.EZCreator.createInIFrame({
		    oAppRef: obj,
		    elPlaceHolder: "content", // id가 content인 textarea에 에디터를 넣어준다.
		    sSkinURI: "<%=ctxPath%>/resources/smarteditor/SmartEditor2Skin.html",
		    htParams : {
		        // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
		        bUseToolbar : true,            
		        // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
		        bUseVerticalResizer : true,    
		        // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
		        bUseModeChanger : true,
		    }
		});
		<%-- === 스마트 에디터 구현 끝 === --%>
		
		<%-- '글암호'에서 엔터 클릭 시 글 등록 --%>
		$("input:password[name='pw']").keyup(function(e) {
			if(e.keyCode == 13) {
				goAddBoard();
			}
		});
		
		
		<%-- 취소 버튼 클릭 시 --%>
		$("button#goBackBtn").click(function() {
			
			if(confirm("작성하던 내용이 저장되지 않습니다.\n글 등록을 취소하시겠습니까?")) {
				history.back();
			}
		});
		
	}); // end of $(document).ready(function() {}) ---------------------
	
	
	<%-- === 글 등록하기 === --%>
	function goAddBoard() {

		<%-- === 스마트 에디터 구현 시작 === --%>
		// id가 content인 textarea에 에디터에서 대입
		obj.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
		<%-- === 스마트 에디터 구현 끝 === --%>
		// 카테고리 유효성 검사
		const category = $("select[name='category']").val();
		
		if(category == "") {
			alert("카테고리를 선택하세요!");
			return;
		}
		
		
		// 글제목 유효성 검사
		const subject = $("input:text[name='subject']").val().trim();
		
		if(subject == "") {
			alert("제목을 입력하세요!");
			$("input:text[name='subject']").val("").focus(); // 공백 없애기
			return;
		}
		
		
		// 글내용 유효성 검사(스마트 에디터를 사용할 경우)
		let content_val = $("textarea[name='content']").val().trim();
		  
		content_val = content_val.replace(/&nbsp;/gi, "");    // 공백 (&nbsp;)을 "" 으로 변환
		/*    
	 		대상문자열.replace(/찾을 문자열/gi, "변경할 문자열");
	      	==> 여기서 꼭 알아야 될 점은 나누기(/)표시안에 넣는 찾을 문자열의 따옴표는 없어야 한다는 점입니다. 
		                그리고 뒤의 gi는 다음을 의미합니다.
		   
		    g : 전체 모든 문자열을 변경 global
		    i : 영문 대소문자를 무시, 모두 일치하는 패턴 검색 ignore
		*/ 
		 
		content_val = content_val.substring(content_val.indexOf("<p>")+3);
        content_val = content_val.substring(0, content_val.indexOf("</p>"));
		
		if(content_val.trim().length == 0) {
		 alert("내용을 입력하세요!");
		 return;
		}
		
		
		// 글암호 유효성 검사
		const pw = $("input:password[name='pw']").val();
		
		if(pw == "") {
		 alert("글암호를 입력하세요!");
		 $("input:password[name='pw']").focus();
		 return;
		}
		
		
		const frm = document.addBoardFrm;
		frm.method = "post";
		frm.action = "<%=ctxPath%>/community/addBoardEnd.trip";
		frm.submit();
		
	} // end of function goAddBoard() ----------------------------------------
</script>

<div style="background-color: rgba(242, 242, 242, 0.4); border: solid 1px rgba(242, 242, 242, 0.4);">
	
	<div class="container" id="addBoardDiv">
		
	    <div style="margin: 7% auto;">
	        <h2 class="font-weight-bold">커뮤니티 글 등록</h2>
	    </div>
	
	    <form name="addBoardFrm" enctype="multipart/form-data">
			
			<div class="info mb-5">
				<table class="table table-bordered" style="width: 100%;">
					<tr>
						<th style="width: 15%;">성명</th>
						<td>
							<c:if test="${not empty sessionScope.loginuser}">
								<input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}">
								<input type="text" name="name" value="${sessionScope.loginuser.user_name}" style="width: 15%;" readonly>
							</c:if>
						</td>
					</tr>
					<tr>
						<th style="width: 15%;">카테고리</th>
						<td>
							<select name="category" style="width: 15%;">
								<option value="">선택하세요</option>
								<option value="1">자유게시판</option>
								<option value="2">숙박</option>
								<option value="3">관광지,체험</option>
								<option value="4">맛집</option>
							</select>
						</td>
					</tr>
					<tr>
						<th style="width: 15%;">제목</th>
						<td>
							<input type="text" name="subject" size="100" maxlength="200">
						</td>
					</tr>
					<tr>
						<th style="width: 15%;">내용</th>
						<td>
							<textarea style="width: 100%; height: 612px;" name="content" id="content"></textarea>
						</td>
					</tr>
					<tr>
						<th style="width: 15%;">첨부파일</th>
						<td>
							<input type="file" name="attach" />
						</td>
					</tr>
					<tr>
						<th style="width: 15%;">글암호</th>
						<td>
							<input type="password" name="pw" size="100" maxlength="4">
						</td>
					</tr>
				</table>
			</div>
			
			<div class="text-center">
				<button type="button" id="addBoardBtn" class="btn btn-success mr-3" onclick="goAddBoard()">등록하기</button>
				<button type="button" id="goBackBtn" class="btn btn-secondary">취소</button>
			</div>
	    </form>
	</div>

</div>