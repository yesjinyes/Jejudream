<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<style type="text/css">


body {
    font-family: "Noto Sans KR", sans-serif;
    font-optical-sizing: auto;
}

@media screen and (min-width: 768px) and (max-width: 1024px) {
    div.container {
        width: 70vw !important;
    }
}

@media screen and (max-width: 768px) {
    div.container {
        width: 80vw !important;
    }
}

@media screen and (max-width: 425px) {
    div.container {
        width: 100vw !important;
        margin-top: 0 !important;
    }

    h1 {
        font-size: 1.4rem !important;
    }

    h5 {
        font-size: 1rem !important;
    }

    div.info_block > input,
    span.error {
        font-size: 0.8rem !important;
    }
}

div.container {
    width: 60%;
    margin: 7% auto;
    border: solid 1px rgba(0, 0, 0, 0.15);
    border-radius: 40px;
    box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
}

div.info {
    border: solid 0px red;
    width: 80%;
    margin: 5% auto;
}

div.info_block > input:first-child {
    display: block;
    width: 100%;
    max-width: 680px;
    height: 50px;
    margin: 0 auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
}

div.info_block > select {
    width: 100%;
    max-width: 680px;
    height: 50px;
    margin: 2% auto 3%;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
    color:gray;
}

div.info_block > textarea {
    width: 100%;
    max-width: 680px;
    height: 150px;
    margin: 0 auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
    color:gray;
}

span.error {
    font-size: 11pt;
    margin: 0 3%;
    color: red;
}

/* 유효성 검사 에러 시 input 테두리 색 변경 */
.input_error {
    border: solid 1px red !important;
}

button#registerBtn {
    width: 80%;
    height: 50px;
    margin: 1% auto;
    border-radius: 8px;
    background-color: #ff5000;
    color: white;
   
}

div.convenient{
    font-size: 17pt;
    margin-bottom: 10px;
    margin-left: 10px;
    color:gray;
}

label{
    margin-left: 10px;
    color:gray;
}

.imgPlay{
width: 70%;
border-radius: 2%;
}

.addSchedule{
cursor: pointer;
}

/* 모달관련시작 */

table#schedule{
		margin-top: 70px;
		padding: 10px 5px;
	 	vertical-align: middle;
	}
	
	
	select.schedule{
		height: 30px;
	}

.visit_time select{
    width: 100%;
    max-width: 100px;
    height: 50px;
    margin: 2% auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
    color:gray;

}

.date-container input{
 	width: 100%;
    max-width: 300px;
    height: 50px;
    margin: 2% auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 20px;
    color:gray;
}

/*---------------------------------------------------*/

	span.markColor {color: #ff8000; }
	
	div.customDisplay {display: inline-block;
	                   margin: 1% 3% 0 0;
	}
	                
	div.commentDel {font-size: 12pt;
	                cursor: pointer; }
	
	div.commentDel:hover {background-color: #ff8000;
						border-radius:2%;
	                      color: white;	}

/*------------아이콘관련------------------------------*/

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

.joinUserName2{
	width: 35%;
	height: calc(1.5em + .75rem + 2px);
    padding: .375rem .75rem;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #495057;
    background-color: #fff;
    background-clip: padding-box;
    border: 1px solid #ced4da;
    border-radius: .25rem;
    transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
}





/*-----------------------------------------------------------------*/

/*스케쥴관련 css  */
	input#joinUserName2:focus{
		outline: none;
	}
	
	span.plusUser{
		float:left; 
		background-color:#737373; 
		color:white;
		border-radius: 10%;
		padding: 8px;
		margin: 3px;
		transition: .8s;
		margin-top: 6px;
	}
	
	span.plusUser > i {
		cursor: pointer;
	}
	
 .ui-autocomplete {
		max-height: 100px;
		overflow-y: auto;
	}
	  
	button.btn_normal{
		border: none;
		color: white;
		width: 70px;
		height: 30px;
		font-size: 12pt;
		padding: 3px 0px;
		border-radius: 10%;
	}



</style>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f42c6cbd2d2060c5c719ee80540fbfbc&libraries=services"></script> 
<script type="text/javascript">

//== 새로고침 시 맨 위로 이동 == //
history.scrollRestoration = "manual"

