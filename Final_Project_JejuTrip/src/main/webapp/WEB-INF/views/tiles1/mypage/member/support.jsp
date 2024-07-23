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
                <a href="<%= ctxPath%>/requiredLogin_goMypage.trip">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
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
	
    <form class = "reservationFrm" name="reservationFrm">
		<div id="reservation">
			<div id="top_color">
				<p style="font-size: 20px; font-weight: bold; color:white;">나의 예약현황</p>
			</div>
			<div class="liblock">
				<ul class="reservation flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">예약전체 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >${requestScope.all_reservation}</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">예약접수중 <br><br></strong> 
						<a href="#" class="count">
							<span id="reservation_confirmed"  style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.ready_reservation}</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li>
						<strong style="font-size: 18px">예약확정 <br><br></strong>
						<a href="#" class="count">
							<span id="trip_complete" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.success_reservation}</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li><strong style="font-size: 18px">예약취소 <br><br></strong>
						 <a href="#" class="count">
						 	<span id="cancel_Reservation" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.fail_reservation}</span>
					 		<span style="color: gray; font-weight: bold;">건</span>
					 	</a>
					</li>
					
				</ul>
			</div>
		</div>
		<div class="reservation_bar" style="margin-top: 10%;">
		 <!-- Nav tabs -->
			<ul class="nav nav-tabs">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#all_reservation">전체예약내역</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#ready_reservation_success">예약승인대기목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#reservation_success">예약확정목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#reservation_quit">예약취소목록</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  <div class="tab-pane active" id="all_reservation">
				<table class="table table-hover">
				  <thead>
				    <tr>
				      <th>예약번호</th>
				      <th>숙소명</th>
				      <th>룸타입</th>
				      <th>고객명</th>
				      <th>체크인</th>
				      <th>체크아웃</th>
				      <th>예약상태</th>
				      <th>1:1문의</th>
				    </tr>
				  </thead>
				  <tbody id="all_reservation_tbody">
					  
				  </tbody>
				</table>
				<div id="all_reservation_pageBar" class="pageBar"></div>
			</div>
			  <div class="tab-pane fade" id="ready_reservation_success">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>룸타입</th>
						      <th>고객명</th>
						      <th>체크인</th>
						      <th>체크아웃</th>
						      <th>예약상태</th>
						      <th>1:1문의</th>
						    </tr>
						  </thead>
			    		 <tbody id="send_reservation_tbody">
						    
						 </tbody>
					</table>
					<div id="send_reservation_pageBar" class="pageBar"></div>
				</div>
				<div class="tab-pane fade" id="reservation_success">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>룸타입</th>
						      <th>고객명</th>
						      <th>체크인</th>
						      <th>체크아웃</th>
						      <th>예약상태</th>
						      <th>1:1문의</th>
						    </tr>
						  </thead>
			    		 <tbody id="success_reservation_tbody">
						    
						 </tbody>
					</table>
					<div id="success_reservation_pageBar" class="pageBar"></div>
				</div>
				<div class="tab-pane fade" id="reservation_quit">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>룸타입</th>
						      <th>고객명</th>
						      <th>체크인</th>
						      <th>체크아웃</th>
						      <th>예약상태</th>
						      <th>1:1문의</th>
						    </tr>
						  </thead>
			    		 <tbody id="fail_reservation_tbody">
						    
						 </tbody>
					</table>
					<div id="fail_reservation_pageBar" class="pageBar"></div>
				</div>
			</div>
		</div>
	</form>

</div>