<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f42c6cbd2d2060c5c719ee80540fbfbc&libraries=services"></script>

<%-- 
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js"
  integrity="sha384-TiCUE00h649CAMonG018J2ujOgDKW/kVWlChEuu4jK2vxfAAD0eZxzCKakxg55G4" crossorigin="anonymous"></script>
<script>
  Kakao.init('c089c8172def97eb00c07217cae17495'); // 사용하려는 앱의 JavaScript 키 입력
</script>

<a id="kakao-login-btn" href="javascript:loginWithKakao()">
  <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="222"
    alt="카카오 로그인 버튼" />
</a>
<p id="token-result"></p>

<script>
  function loginWithKakao() {
    Kakao.Auth.authorize({
      redirectUri: 'https://developers.kakao.com/tool/demo/oauth',
    });
  }

  // 아래는 데모를 위한 UI 코드입니다.
  displayToken()
  function displayToken() {
    var token = getCookie('authorize-access-token');

    if(token) {
      Kakao.Auth.setAccessToken(token);
      Kakao.Auth.getStatusInfo()
        .then(function(res) {
          if (res.status === 'connected') {
            document.getElementById('token-result').innerText
              = 'login success, token: ' + Kakao.Auth.getAccessToken();
          }
        })
        .catch(function(err) {
          Kakao.Auth.setAccessToken(null);
        });
    }
  }

  function getCookie(name) {
    var parts = document.cookie.split(name + '=');
    if (parts.length === 2) { return parts[1].split(';')[0]; }
  }
</script>
--%>



<script type="text/javascript">