$(document).ready(function() {
	
	goLikeDislikeCount();
	//goCheckSchedule();
	
	const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
	
    let currentShowPageNo = 1; // currentShowPageNo 초기값
    goReviewListView(currentShowPageNo); // 페이징처리된 리뷰보여주는 함수

    
    
    //리뷰 작성-----------------------------------------------------------------
   
    $("button#btnCommentOK").click(function(){
    	if(${empty sessionScope.loginCompanyuser}){  
	    	if(${empty sessionScope.loginuser}) {
				alert("리뷰 작성은 로그인 후 가능합니다.");
				
	            // 현재 URL을 세션에 저장하고 로그인 페이지로 리다이렉트
	            const currentUrl = window.location.href;
	             
	            window.location.href = "rememberlogin.trip?goBackURL=" + encodeURIComponent(currentUrl);
	             
	            return false;
			} 
	  	  	else{
				const review_content = $("textarea[name='review_content']").val().trim(); 
	           
	            if(review_content == "") {
	               alert("리뷰 내용을 입력해 주세요.");
	               $("textarea[name='review_content']").val(""); 
	               return; // 종료
	           }  
	            
	            const queryString = $("form[name='reviewFrm']").serialize();
	            
	            $.ajax({
	                url:"<%= ctxPath%>/reviewRegister.trip",
	                type:"post",
	                data:queryString,
	                dataType:"json",
	                success:function(json){ 
	                   console.log(JSON.stringify(json));
	                  
	                   if(json.n == 1) {
	                       goReviewListView(currentShowPageNo);
	                     }
	                    
	                   else  {
	                      alert("리뷰 작성이 실패했습니다.");
	                   }
	                   
	                   $("textarea[name='review_content']").val("").focus();
	                },
	                error: function(request, status, error){
	                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	                
	                }
	             });
		  	  }
    	}
    	else{
    		$("textarea[name='review_content']").val("").focus();
    		alert("기업은 리뷰 작성을 할 수 없습니다.")
    	}
    	  
      });//end of  $("button#btnCommentOK").click(function())--------------
    
      //----------------------------------------------------------------------------------------
      
    //달력용--------------------------------------------------------------------
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
   
      //------------------------------------------------------------------------ 
		// 시작시간, 종료시간		
		var html="";
		for(var i=0; i<24; i++){
			if(i<10){
				html+="<option value='0"+i+"'>0"+i+"</option>";
			}
			else{
				html+="<option value="+i+">"+i+"</option>";
			}
		}// end of for----------------------
    
	 	$("select#startHour").html(html);
		$("select#endHour").html(html);
		
		// 시작분, 종료분 
		html="";
		for(var i=0; i<60; i=i+5){
			if(i<10){
				html+="<option value='0"+i+"'>0"+i+"</option>";
			}
			else {
				html+="<option value="+i+">"+i+"</option>";
			}
		}// end of for--------------------
		html+="<option value="+59+">"+59+"</option>"
		
		$("select#startMinute").html(html);
		$("select#endMinute").html(html);
		
		// '종일' 체크박스 클릭시
		$("input#allDay").click(function() {
			var bool = $('input#allDay').prop("checked");
			
			if(bool == true) {
				$("select#startHour").val("00");
				$("select#startMinute").val("00");
				$("select#endHour").val("23");
				$("select#endMinute").val("59");
				$("select#startHour").prop("disabled",true);
				$("select#startMinute").prop("disabled",true);
				$("select#endHour").prop("disabled",true);
				$("select#endMinute").prop("disabled",true);
			} 
			else {
				$("select#startHour").prop("disabled",false);
				$("select#startMinute").prop("disabled",false);
				$("select#endHour").prop("disabled",false);
				$("select#endMinute").prop("disabled",false);
			}
		});
    
    
    //--------------------------------------map관련---------------------------------------//
		 
        var playAddress = document.getElementById("playAddress").textContent.trim();
        
        // 지도 생성 및 설정
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
            level: 4 // 지도의 확대 레벨
        };  
        var map = new kakao.maps.Map(mapContainer, mapOption); 

        // 주소-좌표 변환 객체를 생성
        var geocoder = new kakao.maps.services.Geocoder();

        // 주소로 좌표를 검색
        geocoder.addressSearch(playAddress, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                var message = 'latlng: new kakao.maps.LatLng(' + result[0].y + ', ' + result[0].x + ')';

                // 결과값으로 받은 위치를 마커로 표시합니다
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                // 인포윈도우로 장소에 대한 설명을 표시합니다
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="width:150px;text-align:center;padding:6px 0;">${requestScope.playvo.play_name}</div>'
                });
                infowindow.open(map, marker);

                // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                map.setCenter(coords);
            }
        });  
        
    //--------------------------------------map관련 끝 ---------------------------------------//

		// 공유자 추가하기
		$(document).on('keyup',"input#joinUserName2",function(){
		
        var joinUserName = $(this).val();
        var loginuserId = "${sessionScope.loginuser.userid}";
        $.ajax({
            url: "<%= ctxPath%>/schedule/insertSchedule/searchPlayJoinUserList.trip",
            data: { "joinUserName": joinUserName },
            dataType: "json",
            success: function(json) {
                var joinUserArr = [];

                if (json.length > 0) {
                    $.each(json, function(index, item) {
                        var name = item.user_name;
                        var userId = item.userid;
                        
                        if (name.includes(joinUserName) && userId !== loginuserId) {
                            joinUserArr.push(name + "(" + item.userid + ")");
                        }
                    });

                    $("input#joinUserName2").autocomplete({
                        source: joinUserArr,
                        select: function(event, ui) {
                            add_joinUser(ui.item.value);
                            return false;
                        },
                        focus: function(event, ui) {
                            return false;
                        },
                        appendTo: ".modal-body" // 자동완성 결과를 모달 내부로 설정
                    });
                }
            }
        });
    });
		

		// x아이콘 클릭시 공유자 제거하기
		$(document).on('click','div.displayUserList2 > span.plusUser > i',function(){
				var text = $(this).parent().text();
				
				var bool = confirm("공유자 목록에서 "+ text +" 님을 삭제하시겠습니까?");
				
				if(bool) {
					$(this).parent().remove();
				}
		});

		
		 $('#fk_lgcatgono').on('change', function() {
			var fk_lgcatgono = $(this).val();
	        
	        if (fk_lgcatgono == "1") {
	        	$('input#fk_smcatgono').val('3'); 
	        } else if (fk_lgcatgono == "2") {
	        	$('input#fk_smcatgono').val('6'); 
	        } else {
	        	$('input#fk_smcatgono').val(''); 
	        }
		 });
		
		// 등록 버튼 클릭
		$("button#register").click(function(){

			// 일자 유효성 검사 
			var startDate = $("input#fromDate").val();	
	    	var sArr = startDate.split("-");
	    	startDate= "";	
	    	for(var i=0; i<sArr.length; i++){
	    		startDate += sArr[i];
	    	}
	    	
	    	var endDate = $("input#fromDate").val();	
	    	var eArr = endDate.split("-");   
	     	var endDate= "";
	     	for(var i=0; i<eArr.length; i++){
	     		endDate += eArr[i];
	     	}
			
	     	var startHour= $("select#startHour").val();
	     	var endHour = $("select#endHour").val();
	     	var startMinute= $("select#startMinute").val();
	     	var endMinute= $("select#endMinute").val();
	        
	     	// 조회기간 시작일자가 종료일자 보다 크면 경고
	        if (Number(endDate) - Number(startDate) < 0) {
	         	alert("종료일이 시작일 보다 작습니다."); 
	         	return;
	        }
	        
	     	// 시작일과 종료일 같을 때 시간과 분에 대한 유효성 검사
	        else if(Number(endDate) == Number(startDate)) {
	        	
	        	if(Number(startHour) > Number(endHour)){
	        		alert("종료일이 시작일 보다 작습니다."); 
	        		return;
	        	}
	        	else if(Number(startHour) == Number(endHour)){
	        		if(Number(startMinute) > Number(endMinute)){
	        			alert("종료일이 시작일 보다 작습니다."); 
	        			return;
	        		}
	        		else if(Number(startMinute) == Number(endMinute)){
	        			alert("시작일과 종료일이 동일합니다."); 
	        			return;
	        		}
	        	}
	        }// end of else if---------------------------------

 			
	        
	     	// 캘린더 선택 유무 검사
			var calType = $("select.calType").val().trim();
			if(calType==""){
				alert("캘린더 종류를 선택하세요."); 
				return;
			}
			
			// 달력 형태로 만들어야 한다.(시작일과 종료일)
			// 오라클에 들어갈 date 형식(년월일시분초)으로 만들기
			var sdate = startDate+$("select#startHour").val()+$("select#startMinute").val()+"00";
			var edate = startDate+$("select#endHour").val()+$("select#endMinute").val()+"00";
			
			$("input[name=startdate]").val(sdate);
			$("input[name=enddate]").val(edate);
		
			// 공유자 넣어주기
			var plusUser_elm = document.querySelectorAll("div.displayUserList2 > span.plusUser");
			var joinUserArr = new Array();
			
			plusUser_elm.forEach(function(item,index,array){
				joinUserArr.push(item.innerText.trim());
			});
			
			var joinuser = joinUserArr.join(",");
			
			$("input[name=joinuser]").val(joinuser);
			
			var frm = document.addSchedulePlayFrm;
			frm.action="<%= ctxPath%>/schedule/registerPlaySchedule_end.trip";
			frm.method="post";
			frm.submit();

		});// end of $("button#register").click(function(){})--------------------
        
        
		$('#exampleModal_scrolling_2 .btn.btn-danger').on('click', function () {
			$('#exampleModal_scrolling_2 form')[0].reset(); // 폼 전체 초기화
		    $("input#joinUserName2").autocomplete("destroy").val(""); // autocomplete 제거 및 입력값 비우기
		    $("div.displayUserList2").empty(); // 사용자 리스트 비우기
	    });
		
});//end of $(document).ready(function() {

	
function add_joinUser(value){  // value 가 공유자로 선택한이름 이다.
	
	var plusUser_es = $("div.displayUserList2 > span.plusUser").text();

	if(plusUser_es.includes(value)) {  // plusUser_es 문자열 속에 value 문자열이 들어있다라면 
		alert("이미 추가한 회원입니다.");
	}
	
	else {
		$("div.displayUserList2").append("<span class='plusUser'>"+value+"&nbsp;<i class='fas fa-times-circle'></i></span>");
	}
	
	$("input#joinUserName2").val("");
	
}// end of function add_joinUser(value){}----------------------------				
	
	

