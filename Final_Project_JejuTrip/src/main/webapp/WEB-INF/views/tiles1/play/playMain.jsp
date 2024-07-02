<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

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

<link rel='stylesheet prefetch' href='https://fonts.googleapis.com/css?family=Montserrat:300,400,700'>


<style type="text/css">

/*구글 웹 폰트 적용*/
@import url('https://fonts.googleapis.com/css2?family=Dongle&family=Sunflower:wght@300&display=swap');

.inner_back{
  font-family: "Dongle", sans-serif;
  font-weight: 300;
  font-style: normal;
  font-size: 26px;
	}


.container {
  font-family: "Dongle", sans-serif;
  font-weight: 200;
  font-style: normal;
  font-size: 25px;
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
    color: #ffdccc;
    text-decoration: none;
}

/*-----------------------------------------------------------------------------------------  */

*{
  margin: 0;
  padding: 0;
  -webkit-box-sizing: border-box;
          box-sizing: border-box;
}

.wrapper{
  width: 100%;
  margin: 0 auto;
  max-width: 150rem;
}

.cols{
  display: flex;
  justify-content: center;
  -ms-flex-wrap: wrap;
      flex-wrap: wrap;
  -webkit-box-pack: center;
}

.col{
  width: calc(25% - 2rem);
  margin: 1rem;
  cursor: pointer;
}

.container_card{

  -webkit-transform-style: preserve-3d;
          transform-style: preserve-3d;
  -webkit-perspective: 1000px;
          perspective: 1000px;
  margin-bottom: 40px;
}

.front,
.back{
  background-size: cover;
  box-shadow: 0 4px 8px 0 rgba(0,0,0,0.25);
  border-radius: 10px;
  background-position: center;
  -webkit-transition: -webkit-transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: -webkit-transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
  -o-transition: transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: transform .7s cubic-bezier(0.4, 0.2, 0.2, 1), -webkit-transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
  -webkit-backface-visibility: hidden;
          backface-visibility: hidden;
  text-align: center;
  min-height: 400px;
  height: auto;
  border-radius: 10px;
  color: #fff;
  font-size: 1.5rem;

}

.back{
 	background: #d1d1e0;
}

.front:after{
  position: absolute;
    top: 0;
    left: 0;
    z-index: 1;
    width: 100%;
    height: 100%;
    content: '';
    display: block;
    opacity: .1;
    background-color: #000;
    -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
    border-radius: 10px;
}
.container_card:hover .front,
.container_card:hover .back{
    -webkit-transition: -webkit-transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
    transition: -webkit-transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
    -o-transition: transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
    transition: transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
    transition: transform .7s cubic-bezier(0.4, 0.2, 0.2, 1), -webkit-transform .7s cubic-bezier(0.4, 0.2, 0.2, 1);
}

.back{
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
}

.inner_front{
    -webkit-transform: translateY(-50%) translateZ(60px) scale(0.94);
            transform: translateY(-50%) translateZ(60px) scale(0.94);
    top: 70%;
    position: absolute;
    left: 90px;
    width: 100%;
    padding: 2rem;
    -webkit-box-sizing: border-box;
            box-sizing: border-box;
    outline: 1px solid transparent;
    -webkit-perspective: inherit;
            perspective: inherit;
    z-index: 2;
    font-weight: bold;
    color: black;
}
.inner_front:before {
  content: '';
  position: absolute;
  top: 50%; 							/* 요소 중앙에 배치 */
  left: 50%;							/* 요소 중앙에 배치 */
  transform: translate(-50%, -50%);		/* 중앙 정렬 보정 */
  width: 200px; 						/* 동그라미의 너비 */
  height: 200px; 						/* 동그라미의 높이 */
  background-color: rgba(255, 255, 255, 0.7); /* 동그라미 색상 및 불투명도 */
  border-radius: 50%; 					/* 동그라미 모양으로 만들기 */
  z-index: -1; 							/* 텍스트 뒤로 배치 */
  }
  
 