$(document).ready(function(){
	
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
	    $("input#fromDate").datepicker();                    
	    $("input#toDate").datepicker();
	        
	    if( $("input#fromDate").val() == "" || $("input#toDate").val() == "") {
	    	
	    	// From의 초기값을 오늘 날짜로 설정
		    $('input#fromDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
		    
		    // To의 초기값을 1일후로 설정
		    $('input#toDate').datepicker('setDate', '+1D'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
		    
		    $('input#toDate').datepicker('option', 'minDate', '+1D');
	    	
	    	
	    } // end of if
	    
	    
	} // end of function setDatePickers() {}

	
	// 기본 날짜 값 페이즈 로드시 삽입
	const i1 = $("input#fromDate").val();
	const o1 = $("input#toDate").val();
	
	$("input:hidden[name='check_in1']").val(i1);
	$("input:hidden[name='check_out1']").val(o1);
	
	let chk = true;
	
	
	
	
	// 서버 측 변수를 JavaScript 변수로 할당
    var lodgingAddress = document.getElementById("lodging-address").textContent.trim();
    
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
    geocoder.addressSearch(lodgingAddress, function(result, status) {
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
                content: '<div style="width:150px;text-align:center;padding:6px 0;" ><a href="https://map.kakao.com/link/to/${requestScope.lodgingDetail.lodging_name},' + result[0].y+','+ result[0].x+'" target="_blank" style="color:black;">${requestScope.lodgingDetail.lodging_name}</a></div>'
            });
            infowindow.open(map, marker);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);
        }
    });  
	
    $("input:text[name='datepicker']").change( (e)=>{
    	
    	chk = false;
    	
    	let d1 = $("input#fromDate").val();
    	let d2 = $("input#toDate").val();
    	
    	if (d1 >= d2) {
    	    
    		let date1 = new Date(d1);
            
    		date1.setDate(date1.getDate() + 1); // d1의 다음 날로 설정
            
    		d2 = date1.toISOString().split('T')[0]; // 'yyyy-mm-dd' 형식으로 변환

            $("input#toDate").val(d2);
    		
        }
    	
    	/*
    	const v1 = $("input#fromDate").val();
    	const v2 = $("input#toDate").val();
    	
    	alert("v1 : " + v1);
    	alert("v2 : " + v2);
    	
    	$("input:hidden[name='check_in1']").val(v1);
    	$("input:hidden[name='check_out1']").val(v2);
    	*/
    	
    });
    
    
    // 재검색 내용으로 바꾸기
    $("button:button[name='search']").click(function(){
    	
    	chk = true;
    	
    	const lodging_code = $("input:hidden[name='lodging_code1']").val();
        const check_in = $("input#fromDate").val();
        const check_out = $("input#toDate").val();
        const people = $("#people").val();

        $.ajax({
        	url:"<%= ctxPath%>/JSONrenewalRooms.trip",
            type:"POST",
            data:{"lodging_code":lodging_code,
            	  "check_in": check_in, 
            	  "check_out": check_out, 
            	  "people": people},
            dataType:"json",
            success: function(json) {
            	
            	let v_html = ``;
            	
            	// 서버에서 받은 새로운 데이터로 페이지 업데이트
                $(".roominfo").empty();
            	
            	if(json.length > 0 ){
            		
            		// alert('히히');
            		$.each(json, function(index, item){
                    	
                    	v_html += `<div class="single-post" style="display:flex; justify-content: space-between;">
                            		<div style="width: 35%;">
                            			<img src="<%= ctxPath%>/resources/images/lodginglist/room/\${item.room_img}" style="width:100%; height:300px;" />
                        			</div>
                        			<div style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
                            			<h3 class="mt-3">\${item.room_name}</h3>
                        			</div>
                        			<div class="px-3" style="align-self: flex-end;">
                            			<span style="color:#b5aec4;">1박 기준 히히</span>
                            			<br>
        								<span>잔여객실 \${item.remaining_qty}개</span>
        								<br>
        								<span>기준인원 \${item.min_person} 명 / 최대인원 \${item.max_person} 명</span>`;
        				
        				if("${item.remaining_qty}" == "0"){
        					
        					v_html += `<h4 class="pb-2" style="color: red;">예약 마감</h4>`;
        				}
        				else {
        					
        					v_html	+= `<h4 class="pb-2" style="color: navy;">\${Number(item.price).toLocaleString('en')} 원</h4>
        								<div class="mb-2">
                    						<button type="button" name="reservation" class="btn btn-success">예약하기</button>
                						</div>`;	
        					
        				}				
        				
                            v_html += `</div>
                    			</div>
                    			<input type="hidden" name="room_detail_code1" value="\${item.room_detail_code}" />
                            	<input type="hidden" name="lodging_code1" value="\${item.lodging_code}" />
                            	<input type="hidden" name="check_in1" value="\${check_in}" />
                            	<input type="hidden" name="check_out1" value="\${check_out}" />`; 
                    }); // end of $.each
            		
            		
            	} // end of if 
            	else {
            		
            		v_html = "<span>해당하는 숙소가 없습니다</span>";
            		
            	} // end of else
                
                
            	$(".roominfo").html(v_html);
                
            },
            error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
            
        }); // end of $.ajax
        
    }); // end of  $("button:button[name='search']").click(function(){})
    
    
    
    // 예약하기 버튼
    $(document).on('click', "button:button[name='reservation']", function(e){
    	
    	
		if(!chk){
    		
    		alert('날짜 변경시에 재검색 버튼을 눌러주세요!');
    		return false;
    	}
    	
    	
		const room_detail_code = $(e.target).parent().parent().parent().siblings('input:hidden[name="room_detail_code1"]').val();
		const lodging_code = $(e.target).parent().parent().parent().siblings('input:hidden[name="lodging_code1"]').val();
		const check_in = $(e.target).parent().parent().parent().siblings('input:hidden[name="check_in1"]').val();
		const check_out = $(e.target).parent().parent().parent().siblings('input:hidden[name="check_out1"]').val();
		
		/*
		alert(room_detail_code);
	    alert(lodging_code);
		alert(check_in);
		alert(check_out);
		*/
		
		const frm = document.reserve;
		
		frm.room_detail_code.value = room_detail_code;
		frm.lodging_code.value = lodging_code; 
		frm.check_in.value = check_in;
		frm.check_out.value = check_out;
		
		frm.method = "post";
		frm.action = "<%= ctxPath%>/lodgingReservation.trip";
		
		frm.submit();
		
	}); // end of $("button:button[name='reservation']").click(function(e){})
	
	
	
	// 엔터 입력시 자동전송
	$("textarea#review_content").bind("keydown", function(e){
		
		if(e.keyCode == 13){ // 엔터
			
			alert('ㅎㅎ');
			// goAddWrite();
		}
		
	}); // end of $("textarea#review_content").bind("keydown", function(e){}) 
	
	
	/*
	// ====== 댓글 수정 ====== //
	let origin_comment_content = "";
	
	$(document).on("click", "button.btnUpdateComment" ,function(e){
		
		const $btn = $(e.target);
		
		if($(e.target).text() == "수정"){
			
			const $content = $(e.target).parent().parent().children("td:nth-child(2)");
			// $의 의미 선택자라는 뜻으로 변수명을 특별하게 부여해준것 뿐임
			
			origin_comment_content = $(e.target).parent().parent().children("td:nth-child(2)").text();
			// 원래 댓글의 내용
			
			$content.html(`<input class='dd' type='text' value='\${origin_comment_content}' size='40' />`); // 댓글내용을 수정할 수 있도록 input 태그를 만들어 준다.
			
			$(e.target).text("완료").removeClass("btn-secondary").addClass("btn-info");
			$(e.target).next().next().text("취소").removeClass("btn-secondary").addClass("btn-danger");
			
			$(document).on("keydown", "input.dd", function(e){
				
				if(e.keyCode == 13){ // 엔터
					
					// alert($btn.text());
					$btn.click();
				}
				
			}); // end of $("input:text[name='content']").bind("keydown", function(e){}) 
			
		}
		else if($(e.target).text() == "완료"){
			
			// alert('댓글수정완료');
			// alert($(e.target).next().val()); // 수정해야할 댓글 시퀀스 번호
			
			const content = $(e.target).parent().parent().children("td:nth-child(2)").find("input").val();
			// 수정 후 댓글내용
			// alert(content);
			
			const seq = $(e.target).next().val();
			
			$.ajax({
				url:"${pageContext.request.contextPath}/updateComment.action",
				type:"post",
				data:{"seq":seq, 
					  "content":content},
				dataType:"json",
				success:function(json){
					
					// $(e.target).parent().parent().children("td:nth-child(2)").html(content);
					$(e.target).text("수정").removeClass("btn-info").addClass("btn-secondary");
					$(e.target).next().next().text("삭제").removeClass("btn-danger").addClass("btn-secondary");
					
					const currentShowPageNo = $(e.target).parent().parent().find("input.currentShowPageNo").val();
					
					
					goViewComment(currentShowPageNo); // 페이징 처리한 댓글 읽어오기
				},
				error: function(request, status, error){
			        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
				
				
			}); // end of $.ajax
			
		}// end of else if
		
	
		
	}); // end of $("button.btnUpdateComment").click(function(){})
	
	
	// ===== 댓글 수정취소 / 댓글 삭제 ===== //
	$(document).on("click", "button.btnDeleteComment", function(e){
	
		if($(e.target).text() == "취소"){
			
			// alert('댓글수정취소');
			// alert($(e.target).parent().parent().children("td:nth-child(2)").html()); // 원래태그가 무엇인지 찍어보기		
			
			const $content = $(e.target).parent().parent().children("td:nth-child(2)");
			// 선택자를 의미하는 태그 
			$content.html(`\${origin_comment_content}`);
			// 밖으로 빼놓은 원래 내용을 태그로 교체해버린다? , 일단 저 변수는 수정버튼 눌렀을때만 값이 들어가게되고, 취소가 나오는경우는 무조건 수정이 눌렸을 경우이기 때문에 가능해진다!
			
			$(e.target).text("삭제").removeClass("btn-danger").addClass("btn-secondary");
            $(e.target).prev().prev().text("수정").removeClass("btn-info").addClass("btn-secondary");
			
		
		}
		else if($(e.target).text() == "삭제"){
			
			// alert('댓글삭제');
			
			const seq = $(e.target).prev().val(); // 삭제해야할 댓글 시퀀스 번호
			// alert(seq);
			
			if(confirm('정말 댓글을 삭제하시겠습니까?')){
				
				$.ajax({
					url:"${pageContext.request.contextPath}/deleteComment.action",
					type:"post",
					data:{"seq":seq, 
						  "parentSeq":"${requestScope.boardvo.seq}"},
					dataType:"json",
					success:function(json){
						
						goViewComment(1); // 페이징 처리한 댓글 읽어오기
						
					},
					error: function(request, status, error){
				        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			        }
					
				}); // end of $.ajax
				
			}// end of if confirm
			
		}// end of else if "삭제"
    
	}); // end of	$(document).on("click", "button.btnDeleteComment", function(e){})
	
	*/
	
	goViewComment(1);
	
}); // end of $(document).ready(function(){})


