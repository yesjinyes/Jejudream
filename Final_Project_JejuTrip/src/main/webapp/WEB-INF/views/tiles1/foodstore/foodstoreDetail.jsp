<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<style type="text/css">


.imgcrop {
  max-height: 420px;
  overflow: hidden;
  position: relative;
}

.imgcrop img{
  width: 100%;
  max-height: initial;
  margin-top: -30%;
}

.main_img_title {
  border: solid 0px red;
  position: absolute;
  top: 45%;
  left: 50%;
  padding: 0 1%;
  transform: translate( -50%, -50% );
  color: white;
  font-size: 40pt;
  font-weight : 500;
  background-color: rgba(115, 115, 115, 0.5)
}

.main_img_content {
  text-align: center;
}

.main_img_content {
  border: solid 0px red;
  position: absolute;
  top: 70%;
  left: 50%;
  padding: 0 1%;
  transform: translate( -50%, -50% );
  color: white;
  font-size: 20pt;
  font-weight : 450;
}

.main_img_title {
  text-align: center;
}


hr#line {
  width: 70%;
  margin: 6% auto 3% auto;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

/* 추가이미지 캐러셀 */
div.add_img_carousel {
  overflow: hidden;
}

div.add_img_carousel img{
  border: solid 0px blue;
  object-fit:cover;
  width: 100%;
  height: 500px;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

ul.list {
  list-style: none;
}

ul.list li {
  border: solid 0px red;
  margin: 2% 2% 0 2%;
  list-style: none;
  display: block;
  width: 17%;
  text-align: center;
  font-size: 15pt;
}

button.iconbtn {
  border: none;
  background-color: white;
}

div.item-each {
  display: block;
}


img.icon {
  width: 30%;
  margin-bottom: 5%;
}

.icon-title {
  color: gray;
  font-size: 13pt;
}

.count {
  color: orange;
  margin-top: -8%;
  font-size: 13pt;
}

div#storedetail {
  width: 90%;
  margin: 3% auto;
  padding: 3% 0 1% 5%;
  background-color: rgba(115, 115, 115, 0.1);
}

div#storedetail > ul li {
  margin: 1% 0 1% -4%;
  font-size: 14pt;
  list-style: none;
  
}

li.info-detail {
  display: flex;
}

p.info-title {
  border: solid 0px blue;
  font-weight: 550;
  color: gray;
  width: 16%;
}

/*--------------------------*/
/* 리뷰 */
div#reviewList {
  width: 70%;
 /*  height: 300px; */
  margin: 5% auto;
  padding: 3%;
}

</style>

<script type="text/javascript">

	$(document).ready(function() {

		
		
	});// end of $(document).ready(function() {})-----------------------------
	
	
	// == 내 일정에 추가 == //
	function addSchedule() {
		$("#calendarModal").modal("show");
	}
	

	////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////
	
	// Function declaration
	function goAddReview() {
		
		const review_content = $("input:text[name='review_content']").val().trim();
		console.log("~~확인용 review_content => " + review_content);
		
		if(review_content == "") {
			alert("리뷰 내용을 입력하세요!");
			return;
		}
		
		
		queryString = $("form[name='addWriteFrm']").serialize();
		
		$.ajax({
			url:"<%= ctxPath%>/addReview.trip",
	        data: queryString,
	        type:"post",
	        dataType:"json",
	        success:function(json){
	        	console.log("리뷰 JSON 확인 : ", JSON.stringify(json));
	        	// {"food_store_code":"5316","fk_userid":"yy6037","n":0}
	        	
	        	
	        	//$("input:text[name='review_content']").val("");
	        },
	        error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});// end of $.ajax({})--------
		
		
	}// end of function goAddReview()--------------------------------------------------
	
</script>



