<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>


<style type="text/css">

ul.nav-tabs {
  width: 90%;
}

.accordion {
  width: 90%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

</style>



<script type="text/javascript">
	
	$(document).ready(function(){

		goViewAllFaqList(1); // 자주묻는질문 전체 띄우기
		
        function activeLink() {
            // 모든 네비게이션 항목에서 active 클래스를 제거합니다.
            list.forEach((item) => item.classList.remove('active'));
            // 클릭된 네비게이션 항목에 active 클래스를 추가합니다.
            this.classList.add('active');
        }

	});// end of $(document).ready(function(){})-----------------------------------------
	
	
	// == 자주묻는질문 리스트 띄우기 == //
	function goViewAllFaqList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/faqListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo},
			type:"get",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				
				let v_html_all = "";
				
				if(json.length > 0){
					$.each(json, function(index, item){
						v_html_all += `<div class="accordionEach">
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
						
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html_all += "<span>등록된 질문이 없습니다.</span>";
				}
				
				$("div#accordion-item").html(v_html_all);
				
			    // 페이지바 함수 호출 
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeAllFaqListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
		function makeAllFaqListPageBar(currentShowPageNo, totalPage){
			const blockSize = 10;
			
			let loop = 1;
			
			let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
			let pageBar_HTML = "<ul style='list-style:none;'>";
			
			// === [맨처음][이전] 만들기 === //
			if(pageNo != 1) {
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewAllFaqList(1)'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewAllFaqList("+(pageNo-1)+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewAllFaqList("+pageNo+")'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewAllFaqList("+pageNo+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewAllFaqList("+totalPage+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// 댓글 페이지바 출력하기
			$("div#faqList_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewAllFaqList(currentShowPageNo)-------------------------
	
	function toggleAccordion(header) {
	    // 해당 헤더의 다음 sibling 요소인 content를 가져옵니다.
	    var content = header.nextElementSibling;

	    // content가 숨겨져 있으면 보이게 하고, 보이는 중이면 숨깁니다.
	    if (content.style.display === 'block') {
	        content.style.display = 'none';
	    } else {
	        content.style.display = 'block';
	    }
	}

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
                <a href="<%= ctxPath%>/mypage_member_chatting.trip">
                    <span class="icon"><ion-icon name="chatbubble-ellipses-outline"></ion-icon></span>
                    <span class="title">채팅</span><c:if test="${requestScope.newChattingCnt > 0}"><span style="border:solid 1px red; color:white; background-color:red; font-weight:bold; font-size:10px; width:40px; height:20px; border-radius:8px; text-align:center;">new</span></c:if>
                </a>
            </li>
        </ul>
    </div>
	
 	<form class="reservationFrm" name="reservationFrm">
		
		<div>
			<div>
				<h2 style="margin-bottom: 3%; font-weight: bold;">자주 묻는 질문</h2>
				<p>고객님들이 제주드림 상품 및 서비스에 대해 자주 문의하는 내용입니다.<br>원하는 내용을 찾지 못하실 경우 <span style="color: orange;">웹채팅</span>으로 문의해 주시면 친절하게 안내해 드리겠습니다.
			</div>
			
			<div style="margin-top: 5%;">
				<span>
					<select class="category-select-box">
						<option>제목</option>
						<option>내용</option>
					</select>
				</span>
				<span>
					<input type="text" name="searchWord" placeholder="검색어를 입력하세요."/>
				</span>
			</div>
		</div>
		
		<div class="faq_bar" style="margin-top: 5%;">
			
			<!-- FAQ 카테고리 navigation bar -->
			<ul class="nav nav-tabs">
				<li class="nav-item">
					<a class="nav-link active" data-toggle="tab" href="#faq_all">전체</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#faq_reservation">예약</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#faq_payment">카드/결제</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#faq_lodging">숙소</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#faq_foodstore">맛집</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#faq_play">즐길거리</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#faq_etc">기타</a>
				</li>
			</ul>
			
			<!-- FAQ 질문, 답변 -->
			<div class="tab-content" style="border: none;"><br>
				<div class="accordion">
				    <div class="accordion-item" id="accordion-item">
				    </div>
				</div>
			</div>
			<div id="faqList_pageBar" class="pageBar"></div>
			
			
		</div>
	</form>


</div>