function goViewComment(currentShowPageNo){
	
	$.ajax({
		
		url:"<%= ctxPath%>/JSONLodgingCommentList.trip",      
		data:{"lodging_code":"${requestScope.lodgingDetail.lodging_code}",
			  "currentShowPageNo":currentShowPageNo},
		dataType:"json",
		success:function(json){
			
			//console.log(JSON.stringify(json));
			let v_html = ``;
			
			if(json.length > 0){
				
				$.each(json, function(index, item){
					
					v_html += `<div style="display: flex;">
					            	<div style="text-align: center; align-content: center; margin-right: 1%;">
					            		<img id="logo" alt="" src="<%= ctxPath %>/resources/images/logo_circle.png" style="width: 50px;">
					            		<br>
					            		<span>\${item.user_name}</span>
					            	</div>
					                <div class="review">
					                    <p class="review-content">
											\${item.review_content}
					                    </p>
					                    <span class="review-author">작성일 : \${item.registerday}</span>
					                </div>`;
					            
					
					if(${sessionScope.loginuser !=null} &&
					   "${sessionScope.loginuser.userid}" == item.fk_userid){
						
						v_html += `<div class="comment-buttons">
					                	<button type="button" class="btn btn-warning btnUpdateComment">수정</button>
					                	<button type="button" class="btn btn-danger btnDeleteComment">삭제</button>
					                	<input type="hidden" name="fk_userid" value='\${item.fk_userid}' />
										<input type='hidden' value='\${currentShowPageNo}' class='currentShowPageNo' />
					                </div>`;
						
					}// end of if 	
					
                  	v_html += "</div>";
				
				}); // end of each
				
			} // end of if
			else{
				
				v_html += `<div class="review">
                    		<p class="review-content">댓글이 없습니다 ㅠㅠ</p>
                    	   </div>`;
				
			} // end of else
			
			$("div#comment").html(v_html);
			
			const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
			// console.log(totalPage);
			
			makeCommentPageBar(currentShowPageNo, totalPage);
			
		},
		error: function(request, status, error){
	          alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
		
	}); // end of ajax
	
} // end of function goViewComment(currentShowPageNo){} 


function makeCommentPageBar(currentShowPageNo, totalPage){
	
	// %%%%%% Ajax 자바스크립트  페이지바 만들기!!!!! %%%%%% // 
	const blockSize = 5;
	
	let loop = 1;
	
	let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
   	
	let pageBar_HTML = "<ul style='list-style:none;'>";
      
	if(pageNo != 1) {

		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewComment(1)'>[맨처음]</a></li>";
		        
		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewComment("+(pageNo-1)+")'>[이전]</a></li>";
		
	}// end of 
	
	while( !(loop > blockSize || pageNo > totalPage) ) {
							// totalPage를 구해와야한다!!!		 
		
		if(pageNo == currentShowPageNo) {
			
            pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; font-weight:bold; padding:2px 4px;'>"+pageNo+"</a></li>";
            
        }
        else {
        
            pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goViewComment("+pageNo+")'>"+pageNo+"</li>";
            
        }
		
		loop++;
		pageNo++;
		
	}// end of while( !(loop > blockSize) ) { 
	
	// === [다음] [마지막] 만들기 ===
	
	if(pageNo <= totalPage) {
		
		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewComment("+(pageNo+1)+")'>[다음]</a></li>";
		
		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewComment("+totalPage+")'>[마지막]</a></li>";
		
	}

	pageBar_HTML += "</ul>";
	
	$("div#pageBar").html(pageBar_HTML);

} // end of function makeCommentPageBar(currentShowPageNo){

</script>
<style>
.select {
    border: 2px solid #ebebeb;
    border-radius: 15px;
    width: 100%;
    align-content: center;
    padding-left: 3%;
    position: sticky;
    top: 20px;
    background-color: white;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
.single-post {
    width: 100%;
    margin-bottom: 20px;
    border: 1px solid #ebebeb;
    border-radius: 5px;
}
.main-image {
    width: 100%;
    height: 400px;
}
@media (max-width: 768px) {
    .main-image {
        height: 200px;
    }
}
@media (max-width: 480px) {
    .main-image {
        height: 150px;
    }
}
.lodging-name {
    font-size: 36px;
}
.lodging-content {
    border-radius: 5px;
    background-color: rgb(250, 250, 250);
}
.review {
	width:100%;
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 15px;
    margin: 10px 0;
    background-color: #fff3e6;
}

.review-content {
    margin: 10px 0;
}
.review-author {
    font-size: 0.9em;
    color: #555;
}
.address {
    padding-left: 2%;
    align-content: center;
    width: 100%;
    height: 100px;
    background-color: #ffffff;
}
.recommendation {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-bottom: 10px;
    background-color: #ffffff;
}

.comment-buttons {
	align-content: center;
    margin-left: 10px;
}
.comment-buttons button {
    margin-bottom: 5px;
    padding: 5px 10px;
    border: none;
    border-radius: 3px;

}
.input-container textarea {
    width:70%;
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    resize: none;
}


</style>
</head>
<body>
    <div class="container">
        <div class="col-md-9">
            <span class="lodging-name">${requestScope.lodgingDetail.lodging_name}</span>
            <p>${requestScope.lodgingDetail.local_status} / ${requestScope.lodgingDetail.lodging_category}</p>    
        </div>

        <div style="display: flex;" class="mt-3">
            <div class="image-gallery col-md-9">
                <img src="<%= ctxPath%>/resources/images/lodginglist/${requestScope.lodgingDetail.main_img}" alt="숙소 이미지" class="main-image">
            </div>
            <div class="select">
                <h3>숙소 체크인 일정</h3>
                <div class="fromDate">
                    <label>체크인</label>
                    <div class="date-container">
                        <span class="date-pick">
                            <input class="datepicker" style="cursor: pointer; width:80%;" type="text" id="fromDate" name="datepicker" value="${requestScope.dateSendMap.check_in}" placeholder="입실일 선택">
                        </span>
                    </div>
                </div>
                <div class="toDate">
                    <label>체크아웃</label>
                    <div class="date-container">
                        <span class="date-pick">
                            <input class="datepicker" style="cursor: pointer; width:80%;" type="text" id="toDate" name="datepicker" value="${requestScope.dateSendMap.check_out}" placeholder="퇴실일 선택">
                        </span>
                    </div>
                </div>
                <div class="people mb-3">
                    <label>인원</label>
                    <div class="people-container">
                        <span class="people-pick">
                            <input type="number" id="people" style="cursor: pointer; width:80%;" name="people" value="${requestScope.dateSendMap.people}" placeholder="인원 선택">
                        </span>
                    </div>
                </div>
                <button type="button" name="search" class="btn btn-danger" style="width: 80%;">재검색</button>
            </div>
        </div>

        <div class="col-md-12 lodging-info">
            <div class="lodging-content px-3 py-2 my-3">
                <span>${requestScope.lodgingDetail.lodging_content}</span>
            </div>

            <h3>편의 시설</h3>
            <ul>
                <c:forEach var="convenient" items="${requestScope.convenientList}">
                    <li>${convenient}</li>
                </c:forEach>
            </ul>

            <div class="roominfo">
                <c:forEach var="roomDetail" items="${requestScope.roomDetailList}">
                    <div class="single-post" style="display:flex; justify-content: space-between;">
                        <div style="width: 35%;">
                            <img src="<%= ctxPath%>/resources/images/lodginglist/room/${roomDetail.room_img}" style="width:100%; height:300px;" />
                        </div>
                        <div style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
                            <h3 class="mt-3">${roomDetail.room_name}</h3>
                        </div>
                        <div class="px-3" style="align-self: flex-end;">
                            <span style="color:#b5aec4;">1박 기준</span>
                            <br>
                            <span>잔여객실 ${roomDetail.remaining_qty}개</span>
                            <br>
                            <span>기준인원 ${roomDetail.min_person} 명 / 최대인원 ${roomDetail.max_person} 명</span>
                            <h4 class="pb-2" style="color: navy;"><fmt:formatNumber value="${roomDetail.price}" pattern="#,###" /> 원</h4>
                            <div class="mb-2">
                                <button type="button" name="reservation" class="btn btn-success">예약하기</button>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="room_detail_code1" value="${roomDetail.room_detail_code}"/>
                    <input type="hidden" name="lodging_code1" value="${roomDetail.lodging_code}"/>
                    <input type="hidden" name="check_in1" value="" />
                    <input type="hidden" name="check_out1" value="" />
                </c:forEach>
            </div>

            <div class="d-flex"> 
                <div style="flex: 7;">
                    <div id="map" style="width:100%; height:300px;"></div>
                    <div class="address mb-3">
                        <h5>지도에서 클릭하여 여행을 떠나보세요!</h5>    
				                        주소 &nbsp;:&nbsp;&nbsp;<span id="lodging-address">${requestScope.lodgingDetail.lodging_address}</span> <br>
				                        연락처  &nbsp;:&nbsp;&nbsp;<span>${requestScope.lodgingDetail.lodging_tell}</span>
                    </div>
                </div>
                <div style="flex: 3; margin-left: 20px;">
                    <div class="recommendation">
                        <h5>같은 지역 맛집 추천</h5>
                        <div></div>
                    </div>
                    <div class="recommendation">
                        <h5>같은 지역 즐길거리 추천</h5>
                        <div></div>
                    </div>
                </div>
            </div>

            <h3>방문자 리뷰</h3>
            <c:if test="${not empty sessionScope.loginuser}"></c:if>
            <form name="comment">
            <div id="input-comment">
		        <div class="input-container" style="display: flex;">
		            <div class="comment-avatar" style="text-align: center; align-content: center; margin-right: 1%;">
		                <img id="logo" alt="작성자 사진" src="<%= ctxPath %>/resources/images/logo_circle.png" style="width: 50px;">
		                <br>
		                <span>${sessionScope.loginuser.user_name}</span>
		            </div>
		            <textarea id="review_content" rows="4" placeholder="이용후기를 댓글로 남겨주세요!"></textarea>
		            <div class="input-buttons" style="align-content: center; margin-left: 1%;">
		                <button type="button" class="btn btn-warning btn-sm" onclick="goAddWrite()">댓글 작성</button>
		                <button type="reset" class="btn btn-light btn-sm">댓글쓰기 취소</button>
		                <input type="hidden" name="userid" value="${sessionScope.loginuser.userid}">
		                <input type="hidden" name="review_division" value="${requestScope.lodgingDetail.review_division}">
		                <input type="hidden" name="parent_code" value="${requestScope.lodgingDetail.lodging_code}" />
		            </div>
		        </div>
		    </div>
		    </form>
            <div id="comment">
            </div>
            
            <div id="pageBar" style="text-align: center;"></div>
            
        </div>
    </div>


<form name="reserve">
	<input type="hidden" name="room_detail_code" />
	<input type="hidden" name="lodging_code" value="" />
	<input type="hidden" name="check_in" value="" />
	<input type="hidden" name="check_out" value="" />
</form>
  
