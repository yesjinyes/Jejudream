<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<style type="text/css">

.mini_image{

	width: 100px; 
	height: 100px;
	/*margin: auto;*/
  	object-fit: cover;

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

<div class="container mt-3" >
	
	<c:set var="reserve_info" value="${requestScope.reserve_info}"></c:set>
	
    <div class="h3 text-center mb-4">숙소 예약정보</div>
    
    <div style="display : flex;">
        <div class="px-4" style="width: 55%;">
            <label class="h4">숙소정보</label>
            <div id="lodgingInfo" style="border: solid 1px black;">
                
				<div style="width: 85%; display : flex;">
					<a href="">
		                	<img class="mini_image" src="<%= ctxPath%>/resources/images/lodginglist/room/${reserve_info.room_img}"/>
		            </a>
		            <div style="align-self: center;">
                    	<div class="mb-1 font12" class="lodging_name">${reserve_info.lodging_name}</div>
	                    <div class="mb-1 font12" id="room" class="room_name">${reserve_info.room_name}</div>
	                    <div class="font12" class="check_people">${reserve_info.min_person}인 기준, 최대 ${reserve_info.max_person}인</div>
	                    <input type="hidden" id="hidelodging_code" value="${reserve_info.lodging_code} }" />
	                </div>
                </div>
                    
                
                
            </div>

            <label class="h4">예약자 정보</label>
          	<div id="userinfo" style="border: solid 1px black;">
          		<c:if test="${not empty sessionScope.loginuser}">
          			<c:set var="loginuser" value="${sessionScope.loginuser}"></c:set>
          			<div style="align-self: center;">
                    	<div class="mb-1 font12" class="user_name">${loginuser.user_name}</div>
	                    <div class="mb-1 font12" class="email">${loginuser.email}</div>
	                    <div class="font12" class="mobile">${loginuser.mobile}</div>
	                </div>
          			
          		</c:if>
          	</div>

            
            <div>
            	<label class="h4 mt-4">숙소 상세정보</label>
            	
                <div class="mb-1 font12" id="lodging_address">주소 : ${reserve_info.lodging_address}</div>
				<div class="mb-1 font12" id="lodging_tell">연락처 : ${reserve_info.lodging_tell}</div>
	            
            </div>
           

            

        </div>



        
        
        <div class="p-3 payArea" style="width: 45%;">
            
            

            <%-- 여기는 총가격이 보여지는 곳입니다.--%>
            <div>
                <div class="row mb-1">
                    
                </div>
                
                <div class="row mb-1">
                    
                </div>
                <div class="row mb-1">
                   
                </div>
              
                <div class="row mb-1">
                   
                </div>
                
                
				<br>
				
                <div class="row h4 mt-3">
                    <div class="col-lg-4 pt-1">
                        	총 결제비용
                    </div>
                    <div class="col-lg-8 text-right">
                    	
                    	<span id="price" >${reserve_info.price}</span>
                        <input type="hidden" id="price" value="${reserve_info.price}"/>
                        
                        
                    </div>
                    
                </div>
				<div class="mt-3" align="center">
               		<button id="paymentSubmit" type="button" class="btn btn-lg btn-dark form-control" style="width: 70%;" onclick="goPayment()">결제하기</button>
           		</div>
                

            </div>
        </div>
    </div>
    
</div>

<form name="reserveData">
	<input type="hidden" name="room_detail_code" value="${reserve_info.room_detail_code}"/>
	<input type="hidden" name="lodging_code" value="${reserve_info.lodging_code}"/>
	<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}" />
	<input type="hidden" name="price" value="${reserve_info.price}"/>
	<input type="hidden" name="check_in" value="2024-07-11"/>
	<input type="hidden" name="check_out" value="2024-07-12"/>
</form>