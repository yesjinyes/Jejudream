<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String ctxPath = request.getContextPath();
%>

<style>

.flex-row {
	display: flex;
	flex-direction: row;
}

.flex-col {
	display: flex;
	flex-direction: col;
}

.container {
	border: solid 0px red;
	float: none;
	width: 1024px;
	margin: 64px auto 0px;
	
}

#reservation {
	width: 100%;
	border-top: 2px solid black;
	border-left: 1px solid gray;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	border-radius: 10px 10px;
}

#top_color{
padding: 20px 10px 0px 20px; 
border-bottom: solid 1px #ff8000; 
background: #ff8000; 
border-radius: 10px 10px 0px 0px;
}

li a {
	color: black;
}

.reservation li {
	list-style: none;
	display: block;
	float: left;
	width: 55%;
	padding: 0 0 2%;
	margin: 0 auto;
	border-right: 1px dotted #c9c7ca;
	text-align: center;
}

.navigation {
    position: relative;
    height: 800px;
    width: 250px;
    background: #ff8000;
}


.navigation ul {
    position: absolute;
    width: 100%;
    padding-left: 5px;
    padding-right: 5px;
    padding-top: 40px;
}

.navigation ul li {
    position: relative;
    list-style: none;
    width: 90%;
    border-radius: 20px 20px;
}

.navigation ul li.active {
    background: #ffcccc;/* 고정되어있을때 강조색 [1] */
}

.navigation ul li a {
    position: relative;
    display: block;
    width: 100%;
    display: flex;
    text-decoration: none;
    color: #fff;
}
 


.navigation ul li a .icon {
    position: relative;
    display: block;
    min-width: 60px;
    height: 60px;
    line-height: 70px;
    text-align: center;
}

.navigation ul li a .icon ion-icon {
    position: relative;
    font-size: 1.5em;
    z-index: 1;
}

.navigation ul li a .title {
    position: relative;
    display: block;
    height: 60px;
    line-height: 60px;
    white-space: nowrap;
    font-weight:bold;
}
#contentFrame{
	width: 1024px; 
	padding-bottom: 1%; 
	margin-left: 2%;
	border: 1px solid #e6e6e6;
	/* background: #008000; */
	
}
</style>

<div class="container">
	
    <div class="navigation">
        <ul>
            <li class="list active" data-link="<%= ctxPath%>/reservations.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
                </a>
            </li>
            <li class="list" data-link="<%= ctxPath%>/editProfile.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원정보수정</span>
                </a>
            </li>
            <li class="list" data-link="<%= ctxPath%>/cash_points.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="wallet-outline"></ion-icon></span>
                    <span class="title">캐시&포인트</span>
                </a>
            </li>
            <li class="list" data-link="<%= ctxPath%>/review.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <br><br><br>
            <li class="list" data-link="<%= ctxPath%>/support.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="help-circle-outline"></ion-icon></span>
                    <span class="title">고객센터</span>
                </a>
            </li>
        </ul>
    </div>
	<form name="reservationFrm">
		<div id="reservation">
			<div id="top_color">
				<p style="font-size: 20px; font-weight: bold; color:white;">나의 예약현황</p>
			</div>
			<div class="liblock">
				<ul class="reservation flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">예약접수중 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >${requestScope.orderStat.processingCnt }0</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">예약확정 <br><br></strong> 
						<a href="#" class="count">
							<span id="reservation_confirmed"  style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.orderStat.shippedOutCnt }0</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li>
						<strong style="font-size: 18px">여행완료 <br><br></strong>
						<a href="#" class="count">
							<span id="trip_complete" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.orderStat.inDeliveryCnt }0</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li><strong style="font-size: 18px">예약취소 <br><br></strong>
						 <a href="#" class="count">
						 	<span id="cancel_Reservation" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.orderStat.deliveredCnt }0</span>
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
			    <a class="nav-link active" data-toggle="tab" href="#home">예약내역</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#menu1">취소내역</a>
			  </li>
			  
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  <div class="tab-pane container active" id="home">
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
				    <tr>
				      <th>1</th>
				      <td>Mark</td>
				      <td>Otto</td>
				      <td>5,000</td>
				      <td>예약완료</td>
				    </tr>
				  </tbody>
				</table>
			</div>
			  <div class="tab-pane container fade" id="menu1">
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
						    <tr>
						      <th>1</th>
						      <td>Mark</td>
						      <td>Otto</td>
						      <td>5,000</td>
						      <td>취소완료</td>
						    </tr>
						 </tbody>
					</table>
				</div>
			</div>
		</div>
		</form>
 <%--    <iframe id="contentFrame" src="<%= ctxPath%>/reservations.trip"></iframe> --%><!--로드시 적용되어 있는 탭은 마이페이지  -->
</div>

    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    
    <script>
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
    </script>