.inner_back{
    border: 0px red solid;
    position: absolute;
    width: 100%;
    height: 400px;
    padding: 1rem;
    text-align: left;
    overflow: auto;
    color: black;
    
}
/* .inner_back::-webkit-scrollbar {
  display: none;
} */

 .inner_back::-webkit-scrollbar {
    width: 10px;
  }
  .inner_back::-webkit-scrollbar-thumb {
    background-color: #ff8000;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
  }
  .inner_back::-webkit-scrollbar-track {
    background-color: grey;
    border-radius: 10px;
    box-shadow: inset 0px 0px 5px white;
  }

.container_card .back{
    -webkit-transform: rotateY(180deg);
            transform: rotateY(180deg);
   
}

.container_card .front{
    -webkit-transform: rotateY(0deg);
            transform: rotateY(0deg);
  
}

.container_card:hover .back{
  -webkit-transform: rotateY(0deg);
          transform: rotateY(0deg);
  
}

.container_card:hover .front{
  -webkit-transform: rotateY(-180deg);
          transform: rotateY(-180deg);
 
}


.front .inner_front p{
  font-size: 25px;
  margin-bottom: 2rem;
  position: relative;
}

.front .inner_front p:after{
  content: '';
  width: 4rem;
  height: 2px;
  position: absolute;
  background: #ff8000;
  display: block;
  left: 0;
  right: 0;
  margin: 0 auto;
  bottom: -.75rem;
}