// 리뷰 보여주기
 function goReviewListView(currentShowPageNo){
	  
    $.ajax({
    url:"<%= ctxPath%>/reviewList.trip",
    type:"get",
    data: {"parent_code":"${requestScope.playvo.play_code}"
    	  ,"currentShowPageNo":currentShowPageNo},
    
    dataType:"json",
    success:function(json){
 	
 	   let v_html = "";
       let r_html = "0"; 
        if (json.length > 0) {    
           $.each(json, function(index, item){ 
              let writeuserid = item.fk_userid;
              let loginuserid = "${sessionScope.loginuser.userid}";
                             
               v_html  += "<div class='customDisplay'><img src='<%= ctxPath %>/resources/images/play/rogo.png' style='width: 30px;'>&nbsp;"+item.fk_userid+"</div>"    
            	   	    + "<div id='review"+index+"' style='font-weight: bold;'><span class='markColor'></span>&nbsp;"+item.review_content+"</div>"
                        + "<div class='customDisplay' style='font-size: 12px;'>&nbsp;"+item.registerday+"</div>"
                        + "<input type='hidden' name='review_code' value='" + item.review_code + "'/>";
               r_html = item.totalCount
               if(loginuserid == "") { 
                  // 로그인을 안한 경우  
                  v_html += "<div class='customDisplay spacediv'>&nbsp;</div><br>";
               }      
               else if(loginuserid != "" && loginuserid == "admin" || writeuserid == loginuserid ) { 
                  // 로그인을 했으나 후기글이 로그인한 사용자 쓴 글이 아니라 다른 사용자 쓴 후기글 이라면  
   	       		  v_html += "<div class='customDisplay spacediv commentDel' onclick='delMyReview("+item.review_code+")'>후기삭제</div>&nbsp;&nbsp;"; 
   	       		
   	       		  if( loginuserid != "admin" && writeuserid == loginuserid ) {
              	  		v_html += "<div class='customDisplay spacediv commentDel commentUpdate' onclick='updateMyReview("+index+","+item.review_code+")'>후기수정</div><br><br>"; 
   	       			}
   	       		}
            
           }); 
           
           const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
           PageBar(currentShowPageNo, totalPage);
        }// end of if -----------------------
        
        else {
           v_html += "<div>등록된 리뷰가 없습니다.</div>";
        }// end of else ---------------------
        $("div#viewComments").html(v_html);
        $("p#reviewCount").html(r_html);
    },
    error: function(request, status, error){
        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
     }
 	   
 	   
	   });
	   
}//end of function goReviewListView()-------------


