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

.div_img_text {
  border: solid 0px red;
  position: absolute;
  top: 50%;
  left: 50%;
  padding: 0 1%;
  transform: translate( -50%, -50% );
  color: white;
  font-size: 35pt;
  font-weight : 450;
  background-color: rgba(115, 115, 115, 0.5)
}

.main_img_text {
  text-align: center;
}

hr#line {
  width: 50%;
  margin: 3% auto 2% auto;
}

ul.list {
  border: solid 0px black;
  width : 50%;
  display: flex;
  margin: 0 auto;
}

ul.list li {
  border: solid 0px red;
  margin: 0 auto;
  list-style: none;
  display: block;
  width: 13%;
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
  margin-bottom: 10%;
}

.icon-title {
  color: gray;
}

.count {
  color: orange;
}

div#storedetail {
  width: 40%;
  margin: 3% auto;
  padding: 2%;
  background-color: rgba(115, 115, 115, 0.1);
}

div#storedetail > ul li {
  margin: 3% 0 3% -4%;
  font-size: 14pt;
  list-style: none;
  
}

li.info-detail {
  display: flex;
}

p.info-title {
  border: solid 0px blue;
  font-weight: 500;
  color: gray;
  width: 13%;
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
		<input type="text" name="food_store_code" value="${requestScope.foodstorevo.food_store_code}" />
		<img class="imgAdd img-fluid" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${requestScope.foodstorevo.food_name}_add1.jpg" alt="..." />
		<div class="div_img_text">
			<p class="main_img_text">${requestScope.foodstorevo.food_name}</p>
		</div>
	</div>
	
	<hr id="line">
	
	<ul class="list">

		<li class="list-item">
			<button type="button" class="iconbtn">
				<div class="item-each">
					<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_like.png">
				</div>
				<p class="icon-title">좋아요</p>
				<p class="count">30</p>
			</button>
		</li>
		
		<li class="list-item">
			<button type="button" class="iconbtn">
				<div class="imgicon">
					<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_mine.png">
				</div>
				<p class="icon-title">찜하기</p>
				<p class="count">10</p>
			</button>
		</li>
		
		<li class="list-item">
			<button type="button" class="iconbtn">
				<div>
					<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_review2.png">
				</div>
				<p class="icon-title">리뷰</p>
				<p class="count">5</p>
			</button>
		</li>
		
		<li class="list-item">
			<button type="button" class="iconbtn">
				<div>
					<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_calender.png">
				</div>
				<p class="icon-title">일정에 추가</p>
				<p class="count">30</p>
			</button>
		</li>
		
		<li class="list-item">
			<button type="button" class="iconbtn" style="cursor: default;">
				<div>
					<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_viewcount.png">
				</div>
				<p class="icon-title">조회수</p>
				<p class="count">128</p>
			</button>
		</li>
	
	</ul>
	
	<div class="border" id="storedetail">
		<h3 class="mb-5">상세정보</h3>
		
			
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
	
	<div class="border img-add mb-5">
		<h3 class="mb-5">추가이미지</h3>
		<div class="imgList">
			<c:forEach var="addimgList" items="${requestScope.addimgList}" varStatus="status">
				<img class="images" src="<%= ctxPath %>/resources/images/foodstore/imgAdd/${addimgList.food_add_img}">
			</c:forEach>
		</div>
	</div>
</div>

