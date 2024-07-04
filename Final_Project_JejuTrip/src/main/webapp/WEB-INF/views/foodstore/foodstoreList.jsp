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

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js" ></script>

<style type="text/css">

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

.foodRecommend,
.foodRecommend:hover {
  text-decoration-line: none;
  color: black;
}

.areamap {
  width: 18%;  
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

/* 버튼 */
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

/* 맛집추천 스크롤 고정  */
@media all and (min-width: 1101px) {
    .foodRecommendList {
    position: -webkit-sticky;
    position: sticky;
    align-self: flex-start;
    top: 0;
    }
}

</style>

<script type="text/javascript">
	$(document).ready(function() {
		
		// == 카테고리 체크박스 선택하기 == //
		$("input:checkbox[name='food_category']").change(function(e){
			const arr_category = [];
			
			// 체크된 카테고리만 배열에 담기 
			$("input:checkbox[name='food_category']:checked").each(function(index, item) {
				arr_category.push($(item).val());
			});

			const str_category = arr_category.join();
			
			const frm = document.checkboxFrm;
			frm.str_category.value = str_category; 
			frm.submit();
		});
		
		// == 카테고리 체크박스 유지시키기 == //
		const str_category = "${requestScope.str_category}";
		
		if(str_category != "") {
			const arr_category = str_category.split(",");
			
			$("input:checkbox[name='food_category']").each(function(index, elmt) {
				for(let i=0; i<arr_category.length; i++) {
					if($(elmt).val() == arr_category[i]) {
						$(elmt).prop("checked", true);
						break;
					}
				}// end of for---------------------
			});
		}
		
		////////////////////////////////////////////////////////////////////////
		
		// == 지역 체크박스 선택하기 == //
		$("input:checkbox[name='area']").change(function(e){
			const arr_area = [];
			
			// 체크된 카테고리만 배열에 담기 
			$("input:checkbox[name='area']:checked").each(function(index, item) {
				arr_area.push($(item).val());
			});

			const str_area = arr_area.join();
			
			const frm = document.checkboxFrm;
			frm.str_area.value = str_area; 
			frm.submit();
		});
		
		// == 지역 체크박스 유지시키기 == //
		const str_area = "${requestScope.str_area}";
		
		if(str_area != "") {
			const arr_area = str_area.split(",");
			
			$("input:checkbox[name='area']").each(function(index, elmt) {
				for(let i=0; i<arr_area.length; i++) {
					if($(elmt).val() == arr_area[i]) {
						$(elmt).prop("checked", true);
						break;
					}
				}// end of for---------------------
			});
		}
		
		////////////////////////////////////////////////////////////////////////
		
		// == 오름차순 정렬 == //
		$("button#btnAsc").click(function() {
			const frm = document.foodstoreFrm;
			frm.orderType.value = "food_name";
			frm.orderValue_asc.value = "asc";
			frm.submit();
		});
		
		// == 내림차순 정렬 == //
		$("button#btnDesc").click(function() {
			const frm = document.foodstoreFrm;
			frm.orderType.value = "food_name";
			frm.orderValue_desc.value = "desc";
			frm.submit();
		});
		
		////////////////////////////////////////////////////////////////////////

	

	});// end of $(document).ready(function()})-------------------
</script>


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
          
        <form name="checkboxFrm">
	        <!-- 맛집 검색 카테고리 -->
	    	<div class="row py-3 mt-5 border rounded">
	            <div class="row mt-2" style="width: 70%; margin-left: 4%;">
	    			<h5 class="mr-5">카테고리 검색</h5>
    				<c:forEach var="categoryList" items="${requestScope.categoryList}" varStatus="status">
    					<div class="mr-4">
	    					<input type="checkbox" id="${status.index}" name="food_category" value="${categoryList}"/>
		                    <label for="${status.index}">${categoryList}</label>
	                    </div>
    				</c:forEach>
	        		<input type="hidden" name="str_category" />
	     		</div>
	    	</div>
	            
	        <!-- 검색 지역 선택 -->
	        <div class="row py-3 mt-1 border rounded">
	          	<div id="tabArea" class="tabArea1 text-center mt-2" style="display: flex;">
		            <div class="areaMap mr-5" style="display: flex;">
		            	<h5 class="mt-4" style="width: 20%; margin-left: 3%;">지역 선택</h5>
		                
		                <%-- <c:forEach var="areaList" items="${requestScope.areaList}" varStatus="status">
			                <div class="areamap">
			                    <div>
			                        <input name="area" id="${status.index}" type="checkbox" class="are_map" value="${areaList}">
				                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_east.png" />
			                        <label for="${status.index}" class="label_chk mt-2">${areaList}</label>
			                    </div>
			                </div>
		                </c:forEach> --%>
		                
		                <div class="areamap mx-2">
		                    <div>
		                        <input name="area" id="area02" type="checkbox" class="are_map" value="JE">
		                    	<img src="<%= ctxPath %>/resources/images/areamap_city.png" />
		                        <label for="area02" class="label_chk">제주 시내</label>
		                    </div>
		                </div>
		                <div class="areamap mx-2">
		                    <div>
		                        <input name="area" id="area03" type="checkbox" class="are_map" value="EA">
		                    	<img src="<%= ctxPath %>/resources/images/areamap_jeju_east.png" />
		                        <label for="area03" class="label_chk">제주시 동부</label>
		                    </div>
		                </div>
		                <div class="areamap mx-2">
		                    <div>
		                        <input name="area" id="area04" type="checkbox" class="are_map" value="WE">
			                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_west.png" />
		                        <label for="area04" class="label_chk">제주시 서부</label>
		                    </div>
		                </div>
		                <div class="areamap mx-2">
		                    <div>
		                        <input name="area" id="area05" type="checkbox" class="are_map" value="SE">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_city.png" />
		                        <label for="area05" class="label_chk">서귀포 시내</label>
		                    </div>
		                </div>
		                <div class="areamap mx-2">
		                    <div>
		                        <input name="area" id="area06" type="checkbox" class="are_map" value="ES">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_east.png" />
		                        <label for="area06" class="label_chk">서귀포 동부</label>
		                    </div>
		                </div>
		                <div class="areamap mx-2">
		                    <div>
		                        <input name="area" id="area07" type="checkbox" class="are_map" value="WS">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_west.png" />
		                        <label for="area07" class="label_chk">서귀포 서부</label>
		                    </div>
		                </div>
		                <input type="hidden" name="str_area" />
		            </div>
		        </div>
	        </div>	
	    </form>
        
        <!-- 정렬 조건 선택 -->
      	<div class="row mt-5">
	       <div class="sort-filter main" style="display: flex; justify-content: space-between; width: 100%">
	            <div style="width: 50%;">
					<button type="button" id="btnLike" class="sort active">인기순</button>
					<button type="button" id="btnAsc" class="sort">오름차순</button>
					<button type="button" id="btnDesc" class="sort">내림차순</button>
	            </div>
	            <div style="">
	                <input type="text" id="searchWord" class="" placeholder="맛집 이름으로 검색">
	                <button type="button" id="btnSearch" title="검색">검색</button>
	            </div>
	        </div>
      	</div>
            
        <!---------------------------------------------------------------------------------------------->
        <!-- 리스트 시작 -->
		<form name="foodstoreFrm">
			<div class="row mt-3">
			
				<!-- 맛집 리스트 -->
				<div class="col-md-8" id="foodstoreList"> 
					<c:forEach var="foodstoreList" items="${requestScope.foodstoreList}" varStatus="status">	
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
						                <span>${foodstoreList.food_address}</span>
						            </div>
						        </div>
						    </div>
						</div>
					</c:forEach>
					<!-- 오름차순, 내림차순 정렬을 위한 input 태그 -->
					<input type="hidden" name="orderType">
					<input type="hidden" name="orderValue_asc">
					<input type="hidden" name="orderValue_desc">
				</div>
				
				<!-- 맛집 랜덤 추천 -->
				<div class="foodRecommendList col-md-4">
					<div class="border rounded" style="margin-right: -5%;">
						<div class="m-4"> 
							<h4 class="mb-4">추천맛집</h4>
							<c:forEach var="randomRecommend" items="${requestScope.randomRecommend}" varStatus="status">	
								<c:if test="${status.index < 3}">
									<div class="border rounded p-3 mb-3">
										<a href="#">
								            <img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodstore/imgMain/${randomRecommend.food_main_img}" alt="..." />
								        </a>
								        <div class="mt-2" id="foodRecommend_1">
								        	<a href="" class="foodRecommend" id="recommend1">${randomRecommend.food_name}</a>
								        </div>
							      	</div>
						      	</c:if>
							</c:forEach>
						</div>
					</div>
				</div>
				
        	</div>
		</form>
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


</body>
</html>