//페이지바 함수
 function PageBar(currentShowPageNo,totalPage){
 	   
     const blockSize = 10;
 	let loop = 1;
 	let pageNo = Math.floor((Number(currentShowPageNo) - 1)/blockSize) * blockSize + 1;
 	
 	let pageBar_HTML = "<ul style='list-style:none'>";
 	
 	// [맨처음] [이전] 만들기
 	if(pageNo != 1) {
 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goReviewListView(1)'>[맨처음]</a></li>";
 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goReviewListView("+(pageNo-1)+")'>[이전]</a></li>";
 	}
 	
 	while(!(loop>blockSize || pageNo > totalPage)) {
 		if(pageNo == currentShowPageNo) {
 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
 		}
 		else {
 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goReviewListView("+pageNo+")'>"+pageNo+"</a></li>";
 		}
 		loop++;
 		pageNo++;
 	}//end of while
 	
 	// [다음] [마지막] 만들기
 	if(pageNo <= totalPage) {
 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goReviewListView("+(pageNo+1)+")'>[다음]</a></li>";
 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goReviewListView("+totalPage+")'>[마지막]</a></li>";
 	}
 	
 	pageBar_HTML += "</ul>";
 	$("div#pageBar").html(pageBar_HTML);
 	
 }


// 리뷰 삭제하는 함수
function delMyReview(review_code){
	   if(confirm("리뷰를 삭제하시겠습니까?")) {
	         $.ajax({
	            url:"<%= ctxPath%>/play/reviewDel.trip",
	            type:"post",
	            data:{"review_code":review_code},
	            dataType:"json",
	            success:function(json){
          
	               if(json.n == 1) {
	                  alert("리뷰 삭제 완료.");
	                  goReviewListView(1); // 특정 제품의 제품후기글들을 보여주는 함수 호출하기 
	               } 
	               else {
	                  alert("삭제가 실패했습니다.");
	                  goReviewListView(1);
	               }
	            
	            },
	            error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
	         });
	      }  
	   
}//end of function delMyReview(review_seq)---------


