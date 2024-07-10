<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>    

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/community/community_main.css" />

<script type="text/javascript">
	$(document).ready(function() {
		
	    loadContent('allBoard'); // 초기 로드 시 첫 번째 탭 내용 불러오기
	
	    $('input[name="category"]').change(function(e) {
	        
	    	if($(e.target).val() == "") {
	    		loadContent("allBoard");
	    		
	    	} else if($(e.target).val() == "1") {
	    		loadContent("freeBoard");
	    	}
	    });
	    
	});
	
	function loadContent(tab) {
        $.get('<%=ctxPath%>/community/' + tab + '.trip', function(data) {
            $('#content').html(data);
        });
    }
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
			
			<input type="radio" id="radio-4" name="category" value="3" />
			<label class="tab" for="radio-4">관광지,체험</label>
			
			<input type="radio" id="radio-5" name="category" value="4" />
			<label class="tab" for="radio-5">맛집</label>
			
			<input type="radio" id="radio-6" name="category" value="5" />
			<label class="tab" for="radio-6">구인</label>
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
	
	
	
	<!-- === 탭 내용 === -->
    <div id="content" class="tab-content"></div>
	