.list-group-item  {cursor: pointer; }
   .moveColor {color: #660029; font-weight: bold; background-color: #ffffe6;}


/*-----------------------------------------------------------------------------------------  */
</style>


<script type="text/javascript">
$(document).ready(function(){
	
    let start = 1;  // HIT상품 게시물을 더보기 위하여 "스크롤" 이벤트 대한 초기값 호출하기 
    let lenHIT = 8; // HIT 상품 "스크롤"을 할 때 보여줄 상품의 개수(단위)크기 
    let category = '전체';
    
    displayHIT(start,category); // 스크롤 초기값
    
	$(".list-group-item").hover(function(e){
        $(e.target).addClass("moveColor");
          }, 
          function(e){
           $(e.target).removeClass("moveColor");  
          });	
	
	 $('.list-group-item').on('click', function() {
         category = $(this).find('input').val();
         start = 1; // 카테고리 변경 시, 시작 위치 초기화
         $("div#categoryList").empty(); // 기존 콘텐츠 비우기
         $("span#end").empty(); // 끝 메시지 비우기
         $("span#countHIT").text("0"); // 카운트 초기화
 		 console.log(category);
	 	 displayHIT(start,category);
     });
    
    
    //===스크롤 이벤트 발생시키기 시작 ===//
    $(window).scroll(function(){

        if($(window).scrollTop() == $(document).height() - $(window).height() ){
        
            // 만약에 위의 값대로 잘 안되면 아래의 것을 하도록 한다.     
            // if( $(window).scrollTop() + 1 >= $(document).height() - $(window).height() ) {    
        
            //alert("기존 문서내용을 끝까지 봤습니다. 이제 새로운 내용을 읽어다가 보여드리겠습니다.")
            if( $("span#totalHITCount").text() != $("span#countHIT").text() ){
                start += lenHIT;
                displayHIT(start,category);
            }
       
        
        if($(window).scrollTop() == 0){
            //다시 처음부터 시작하도록 한다.
            $("div#categoryList").empty();
            $("span#end").empty();
            $("span#countHIT").text("0");

            start=1;
            displayHIT(start,category);
        }
            }
        
      
	});

});//end of $(document).ready(function()	
		
let lenHIT = 8;		
		
function displayHIT(start,category){
    $.ajax({

        url: "<%= ctxPath%>/playMainJSON.trip",
        //type:"get",
        data:{
              "start":start,   //"1"  "9"  "17"  "25"  "33"
              "len":lenHIT ,
              "category": category},  // 8    8    8     8     8
        dataType:"json",  
        success:function(json){
        	console.log(JSON.stringify(json));
        	let v_html = "";

        	if(start == "1" && json.length == 0) {
                v_html = "현재 카테고리 준비중 입니다...";
                $("div#categoryList").html(v_html);
            }

            else if (json.length > 0) {
            	
            	$.each(json, function(index, item){
	                console.log("~~~ 확인용 json => ", JSON.stringify(json));
	                v_html += "    <div class='col-md-6' ontouchstart='this.classList.toggle(\"hover\");'>";
	                v_html += "      <div class='container_card'>";
	                v_html += "        <div class='front' style='background-image: url(<%= ctxPath %>/resources/images/play/" + item.play_main_img + ")'>";
	                v_html += "          <div class='inner_front'>";
	                v_html += "            <p style='font-size: 40px;'>" + item.play_name + "</p>";
	                v_html += "            <span style=' color:#786b94;'>" + item.play_category + "</span>";
	                v_html += "          </div>";
	                v_html += "        </div>";
	                v_html += "        <div class='back'>";
	                v_html += "          <div class='inner_back'>";
	                v_html += "            <div>";
	                v_html += "              <span><img src='<%= ctxPath %>/resources/images/play/rogo.png' style='width: 30px;'> 행사정보</span><br>";
	                v_html += "              <span class='inner_back_content'>" + item.play_content + "</span>";
	                v_html += "            </div>";
	                v_html += "            <br>";
	                v_html += "            <div>";
	                v_html += "              <span><img src='<%= ctxPath %>/resources/images/play/rogo.png' style='width: 30px;'> 운영시간 </span><br>";
	                v_html += "              <span class='open_time'>" + item.play_businesshours + "</span>";
	                v_html += "            </div>";
	                v_html += "            <br>";
	                v_html += "            <div>";
	                v_html += "              <span><img src='<%= ctxPath %>/resources/images/play/rogo.png' style='width: 30px;'> 오시는길 </span><br>";
	                v_html += "              <span class='adress'>" + item.play_address + "</span>";
	                v_html += "            </div>";
	                v_html += "          </div>";
	                v_html += "        </div>";
	                v_html += "      </div>";
	                v_html += "  </div>";
	                
	            $("div#categoryList").html(v_html)
                });

                // span#countHIT 에 지금까지 출력된 상품의 개수를 누적해서 기록한다.
                $("span#countHIT").text( Number($("span#countHIT").text()) + json.length);


                 // 스크롤을 계속해서 클릭하여 countHIT 값과 totalHITCount 값이 일치하는 경우
                 if( $("span#countHIT").text() == $("span#totalHITCount").text() ){
                    $("span#end").html("더이상 조회할 제품이 없습니다.");
                }
                
            }//end of else if (json.length > 0)

        },
        error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
         }     
    });


}

function goTop(){
    $(window).scrollTop(0);

}


</script>


</head>

