<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>


<style type="text/css">

input#searchWordFaq {
  height: 35px;
  padding-left: 1%;
  border: solid 1px gray;
  border-radius: 5px;
}

button#btnSearch {
  height: 35px;
  border: solid 1px gray;
  border-radius: 5px;
}



ul.nav-tabs {
  width: 90%;
}

.accordion {
  width: 90%;
  /* box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); */
}

div.accordionEach {
  margin-bottom: 1%;
}

.accordion-item {
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  margin-bottom: 2%;
  overflow: hidden;
}

.accordion-header {
  width: 100%;
  background-color: #fff2e6;
  color: #333333;
  padding: 15px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  position: relative;
}

.accordion-header:hover {
  background-color: #ffe5cc;
}

.arrow {
  position: absolute;
  top: 50%;
  right: 15px;
  width: 0;
  height: 0;
  border: 6px solid transparent;
  border-top-color: #333333;
  transform: translateY(-50%);
  transition: transform 0.3s ease;
}

/* 화살표 회전 */
.accordion-item.active .arrow {
  transform: translateY(-50%) rotate(180deg);
}

.accordion-content {
  padding: 15px;
  font-size: 14px;
  line-height: 1.6;
  display: none;
}

.accordion-item.active .accordion-content {
  display: block;
}

span.faq_answer {
  font-size: 12pt;
}

div.accordion-content {
  padding: 2%;
}

.backgroundColor {
    background-color: #ffe5cc;
}

</style>



