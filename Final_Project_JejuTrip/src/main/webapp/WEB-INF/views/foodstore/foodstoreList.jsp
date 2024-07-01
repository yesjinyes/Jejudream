<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<%-- 직접 만든 JS --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/foodstore/foodstore.js" ></script>

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js" ></script>

<style type="text/css">

body { 
  font-family: 'Poppins', sans-serif;
}

.single-post {
  margin-bottom: 20px;
  border: 1px solid #ebebeb;
  border-radius: 5px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.single-post:hover {
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}


.title a {
  margin: 10px 0;
  color: black;
  text-decoration: none;
  transition-duration: 300ms;
  text-transform: capitalize;

}

.title a:hover {
  color: #ff854d;
  text-decoration: none;
}

.slider-container {
  width: 80%;
  text-align: center;
}

.slider {
  width: 100%;

}

.price-display {
  font-size: 20px;

}

ul#food_category {
  display: flex;
  width: 40%;
}

.nav-item {
  display: flex;
}

.foodRecommend,
.foodRecommend:hover {
  text-decoration-line: none;
  color: black;
}

.areamap {
  width: 15%;  
}

.imgMainList {
  width: 35%;
  height: 190px;
}

.imgMain {
  height: 190px;
  width: 100%;
  object-fit: cover;
}

.contentList {
  flex: 1; 
  display: flex; 
  flex-direction: column; 
  justify-content: space-between; 
  padding-left: 20px;
  margin-right: 1%;
}

button.sort {
  border: #737373;
  border-radius: 5px;
  padding: 0.8% 2%;
  background-color: #ffdccc;
  color: #404040;
}

button.sort:hover {
  background-color: #ffa880;
}

button#btnSearch {
  border: gray;
  border-radius: 5px;
}


@media all and (min-width: 1101px) {
    .foodRecommendList {
    position: -webkit-sticky;
    position: sticky;
    align-self: flex-start;
    top: 0;
    }
}

.imgRecommend {
   width: 100%;
   height: 170px;
}

</style>


