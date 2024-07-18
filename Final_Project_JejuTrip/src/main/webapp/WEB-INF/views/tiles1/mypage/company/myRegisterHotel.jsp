<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/myRegisterHotel.css"/>
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
        
        $("tr").bind("click",function(e){
        	const lodgingCode = $(e.target).parent().next().val();
        	if(Number(lodgingCode) > 0){
        		open_modal(lodgingCode);	
        	}
        });
        
    }); // end of $(document).ready(function(){
    	
    function open_modal(lodgingCode){
    	
    	$.ajax({
			url:"<%= ctxPath%>/selectRegisterHotelJSON.trip",
			data:{"lodging_code":lodgingCode}, 
			type:"post",
			dataType:"json",
			success:function(json){
				let v_html = `<div style="margin-bottom:5px;">숙소명 : \${json.lodging_name}</div>`;
				v_html += `<div style="margin-bottom:5px;">숙소구분 : \${json.lodging_category}</div>`;
				v_html += `<div style="margin-bottom:5px;">위치 구분 : \${json.local_status}</div>`;
				v_html += `<div style="margin-bottom:5px;">주소 : \${json.lodging_address}</div>`;
				v_html += `<div style="margin-bottom:5px;">전화번호 : \${json.lodging_tell}</div>`;
				v_html += `<div style="margin-bottom:5px;">상세설명 : \${json.lodging_content}</div>`;
				v_html += `<img src="<%=ctxPath%>/resources/images/lodginglist/\${json.main_img}" style="width:100%; margin-bottom:20px;"/>`;
				if(json.status == '0'){
					v_html += `<div style="margin-bottom:5px;">처리상태 : <span style="color:blue; font-weight:bold;">처리중</span></div>`;
				}
				else if(json.status == '1'){
					v_html += `<div style="margin-bottom:5px;">처리상태 : <span style="color:green; font-weight:bold;">승인</span></div>`;
				}
				else if(json.status == '2'){
					v_html += `<div style="margin-bottom:5px;">처리상태 : <span style="color:red; font-weight:bold;">반려</span></div>`;
					v_html += `<div style="margin-bottom:5px;">반려사유 : \${json.feedback_msg}</div>`;
				}
			    $("div.modal-body").html(v_html);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); 
    	
    	
    	
    	$('#modal_showDetail').modal('show'); // 모달창 보여주기
    }
</script>

<div class="body">
    <div class="navigation">
        <ul>
            <li class="list">
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
            <li class="list active">
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
				<p style="font-size: 20px; font-weight: bold; color:white;">숙소등록 신청현황</p>
			</div>
			<div class="liblock">
				<ul class="reservation flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">전체 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >
						 		<c:forEach var="map" items="${requestScope.mapList}">
						 			<c:if test="${map.status == '4'}">
						 				${map.count_status}
						 			</c:if>
						 		</c:forEach>
						 	</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">처리중 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >
						 		<c:forEach var="map" items="${requestScope.mapList}">
						 			<c:if test="${map.status == '0'}">
						 				${map.count_status}
						 			</c:if>
						 		</c:forEach>
						 	</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">승인 <br><br></strong> 
						<a href="#" class="count">
							<span id="reservation_confirmed"  style="color: ff8000; font-weight: bold; font-size: 30px;">
								<c:forEach var="map" items="${requestScope.mapList}">
						 			<c:if test="${map.status == '1'}">
						 				${map.count_status}
						 			</c:if>
						 		</c:forEach>
							</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li>
						<strong style="font-size: 18px">반려 <br><br></strong>
						<a href="#" class="count">
							<span id="trip_complete" style="color: ff8000; font-weight: bold; font-size: 30px;">
								<c:forEach var="map" items="${requestScope.mapList}">
						 			<c:if test="${map.status == '2'}">
						 				${map.count_status}
						 			</c:if>
						 		</c:forEach>
							</span>
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
			    <a class="nav-link active" data-toggle="tab" href="#all">전체</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#ready">처리중</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#accept">승인</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#oppose">반려</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  	<div class="tab-pane container active" id="all">
					<table class="table table-hover">
				  		<thead>
				    		<tr>
				      			<th>#</th>
				      			<th>숙소명</th>
				      			<th>카테고리</th>
				      			<th>주소</th>
				      			<th>처리상태</th>
				      			<th>객실등록</th>
				    		</tr>
				  		</thead>
				  		<tbody>
				    	<c:forEach var="lodgingvo" items="${requestScope.lodgingvoList}">
					    	<tr class="lodgingvoList_tr">
					      		<th>${lodgingvo.lodging_code}</th>
					      		<td>${lodgingvo.lodging_name}</td>
					      		<td>${lodgingvo.lodging_category}</td>
					      		<td>${lodgingvo.lodging_address}</td>
				      			<c:if test="${lodgingvo.status == 0}"><td style="color:blue; font-weight:bold;">처리중</td></c:if>
				      			<c:if test="${lodgingvo.status == 1}"><td style="color:green; font-weight:bold;">승인</td></c:if>
				      			<c:if test="${lodgingvo.status == 2}"><td style="color:red; font-weight:bold;">반려</td></c:if>
				      			<c:if test="${lodgingvo.status == 1}"><td><button type="button" class="btn btn-light">객실등록</button></td></c:if>
					    	</tr>
					    	<input type="hidden" name="lodginvo_lodgingCode" value="${lodgingvo.lodging_code}"/>
				    	</c:forEach>
				  		</tbody>
					</table>
			  </div>
			  <div class="tab-pane container fade" id="ready">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
				      			<th>#</th>
				      			<th>숙소명</th>
				      			<th>카테고리</th>
				      			<th>주소</th>
				      			<th>처리상태</th>
				    		</tr>
						  </thead>
			    		 <tbody>
						    <c:forEach var="lodgingvo" items="${requestScope.lodgingvoList}">
							    <c:if test="${lodgingvo.status == 0 }">
							    	<tr>
							      		<th>${lodgingvo.lodging_code}</th>
							      		<td>${lodgingvo.lodging_name}</td>
							      		<td>${lodgingvo.lodging_category}</td>
							      		<td>${lodgingvo.lodging_address}</td>
						      			<c:if test="${lodgingvo.status == 0}"><td style="color:blue; font-weight:bold;">처리중</td></c:if>
						      			<c:if test="${lodgingvo.status == 1}"><td style="color:green; font-weight:bold;">승인</td></c:if>
						      			<c:if test="${lodgingvo.status == 2}"><td style="color:red; font-weight:bold;">반려</td></c:if>
							    	</tr>
							    </c:if>
							    <input type="hidden" name="lodginvo_lodgingCode" value="${lodgingvo.lodging_code}"/>
					    	</c:forEach>
						 </tbody>
					</table>
				</div>
				<div class="tab-pane container fade" id="accept">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
				      			<th>#</th>
				      			<th>숙소명</th>
				      			<th>카테고리</th>
				      			<th>주소</th>
				      			<th>처리상태</th>
				      			<th>객실등록</th>
				    		</tr>
						  </thead>
			    		 <tbody>
						    <c:forEach var="lodgingvo" items="${requestScope.lodgingvoList}">
							    <c:if test="${lodgingvo.status == 1 }">
							    	<tr>
							      		<th>${lodgingvo.lodging_code}</th>
							      		<td>${lodgingvo.lodging_name}</td>
							      		<td>${lodgingvo.lodging_category}</td>
							      		<td>${lodgingvo.lodging_address}</td>
						      			<c:if test="${lodgingvo.status == 0}"><td style="color:blue; font-weight:bold;">처리중</td></c:if>
						      			<c:if test="${lodgingvo.status == 1}"><td style="color:green; font-weight:bold;">승인</td></c:if>
						      			<c:if test="${lodgingvo.status == 2}"><td style="color:red; font-weight:bold;">반려</td></c:if>
						      			<c:if test="${lodgingvo.status == 1}"><td><button type="button" class="btn btn-light">객실등록</button></td></c:if>
							    	</tr>
							    </c:if>
							    <input type="hidden" name="lodginvo_lodgingCode" value="${lodgingvo.lodging_code}"/>
					    	</c:forEach>
						 </tbody>
					</table>
				</div>
				<div class="tab-pane container fade" id="oppose">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
				      			<th>#</th>
				      			<th>숙소명</th>
				      			<th>카테고리</th>
				      			<th>주소</th>
				      			<th>처리상태</th>
				    		</tr>
						  </thead>
			    		 <tbody>
						    <c:forEach var="lodgingvo" items="${requestScope.lodgingvoList}">
							    <c:if test="${lodgingvo.status == 2 }">
							    	<tr>
							      		<th>${lodgingvo.lodging_code}</th>
							      		<td>${lodgingvo.lodging_name}</td>
							      		<td>${lodgingvo.lodging_category}</td>
							      		<td>${lodgingvo.lodging_address}</td>
						      			<c:if test="${lodgingvo.status == 0}"><td style="color:blue; font-weight:bold;">처리중</td></c:if>
						      			<c:if test="${lodgingvo.status == 1}"><td style="color:green; font-weight:bold;">승인</td></c:if>
						      			<c:if test="${lodgingvo.status == 2}"><td style="color:red; font-weight:bold;">반려</td></c:if>
							    	</tr>
							    </c:if>
							    <input type="hidden" name="lodginvo_lodgingCode" value="${lodgingvo.lodging_code}"/>
					    	</c:forEach>
						 </tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
</div>

<%-- === 내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_showDetail" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">등록 신청 상세정보</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
      		
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	  <!-- <button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goEditMyCal()">수정</button> -->
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>