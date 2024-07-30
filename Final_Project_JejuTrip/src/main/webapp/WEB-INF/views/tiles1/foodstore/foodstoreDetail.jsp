<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=16695e6ff612a1dbaa353fda89e2424d&libraries=services"></script>

<style type="text/css">

/* 상단 이미지, 텍스트 */
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

/*--------------------------------------------------------*/

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

/*--------------------------------------------------------*/

/* 아이콘 리스트 */
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

button#btnSchedule {
  border: solid 1px orange;
  border-radius: 10%;
  background-color: #ffebcc;
  margin: 10% 0 0 15%;
  padding-top: 10%;
}


/* 상세정보 */
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

/*--------------------------------------------------------*/

/* 맛집 리뷰 */
div#reviewList {
  width: 70%;
  margin: 2% auto;
  padding: 3%;
}

form#addReviewFrm {
  width: 95%;
  margin: 2% auto 0 auto;
}

table#review-table {
  width: 95%;
  margin: 0 auto;
}

textarea {
  width: 80%;
  height: 100px;
  margin-top: 1%;
}

/*--------------------------------------------------------*/
/* == 일정 == */

/* 방문날짜 */
input#scheduleDate {
  border: solid 1px rgba(206, 212, 218);
  border-radius: 5px;
  height: 35px;
  padding-left: 3%;
}

/* 방문 시간 */
.visit_time select{
  width: 100%;
  max-width: 60px;
  height: 35px;
  margin: 2% auto;
  border: solid 1px rgba(206, 212, 218);
  border-radius: 5px;
  padding: 0 0 0 15px;
  font-size: 16px;
  color:gray;
}

/*--------------------------------------------------------*/

div.bottom {
  width: 70%;
  margin: 0 auto;
  
}

div#map_div {
  padding: 3%;
  margin-left: -1.5%;
  /* margin-right: 3%; */
}

div#map {
  height:450px;
}

/*--------------------------------------------------------*/

/* 근처 숙소 랜덤 추천 */
div.recommend-img-box {
  overflow:hidden;
  height: 200px;
}

img.recommend-img {
  width:100%;
  height:100%;
  object-fit:cover;
}

a.recommend-lodging-title {
  text-decoration: none;
}

/*--------------------------------------------------------*/

/* 공유자 추가 */
input#FoodjoinUserName:focus{
  outline: none;
}

.ui-autocomplete {
  max-height: 100px;
  overflow-y: auto;
}

span.plusUser{
  float:left; 
  background-color: #ffdccc;
  color:#595959;
  border-radius: 5px;
  padding: 8px;
  margin: 3px;
  transition: .8s;
  margin-top: 6px;
}

</style>