// 리뷰 수정하는 함수
function updateMyReview(index,review_code){
		const origin_elmt = $("div#review" + index).html();//원래의 제품후기 엘리먼트   
		
		const review_contents = $("div#review" + index).text().substring(1);
		
		$("div.commentUpdate").hide(); 
		$("div.commentDel").hide(); 
		// "후기수정" 을 위한 엘리먼트 만들기 
	       let v_html = "<textarea id='edit_textarea' style='font-size: 12pt; width: 40%; height: 50px;'>"+review_contents+"</textarea>";
	       v_html += "<div style='display: inline-block; position: relative; top: -20px; left: 10px;'><button type='button' class='btn btn-sm btn-outline-secondary' id='btnReviewUpdate_OK'>수정완료</button></div>"; 
	       v_html += "<div style='display: inline-block; position: relative; top: -20px; left: 20px;'><button type='button' class='btn btn-sm btn-outline-secondary' id='btnReviewUpdate_NO'>수정취소</button></div>";
		
	       
	    // 원래의 제품후기 엘리먼트에 위에서 만든 "후기수정" 을 위한 엘리먼트로 교체하기  
	       $("div#review"+index).html(v_html);
	    
	    // 수정취소 버튼 클릭시
	       $(document).on("click", "button#btnReviewUpdate_NO", function(){
	    	   $("div#review"+index).html(origin_elmt);//원래의 제품후기 엘리먼트로 복원하기.
	    	   $("div.commentUpdate").show();
	    	   $("div.commentDel").show();
	       });
	    // 수정완료 버튼 클릭시
	       $(document).on("click", "button#btnReviewUpdate_OK", function(){
	    	   $.ajax({
		            url:"<%= ctxPath%>/play/reviewUpdate.trip",
		            type:"post",
		            data:{"review_code":review_code
		            	 ,"review_content":$("textarea#edit_textarea").val()},
		            dataType:"json",
		            success:function(json){
		            // console.log(JSON.stringify(json));
		            // {"n":1} 또는 {"n":0}
		            
		               if(json.n == 1) {
		                  goReviewListView(1); // 특정 제품의 제품후기글들을 보여주는 함수 호출하기 
		               } 
		               else {
		                  alert("제품후기 수정이 실패했습니다.");
		                  goReviewListView(1);
		               }
		            
		            },
		            error: function(request, status, error){
		               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		            }
		         });
	       });
	    
	    
}