<div id="container">
	
	<div class="imgcrop">
		<img class="imgAdd img-fluid" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${requestScope.foodstorevo.food_name}_add1.jpg" alt="..." />
		<div class="div_img_text">
			<p class="main_img_title">${requestScope.foodstorevo.food_name}</p>
			<p class="main_img_content">${requestScope.foodstorevo.food_content}</p>
		</div>
	</div>
	
	<hr id="line">
	
	<div class="row" style="width: 70%; margin: 0 auto;">
	
		<!-- 추가이미지 캐러셀 시작-->
		<div class="col-md-5">
			<div id="carousel-images" class="carousel slide add_img_carousel" data-ride="carousel">
				<ol class="carousel-indicators">
					<li data-target="#carousel-images" data-slide-to="0" class="active"></li>
					<li data-target="#carousel-images" data-slide-to="1"></li>
					<li data-target="#carousel-images" data-slide-to="2"></li>
				</ol>
				<div class="carousel-inner">
					<div class="carousel-item active">
						<img class="carousel-img" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${requestScope.foodstorevo.food_name}_add3.jpg" class="d-block w-100" alt="...">
					</div>
					<div class="carousel-item">
						<img class="carousel-img" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${requestScope.foodstorevo.food_name}_add2.jpg" class="d-block w-100" alt="...">	      
					</div>
					<div class="carousel-item">
						<img class="carousel-img" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${requestScope.foodstorevo.food_name}_add1.jpg" class="d-block w-100" alt="...">
					</div>
				</div>
				<a class="carousel-control-prev" href="#carousel-images" role="button" data-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="sr-only">Previous</span>
				</a>
				<a class="carousel-control-next" href="#carousel-images" role="button" data-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"></span>
					<span class="sr-only">Next</span>
				</a>
			</div>
		</div>
		<!-- 추가이미지 캐러셀 끝 -->
	
		<!-- 오른쪽 div -->
		<div class="col-md-7">
			<div class="border rounded" style="margin: 0 -2% 0 2%; padding: 3% 0 2% 0;">
				
				<!-- 아이콘 모음 시작 -->
				<ul class="list" style="display: flex; margin-left: 8%;">
					<li class="list-item">
						<button type="button" class="iconbtn">
							<div class="item-each">
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_like.png">
							</div>
							<p class="icon-title">좋아요</p>
						</button>
						<p class="count">30</p>
					</li>
					<li class="list-item">
						<button type="button" class="iconbtn">
							<div>
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_review2.png">
							</div>
							<p class="icon-title">리뷰</p>
						</button>
						<p class="count">5</p>
					</li>
					<li class="list-item">
						<button type="button" class="iconbtn" onclick="addSchedule()">
							<div>
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_calender.png">
							</div>
							<p class="icon-title">일정에 추가</p>
						</button>
						<p class="count">30</p>
					</li>
					<li class="list-item">
						<button type="button" class="iconbtn" style="cursor: default;">
							<div>
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_viewcount.png">
							</div>
							<p class="icon-title">조회수</p>
						</button>
						<p class="count">128</p>
					</li>
				</ul>
				<!-- 아이콘 모음 끝-->
				
				<!-- 일정 추가 모달 시작-->
			    <div class="modal fade" id="calendarModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			        <div class="modal-dialog" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <h5 class="modal-title" id="exampleModalLabel">내 일정에 추가</h5>
			                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			                        <span aria-hidden="true">&times;</span>
			                    </button>
			                </div>
			                <div class="modal-body" style="padding: 7%;">
			                    <div class="form-group">
			                    	<label for="food_name" class="col-form-label">맛집 이름</label>
			                        <input type="text" class="form-control mb-3" id="food_name" name="food_name" readonly="readonly" value="${requestScope.foodstorevo.food_name}">
			                        <label for="calendar_title" class="col-form-label">일정 제목</label>
			                        <input type="text" class="form-control mb-3" id="calendar_title" name="calendar_title">
			                        <label for="calendar_content" class="col-form-label">일정 내용</label>
			                        <input type="text" class="form-control mb-3" id="calendar_content" name="calendar_content">
			                        
			                        <label for="taskId" class="col-form-label">시작 일자</label>
			                        <br>
			                  <input type="date" id="calendar_start_time" name="calendar_start_time"/>&nbsp; 
			                  <select id="startHour" class="form-select"></select> 시
			                  <select id="startMinute" class="form-select"></select> 분
			                  
			                  <br>
			                  <label for="taskId" class="col-form-label">종료 일자</label>
			                  <br>
			                  <input type="date" id="calendar_end_time" name="calendar_end_time"/>&nbsp;
			                  <select id="endHour" class="schedule"></select> 시
			                  <select id="endMinute" class="schedule"></select> 분&nbsp;
			                  <input type="checkbox" id="allDay"/>&nbsp;<label for="allDay">종일</label>
			                  
			                  <input type="hidden" name="startdate"/>
			                  <input type="hidden" name="enddate"/>
			                  <input type="hidden" name="schedule_seq"/>
			                    </div>
			                </div>
			                <div class="modal-footer">
			                    <button type="button" class="btn btn-info" id="EditCalendar">등록</button>
			                    <button type="button" class="btn btn-secondary" data-dismiss="modal"
			                        id="sprintSettingModalClose">취소</button>
			                </div>
			    
			            </div>
			        </div>
			    </div>
				<!-- 일정 추가 모달 끝-->
				
				<!-- 상세 정보 -->
				<div class="border rounded" id="storedetail">
					<h4 class="mb-5 mt-2 ml-2">상세정보</h4>
					<c:if test="${not empty requestScope.foodstorevo.food_store_code}">
						<ul>
							<li class="info-detail">
								<p class="info-title">카테고리</p>
								<p class="info-content">${requestScope.foodstorevo.food_category}</p>
							</li>
							<li class="info-detail">
								<p class="info-title">주소</p>
								<p class="info-content">${requestScope.foodstorevo.food_address}</p>
							</li>
							<li class="info-detail">
								<p class="info-title">영업시간</p>
								<p class="info-content">${requestScope.foodstorevo.food_businesshours}</p>
							</li>
							<li class="info-detail">
								<p class="info-title">연락처</p>
								<p class="info-content">${requestScope.foodstorevo.food_mobile}</p>
							</li>
						</ul>
					</c:if>
					
					<c:if test="${empty requestScope.foodstorevo.food_store_code}">
						<div>해당 상세페이지 없음</div>
					</c:if>
				</div>
				
			</div>
		</div><!-- 우측 div 끝 -->
	</div> <!-- row 끝 -->
	
	<!-- //////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- //////////////////////////////////////////////////////////////////////////////////////////////////////////// -->










	<!-- 맛집 리뷰 -->
	<div class="border rounded" id="reviewList">

		<!-- 리뷰쓰기 폼 추가 -->
        <c:if test="${not empty sessionScope.loginuser}">
           <h3 style="margin-top: 50px;">리뷰 쓰기</h3>
           <form name="addWriteFrm" id="addWriteFrm" style="margin-top: 20px;">
               <table class="table" style="width: 1024px">
                    <tr style="height: 30px;">
                       <th width="10%">아이디</th>
                       <td>
                          <input type="text" name="fk_userid" value="${sessionScope.loginuser.userid}" readonly />
                          <%-- <input type="text" name="name" value="${sessionScope.loginuser.name}" readonly /> --%>
                       </td>
                    </tr>
                    
                    <tr style="height: 30px;">
                       <th>작성된 리뷰 </th>
                       <td>
                          <input type="text" name="review_content" size="100" maxlength="1000" />
                          
                          <!-- 리뷰에 달리는 원게시물 글번호(즉, 리뷰의 부모글 글번호) -->
                          <input type="hidden" name="food_store_code" value="${requestScope.foodstorevo.food_store_code}" />
                       </td>
                    </tr>
                    
                    <tr>
                     <th colspan="2">
                          <button type="button" class="btn btn-success btn-sm mr-3" onclick="goAddReview()">리뷰쓰기</button>
                         <button type="reset" class="btn btn-success btn-sm">리뷰쓰기 취소</button>
                     </th>
                    </tr>

				</table>       
				
				<input type="hidden" name="parent_code" value="${requestScope.foodstorevo.food_store_code}" />  
			</form>
		</c:if>

		<!-- 리뷰 내용 보여주기 -->
		<h3 class="mb-5">작성된 리뷰</h3>
		<table class="table" style="margin-bottom: 3%;">
			<thead>
				<tr>
					<th style="width: 6%;">순번</th>
					<th style="text-align: center;">내용</th>
					<th style="width: 12%; text-align: center;">작성자 아이디</th>
					<th style="width: 12%; text-align: center;">작성일자</th>
					<th style="width: 12%; text-align: center;">수정/삭제</th>
				</tr>
			</thead>
			<tbody id="commentDisplay"></tbody>
		</table>
		
		<!-- 리뷰 페이지바가 보여지는 곳 -->
		<div style="display: flex; margin-bottom: 50px;">
        	<div id="pageBar" style="margin: auto; text-align: center;"></div>
        </div>
		
	</div>
	<!-- 리뷰 끝 -->
	
	
</div>
<!-- container 끝 -->