<body>
	<div class="container">
        <div class="row">
            <div class="col-md-3" >
				<ul class="list-group" style="border-radius: 20px;">
				  	<li class="list-group-item d-flex justify-content-between align-items-center" style="margin-top: 230px;">
					    <input type="hidden" name="total" value="전체"/>
					    <label for="total" style="font-weight: bold;">전체</label>
					    <span class="badge badge-pill" style="background:#ff8000; color:#fff;">14</span>
				  	</li>
				  	<li class="list-group-item d-flex justify-content-between align-items-center" >
					    <input type="hidden" name="tourism" value="관광지" />
					    <label for="tourism" style="font-weight: bold;">관광지</label>
					    <span class="badge badge-pill" style="background:#ff8000; color:#fff;">14</span>
				  	</li>
				  	<li class="list-group-item d-flex justify-content-between align-items-center">
					    <input type="hidden" name="showing" value="전시회"/>
			            <label for="showing" style="font-weight: bold;">전시회</label>
					    <span class="badge badge-pill" style="background:#ff8000; color:#fff;">2</span>
				  	</li>
				  	<li class="list-group-item d-flex justify-content-between align-items-center">
					    <input type="hidden" name="experience" value="체험"/>
			            <label for="experience" style="font-weight: bold;">체험</label>
					    <span class="badge badge-pill" style="background:#ff8000; color:#fff;">1</span>
				  	</li>
				</ul>
            </div>
            
            <div class="col-md-9 py-3">
            	<div class="row py-3">
            		<div id="tabArea" class="tabArea1 text-center" style="display: flex; border: solid 0px black; align-items: center;">
			            <div class="tabTitle pr-3" style="align-self: center; width:15%;">
			                <span>여행하실 곳을 <br> 선택해주세요.</span>
			            </div>
			            <div class="areaMap" style="display: flex;">
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_total.png" />
			                    <div>
			                        <input id="area01" type="checkbox" class="are_map" value="">
			                        <br><label for="area01" class="label_chk">전체</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_city.png" />
			                    <div>
			                        <input name="area" id="area02" type="checkbox" class="are_map" value="JE">
			                        <label for="area02" class="label_chk">제주 시내권</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_east.png" />
			                    <div>
			                        <input name="area" id="area03" type="checkbox" class="are_map" value="EA">
			                        <label for="area03" class="label_chk">제주시 동부</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_west.png" />
			                    <div>
			                        <input name="area" id="area04" type="checkbox" class="are_map" value="WE">
			                        <label for="area04" class="label_chk">제주시 서부</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_city.png" />
			                    <div>
			                        <input name="area" id="area05" type="checkbox" class="are_map" value="SE">
			                        <label for="area05" class="label_chk">중문/서귀포</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_east.png" />
			                    <div>
			                        <input name="area" id="area06" type="checkbox" class="are_map" value="ES">
			                        <label for="area06" class="label_chk">서귀포 동부</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_west.png" />
			                    <div>
			                        <input name="area" id="area07" type="checkbox" class="are_map" value="WS">
			                        <label for="area07" class="label_chk">서귀포 서부</label>
			                    </div>
			                </div>
			            </div>
			        </div>
            	</div>	
            	
            	<div class="row" >
            		
                    <div class="sort-filter main" style="display: flex; justify-content:space-between; width: 98%; margin-bottom: 20px;">
                        <div>
	                        <button type="button" onclick="" class="sort active" value="">추천순</button>
	                        <button type="button" onclick="" class="sort" value="NEW">최신등록순</button>
	                        <c:if test="${sessionScope.loginuser.userid == 'admin'}">
                        		<button type="button" onclick="" class="sort" value="NEW">즐길거리 등록</button>
                        	</c:if>
                        </div>
                        <div>
                            <input type="text" id="searchWord" class="" placeholder="검색 ">
                            <button type="button" title="검색">검색</button>
                        </div>
                    </div>
                
            	</div>
			   <!------카테고리 [ ajax ]---------------------------------------------------------------------------------------  -->
				
				<div class='wrapper'>
					<div class='cols' id="categoryList"></div>
				
				
					<div>
				        <p class="text-center"><%--가운데정렬 --%>
				            <span id="end" style="display:block; margin:20px; font-size: 14pt; font-weight: bold; color: red;"><%--더이상보여줄내용이없습니다 들어오는곳 --%></span> 
				            <span id="totalHITCount">${requestScope.totalHITCount}</span> <%-- 히트상품 전체개수 DB에서 받아옴--%>   
				            <span id="countHIT">0</span><%-- 더보기 버튼 누를때마다 8개씩 올라감 8->16->24 ... --%>
				        </p>
				    </div>	
					<div style="display: flex;">
					    <div style="margin: 20px 0 20px auto;">
					    	<button class="btn btn-info" onclick="goTop()">맨위로가기</button>
					    </div>
				    </div>
				</div>
				
			   <!---------------------------------------------------------------------------------------------  -->
                
			</div>
		</div>

	</div><!--end of container  -->
		
</body>
</html>