<title>foodStore</title>
</head>
<body>

    <div class="container">
    
    	<!-- Jeju Dream 로고 -->
		<div class="col-12 text-center">
		    <h2>
		    	<img src="<%= ctxPath %>/resources/images/foodstore/logo.jpg" style="width: 5%;"/> 
		        <a href="index.html">Jeju Dream</a>
		    </h2>
		</div>
          
        <!-- 맛집 검색 카테고리 -->
    	<div class="row py-3 mt-5 border rounded">
            <div class="row mt-2" style="width: 70%; margin-left: 4%;">
    			<h5 class="mr-5">카테고리 검색</h5>
                <div class="mr-4">
                    <input type="checkbox" id="korean" name="food_category" value="korean"/>
                    <label for="korean">한식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="japanese" name="food_category" value="japanese" />
                    <label for="japanese">일식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="western" name="food_category" value="western" />
                    <label for="western">양식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="chinese" name="food_category" value="chinese" />
                    <label for="chinese">중식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="etc" name="food_category" value="etc" />
                    <label for="etc">기타</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="cafe" name="food_category" value="cafe" />
                    <label for="cafe">카페</label>
                </div>
     		</div>
    	</div>
            
        <!-- 검색 지역 선택 -->
        <div class="row py-3 mt-1 border rounded">
          	<div id="tabArea" class="tabArea1 text-center mt-2" style="display: flex; /*align-items: center;*/">
	            <div class="areaMap" style="display: flex;">
	            	<h5 class="mt-4" style="width: 20%; margin-left: 3%;">지역 선택</h5>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_total.png" />
	                    <div>
	                        <input id="area01" type="checkbox" class="are_map" value="">
	                        <br><label for="area01" class="label_chk">전체</label>
	                    </div>
	                </div>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_city.png" />
	                    <div>
	                        <input name="area" id="area02" type="checkbox" class="are_map" value="JE">
	                        <label for="area02" class="label_chk">제주 시내권</label>
	                    </div>
	                </div>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_east.png" />
	                    <div>
	                        <input name="area" id="area03" type="checkbox" class="are_map" value="EA">
	                        <label for="area03" class="label_chk">제주시 동부</label>
	                    </div>
	                </div>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_west.png" />
	                    <div>
	                        <input name="area" id="area04" type="checkbox" class="are_map" value="WE">
	                        <label for="area04" class="label_chk">제주시 서부</label>
	                    </div>
	                </div>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_bt_city.png" />
	                    <div>
	                        <input name="area" id="area05" type="checkbox" class="are_map" value="SE">
	                        <label for="area05" class="label_chk">중문/서귀포</label>
	                    </div>
	                </div>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_bt_east.png" />
	                    <div>
	                        <input name="area" id="area06" type="checkbox" class="are_map" value="ES">
	                        <label for="area06" class="label_chk">서귀포 동부</label>
	                    </div>
	                </div>
	                <div class="areamap mx-2">
	                    <img src="<%= ctxPath %>/resources/images/areamap_bt_west.png" />
	                    <div>
	                        <input name="area" id="area07" type="checkbox" class="are_map" value="WS">
	                        <label for="area07" class="label_chk">서귀포 서부</label>
	                    </div>
	                </div>
	            </div>
	        </div>
        </div>	
        
        <!-- 정렬 조건 선택 -->
      	<div class="row mt-5">
	       <div class="sort-filter main" style="display: flex; justify-content: space-between; width: 100%">
	            <div style="width: 50%;">
					<button type="button" onclick="" class="sort active" value="">추천순</button>
					<button type="button" onclick="" class="sort" value="PRICE">낮은가격순</button>
					<button type="button" onclick="" class="sort" value="PRICE_DESC">높은가격순</button>
					<button type="button" onclick="" class="sort" value="NEW">최신등록순</button>
	            </div>
	            <div style="">
	                <input type="text" id="searchWord" class="" placeholder="맛집 이름으로 검색">
	                <button type="button" id="btnSearch" title="검색">검색</button>
	            </div>
	        </div>
      	</div>
            
        <!---------------------------------------------------------------------------------------------->
        <!-- 리스트 시작 -->
		<div class="row mt-3">
			<form name="foodstoreFrm">
				<!-- 맛집 리스트 -->
				<div class="col-md-8" id="foodstoreList"> 
					<c:forEach var="foodstoreList" items="${requestScope.foodstoreList}">	
						<div class="row">
					    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
					    		<div class="imgMainList">
						    		<a href="#">
						            	<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodstore/imgMain/${foodstoreList.food_main_img}" alt="..." />
						        	</a>
					        	</div>
						        <div class="contentList">
						            <div class="mb-3">
						            	<h3 class="pt-3 title"><a href="#">${foodstoreList.food_name}</a></h3>
						            	<span>${foodstoreList.food_content}</span>
						            </div>
						            <div class="pb-3">
						                <span style="color:#b5aec4;">${foodstoreList.food_category}</span><br>
						                <input type="text" name="food_category" value="${foodstoreList.food_category}"/>
						                <span>${foodstoreList.food_address}</span>
						            </div>
						        </div>
						    </div>
						</div>
					</c:forEach>
				</div>
				
				<!-- 맛집 랜덤 추천 -->
				<div class="foodRecommendList col-md-4">
					<div class="border rounded" style="margin-right: -5%;">
						<div class="m-4"> 
							<h4 class="mb-4">추천맛집</h4>
							
							<div class="border rounded p-3">
								<a href="#">
						            <img class="imgRecommend" src="<%= ctxPath %>/resources/images/lodginglist/비자림미담독채펜션_thum.jpg" alt="..." />
						        </a>
						        <div class="mt-2" id="foodRecommend_1">
						        	<a href="" class="foodRecommend">맛집추천게시물1</a>
						        </div>
					      	</div>
					      	
					      	
					      	<div class="border rounded p-3 mt-2">
									<a href="#">
							        	<img class="imgRecommend" src="<%= ctxPath %>/resources/images/lodginglist/비자림미담독채펜션_thum.jpg" alt="..." />
							        </a>
							        <div class="mt-2" id="foodRecommend_2">
							        	<a href="" class="foodRecommend">맛집추천게시물2</a>
							        </div>
					      	</div>
					      	
					      	<div class="border rounded p-3 mt-2">
								<a href="#">
						            <img class="imgRecommend" src="<%= ctxPath %>/resources/images/lodginglist/비자림미담독채펜션_thum.jpg" alt="..." />
						        </a>
						        <div class="mt-2">
						        	<a href="" class="foodRecommend">맛집추천게시물2</a>
						        </div>
					      	</div>
							
						</div>
					</div>
				</div>
				
			</form>
        </div>
        <!---------------------------------------------------------------------------------------------->
        
        <!-- 페이징 임의로 넣어둠 -->        
        <div class="pagination-area">
            <nav aria-label="#">
                <ul class="pagination pagination-sm justify-content-center">
                    <li class="page-item active">
                        <a class="page-link" href="#">1 <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next <i class="fa fa-angle-double-right" aria-hidden="true"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
        
	</div> 

 
 
<%-- <form name="foodstoreFrm">
	<input type="text" name="food_name" />
	<input type="text" name="food_category" value="${requestScope. }" />
	

</form>
  --%>
 
 
</body>
</html>