<script type="text/javascript">
	
	$(document).ready(function(){

		let searchWordFaq = "";
		
		goViewFaqList(1,searchWordFaq); // 자주묻는질문 전체 띄우기
		

		// == 카테고리 값 띄우기 == //
		$("a.faq_category").click(function(e) {
			// alert($(e.target).text());
			
			const faq_category = $(e.target).text(); // 선택한 카테고리 값 가져오기

			if(faq_category == '전체') {
				$("input[name='faq_category']").val(""); // input 태그에 클릭된 카테고리 꽂아주기 (전체일 경우 "" 이 되고, mapper 에서 조건 주었음)
			}
			else {
				$("input[name='faq_category']").val(faq_category); // input 태그에 클릭된 카테고리 꽂아주기
			}
			
			goViewFaqList(1, searchWordFaq);
			
			$("input[name='searchWordFaq']").val(""); // 검색 후 카테고리 탭 변경 시 검색창 초기화
			
		});// end of $("a.faq_category").click(function(e) {})-------------------------
		
		
		// == 검색하기 엔터 == //
   		$("input[name='searchWordFaq']").bind("keyup", function(e){
			 if(e.keyCode == 13) {
				const searchWordFaq = $(this).val();
				//console.log("검색어 확인 : "+ searchWordFaq);
				
				goViewFaqList(1, searchWordFaq);
			} 
		});
		
				
		
		
	});// end of $(document).ready(function(){})-----------------------------------------
	
	// ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
	
	// == 질문 아코디언 == //
	function toggleAccordion(header) {

		var content = header.nextElementSibling;

	    // content가 숨겨져 있으면 보이게 하고, 보이는 중이면 숨기기
	    if (content.style.display === 'block') {
	        content.style.display = 'none';
	    } else {
	        content.style.display = 'block';
	    }
	}// end of function toggleAccordion(header)-----------------------
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	// == 자주묻는질문 리스트 띄우기 == //
	function goViewFaqList(currentShowPageNo, searchWordFaq){
		searchWordFaq = $("input[name='searchWordFaq']").val();
		// console.log("검색어 : " + searchWordFaq);
		
		$.ajax({
			url:"<%= ctxPath%>/faqListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo
				, "faq_category":$("input[name='faq_category']").val()
				, "searchWordFaq":searchWordFaq},
			type:"get",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				
				let v_html_faq = "";
				
				if(json.length > 0){
					$.each(json, function(index, item){
						v_html_faq += `<div class="accordionEach">
										   <div class="accordion-header" id="accordion-header" onclick="toggleAccordion(this)">
											   <span>Q.</span>&nbsp;&nbsp;
						    			       <input type="hidden" name="faq_seq" value="\${item.faq_seq}" />
								               <span class="faq_question">\${item.faq_question}</span>
								               <span class="arrow"></span>
								           </div>
									       <div class="accordion-content" id="accordion-content">
									       	   <span class="faq_answer">\${item.faq_answer}</span>
									       </div>
									   </div>`;
						
					}); // end of $.each-------------------------
					
					// 페이지바 함수 호출 
				    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
				 	// console.log("totalPage : ", totalPage);
				 	
				    makeAllFaqListPageBar(currentShowPageNo, totalPage);
				}
				else {
					v_html_faq += "<span style='font-size: 13pt;'>등록된 질문이 없습니다.</span>";
				}
				
				$("div#faqList").html(v_html_faq);
				
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});// $.ajax-----------------------------
		
		
		// == 자주묻는질문 페이지바 == //
		function makeAllFaqListPageBar(currentShowPageNo, totalPage){
			const blockSize = 10;
			
			let loop = 1;
			
			let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
			
			let pageBar_HTML = "<ul style='list-style:none;'>";
			
			// [맨처음][이전] 만들기
			if(pageNo != 1) {
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewFaqList(1,"+searchWordFaq+")'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewFaqList("+(pageNo-1)+","+searchWordFaq+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewFaqList("+pageNo+",searchWordFaq)'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------ 
			
			// [다음][마지막] 만들기
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewFaqList("+pageNo+","+searchWordFaq+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewFaqList("+totalPage+","+searchWordFaq+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// 페이지바 출력하기
			$("div#faqList_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewFaqList(currentShowPageNo)-------------------------
	
	///////////////////////////////////////////////////////////////////////////////////////////////

 	// == 검색하기 == //
	function goSearch() {
		const searchWordFaq = $("input[name='searchWordFaq']").val();
		// console.log("검색어 확인 : " + searchWordFaq);
		
		goViewFaqList(1, searchWordFaq);
	}// end of function goSearch()--------------------
	
	
	
</script>


<div class="body">
    <div class="navigation">
        <ul>
            <li class="list active">
                <a href="<%= ctxPath%>/support.trip">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">자주묻는질문</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/mypage_company_chatting.trip">
                    <span class="icon"><ion-icon name="chatbubble-ellipses-outline"></ion-icon></span>
                    <span class="title">채팅</span><c:if test="${requestScope.newChattingCnt > 0}"><span style="border:solid 1px red; color:white; background-color:red; font-weight:bold; font-size:10px; width:40px; height:20px; border-radius:8px; text-align:center;">new</span></c:if>
                </a>
            </li>
        </ul>
    </div>
	
 	<form class="reservationFrm" name="reservationFrm">
		
		<div class="faq_header">
			<div>
				<h2 style="margin-bottom: 3%; font-weight: bold;">자주 묻는 질문</h2>
				<p>고객님들이 제주드림 상품 및 서비스에 대해 자주 문의하는 내용입니다.<br>원하는 내용을 찾지 못하실 경우 <span style="color: orange;">웹채팅</span>으로 문의해 주시면 친절하게 안내해 드리겠습니다.
			</div>
			
			<!-- 검색창 -->
			<div style="margin-top: 5%;">
				<span>
					<input type="text" name="searchWordFaq" id="searchWordFaq" placeholder="검색어를 입력하세요.">
					<input type="text" style="display: none;">
	                <button type="button" id="btnSearch" title="검색" onclick="goSearch()">검색</button>
				</span>
			</div>
		</div>
		
		<div class="faq_content" style="margin-top: 5%;">
			
			<!-- FAQ 카테고리 navigation bar -->
			<ul class="nav nav-tabs">
				<li class="nav-item">
					<a class="nav-link active faq_category" data-toggle="tab" href="#faqList">전체</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href=#faqList>예약</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">카드/결제</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">숙소</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">맛집</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">즐길거리</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">기타</a>
				</li>
			</ul>
			
			<!-- FAQ 질문, 답변 리스트 -->
			<div class="tab-content" style="border: none;"><br>
				<div class="accordion">
				    <div class="accordion-item" id="accordion-item">
				    	<div id="faqList">
				    	
				    	</div>
				    </div>
				</div>
			</div>
			<div id="faqList_pageBar" class="pageBar"></div>
			<input type="hidden" name="faq_category"/>
			
		</div>
	</form>


</div>