<script type="text/javascript">

	//== 새로고침 시 맨 위로 이동 == //
	history.scrollRestoration = "manual"
	
	$(document).ready(function() {

		goLikeDislikeCount(); // 좋아요 개수 띄우기
		
		goViewReview(1); // 리뷰 리스트 띄우기
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// == 리뷰 input 엔터 키 == //
		$("textarea[name='review_content']").bind("keyup", function(e) {
			if(e.keyCode == 13) {
				goAddReview();
			}
		});
		
		// == 리뷰 아이콘 클릭 시 리뷰 리스트로 이동 == //
		const reviewList = document.getElementById("reviewList");
		
		$("button#btnReview").click(function() {
			// alert("리뷰 버튼 클릭");
			window.scrollBy({top: reviewList.getBoundingClientRect().top, behavior: 'smooth'});
		});

		
		// == 리뷰 수정, 완료  == //
		let origin_review_content = "";
		
		$(document).on("click", "button.btnUpdateReview", function(e) {
		
			const $btn = $(e.target);
			
			if($(e.target).text() == "수정"){
				// alert("리뷰수정");
			  	// alert($(e.target).parent().parent().children("td:nth-child(1)").text()); // 수정전 리뷰 내용

			  	const $content = $(e.target).parent().parent().children("td:nth-child(2)");
			  	
			    origin_review_content = $(e.target).parent().parent().children("td:nth-child(2)").text(); // 수정 전 리뷰 내용
			    
			    $content.html(`<input id='review_update' type='text' value='\${origin_review_content}' size='40' />`); // 리뷰 내용을 수정할 수 있도록 input 태그를 만들어 준다.
			    
			    $(e.target).text("완료").removeClass("btn-secondary").addClass("btn-info");
			    $(e.target).next().next().text("취소").removeClass("btn-secondary").addClass("btn-danger"); 
			    
			    $(document).on("keyup", "input#review_update", function(e){
			    	if(e.keyCode == 13){
			    	    // alert("완료버튼 엔터");
			    		$btn.click();
			    	}
			    }); 
			}
			
			else if($(e.target).text() == "완료") {
				// alert("리뷰시퀀스 들어올 자리 : "+$(e.target).parent().parent().children("td:nth-child(1)").text());
				// alert($(e.target).parent().parent().children("td:nth-child(2)").children("input").val()); // 수정 후 리뷰 내용
				
				const review_code = $(e.target).parent().parent().children("td:nth-child(1)").text();
				const review_content = $(e.target).parent().parent().children("td:nth-child(2)").children("input").val(); // 수정 후 리뷰 내용
				
				$.ajax({
					url:"updateReview.trip",
					type:"post",
					data:{"review_code":review_code, "review_content":review_content},
					dataType:"json",
					success:function(json) {
						// console.log("~~리뷰 수정 값 들어가나 확인 : "+JSON.stringify(json));
						
						//$(e.target).parent().parent().children("td:nth-child(2)").html(content);
						
						const currentShowPageNo = $(e.target).parent().parent().find("input.currentShowPageNo").val(); 
						
						goViewReview(currentShowPageNo); // 작성한 리뷰 불러오기
						
						$(e.target).text("수정").removeClass("btn-info").addClass("btn-secondary");
						$(e.target).next().next().text("삭제").removeClass("btn-danger").addClass("btn-secondary");
						
					},
					error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
					
				});// end of $.ajax---------------------------
				
			}// end of else if($(e.target).text() == "완료")--------------------
			
		});// end of $(document).on("click", "button.btnUpdateReview", function(e)--------------
		
				
		// == 리뷰 수정취소, 삭제 == //			
		$(document).on("click", "button.btnDeleteReview", function(e) {

			if($(e.target).text() == "취소") {
				// alert("댓글 수정취소");
				
				const $review_content = $(e.target).parent().parent().children("td:nth-child(2)");
				
				$review_content.html(`\${origin_review_content}`); // 변수명 지역변수 적용
				
				$(e.target).text("삭제").removeClass("btn-danger").addClass("btn-secondary");
	            $(e.target).prev().prev().text("수정").removeClass("btn-info").addClass("btn-secondary");
			}
			
			else if($(e.target).text() == "삭제") {
				const review_code = $(e.target).parent().parent().children("td:nth-child(1)").text(); // 삭제할 리뷰번호
				// alert("삭제할 리뷰번호" + review_code);
				
				if(confirm("정말로 삭제하시겠습니까?")) {
					$.ajax({
						url:"deleteReview.trip",
						type:"post",
						data:{"review_code": review_code},
						dataType:"json",
						success:function(json){
							// console.log("리뷰삭제 =>" + JSON.stringify(json))
							goViewReview(1);
						},
						error: function(request, status, error){
							alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						}
					});	// end of $.ajax({})---------------	
				}
			}
			
		});// end of $(document).on("click", "button.btnDeleteReview", function(e)--------
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// == 좋아요 기능 == //
		$("button#btnLike").click(function() {
			// alert("좋아요 버튼 클릭");
			
			if(${empty sessionScope.loginuser}) {
				alert("좋아요는 로그인 후 가능합니다.");
				
				location.href = "login.trip";
				
				return; // 종료
			}
			else{
				//로그인을 한 경우라면
				$.ajax({
					url:"foodLike.trip",
					type:"POST",
					data:{"parent_code":"${requestScope.foodstorevo.food_store_code}",
						  "fk_userid":"${sessionScope.loginuser.userid}"},
					dataType:"json", 
					success:function(json) {
						if(json.n == 1){
							// alert("좋아요 등록 완료");
							goLikeDislikeCount();
						}
						else{
							// alert("좋아요 취소");
							goLikeDislikeCount();
						}
			        },
			        error: function(request, status, error){
			        	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			        }
		    	});// end of $.ajax-------------------------
			} 
		});// end of $("button#btnLike").click(function() {})----------------------------
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// == 일정 시작 == //
		
 		// == 일정추가 modal 달력 띄우기 == //
		const today = new Date();
	    const year = today.getFullYear();
	    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
	    const day = String(today.getDate()).padStart(2, '0');
	    
	    setDatePickers();
	 	// **** 동기적으로 실행하기 위해서 document.ready 안에다가 함수선언했음  ******    
	
	    // === 전체 datepicker 옵션 일괄 설정하기 ===  
	    //     한번의 설정으로 $("input#fromDate"), $('input#toDate')의 옵션을 모두 설정할 수 있다.
	    function setDatePickers() {
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
		    $("input#scheduleDate").datepicker();                    
		        
		    // From의 초기값을 오늘 날짜로 설정
		    $('input#scheduleDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
		    
		} // end of function setDatePickers() {}-----------------------

	    
	    // == 로그인 하지 않고 일정 추가 버튼 시 로그인 페이지로 이동 , 로그인 시에는 모달 띄우기 == //
	    $("button#btnSchedule").click(function() {
	    	if(${empty sessionScope.loginuser}) {
	    		alert("일정 추가 기능은 로그인 후 사용 가능합니다.");
	    	 	location.href = "login.trip";
	    	}
	    	else {
	    		viewScheduleModal(); // 일정 모달 띄우기
	    	}
	    });// end of $("button#btnSchedule").click(function() {})----------------
	    

	    // == 모달창 닫으면 내용 reset == //
	    $('#calendarModal').on('hidden.bs.modal', function (e) {
            $(this).find('form')[0].reset();
            $("input#scheduleDate").datepicker('setDate', 'today');
        });
	    
		// == 일정 달력 input 태그 밑에 고정 == //
	    jQuery("#calendar").datepicker({
            beforeShow: function(input) {
               var i_offset = jQuery(input).offset();
               setTimeout(function(){
                  jQuery("#ui-datepicker-div").css({"left":i_offset});
                  // datepicker의 div의 포지션을 강제로 클릭한 input 위치로 이동시킨다.
               });
            }
        });
	    
	    // == 일정 시간 설정 == //
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
		});// end of $("input#allDay").click(function() {})------------------------
		
		
		// 공유자 추가하기
		$("input#FoodjoinUserName").bind("keyup",function(){
				var joinUserName = $(this).val();
				
				$.ajax({
					url:"<%= ctxPath%>/schedule/insertSchedule/searchFoodJoinUserList.trip",
					data:{"joinUserName":joinUserName},
					dataType:"json",
					success : function(json){
						console.log("공유자 넘어오는지 확인 => "+JSON.stringify(json));
						var joinUserArr = [];
						// console.log(json.length);
					
						if(json.length > 0){
							
							$.each(json, function(index,item){
								var user_name = item.user_name;
								if(user_name.includes(joinUserName)){ // name 이라는 문자열에 joinUserName 라는 문자열이 포함된 경우라면 true , 
									                             // name 이라는 문자열에 joinUserName 라는 문자열이 포함되지 않은 경우라면 false 
								   joinUserArr.push(user_name+"("+item.userid+")");
								}
							});
							
							$("input#FoodjoinUserName").autocomplete({  // 참조 https://jqueryui.com/autocomplete/#default
								source:joinUserArr,
								select: function(event, ui) {       // 자동완성 되어 나온 공유자이름을 마우스로 클릭할 경우 
									add_joinUser(ui.item.value);    // 아래에서 만들어 두었던 add_joinUser(value) 함수 호출하기 
									                                // ui.item.value 이  선택한이름 이다.
									return false;
						        },
						        focus: function(event, ui) {
						            return false;
						        },
						        appendTo: ".modal-body" // 자동완성 결과를 모달 내부로 설정
							}); 
							
						}// end of if---------------------------
					}// end of success------------------
				});
		});// end of $("input#joinUserName").bind("keyup",function(){})------------------ 
	
		// x 아이콘 클릭시 공유자 제거하기
		$(document).on('click','div.displayUserList > span.plusUser > i',function(){
			var text = $(this).parent().text(); // 이순신(leess/leesunsin@naver.com)
			
			var bool = confirm("공유자 목록에서 "+ text +" 회원을 삭제하시겠습니까?");
			// 공유자 목록에서 이순신(leess/leesunsin@naver.com) 회원을 삭제하시겠습니까?
			
			if(bool) {
				$(this).parent().remove();
			}
		});// end of $(document).on('click','div.displayUserList > span.plusUser > i',function(){})--------------
		
		// == 일정 끝 == //
		///////////////////////////////////////////////////////////////////////////////////

		// == 지도 띄우기 == //
		// 서버 측 변수를 JavaScript 변수로 할당
		var food_address = $("input#food_address").val().trim();
		
		// 지도 생성 및 설정
	    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 4 // 지도의 확대 레벨
	    };  
	    var map = new kakao.maps.Map(mapContainer, mapOption); 

	    // 주소-좌표 변환 객체를 생성합니다
	    var geocoder = new kakao.maps.services.Geocoder();

	    // 주소로 좌표를 검색합니다
	    geocoder.addressSearch(food_address, function(result, status) {
	        if (status === kakao.maps.services.Status.OK) {
	            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	            var message = 'latlng: new kakao.maps.LatLng(' + result[0].y + ', ' + result[0].x + ')';
	            //var resultDiv = document.getElementById('clickLatlng'); 
	            //resultDiv.innerHTML = message;

	            // 결과값으로 받은 위치를 마커로 표시합니다
	            var marker = new kakao.maps.Marker({
	                map: map,
	                position: coords
	            });

	            // 인포윈도우로 장소에 대한 설명을 표시합니다
	            var infowindow = new kakao.maps.InfoWindow({
	                content: '<div style="width:150px;text-align:center;padding:6px 0;" ><a href="https://map.kakao.com/link/to/${requestScope.foodstorevo.food_name},' + result[0].y+','+ result[0].x+'" target="_blank" style="color:black;">${requestScope.foodstorevo.food_name}</a></div>'
	            });
	            infowindow.open(map, marker);
	            
	            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	            map.setCenter(coords);
	        }
	    });  
	    
		///////////////////////////////////////////////////////////////////////////////////

	    
	});// end of $(document).ready(function() {})-----------------------------
	
	
	//▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒//
	// Function declaration

	// == 좋아요 클릭, 취소 개수 띄우기 == //
	function goLikeDislikeCount(){
		
		$.ajax({
	        url: "<%= ctxPath %>/countFoodlike.trip",
	        data: {"parent_code": "${requestScope.foodstorevo.food_store_code}",
	            "fk_userid": "${sessionScope.loginuser.userid}"},
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
	    });// end of $.ajax---------------------------------------
		
	}//end of function goLikeDislikeCount()---------------------------------------
	
	
	// == 일정 추가 모달 띄우기 == //
	function viewScheduleModal() {
		
		$("#calendarModal").modal("show");
		
	}// end of function addSchedule()-----------------------------------------
	
	
	// == 일정에 추가하기 == //
	function addSchedule() {
	
		// 오라클에 들어갈  date 형식('yyyy-mm-dd hh24:mi:ss')으로 만들기
       	var scheduleDate = $("input#scheduleDate").val();
       	var startdate = scheduleDate + $("select#startHour").val()+$("select#startMinute").val()+"00";
		var enddate = scheduleDate + $("select#endHour").val()+$("select#endMinute").val()+"00";
		// console.log("~~startDate 확인 => " + startDate);
		// console.log("~~endDate 확인 => " + endDate);
		
		$("input[name=startdate]").val(startdate);
		$("input[name=enddate]").val(enddate);
		
		// 일정 Form
		//const schedule = $("form[name='scheduleFrm']").serialize();
		
		// 일정 제목 유효성 검사
		const scheduleTitle = $("input#scheduleTitle").val().trim();
		if(scheduleTitle == "") {
			alert("일정 제목을 입력해주세요");
			return;
		}
		
		// 일정 내용 유효성 검사
		const scheduleContent = $("input#scheduleContent").val().trim();
		if(scheduleContent == "") {
			alert("일정 내용을 입력해주세요");
			return;
		}
		
		// 방문 시간 유효성 검사
		var startHour= $("select#startHour").val();
     	var endHour = $("select#endHour").val();
     	var startMinute= $("select#startMinute").val();
     	var endMinute= $("select#endMinute").val();
       
       	if(Number(startHour) > Number(endHour)){
       		alert("종료 시간이 시작 시간보다 빠릅니다. 방문 시간을 확인해주세요.");
       		return;
       	}
       	
       	else if(Number(startHour) == Number(endHour)){
       		
       		if(Number(startMinute) > Number(endMinute)){
       			alert("종료 시간이 시작 시간보다 빠릅니다. 방문 시간을 확인해주세요."); 
       			return;
       		}
       		else if(Number(startMinute) == Number(endMinute)){
       			alert("시작 시간과 종료 시간이 동일합니다. 방문 시간을 확인해주세요."); 
       			return;
       		}
       	}
		
     	// 공유자 넣어주기
		var plusUser_elm = document.querySelectorAll("div.displayUserList > span.plusUser");
		var joinUserArr = new Array();
		
		plusUser_elm.forEach(function(item,index,array){
		//	console.log(item.innerText.trim());
			/*
				이순신(leess) 
				아이유1(iyou1) 
				설현(seolh) 
			*/
			joinUserArr.push(item.innerText.trim());
		});
		
		var joinuser = joinUserArr.join(",");
		console.log("공유자 => " + joinuser);
		// 이순신(leess),아이유1(iyou1),설현(seolh) 
		
		$("input[name=joinuser]").val(joinuser);
		
		// 일정 Form
		const schedule = $("form[name='scheduleFrm']").serialize();
		
		<%-- var frm = document.scheduleFrm;
		frm.action="<%= ctxPath%>/schedule/registerSchedule_end.action";
		frm.method="post";
		frm.submit(); --%>
       	
       	
		// 일정 등록 데이터 넘기기
		$.ajax({
			url:"addFoodSchedule.trip",
			type:"post",
			data:schedule,
			success:function(json) {
				// console.log("일정 데이터 넘기기 => " + JSON.stringify(json));
				
				alert("일정 등록에 성공했습니다.");
				$("#calendarModal").modal("hide");
			},
			error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
		});// end of $.ajax------------------------

	}// end of function viewScheduleModal()------------------------------
	
	/////////////// === 리뷰 시작 === ///////////////////////////////////////////////////////////////////////
	
	// == 맛집 리뷰 작성하기 == //
	function goAddReview() {
		
		const review_content = $("textarea[name='review_content']").val().trim();
		
		if(review_content == "") {
			alert("리뷰 내용을 입력하세요!");
			return;
		}
		
		const queryString = $("form[name='addReviewFrm']").serialize();
		
		$.ajax({
			url:"<%= ctxPath%>/addReview.trip",
	        data: queryString,
	        type:"post",
	        dataType:"json",
	        success:function(json){
	        	// console.log("리뷰 insert 확인 : ", JSON.stringify(json));
	        	// {"food_store_code":"5316","fk_userid":"yy6037","n":1}
	        	
	        	if(json.n == 1) {
	        		alert("리뷰가 등록되었습니다.");
	        		goViewReview(1);
	        	}
	        	else {
	        		alert("리뷰 작성 실패");
	        	}
	        	
	        	$("textarea[name='review_content']").val("");
	        },
	        error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});// end of $.ajax({})--------
		
	}// end of function goAddReview()--------------------------------------------------
	
	
	// == 작성한 리뷰 보이기 == //
	function goViewReview(currentShowPageNo) {
		
		$.ajax({
			url:"<%=ctxPath%>/foodstoreReviewList.trip",
			data:{"parent_code":"${requestScope.foodstorevo.food_store_code}"
				, "currentShowPageNo":currentShowPageNo},
			dataType:"json",
			success:function(json) {
				// console.log("리뷰 select 확인 : "+JSON.stringify(json));
				
				let v_html = ""; // 작성한 리뷰
				let count_html = 0; // 리뷰 총 개수

				if(json.length > 0) {
					$.each(json, function(index, item){
						
						v_html += `<tr>
									   <td style='display: none;'>\${item.review_code}</td>
								       <td>\${item.review_content}</td>
								       <td>\${item.fk_userid}</td>
								       <td class='review'>\${item.registerday}</td>`;    
								       
								       if(${sessionScope.loginuser != null} &&
								          "${sessionScope.loginuser.userid}" == item.fk_userid) {
								    	   
								    	   v_html += `<td class='review'>
								    	   				  <button class='btn btn-secondary btn-sm btnUpdateReview'>수정</button>
								    	   				  <input type='hidden' value='\${item.parent_code}'/>
								    		              <button class='btn btn-secondary btn-sm btnDeleteReview'>삭제</button>
								    		              <input type='hidden' value='\${currentShowPageNo}' class='currentShowPageNo' />
								    		          </td>`;
								       }
								        
						v_html += `</tr>`;
						count_html = item.totalCount;  
					});
					
					const totalPage = Math.ceil( json[0].totalCount / json[0].sizePerPage);
					
					makeReviewPageBar(currentShowPageNo, totalPage); // 리뷰 페이지바 함수 호출
					
				}// end of if(json.length > 0)---------
				
				else { // 리뷰가 없을 경우
			    	   v_html += `<tr>
			    	   			      <td>작성된 리뷰가 없습니다.</td>
			    	   			  </tr>`;
			    }
				
				$("tbody#reviewDisplay").html(v_html); // 작성된 리뷰 자리에 넣어주기
				$("p#reviewCount").html(count_html); // 리뷰 총 개수 넣어주기
				
				
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function goViewReview()----------------------
	
	
	// == 리뷰 페이지바 함수 만들기 == //
  	function makeReviewPageBar(currentShowPageNo, totalPage) {
		
		const blockSize = 10; 
		
		let loop = 1;
		
		let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		let pageBar_html = "<ul style='list-style:none;'>";
		
		// === [맨처음] [이전] 만들기 === //
		if(pageNo != 1) {
			pageBar_html += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewReview(1)'>[맨처음]</a></li>";
			pageBar_html += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewReview("+(pageNo-1)+")'>[이전]</a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
		      
			if(pageNo == currentShowPageNo) {
				pageBar_html += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; padding:2px 4px;'>"+pageNo+"</li>";
			}
			else {
				pageBar_html += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goViewReview("+pageNo+")'>"+pageNo+"</a></li>";
			}
			      
			loop++;
			pageNo++;
		      
		} // end of while-------------------------------
		
		// === [다음] [마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar_html += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewReview("+(pageNo+1)+")'>[다음]</a></li>";
			pageBar_html += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewReview("+totalPage+")'>[마지막]</a></li>";
		}
		
		pageBar_html += "</ul>";
		 
		// console.log("pageBar_html 확인 : ", pageBar_html);
		
		// 리뷰 페이지바 출력
		$("div#pageBar").html(pageBar_html);
		
	}// end of function makeReviewPageBar(currentShowPageNo)------------------ */

	
	// == 맛집 상세 페이지에서 로그인 페이지로 이동 (리뷰 작성을 위한 것) == //
	function goLogin() {
		location.href = "login.trip";
	}// end of function goLogin()---------------------------
	
	/////////////// === 리뷰 끝 === ///////////////////////////////////////////////////////////////////////
	

	// == 맛집 삭제 == //
	function goDeleteFoodstore(food_store_code) {
		
		if(confirm("정말로 삭제하시겠습니까?")) {
			
			$.ajax({
				url:"<%= ctxPath%>/deleteFoodstore.trip",
		        data: {"food_store_code" : food_store_code},
		        type:"post",
		        dataType:"json",
		        success:function(json){
		        	// console.log("맛집 삭제 확인 : ", JSON.stringify(json));
		        	
		        	if(json.n == 1 || json.totalCount == 0) {
		        		alert("맛집이 삭제되었습니다.");
		        		location.href = "<%= ctxPath%>/foodstoreList.trip"
		        	}
		        	else {
		        		alert("맛집 삭제 실패");
		        	}
		        },
		        error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
				
			});// end of $.ajax({})--------
		}
	
	}// end of function goDelete()-------------------
	
	
	// == 공유자를 넣어주기 == //
	function add_joinUser(value){  // value 는 공유자로 선택한 이름
		
		var plusUser_es = $("div.displayUserList > span.plusUser").text();
	 	// console.log("확인용 plusUser_es => " + plusUser_es);
	  
		if(plusUser_es.includes(value)) { 
			alert("이미 추가한 회원입니다.");
		}
		
		else {
			$("div.displayUserList").append("<span class='plusUser'>"+value+"&nbsp;<i class='fas fa-times-circle'></i></span>");
		}
		
		$("input#FoodjoinUserName").val("");
		
	}// end of function add_joinUser(value){}----------------------------			
	
</script>


<div id="container">
	<c:if test="${sessionScope.loginuser.userid == 'admin'}">
		<div style="width: 90%; margin: 3% auto;text-align: right;">
			<button type="button" onclick="javascript:location.href='<%= ctxPath%>/editFoodstore.trip?food_store_code=${requestScope.foodstorevo.food_store_code}'" class="btn btn-secondary mr-2">맛집 수정</button>
			<button type="button" onclick="goDeleteFoodstore('${requestScope.foodstorevo.food_store_code}')" class="btn btn-danger" >맛집 삭제</button>
		</div>
	</c:if>
	
	<div class="imgcrop">
		<c:forEach var="addimgList" items="${requestScope.addimgList}" begin="0" end="0">
			<img class="imgAdd img-fluid" src="<%= ctxPath %>/resources/images/foodimg/${addimgList.food_add_img}" alt="..." />
		</c:forEach>
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
					<c:forEach var="addimgList" items="${requestScope.addimgList}" varStatus="status">
						<c:if test="${status.index == 0}">
							<div class="carousel-item active">
								<img class="carousel-img" src="<%= ctxPath %>/resources/images/foodimg/${addimgList.food_add_img}" class="d-block w-100" alt="...">
							</div>
						</c:if>
						<c:if test="${status.index > 0}">
							<div class="carousel-item">
								<img class="carousel-img" src="<%= ctxPath %>/resources/images/foodimg/${addimgList.food_add_img}" class="d-block w-100" alt="...">
							</div>
						</c:if>
					</c:forEach>
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
						<!-- <button type="button" class="iconbtn" onclick="golikeAdd()"> -->
						<button type="button" class="iconbtn" id="btnLike">
							<div class="item-each">
								<img class="icon like" id="like" src="<%= ctxPath %>/resources/images/foodstore/icon/Like.png">
								<img class="icon likeup" id="likeup" src="<%= ctxPath %>/resources/images/foodstore/icon/LikeUp.png">
							</div>
							<p class="icon-title">좋아요</p>
						</button>
						<p class="count" id="likeCount"></p>
					</li>
					<li class="list-item">
						<button type="button" class="iconbtn" id="btnReview">
							<div>
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_review2.png">
							</div>
							<p class="icon-title">리뷰</p>
						</button>
						<p class="count" id="reviewCount"></p>
					</li>
					<li class="list-item">
						<button type="button" class="iconbtn" style="cursor: default;">
							<div>
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_viewcount.png">
							</div>
							<p class="icon-title">조회수</p>
						</button>
						<p class="count" id="readCount">${requestScope.foodstorevo.readCount}</p>
					</li>
					<li class="list-item">
						<button type="button" class="iconbtn" id="btnSchedule">
							<div>
								<img class="icon" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_calender.png">
							</div>
							<p class="icon-title" id="addSchedule">일정 추가</p>
						</button>
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
			                <form name="scheduleFrm">
				                <div class="modal-body" style="padding: 7%;">
				                    <div class="form-group">
				                        <input type="hidden" class="form-control schedule-input mb-3" id="parent_code" name="parent_code" readonly="readonly" value="${requestScope.foodstorevo.food_store_code}">
				                        
				                        <input type="hidden" id="food_store_code" name="food_store_code" value="${requestScope.foodstorevo.food_store_code}" />
				                        <input type="hidden" id="food_address" name="food_address" value="${requestScope.foodstorevo.food_address}" />
				                        
				                        <label for="scheduleTitle" class="col-form-label">맛집 이름</label>
				                        <input type="text" class="form-control schedule-input mb-3" id="scheduleTitle" name="scheduleTitle" readonly="readonly" value="${requestScope.foodstorevo.food_name}">
				                        
				                        <label for="scheduleContent" class="col-form-label">일정 내용</label>
				                        <input type="text" class="form-control schedule-input mb-3" id="scheduleContent" name="scheduleContent">
				                        
				                        <div class="scheduleDate">
								            <label class="mt-3">방문 날짜</label>
								            <div>
								                <div class="date-container">
								                    <span class="date-pick">
								                        <input class="datepicker schedule-input" style="cursor: pointer;" type="text" id="scheduleDate" name="scheduleDate" placeholder="일정에 추가할 날짜 선택">
								                    </span>
								                </div>
								            </div>
								        </div>
								        
								        <div class="visit_time">
								        	<label class="mt-4">방문 시간</label><br>
											<select id="startHour" class="schedule"></select> 시
											<select id="startMinute" class="schedule"></select> 분
											<select id="endHour" class="schedule"></select> 시
											<select id="endMinute" class="schedule"></select> 분
											<input type="checkbox" id="allDay" class="ml-3"/>&nbsp;<label for="allDay">종일</label>
											 
											<input type="hidden" name="startdate"/>
											<input type="hidden" name="enddate"/>
								        </div>
								        
								        <div class="joinUser">
								        	<label class="mt-4">일정 공유자 추가</label><br>
								        	<input type="text" id="FoodjoinUserName" class="form-control schedule-input" placeholder="일정을 공유할 회원 이름을 입력하세요"/>
											<div class="displayUserList"></div><br>
											<input type="hidden" name="joinuser"/>
								        </div>
								        
				                    </div>
				                </div>
			                </form>
			                <div class="modal-footer">
			                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="sprintSettingModalClose">취소</button>
			                    <button type="button" class="btn btn-info" id="EditCalendar" onclick="addSchedule()">등록</button>
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
		</div>
	</div>
	
	<!-- //////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<!-- 맛집 리뷰 -->
	<div class="border rounded" id="reviewList">

		<!-- 리뷰쓰기 -->
		<c:if test="${empty sessionScope.loginuser}">
			<h4 class="mb-5" style="color: orange;">리뷰를 작성하려면 먼저 로그인을 해주세요.
				<button type="button" class="btn btn-secondary ml-4" onclick="goLogin()">로그인하기</button>
			</h4>
		</c:if>
        <c:if test="${not empty sessionScope.loginuser}">
           <h3 style="margin: 0 0 2% 4%;">리뷰 작성</h3>
           <form name="addReviewFrm" id="addReviewFrm">
               <table class="table" style="width: 100%;">
                    <tr style="height: 30px;">
                       <!-- 리뷰 내용 -->
                       <td>
                          <textarea name="review_content" placeholder="리뷰 내용을 작성해 주세요."></textarea> 
                          <input type="text" style="display: none" />
                          <button type="reset" class="btn btn-light btn-sm mr-2 ml-5">취소</button>
                     	  <button type="button" class="btn btn-success btn-sm mr-3" onclick="goAddReview()">리뷰등록</button>

                          <!-- 리뷰에 달리는 원게시물 글번호(즉, 리뷰의 부모글 글번호) -->
                          <input type="hidden" name="parent_code" value="${requestScope.foodstorevo.food_store_code}" />
		                  <input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}" readonly />
                       </td>
                    </tr>
				</table>       
			</form>
		</c:if>

		<h3 style="margin: 5% 0 3% 4%;">작성된 리뷰</h3>
		<c:if test="${empty sessionScope.loginuser}">
			<p style="margin-left: 4%; color: #a6a6a6;">※ 리뷰 수정, 삭제는 로그인 후에 가능합니다.</p>
		</c:if>
		<!-- 리뷰 내용 보여주기 -->
		<table class="table" id="review-table">
			<thead>
				<tr>
					<th style="display: none;">review_code</th>
					<th style="text-align: center;">내용</th>
					<th style="width: 12%;">작성자 아이디</th>
					<th style="width: 12%;">작성일자</th>
					<c:if test="${not empty sessionScope.loginuser}">
						<th style="width: 12%;">수정/삭제</th>
					</c:if>
				</tr>
			</thead>
			<tbody id="reviewDisplay">
			</tbody>
		</table>
		<!-- 리뷰 페이지바 -->
		<div style="display: flex;">
        	<div id="pageBar" style="margin: auto; text-align: center;"></div>
        </div>
	</div>
	
	<!-- 지도, 랜덤추천 -->
		<!-- 지도 -->
		<div class="row bottom">
			<div class="col-md-8">
				<div class="border rounded" id="map_div">
					<h3 class="mb-5">위치 확인</h3>
					<div id="map"></div>
					<input type="hidden" name="food_address" id="food_address" value="${requestScope.foodstorevo.food_address}" />
					<input type="text" style="display: none;" />
				</div>
			</div>
			
			<!-- 랜덤추천 -->
			<div class="col-md-4 border rounded">
				<div>
					<h3 class="mb-4 mt-4 ml-3">근처 숙소 추천</h3>
					<div class="recommend-lodging">
						<c:forEach var="lodgingList" items="${requestScope.lodgingList}" begin="0" end="1">
							<div class="border rounded p-3 mb-3">
							    <div class="recommend-img-box">
							    	<a href="<%= ctxPath%>/lodgingDetail.trip?lodging_code=${lodgingList.lodging_code}"> 
						            	<img class="recommend-img img-fluid" src="<%= ctxPath %>/resources/images/lodginglist/${lodgingList.main_img}" alt="..." />
						        	</a>
						        </div>
						        <div class="mt-2">
							        <a href="<%= ctxPath%>/lodgingDetail.trip?lodging_code=${lodgingList.lodging_code}" class="recommend-lodging-title" > 
							        	<span style="color: black; font-size: 14pt;">${lodgingList.lodging_name}</span><br>
						        	</a>
						        </div>
					      	</div>
				      	</c:forEach>
					</div>
				</div>
			</div>
		</div>
	
</div>
<br><br>
<!-- container 끝 -->






