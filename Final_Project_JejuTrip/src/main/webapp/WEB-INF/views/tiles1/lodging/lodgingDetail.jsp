<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>
<style>



.main-image {
    width: 100%;
    height: 400px;
    object-fit: cover;
    
}

@media (max-width: 768px) {
           .main-image {
               height: 200px; /* 작은 화면에서는 높이를 줄임 */
           }
       }

@media (max-width: 480px) {
    .main-image {
        height: 150px; /* 더 작은 화면에서는 높이를 더 줄임 */
    }
}

.lodging-name {
    font-size: 24px;
    margin-top: 0;
}


</style>

<script type="text/javascript">

$(document).ready(function(){

	
	$("button:button[name='reservation']").click(function(e){
	
		const tt = $(e.target).parent().siblings('input[name="room_detail_code"]').val();
		
		// alert(tt);
		
		const frm = document.reserve;
		
		frm.room_detail_code.value = tt;
		
		frm.method = "post";
		frm.action = "<%= ctxPath%>/lodgingReservation.trip";
		
		frm.submit();
	}); 
	
	
	
	
	
	
	
	
	
}); // end of $(document).ready(function(){})




</script>

<div class="container">
	
       <div class="image-gallery">
           <img src="<%= ctxPath%>/resources/images/lodginglist/${requestScope.lodgingDetail.main_img}" alt="숙소 이미지" class="main-image">
           
       </div>

       <div class="lodging-info">
           <h2 class="lodging-name">${requestScope.lodgingDetail.lodging_name}</h2>
           <p class="lodging-category">${requestScope.lodgingDetail.lodging_category}</p>
           <p class="lodging-localstatus">${requestScope.lodgingDetail.local_status}</p>
           <p class="lodging-address">${requestScope.lodgingDetail.lodging_address}</p>
           

           <h3>편의 시설</h3>
           <ul class="">
               <li>무료 와이파이</li>
               <li>조식 포함</li>
               <li>수영장</li>
               <li>헬스장</li>
           </ul>

           <h3>설명</h3>
           <p>${requestScope.lodgingDetail.lodging_content}</p>
			
		   <c:forEach var="roomDetail" items="${requestScope.roomDetailList}">
		   	<div>
		   		<img src="<%= ctxPath%>/resources/images/lodginglist/room/${roomDetail.room_img}" style="width:400px; height:300px;" />
		   	</div>
		   	
		   	<div>
		   	객실명 : ${roomDetail.room_name}
		   	</div>
		   	
		   	<input type="text" name="room_detail_code" value="${roomDetail.room_detail_code}"/>
		   	
		   
		   	
		   	<div>
		   	숙소 코드 : ${roomDetail.fk_lodging_code}
		   	</div>
		   	
		   	<div>
		   	숙소 재고 : ${roomDetail.room_stock}
		   	</div>
		   	
		   	<div>
		   		<button type="button" name="reservation" class="btn btn-success">예약하기</button>
		   	</div>
		   </c:forEach>
		   
		   
		   
           
       </div>
   
</div>

<form name="reserve">
	<input type="hidden" name="room_detail_code" />
	<input type="hidden" name="lodging_code" value="${requestScope.lodgingDetail.lodging_code}" />
</form>
  
