<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        const list = document.querySelectorAll('.list');

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
    }); // end of $(document).ready(function(){
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
                <a href="<%= ctxPath%>/company_chart.trip">
                    <span class="icon"><ion-icon name="bar-chart-outline"></ion-icon></ion-icon></span>
                    <span class="title">통계</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/myRegisterHotel.trip">
                    <span class="icon"><ion-icon name="wallet-outline"></ion-icon></span>
                    <span class="title">숙소등록신청현황</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/review.trip">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <br><br><br>
            <li class="list">
                <a href="<%= ctxPath%>/support.trip">
                    <span class="icon"><ion-icon name="help-circle-outline"></ion-icon></span>
                    <span class="title">고객센터</span>
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
						<strong style="font-size: 18px">예약승인대기 <br><br></strong> 
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
					
					<li>
						<strong style="font-size: 18px">환불완료 <br><br></strong> 
						<a href="#" class="count">
							<span id="refund_completed" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.orderStat.deliveredCnt }0</span>
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
			    <a class="nav-link" data-toggle="tab" href="#reservation_success">예약승인목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#reservation_quit">예약취소목록</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  <div class="tab-pane container active" id="all_reservation">
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
				    </tr>
				  </thead>
				  <tbody>
					  <c:forEach var="reservation" items="${requestScope.reservationList}">
						  <tr>
						      <th>${reservation.lodging_name}</th>
						      <td>${reservation.user_name}</td>
						      <td>${reservation.room_name}</td>
						      <td>${reservation.user_name}</td>
						      <td>${reservation.check_in}</td>
						      <td>${reservation.check_out}</td>
						      <c:if test="${reservation.status == '0'}">
						      		<td><span style="color:blue; font-weight:bold;">승인대기</span></td>
						      </c:if>
						      <c:if test="${reservation.status == '1'}">
						      		<td><span style="color:green; font-weight:bold;">승인</span></td>
						      </c:if>
						      <c:if test="${reservation.status == '2'}">
						      		<td><span style="color:red; font-weight:bold;">취소</span></td>
						      </c:if>
						      
						  </tr>
					  </c:forEach>
				  </tbody>
				</table>
			</div>
			  <div class="tab-pane container fade" id="ready_reservation_success">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>예약일</th>
						      <th>상품정보</th>
						      <th>금액</th>
						      <th>예약상태</th>
						    </tr>
						  </thead>
			    		 <tbody>
						    <c:forEach var="reservation" items="${requestScope.reservationList}">
								  <c:if test="${reservation.status == '0' }">
								  	<tr>
									      <th>${reservation.lodging_name}</th>
									      <td>${reservation.user_name}</td>
									      <td>${reservation.room_name}</td>
									      <td>${reservation.user_name}</td>
									      <td>${reservation.check_in}</td>
									      <td>${reservation.check_out}</td>
									      <c:if test="${reservation.status == '0'}">
									      		<td><span style="color:blue; font-weight:bold;">승인대기</span></td>
									      </c:if>
									      <c:if test="${reservation.status == '1'}">
									      		<td><span style="color:green; font-weight:bold;">승인</span></td>
									      </c:if>
									      <c:if test="${reservation.status == '2'}">
									      		<td><span style="color:red; font-weight:bold;">취소</span></td>
									      </c:if>
								      
								  	</tr>
								  </c:if>
							</c:forEach>
						 </tbody>
					</table>
				</div>
				<div class="tab-pane container fade" id="reservation_success">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>예약일</th>
						      <th>상품정보</th>
						      <th>금액</th>
						      <th>예약상태</th>
						    </tr>
						  </thead>
			    		 <tbody>
						    <c:forEach var="reservation" items="${requestScope.reservationList}">
								  <c:if test="${reservation.status == '1' }">
								  	<tr>
									      <th>${reservation.lodging_name}</th>
									      <td>${reservation.user_name}</td>
									      <td>${reservation.room_name}</td>
									      <td>${reservation.user_name}</td>
									      <td>${reservation.check_in}</td>
									      <td>${reservation.check_out}</td>
									      <c:if test="${reservation.status == '0'}">
									      		<td><span style="color:blue; font-weight:bold;">승인대기</span></td>
									      </c:if>
									      <c:if test="${reservation.status == '1'}">
									      		<td><span style="color:green; font-weight:bold;">승인</span></td>
									      </c:if>
									      <c:if test="${reservation.status == '2'}">
									      		<td><span style="color:red; font-weight:bold;">취소</span></td>
									      </c:if>
								      
								  	</tr>
								  </c:if>
							</c:forEach>
						 </tbody>
					</table>
				</div>
				<div class="tab-pane container fade" id="reservation_quit">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>예약일</th>
						      <th>상품정보</th>
						      <th>금액</th>
						      <th>예약상태</th>
						    </tr>
						  </thead>
			    		 <tbody>
						    <c:forEach var="reservation" items="${requestScope.reservationList}">
								  <c:if test="${reservation.status == '2' }">
								  	<tr>
									      <th>${reservation.lodging_name}</th>
									      <td>${reservation.user_name}</td>
									      <td>${reservation.room_name}</td>
									      <td>${reservation.user_name}</td>
									      <td>${reservation.check_in}</td>
									      <td>${reservation.check_out}</td>
									      <c:if test="${reservation.status == '0'}">
									      		<td><span style="color:blue; font-weight:bold;">승인대기</span></td>
									      </c:if>
									      <c:if test="${reservation.status == '1'}">
									      		<td><span style="color:green; font-weight:bold;">승인</span></td>
									      </c:if>
									      <c:if test="${reservation.status == '2'}">
									      		<td><span style="color:red; font-weight:bold;">취소</span></td>
									      </c:if>
								      
								  	</tr>
								  </c:if>
							</c:forEach>
						 </tbody>
					</table>
				</div>
			</div>
		</div>
	</form>

</div>