//--------------------------좋아요 등록하기 --------------------------------- //

function golikeAdd(){
 
	if(${empty sessionScope.loginCompanyuser}){
		if(${empty sessionScope.loginuser}) {
			alert("좋아요는 로그인 후 가능합니다.");
			
	        // 현재 URL을 세션에 저장하고 로그인 페이지로 리다이렉트
	        const currentUrl = window.location.href;
	         
	        window.location.href = "rememberlogin.trip?goBackURL=" + encodeURIComponent(currentUrl);
	         
	        return false;
		} 
		else{//로그인을 한 경우라면
	  		
			  $.ajax({
			          url:"<%= ctxPath%>/play/playLike.trip",
			          type:"POST",
			          data:{"parent_code":"${requestScope.playvo.play_code}",
			          	    "fk_userid":"${sessionScope.loginuser.userid}"},
			          dataType:"json", 
			          success:function(json) {
			          	if(json.n == 1){
			          		alert("좋아요 등록 완료");
			          		goLikeDislikeCount();
			          	}
			          	else{
			          		
			          		goLikeDislikeCount();
			          		
			          	}
			
			          },
			          error: function(request, status, error){
			             alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			          }
		      			});
		  
		 		
			}
  	
  	}
	else{
		alert("기업은 좋아요 등록을 할 수 없습니다.");
	}
}// end of function golikeAdd(pnum}



