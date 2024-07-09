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
  margin: 3% auto 5% auto;
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
  border: solid 1px red;
  /* margin: 0 auto; */
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

div.img-add {
  width: 80%;
  padding: 2%;
  margin: 0 auto;
}

div.imgList {
  border: solid 0px red;
  margin-left: 0.3%;
  
}

img.images {
  width: 33.1%;
  height: 400px;
}



</style>

<script type="text/javascript">

	$(document).ready(function() {
		
	
		
	});// end of $(document).ready(function() {})-----------------------------
	
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
	
		<!-- 추가이미지 캐러셀 -->
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
	
		<!-- 오른쪽 div -->
		<div class="col-md-7">
			<div class="border rounded" style="margin: 0 -2% 0 2%; padding: 3% 0 2% 0;">
				<!-- 아이콘 모음 -->
				<ul class="list" style="border: solid 0px black; display: flex;">
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
						<button type="button" class="iconbtn">
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
		
				<!-- 상세 정보 -->
				<div class="border rounded" id="storedetail">
					<h3 class="mb-5 mt-2 ml-2">상세정보</h3>
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
		</div>
	</div>
	
	<!-- 맛집 추가이미지 -->
 	<%-- <div class="border img-add mb-5">
		<h3 class="mb-5">추가이미지</h3>
		<div class="imgList">
			<c:forEach var="addimgList" items="${requestScope.addimgList}" varStatus="status">
				<img class="images" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${addimgList.food_add_img}">
			</c:forEach>
		</div>
	</div> --%>
	

	
	
</div>

