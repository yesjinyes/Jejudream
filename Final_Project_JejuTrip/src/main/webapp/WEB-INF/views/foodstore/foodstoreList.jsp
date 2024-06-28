<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>
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

body {
  font-family: 'Poppins', sans-serif;
}
/* 
li {

  list-style: none;
}
 */

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


<script type="text/javascript">
$(document).ready(function(){
	
	const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const day = String(today.getDate()).padStart(2, '0');
    
    
    $('input#datepicker').keyup( (e)=>{
        // 생년월일 input태그가 text 타입인데 키보드로 문자를 입력하려고할때 막아야한다 마우스클릭으로만 가능하게끔
            $(e.target).val("").next().show(); // 에러메시지 표현

        }); // end of $('input#datepicker').keyup( (e)=>{})

       
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // **** 아래거는 jsp파일에 주석처리된 투숙날짜달력에 적용되는 태그로서 시작일자 종료일자를 세팅해주게끔 해주는 것이다!!! 유용할듯 ******    

        // === 전체 datepicker 옵션 일괄 설정하기 ===  
        //     한번의 설정으로 $("input#fromDate"), $('input#toDate')의 옵션을 모두 설정할 수 있다.
        $(function() {
        //모든 datepicker에 대한 공통 옵션 설정
        $.datepicker.setDefaults({
             dateFormat: 'yy-mm-dd' //Input Display Format 변경
            ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
            ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
            ,changeYear: true //콤보박스에서 년 선택 가능
            ,changeMonth: true //콤보박스에서 월 선택 가능                
         // ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
         // ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
         // ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
         // ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
            ,yearSuffix: "년" //달력의 년도 부분 뒤에 붙는 텍스트
            ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
            ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
            ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
            ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
          ,minDate: "0D" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
          ,maxDate: "+1Y" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)                    
        });
 
        // input을 datepicker로 선언
        $("input#fromDate").datepicker();                    
        $("input#toDate").datepicker();
        
        
        // From의 초기값을 오늘 날짜로 설정
        $('input#fromDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
        
        // To의 초기값을 1일후로 설정
        $('input#toDate').datepicker('setDate', '+1D'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
        
        $('input#toDate').datepicker('option', 'minDate', '+1D');
     });
   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    $('input#datepicker').bind("change", (e)=> {
    // 생년월일에 입력되어진값이 변경되었다면 에러메시지를 지워야한다

        if($(e.target).val() != "" ){
        // 정상적이지않으면 자동으로 값이 ""로 된다! 그렇기때문에 올바른값을 검사하는 기준이 된다
            $(e.target).next().hide();
            
        }// 생년월일에 마우스로 달력에 있는 날짜를 선택한 경우 이벤트 처리 한것 


    }); // end of $('input#datepicker').bind("change", (e)=> {})
   
	
})

</script>

<title>foodStore</title>
</head>
<body>

    <div class="container">
    
    	<!-- Jeju Dream 로고 -->
		<div class="col-12 text-center">
		    <h2>
		    	<img src="<%= ctxPath %>/resources/images/foodStore/logo.jpg" style="width: 5%;"/> 
		        <a href="index.html">Jeju Dream</a>
		    </h2>
		</div>
          
        <!-- 맛집 검색 카테고리 -->
    	<div class="row py-3 mt-5 border rounded">
            <div class="row mt-2" style="width: 70%; margin-left: 4%;">
    			<h5 class="mr-5">카테고리 검색</h5>
                <div class="mr-4">
                    <input type="checkbox" id="korean" />
                    <label for="korean">한식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="japanese" />
                    <label for="japanese">일식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="western" />
                    <label for="western">양식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="chinese" />
                    <label for="chinese">중식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="etc" />
                    <label for="etc">기타</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" id="cafe" />
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
		
			<!-- 맛집 리스트 -->
			<div class="col-md-8"> 
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				            	<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/물꼬해녀의집.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">${requestScope.foodStoreList.food_name}</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/성산일출봉 아시횟집.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">성산일출봉 아시횟집</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/돌집식당.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">돌집식당</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>

				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/대윤흑돼지 서귀포올레시장점.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">대윤흑돼지 서귀포올레시장점</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/제주 판타스틱버거.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">제주 판타스틱버거</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/동백키친.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">동백키친</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/젠하이드어웨이 제주점.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">젠하이드어웨이 제주점</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/영육일삼.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">영육일삼</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/미도리제주.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">미도리제주</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/구르메스시 오마카세.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">구르메스시 오마카세</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/강정중국집.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">강정중국집</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/연태만.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">연태만</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="row">
			    	<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
			    		<div class="imgMainList">
				    		<a href="">
				    			<img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodStore/imgMain/서울앵무새 제주.jpg" alt="..." />
				        	</a>
			        	</div>
				        <div class="contentList" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
				            <div class="mb-3">
				            	<h3 class="pt-3 title"><a href="#">서울앵무새 제주</a></h3>
				            	<span>해녀가 바로 손질해주는 해산물 맛집</span>
				            </div>
				            <div class="pb-3">
				                <span style="color:#b5aec4;">한식</span><br>
				                <span>제주시 우도면</span>
				            </div>
				        </div>
				    </div>
				</div>
			</div>
			
			<!-- 맛집 추천 -->
			<div class="foodRecommendList col-md-4">
				<div class="border rounded" style="margin-right: -5%;">
					<div class="m-4"> 
						<h4 class="mb-4">추천맛집</h4>
						<div class="border rounded p-3">
							<a href="#">
					            <img class="imgRecommend" src="<%= ctxPath %>/resources/images/lodginglist/비자림미담독채펜션_thum.jpg" alt="..." />
					        </a>
					        <div class="mt-2">
					        	<a href="" class="foodRecommend">맛집추천게시물1</a>
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
 
 
 	<form name="foodStoreFrm">
 		<input type="text" name="foodName" />
 		<input type="text" name="content" />
 		<input type="text" name="category" />
 		<input type="text" name="address" />
 	</form>
 
 
 
</body>
</html>