function goLikeDislikeCount(){ // 좋아요, 싫어요 갯수를 보여주도록 하는 것이다.
	$.ajax({
        url: "<%= ctxPath %>/countLike.trip",
        data: {
            "parent_code": "${requestScope.playvo.play_code}",
            "fk_userid": "${sessionScope.loginuser.userid}"
        },
        dataType: "json",
        success: function(json) {
            $("p#likeCount").html(json.countLike);
            if (json.check) {
                $("#like").hide();
                $("#likeup").show();
            } else {
                $("#like").show();
                $("#likeup").hide();
            }
        },
        error: function(request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    });
	
}//end of function goLikeDislikeCount()


//-----------------------------------------------------------------------


function goScheduleAdd(){
	if(${empty sessionScope.loginCompanyuser}){
		if(${empty sessionScope.loginuser}) {
			alert("일정추가는 로그인 후 가능합니다.");
			
	        // 현재 URL을 세션에 저장하고 로그인 페이지로 리다이렉트
	        const currentUrl = window.location.href;
	         
	        window.location.href = "rememberlogin.trip?goBackURL=" + encodeURIComponent(currentUrl);
	         
	        return false;
		} 
		  	else{
	        $('#exampleModal_scrolling_2').modal('show');
	    }
	}
	else{
		alert("기업은 일정 등록을 할 수 없습니다.");
	}
	
}


function goDelete() {
    if (confirm("정말로 이 게시물을 삭제하시겠습니까?")) {
        const frm = document.delFrm;
        frm.action = "<%=ctxPath%>/deletePlay.trip";
        frm.method = "post";
        frm.submit();
	}
}
</script>

<body>

<div class="container">
	
	<c:if test="${sessionScope.loginuser.userid == 'admin'}">
		<div style="width: 90%; margin: 3% auto;text-align: right;">
			<button type="button" onclick="javascript:location.href='<%= ctxPath%>/editPlay.trip?play_code=${requestScope.playvo.play_code}'" class="btn btn-outline-warning btn-sm">즐길거리 수정</button>
			<button type="button" onclick="goDelete()" class="btn btn-outline-warning btn-sm" >즐길거리 삭제</button>
		</div>
	</c:if>
	
	<div style="width: 90%; margin: 3% auto;text-align: right;">
		<ul class="list" style="display: flex; margin-left: 8%;">
			<li class="list-item">
				<c:if test="${sessionScope.loginuser.userid == 'admin'}">
					<button type="button" class="iconbtn">	
						<div class="item-each">
							<img class="icon like" id="like" src="<%= ctxPath %>/resources/images/foodstore/icon/Like.png">
						</div>
					</button>
				</c:if>
				<c:if test="${sessionScope.loginuser.userid != 'admin'}">
					<button type="button" class="iconbtn" onclick="golikeAdd()">	
						<div class="item-each">
							<img class="icon like" id="like" src="<%= ctxPath %>/resources/images/foodstore/icon/Like.png">
							<img class="icon likeup" id="likeup" src="<%= ctxPath %>/resources/images/foodstore/icon/LikeUp.png">
						</div>
					</button>
				</c:if>
					<p class="icon-title">좋아요</p>
				<p class="count" id="likeCount"></p>
			</li>
			<li class="list-item">
				<button type="button" class="iconbtn">
					<div>
						<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_review2.png">
					</div>
					<p class="icon-title">리뷰</p>
				</button>
				<p class="count" id="reviewCount">0</p>
			</li>
			<li class="list-item">
				<button type="button" class="iconbtn" style="cursor: default;">
					<div>
						<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_viewcount.png">
					</div>
					<p class="icon-title">조회수</p>
				</button>
				<p class="count">${requestScope.playvo.readCount}</p>
			</li>
			<li class="list-item">
				<div>
				<c:if test="${sessionScope.loginuser.userid == 'admin'}">
					<button type="button" class="iconbtn addSchedule" id ="addSchedule_btn">
							<img class="icon" id="calender" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_calender.png">
					</button>
				</c:if>
				<c:if test="${sessionScope.loginuser.userid != 'admin'}">
					<button type="button" class="iconbtn addSchedule" id ="addSchedule_btn" onclick="goScheduleAdd()">
							<img class="icon" id="calender" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_calender.png">
					</button>
				</c:if>
					<p class="icon-title" id="addScheduletitle">일정추가</p>
				</div>
			</li>
		</ul>
    </div>
    
    <div style="width: 80%; margin: 3% auto;text-align: center;">
        <h1 style="margin-top: 1%;" class="font-weight-bold">${requestScope.playvo.play_name}</h1>
        <h5>[ ${requestScope.playvo.play_category} ]</h5><br>
    </div>
    
    <div style="display: flex;">
    	<div class="col-lg-7">
     		<img style="margin-left: 5%; height: 500px;" class="imgPlay" src="<%= ctxPath %>/resources/images/play/${requestScope.playvo.play_main_img}">
     	</div>
     
    	<div class="col-lg-5" style="font-size: 20px;">
    		<span>${requestScope.playvo.play_content}</span> <br><br>
    		<span>운영시간 : </span>
    		<span>${requestScope.playvo.play_businesshours}</span> <br><br>
    		<span>오시는길 : </span>
    		<span id="playAddress">${requestScope.playvo.play_address}</span><br><br>
    		<span>연락처 : </span>
    		<span>${requestScope.playvo.play_mobile}</span>
    	</div>
    </div>
       
	<div>
		
	</div>
	<div style="margin-top:30px;">
		<h2 class="text-muted">위치확인</h2>
		<p style="margin-top:10px">
		    <em class="link">
		        <a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')">
		         	 주소 결과가 잘못 나오는 경우에는 여기에 제보해주세요.
		        </a>
		    </em>
	    </p>
		<div id="map" style="width:95%;height:500px;margin: auto; margin-bottom: 50px;"></div>
		<div id="clickLatlng"></div>
	</div>
	
	<div class="text-left" >
	    <p class="h4 text-muted">리뷰</p>
	    <p class="h6" style="color: red">부적절한 게시글을 업로드 시 불이익을 받을 수 있습니다.</p>
    </div>
     
    <div class="row"  >
        <div class="col-lg-10">
    		<form name="reviewFrm">
    		    <textarea name="review_content" style="font-size: 12pt; width: 90%; height: 75px;"></textarea>
    		    <input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}" />
   	            <input type="hidden" name="play_code" value="${requestScope.playvo.play_code}" />
    		</form>
	    </div>
	    <div class="col-lg-2" style="display: flex;">
	    	<button type="button" class="btn btn-outline-secondary w-100 h-100" id="btnCommentOK" ><span class="h5">리뷰등록</span></button>
	    </div>
    </div>
    <div style="margin-bottom: 10%; margin-top: 5%;">
    	<div id="viewComments" ></div><%-- 리뷰내용 --%>
    	<div style="display: flex; margin-bottom: 50px;">
        	<div id="pageBar" style="margin: auto; text-align: center;"></div>
     	</div>
    </div>
    
    <form name="delFrm">
	  <input type="hidden" name="play_code" value="${requestScope.playvo.play_code}" />
	</form>
    
    
