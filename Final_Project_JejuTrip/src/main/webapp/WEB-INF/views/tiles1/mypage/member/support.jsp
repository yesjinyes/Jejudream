<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
	
	$(document).ready(function(){

        function activeLink() {
            // 모든 네비게이션 항목에서 active 클래스를 제거합니다.
            list.forEach((item) => item.classList.remove('active'));
            // 클릭된 네비게이션 항목에 active 클래스를 추가합니다.
            this.classList.add('active');
        }

        list.forEach((item) => {
            item.addEventListener('click', function () {
                // active 클래스를 변경하는 함수 호출
                activeLink.call(this);
                // iframe의 src 속성을 변경하여 콘텐츠를 로드
                const link = this.getAttribute('data-link');
                document.getElementById('contentFrame').src = link;
            });
        });
        
	});// end of ready   	
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
			<!-- Nav tabs -->
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
			
			<!-- Tab panes -->
			<div class="tab-content">
				<!-- 질문(전체) -->
				<div class="tab-pane active" id="faq_all">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>분류</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody id="faq_all_tbody">
						</tbody>
					</table>
					<div id="faq_all_pageBar" class="pageBar"></div>
				</div>
				
				<!-- 질문(예약) -->
				<div class="tab-pane fade" id="faq_reservation">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>분류</th>
								<th>제목</th>
							</tr>
						</thead>
				   		<tbody id="faq_reservation_tbody">
						</tbody>
					</table>
					<div id="faq_reservation_pageBar" class="pageBar"></div>
				</div>
				
				<!-- 질문(카드/결제) -->
				<div class="tab-pane fade" id="faq_payment">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>번호</th>
						      <th>분류</th>
						      <th>제목</th>
						    </tr>
						  </thead>
				   		 <tbody id="faq_payment_tbody">
						 </tbody>
					</table>
					<div id="faq_payment_pageBar" class="pageBar"></div>
				</div>
				
				<!-- 질문(숙소) -->
				<div class="tab-pane fade" id="faq_lodging">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>번호</th>
						      <th>분류</th>
						      <th>제목</th>
						    </tr>
						  </thead>
				   		 <tbody id="faq_lodging_tbody">
						 </tbody>
					</table>
					<div id="faq_lodging_pageBar" class="pageBar"></div>
				</div>
				
				<!-- 질문(맛집) -->
				<div class="tab-pane fade" id="faq_foodstore">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>번호</th>
						      <th>분류</th>
						      <th>제목</th>
						    </tr>
						  </thead>
				   		 <tbody id="faq_foodstore_tbody">
						 </tbody>
					</table>
					<div id="faq_foodstore_pageBar" class="pageBar"></div>
				</div>
				
				<!-- 질문(즐길거리) -->
				<div class="tab-pane fade" id="faq_play">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>번호</th>
						      <th>분류</th>
						      <th>제목</th>
						    </tr>
						  </thead>
				   		 <tbody id="faq_play_tbody">
						 </tbody>
					</table>
					<div id="faq_play_pageBar" class="pageBar"></div>
				</div>
				
				<!-- 질문(기타) -->
				<div class="tab-pane fade" id="faq_etc">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>번호</th>
						      <th>분류</th>
						      <th>제목</th>
						    </tr>
						  </thead>
				   		 <tbody id="faq_etc_tbody">
						 </tbody>
					</table>
					<div id="faq_etc_pageBar" class="pageBar"></div>
				</div>
				
			</div>
			
			
		</div>
	</form>


</div>