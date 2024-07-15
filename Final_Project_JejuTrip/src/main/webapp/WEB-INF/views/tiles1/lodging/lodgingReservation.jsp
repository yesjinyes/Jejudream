<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<style type="text/css">

.mini_image{

	width: 140px; 
	height: 140px;
	border-radius: 5px; /* 모서리 둥글게 */
    margin-right: 10px;
  	object-fit: cover;

}

.row {
    margin-bottom: 10px;
}
        
        
.total {
    font-weight: bold;
    font-size: 20px;
}
.btn {
    width: 100%;
}
        

#lodgingInfo, #userinfo, #reserveinfo {
    border: solid 1px #ddd;
    border-radius: 5px;
    padding: 15px;
    background-color: #f9f9f9;
}



.payArea {
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 10px;
    background-color: #ffffff;
}




</style>


<script>

$(document).ready(function(){
	

});

function goPayment(){
	
	
	// 포트원(구 아임포트) 결제 팝업창 띄우기
    const url = `<%= ctxPath%>/room_Reservation.trip`;

    // 너비 1000, 높이 600 인 팝업창을 화면 가운데 위치시키기
    const width = 1000;
    const height = 600;

    const left = Math.ceil((window.screen.width - width)/2);   // (내모니터 화면 넓이 - 650)/2 , 예로 내모니터 화면 넓이가 1400 이면 650을 뺀 나머지 750 의 반 375 이다.
    // Math.ceil() 은 정수로 만드는 것이다.

    const top = Math.ceil((window.screen.height - height)/2);   // (내모니터 화면 높이 - 650)/2 , 예로 내모니터 화면 높이가 900 이면 570을 뺀 나머지 330 의 반 165 이다.
    // Math.ceil() 은 정수로 만드는 것이다.

    window.open(url, "결제창", `left=\${left}, top=\${top}, width=\${width}, height=\${height}`);
	
} // end of function goPayment(){}


function goReserveInsert(){
	
	// alert("전달받은 room_code : " + room_code);
	// alert("전달받은 userid : " + userid);
	
	// FormData 객체 생성
	const formData = $("form[name='reserveData']").serialize();
	const frm = document.reserveData;
	
	
	$.ajax({
		url:"JSONreserveInsert.trip",
		type:"post",
		data: formData,
		dataType:"json",
		success: function(json) {
		
			if(json.n == 1){
				
				alert('예약 테이블 insert 성공');
				
				
				frm.reservation_code.value = json.num;
				frm.method = "post";
				frm.action = "<%= ctxPath%>/reserveResult.trip";
				
				frm.submit();
				
			}
			else{
				
				alert('예약 테이블 inset 실패');
				return;
			}
			
		},
		error: function(request, status, error){
	        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
		
	});
	
	
	
	
} // end of function goReserveInsert(room_code, userid){}


</script>
<div class="container my-3">
        <c:set var="reserve_info" value="${requestScope.reserve_info}"></c:set>
        
        <div class="row">
            <div class="col-md-7">
                <label class="h4">숙소정보</label>
                <div id="lodgingInfo">
                    <div class="d-flex">
                        <a href="<%= ctxPath%>/lodgingDetail.trip?lodging_code=${reserve_info.lodging_code}">
                            <img class="mini_image" src="<%= ctxPath%>/resources/images/lodginglist/room/${reserve_info.room_img}"/>
                        </a>
                        <div class="ml-3" style="align-content: center;">
                            <div class="mb-1 lodging_name">${reserve_info.lodging_name}</div>
                            <div class="mb-1 room_name" id="room">${reserve_info.room_name}</div>
                            <div class="mb-1 check_people">${reserve_info.min_person}인 기준, 최대 ${reserve_info.max_person}인</div>
                            <div>입실시간 : ${reserve_info.check_inTime}  / 퇴실시간 : ${reserve_info.check_outTime}</div>
                            <input type="hidden" id="hidelodging_code" value="${reserve_info.lodging_code}" />
                        </div>
                    </div>
                    <div class="my-2" id="lodging_address">주소 : ${reserve_info.lodging_address}</div>
                    <div class="mb-1" id="lodging_tell">연락처 : ${reserve_info.lodging_tell}</div>
                </div>

                <label class="h4 mt-3">예약자 정보</label>
                <div id="userinfo">
                    <c:if test="${not empty sessionScope.loginuser}">
                        <c:set var="loginuser" value="${sessionScope.loginuser}"></c:set>
                        <div>
                            <div class="mb-1 user_name">예약자 성명 : ${loginuser.user_name}</div>
                            <div class="mb-1 email">예약자 이메일 : ${loginuser.email}</div>
                            <div class="mobile">예약자 연락처 : ${fn:substring(loginuser.mobile, 0, 3)}-${fn:substring(loginuser.mobile, 3, 7)}-${fn:substring(loginuser.mobile, 7, 12)}</div>
                        </div>
                    </c:if>
                </div>

                <div>
                    <label class="h4 mt-3">예약 신청정보</label>
                    <div id="reserveinfo">
                        <div class="mb-1">체크인 날짜 : ${reserve_info.check_in}</div>
                        <div class="mb-1">체크아웃 날짜 : ${reserve_info.check_out}</div>
                        <div>총 숙박일 : ${reserve_info.days}박 <fmt:formatNumber var="outday" value="${reserve_info.days}"/>${outday + 1}일</div>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <label class="h4">결제 정보</label>
                <div class="payArea">
                    <div class="row mb-1">
                        <div class="col-6">1박 기준 가격</div>
                        <div class="col-6 text-right"><fmt:formatNumber value="${reserve_info.price}" pattern="#,###"/> 원</div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-6">총 숙박일</div>
                        <div class="col-6 text-right">${reserve_info.days} 박 <fmt:formatNumber var="outday" value="${reserve_info.days}"/> ${outday + 1} 일</div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-6">1박 기준 가격 X 총 숙박일</div>
                        <div class="col-6 text-right"><fmt:formatNumber value="${reserve_info.price}" pattern="#,###"/> X ${reserve_info.days} 일</div>
                    </div>
                    
                    <hr width="100%" color="#ff9900" size="3">
                    
                    <div class="row mt-3">
                        <div class="col-6">총 결제비용</div>
                        <div class="col-6 text-right total"><fmt:formatNumber value="${reserve_info.totalPrice}" pattern="#,###"/> 원</div>
                    </div>
                    <div class="row mt-5 justify-content-center">
                        <div class="col-md-8">
                            <button id="paymentSubmit" type="button" class="btn btn-lg btn-warning" onclick="goPayment()">결제하기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<form name="reserveData">
	<input type="hidden" name="room_detail_code" value="${reserve_info.room_detail_code}"/>
	<input type="hidden" name="lodging_code" value="${reserve_info.lodging_code}"/>
	<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}" />
	<input type="hidden" name="price" value="${reserve_info.price}" />
	<input type="hidden" name="totalPrice" value="${reserve_info.totalPrice}"/>
	<input type="hidden" name="check_in" value="${reserve_info.check_in}"/>
	<input type="hidden" name="check_out" value="${reserve_info.check_out}"/>
	<input type="hidden" name="days" value="${reserve_info.days}"/>
	<input type="hidden" name="reservation_code" value=""/>
</form>