</div>
<!--컨테이너끝  -->

<!---------------------------------------------예약하는 모달시작---------------------------------------------------------------------->
	 
	 
<div class="modal fade" id="exampleModal_scrolling_2">
	 <form name="addSchedulePlayFrm" enctype="multipart/form-data">
		  <div class="modal-dialog modal-lg modal-dialog-scrollable">
		    <div class="modal-content">
		      
		      <!-- Modal header -->
		      <div class="modal-header">
		        <h5 class="modal-title"><span style="color:#ff8000; font-size: 50px;">${requestScope.playvo.play_name}</span> 일정 추가하기</h5>
		        <button type="button" class="close" data-dismiss="modal">&times;</button>
		      </div>
		      
		      <!-- Modal body -->
		      <div class="modal-body">
                <div class="info_block mt-5 add_calType" >
                	<label style="font-size: 20px;"> 캘린더 선택</label><br>
	                <select class="calType schedule" name="fk_lgcatgono" id="fk_lgcatgono" style="display: left;">
						<option value="">선택하세요</option>
						<option value="1">내 캘린더</option>
						<option value="2">공유 캘린더</option>
					</select> &nbsp;
					<input type="hidden" name="fk_smcatgono" id="fk_smcatgono"/>
                </div>
                
                <div class="add_date" >
		            <label style="font-size: 20px;"> 방문 예정일을 선택해 주세요</label>
		            <div class="value-text">
		                <div class="date-container">
		                    <span class="date-pick">
		                        <input class="datepicker" style="cursor: pointer;" type="text" id="fromDate" name="fromDate" value="">
		                    </span>
		                </div>
		            </div>
		        </div>
		        <div class="visit_time">
		        	<label style="font-size: 20px;"> 방문 시간을 선택해 주세요</label><br>
					<select id="startHour" class="schedule"></select> 시
					<select id="startMinute" class="schedule"></select> 분
					<select id="endHour" class="schedule"></select> 시
					<select id="endMinute" class="schedule"></select> 분&nbsp;
					<input type="checkbox" id="allDay"/>&nbsp;<label for="allDay">종일</label>
					
					<input type="hidden" name="startdate"/>
					<input type="hidden" name="enddate"/>
		        </div>
		        <div class="info_block add_comment" >
		        	<label style="font-size: 20px;"> 메모</label><br>
		        	<textarea name="content" id="content" placeholder="추가로 작성하실 내용을 입력해 주세요."></textarea>
		        </div>
		        <div class="add_party" >
					 <label style="font-size: 20px;"> 색상</label><br>
		        	<input type="color" id="color" name="color" value="#009900"/><br>
		        	<label style="font-size: 20px;"> 일행 추가하기</label><br>
		        	<input type="text" id="joinUserName2" class="joinUserName2" placeholder="일정을 공유할 회원명을 입력하세요"/>
					<div class="displayUserList2"></div>
					<input type="hidden" name="joinuser"/><br>
		        </div>
		        
		      </div>
		      
		      <input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}">
	      	  <input type="hidden" name="parent_code" value="${requestScope.playvo.play_code}">
	      	  <input type="hidden" name="review_division" value="${requestScope.playvo.review_division}">
	      	  <input type="hidden" name="subject" value="${requestScope.playvo.play_name}">
	      	  <input type="hidden" name="place" value="${requestScope.playvo.play_address}">
		      
		      <!-- Modal footer -->
		      <div class="modal-footer">
		        <button type="button" class="btn" id="register" style="background: #ff8000; color: #fff;">일정추가</button>
		        <button type="button" class="btn btn-danger" data-dismiss="modal">취소</button>
		      </div>
		    </div>
		  </div>
	</form>
</div>
		<!----------------------------------------------------------------------  -->
	
	



</body>
     