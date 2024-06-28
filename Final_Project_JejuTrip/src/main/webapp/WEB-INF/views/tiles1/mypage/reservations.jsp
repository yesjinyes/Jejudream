<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
String ctxPath = request.getContextPath();
%>

<%-- Bootstrap CSS --%>
<link rel="stylesheet" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<style type="text/css">
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
	width: 100%;
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


</style>

<script>
//폼(form)을 전송(submit)
	 const frm = document.reservationFrm;
	 frm.method="get";
	 frm.action="<%= ctxPath%>/reservations.trip";
	 frm.submit();

</script>

<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
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
		
	</div>
		
</body>
</html>