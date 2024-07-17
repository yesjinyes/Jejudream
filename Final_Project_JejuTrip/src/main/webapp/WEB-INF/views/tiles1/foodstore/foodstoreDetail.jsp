<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

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
  margin: 5% auto;
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



</style>

<script type="text/javascript">

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
				
				/* var referrer = document.referrer;
				console.log("이전 페이지 URL: "+referrer); */
				
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
	    
		
	    // == 일정 취소버튼 클릭 시 내용 reset == //
	    $("button#sprintSettingModalClose").click(function() {
	    	$("input:text[id='scheduleTitle']").val("");
	    	$("input:text[id='scheduleContent']").val("");
	    	$("input#scheduleDate").datepicker('setDate', 'today');
	    });
	    
	    
	});// end of $(document).ready(function() {})-----------------------------
	
	
	//▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒//
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
		
		// 일정 제목
		const scheduleTitle = $("input:text[id='scheduleTitle']").val();
		// console.log("~~scheduleTitle 확인 => " + scheduleTitle);
		
		// 일정 내용
		const scheduleContent = $("input:text[id='scheduleContent']").val();
		// console.log("~~scheduleContent 확인 => " + scheduleContent);
		
		// 일정 날짜
		const scheduleDate = $("input:text[id='scheduleDate']").val();
		// console.log("~~scheduleDate 확인 => " + scheduleDate);
	
		
		const frm = document.scheduleFrm;
		
		frm.scheduleTitle.value = scheduleTitle;
		frm.scheduleContent.value = scheduleContent;
		frm.scheduleDate.value = scheduleDate;
		
		frm.action = "foodstoreDetail.trip";
		// frm.submit();
		
		
	}
	
	
	//////////////////////////////////////////// === 리뷰 시작 === //////////////////////////////////////////////////
	
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
				//console.log("리뷰 select 확인 : "+JSON.stringify(json));
				
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
				}// end of if(json.length > 0)---------
				
				else { // 리뷰가 없을 경우
			    	   v_html += `<tr>
			    	   			      <td>작성된 리뷰가 없습니다.</td>
			    	   			  </tr>`;
			    }
				
				$("tbody#reviewDisplay").html(v_html); // 작성된 리뷰 자리에 넣어주기
				$("p#reviewCount").html(count_html); // 리뷰 총 개수 넣어주기
				
				const totalPage = Math.ceil( json[0].totalCount / json[0].sizePerPage);
				
				makeReviewPageBar(currentShowPageNo, totalPage); // 리뷰 페이지바 함수 호출
				
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

	//////////////////////////////////////////// === 리뷰 끝 === ////////////////////////////////////////////////////
	
	// == 맛집 상세 페이지에서 로그인 페이지로 이동 (리뷰 작성을 위한 것) == //
	function goLogin() {
		
		location.href = "login.trip";

		// 로그인 후에 다시 전 페이지로 돌아가는 기능 구현해야 함
		
	}// end of function goLogin()---------------------------
	
</script>



<div id="container">

	<c:if test="${sessionScope.loginuser.userid == 'admin'}">
		<div style="width: 90%; margin: 3% auto;text-align: right;">
			<button type="button" onclick="javascript:location.href='<%= ctxPath%>/editFoodstore.trip?food_store_code=${requestScope.foodstorevo.food_store_code}'" class="btn btn-secondary mr-2">맛집 수정</button>
			<button type="button" onclick="goDelete()" class="btn btn-danger" >맛집 삭제</button>
		</div>
	</c:if>
	
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
						<!-- <button type="button" class="iconbtn" onclick="golikeAdd()"> -->
						<button type="button" class="iconbtn" id="btnLike">
							<div class="item-each">
								<img class="icon like" id="like" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_like.png">
								<img class="icon likeup" id="likeup" src="<%= ctxPath %>/resources/images/foodstore/icon/icon_likeup.png">
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
				                    	<label for="food_name" class="col-form-label">맛집 이름</label>
				                        <input type="text" class="form-control mb-3" id="food_name" name="food_name" readonly="readonly" value="${requestScope.foodstorevo.food_name}">
				                        
				                        <label for="scheduleTitle" class="col-form-label">일정 제목</label>
				                        <input type="text" class="form-control mb-3" id="scheduleTitle" name="scheduleTitle">
				                        
				                        <label for="scheduleContent" class="col-form-label">일정 내용</label>
				                        <input type="text" class="form-control mb-3" id="scheduleContent" name="scheduleContent">
				                        
				                        <div class="scheduleDate">
								            <label>날짜</label>
								            <div>
								                <div class="date-container">
								                    <span class="date-pick">
								                        <input class="datepicker" style="cursor: pointer;" type="text" id="scheduleDate" name="scheduleDate" placeholder="일정에 추가할 날짜 선택">
								                    </span>
								                </div>
								            </div>
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
		</div><!-- 우측 div 끝 -->
		
	</div> <!-- row 끝 -->
	
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
		
		<!-- 리뷰 페이지바가 보여지는 곳 -->
		<div style="display: flex; margin-bottom: 50px;">
        	<div id="pageBar" style="margin: auto; text-align: center;"></div>
        </div>
		
	</div>
	<!-- 리뷰 끝 -->
	
</div>
<!-- container 끝 -->







