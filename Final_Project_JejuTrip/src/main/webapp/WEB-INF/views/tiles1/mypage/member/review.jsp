<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageReview.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
		
    	
    	
    	let currentShowPageNo = 1; // currentShowPageNo 초기값
    	goViewAllReviewList(currentShowPageNo); // 페이징처리된 리뷰보여주는 함수
    	goViewfoodReviewList(currentShowPageNo);
    	goViewPlayReviewList(currentShowPageNo);
    	goViewLoginReviewList(currentShowPageNo)

        
    	
    	
    	
    }); // end of $(document).ready(function(){}------------------------------------------------------------------------
    	
    	
function goViewAllReviewList(currentShowPageNo){
	$.ajax({
	    url:"<%= ctxPath%>/userReviewListJSON.trip",
	    type:"post",
	    data: {"fk_userid":"${sessionScope.loginuser.userid}"
	    	  ,"currentShowPageNo":currentShowPageNo},
	    
	    dataType:"json",
	    success:function(json){
	 	
	 	   let v_html = "";
	       let r_html = ""; 
	        if (json.length > 0) {    
	           $.each(json, function(index, item){ 
	                             
	                v_html += "<tr>";
	              	v_html += "<td>"+item.rno+"</td>";
	              	if(item.review_division_R == 'A'){
	              	    v_html += "<td><span style='font-weight:bold;'>숙소</span></td>";
	              	  v_html += "<input type='hidden' value='<%= ctxPath%>/lodgingDetail.trip?lodging_code="+item.parent_code+"'>";
	              	}
					if(item.review_division_R == 'B'){
						v_html += "<td><span style='font-weight:bold;'>맛집</span></td>";
						v_html += "<input type='hidden' value='<%= ctxPath%>/foodstoreDetail.trip?food_store_code="+item.parent_code+"'>";
					}
					if(item.review_division_R == 'C'){
						v_html += "<td><span style='font-weight:bold;'>즐길거리</span></td>";
						v_html += "<input type='hidden' value='<%= ctxPath%>/goAddSchedule.trip?play_code="+item.parent_code+"'>"
					}
					v_html += "<td>"+item.review_content+"</td>";
					v_html += "<td>"+item.registerday+"</td>";
					v_html += "</tr>";
			    	
			    	
	               r_html = item.allTotalCount
	           }); 
	           
	           const totalPage = Math.ceil(json[0].allTotalCount / json[0].sizePerPage);
	           PageBar(currentShowPageNo, totalPage);
	        }// end of if -----------------------
	        
	        else {
	        	v_html += "<tr>";
				v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
				v_html += "</tr>";
	        }// end of else ---------------------
	        $("tbody#all_review_tbody").html(v_html);
	        $("span#reservation_reception").html(r_html);
	        
	        $("tbody#all_review_tbody tr").each(function() {
                var link = $(this).find('input[type=hidden]').val();
                $(this).find('td').click(function() {
                    window.location.href = link;
                });
            });
	    },
	    error: function(request, status, error){
	        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	     }
	 	   
	 	   
		   });
	
}
	
	//goViewAllReviewList 페이지바 함수
	 function PageBar(currentShowPageNo,totalPage){
	 	   
	     const blockSize = 10;
	 	let loop = 1;
	 	let pageNo = Math.floor((Number(currentShowPageNo) - 1)/blockSize) * blockSize + 1;
	 	
	 	let pageBar_HTML = "<ul style='list-style:none'>";
	 	
	 	// [맨처음] [이전] 만들기
	 	if(pageNo != 1) {
	 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewAllReviewList(1)'>[맨처음]</a></li>";
	 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewAllReviewList("+(pageNo-1)+")'>[이전]</a></li>";
	 	}
	 	
	 	while(!(loop>blockSize || pageNo > totalPage)) {
	 		if(pageNo == currentShowPageNo) {
	 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
	 		}
	 		else {
	 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goViewAllReviewList("+pageNo+")'>"+pageNo+"</a></li>";
	 		}
	 		loop++;
	 		pageNo++;
	 	}//end of while
	 	
	 	// [다음] [마지막] 만들기
	 	if(pageNo <= totalPage) {
	 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewAllReviewList("+(pageNo+1)+")'>[다음]</a></li>";
	 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewAllReviewList("+totalPage+")'>[마지막]</a></li>";
	 	}
	 	
	 	
	 	pageBar_HTML += "</ul>";
	 	
	 	// 156.댓글 페이지바 출력하기
	 	$("div#pageBar").html(pageBar_HTML);
	 	
	 }
	
	////////////////////////////////////////////////////////////////////////
	
	//맛집 리뷰 불러오는거
	function goViewfoodReviewList(currentShowPageNo){
			$.ajax({
			    url:"<%= ctxPath%>/userfoodReviewListJSON.trip",
			    type:"post",
			    data: {"fk_userid":"${sessionScope.loginuser.userid}"
			    	  ,"currentShowPageNo":currentShowPageNo},
			    
			    dataType:"json",
			    success:function(json){
			 	
			 	   let v_html = "";
			       let r_html = ""; 
			        if (json.length > 0) {    
			           $.each(json, function(index, item){ 
			                             
			              v_html += "<tr>";
			              	v_html += "<td>"+item.rno+"</td>";
							v_html += "<td>"+item.food_name+"</td>";
		              	    v_html += "<td>"+item.review_content+"</td>";
							v_html += "<td>"+item.registerday+"</td>";
							v_html += "<input type='hidden' value='<%= ctxPath%>/foodstoreDetail.trip?food_store_code="+item.parent_code+"'>";
							v_html += "</tr>";
					    	
					    	
			               r_html = item.totalCount
			           }); 
			           
			           const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
			           foodPageBar(currentShowPageNo, totalPage);
			        }// end of if -----------------------
			        
			        else {
			        	v_html += "<tr>";
						v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
						v_html += "</tr>";
			        }// end of else ---------------------
			        $("tbody#food_review_tbody").html(v_html);
			        $("span#food_count").html(r_html);
			        
			        $("tbody#food_review_tbody tr").each(function() {
		                var link = $(this).find('input[type=hidden]').val();
		                $(this).find('td').click(function() {
		                    window.location.href = link;
		                });
		            });
			        
			    },
			    error: function(request, status, error){
			        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			     }
			 	   
			 	   
				   });
			
		}
	//goViewAllReviewList 페이지바 함수
	 function foodPageBar(currentShowPageNo,totalPage){
	 	   
	     const blockSize = 10;
	 	let loop = 1;
	 	let pageNo = Math.floor((Number(currentShowPageNo) - 1)/blockSize) * blockSize + 1;
	 	
	 	let pageBar_HTML = "<ul style='list-style:none'>";
	 	
	 	// [맨처음] [이전] 만들기
	 	if(pageNo != 1) {
	 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewfoodReviewList(1)'>[맨처음]</a></li>";
	 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+(pageNo-1)+")'>[이전]</a></li>";
	 	}
	 	
	 	while(!(loop>blockSize || pageNo > totalPage)) {
	 		if(pageNo == currentShowPageNo) {
	 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
	 		}
	 		else {
	 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+pageNo+")'>"+pageNo+"</a></li>";
	 		}
	 		loop++;
	 		pageNo++;
	 	}//end of while
	 	
	 	// [다음] [마지막] 만들기
	 	if(pageNo <= totalPage) {
	 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+(pageNo+1)+")'>[다음]</a></li>";
	 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+totalPage+")'>[마지막]</a></li>";
	 	}
	 	
	 	
	 	pageBar_HTML += "</ul>";
	 	
	 	// 156.댓글 페이지바 출력하기
	 	$("div#foodpageBar").html(pageBar_HTML);
	 	
	 }
	
	////////////////////////////////////////////////////////////////////////
		
		//즐길거리 리뷰 불러오는거
		function goViewPlayReviewList(currentShowPageNo){
				$.ajax({
				    url:"<%= ctxPath%>/userFoodReviewListJSON.trip",
				    type:"post",
				    data: {"fk_userid":"${sessionScope.loginuser.userid}"
				    	  ,"currentShowPageNo":currentShowPageNo},
				    
				    dataType:"json",
				    success:function(json){
				 	
				 	   let v_html = "";
				       let r_html = ""; 
				        if (json.length > 0) {    
				           $.each(json, function(index, item){ 
				                             
				              v_html += "<tr>";
				              	v_html += "<td>"+item.rno+"</td>";
								v_html += "<td>"+item.play_name+"</td>";
								v_html += "<td>"+item.review_content+"</td>";
								v_html += "<td>"+item.registerday+"</td>";
								v_html += "<input type='hidden' value='<%= ctxPath%>/goAddSchedule.trip?play_code="+item.parent_code+"'>";
								v_html += "</tr>";
						    	
						    	
				               r_html = item.totalCount
				           }); 
				           
				           const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
				           playPageBar(currentShowPageNo, totalPage);
				        }// end of if -----------------------
				        
				        else {
				        	v_html += "<tr>";
							v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
							v_html += "</tr>";
				        }// end of else ---------------------
				        $("tbody#play_review_tbody").html(v_html);
				        $("span#play_count").html(r_html);
				        
				        $("tbody#play_review_tbody tr").each(function() {
			                var link = $(this).find('input[type=hidden]').val();
			                $(this).find('td').click(function() {
			                    window.location.href = link;
			                });
			            });
				        
				    },
				    error: function(request, status, error){
				        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				     }
				 	   
				 	   
					   });
				
			}
		//goViewAllReviewList 페이지바 함수
		 function playPageBar(currentShowPageNo,totalPage){
		 	   
		     const blockSize = 10;
		 	let loop = 1;
		 	let pageNo = Math.floor((Number(currentShowPageNo) - 1)/blockSize) * blockSize + 1;
		 	
		 	let pageBar_HTML = "<ul style='list-style:none'>";
		 	
		 	// [맨처음] [이전] 만들기
		 	if(pageNo != 1) {
		 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewfoodReviewList(1)'>[맨처음]</a></li>";
		 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+(pageNo-1)+")'>[이전]</a></li>";
		 	}
		 	
		 	while(!(loop>blockSize || pageNo > totalPage)) {
		 		if(pageNo == currentShowPageNo) {
		 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
		 		}
		 		else {
		 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+pageNo+")'>"+pageNo+"</a></li>";
		 		}
		 		loop++;
		 		pageNo++;
		 	}//end of while
		 	
		 	// [다음] [마지막] 만들기
		 	if(pageNo <= totalPage) {
		 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+(pageNo+1)+")'>[다음]</a></li>";
		 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewfoodReviewList("+totalPage+")'>[마지막]</a></li>";
		 	}
		 	
		 	
		 	pageBar_HTML += "</ul>";
		 	
		 	// 156.댓글 페이지바 출력하기
		 	$("div#playpageBar").html(pageBar_HTML);
		 	
		 }
		
		
		
////////////////////////////////////////////////////////////////////////
			
			//숙소 리뷰 불러오는거
			function goViewLoginReviewList(currentShowPageNo){
					$.ajax({
					    url:"<%= ctxPath%>/userLoginReviewListJSON.trip",
					    type:"post",
					    data: {"fk_userid":"${sessionScope.loginuser.userid}"
					    	  ,"currentShowPageNo":currentShowPageNo},
					    
					    dataType:"json",
					    success:function(json){
					 	
					 	   let v_html = "";
					       let r_html = ""; 
					        if (json.length > 0) {    
					           $.each(json, function(index, item){ 
					                             
					              v_html += "<tr>";
					              	v_html += "<td>"+item.rno+"</td>";
									v_html += "<td>"+item.reservation_code+"</td>";
									v_html += "<td>"+item.lodging_name+"</td>";
									v_html += "<td>"+item.check_in+"</td>";
				              	    v_html += "<td>"+item.review_content+"</td>";
									v_html += "<td>"+item.registerday+"</td>";
									v_html += "<input type='hidden' value='<%= ctxPath%>/lodgingDetail.trip?lodging_code="+item.parent_code+"'>";
									v_html += "</tr>";
							    	
							    	
					               r_html = item.totalCount
					           }); 
					           
					           const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
					           logingPageBar(currentShowPageNo, totalPage);
					        }// end of if -----------------------
					        
					        else {
					        	v_html += "<tr>";
								v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
								v_html += "</tr>";
					        }// end of else ---------------------
					        $("tbody#login_review_tbody").html(v_html);
					        $("span#lodging_count").html(r_html);
					        
					        
					        $("tbody#login_review_tbody tr").each(function() {
				                var link = $(this).find('input[type=hidden]').val();
				                $(this).find('td').click(function() {
				                    window.location.href = link;
				                });
				            });
					        
					    },
					    error: function(request, status, error){
					        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					     }
					 	   
					 	   
						   });
					
				}
			//goViewAllReviewList 페이지바 함수
			 function logingPageBar(currentShowPageNo,totalPage){
			 	   
			     const blockSize = 10;
			 	let loop = 1;
			 	let pageNo = Math.floor((Number(currentShowPageNo) - 1)/blockSize) * blockSize + 1;
			 	
			 	let pageBar_HTML = "<ul style='list-style:none'>";
			 	
			 	// [맨처음] [이전] 만들기
			 	if(pageNo != 1) {
			 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewLoginReviewList(1)'>[맨처음]</a></li>";
			 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewLoginReviewList("+(pageNo-1)+")'>[이전]</a></li>";
			 	}
			 	
			 	while(!(loop>blockSize || pageNo > totalPage)) {
			 		if(pageNo == currentShowPageNo) {
			 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
			 		}
			 		else {
			 			pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goViewLoginReviewList("+pageNo+")'>"+pageNo+"</a></li>";
			 		}
			 		loop++;
			 		pageNo++;
			 	}//end of while
			 	
			 	// [다음] [마지막] 만들기
			 	if(pageNo <= totalPage) {
			 		pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goViewLoginReviewList("+(pageNo+1)+")'>[다음]</a></li>";
			 		pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goViewLoginReviewList("+totalPage+")'>[마지막]</a></li>";
			 	}
			 	
			 	
			 	pageBar_HTML += "</ul>";
			 	
			 	// 156.댓글 페이지바 출력하기
			 	$("div#logingPageBar").html(pageBar_HTML);
			 	
			 }
		
		
		
	
	
</script>

<div class="body">
    <div class="navigation">
        <ul>
            <li class="list">
                <a href="<%= ctxPath%>/requiredLogin_goMypage.trip">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/editProfile.trip">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원정보수정</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/my_schedule.trip">
                    <span class="icon"><ion-icon name="calendar-number-outline"></ion-icon></span>
                    <span class="title">내 일정</span>
                </a>
            </li>
            <li class="list active">
                <a href="<%= ctxPath%>/review.trip">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <br><br><br>
            <li class="list">
                <a href="<%= ctxPath%>/support.trip">
                    <span class="icon"><ion-icon name="help-circle-outline"></ion-icon></span>
                    <span class="title">고객센터</span>
                </a>
            </li>
        </ul>
    </div>
	
    <form class = "reviewFrm" name="reviewFrm">
		<div id="review">
			<div id="top_color">
				<p style="font-size: 20px; font-weight: bold; color:white;">이용 후기</p>
			</div>
			<div class="liblock">
				<ul class="review flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">모든후기 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >0</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">숙소 <br><br></strong> 
						<a href="#" class="count">
							<span id="lodging_count"  style="color: ff8000; font-weight: bold; font-size: 30px;">0</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li>
						<strong style="font-size: 18px">맛집 <br><br></strong>
						<a href="#" class="count">
							<span id="food_count" style="color: ff8000; font-weight: bold; font-size: 30px;">0</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li><strong style="font-size: 18px">즐길거리 <br><br></strong>
						 <a href="#" class="count">
						 	<span id="play_count" style="color: ff8000; font-weight: bold; font-size: 30px;">0</span>
					 		<span style="color: gray; font-weight: bold;">건</span>
					 	</a>
					</li>
					
				</ul>
			</div>
		</div>
		<div class="reservation_bar" style="margin-top: 10%;">
		 <!-- Nav tabs -->
			<ul class="nav nav-tabs">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#all_review">전체후기 & 댓글</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#login_review">숙소</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#food_review">맛집</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#play_review">즐길거리</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  <div class="tab-pane active" id="all_review" >
				<table class="table table-hover">
				  <thead>
				    <tr>
				      <th>#</th>
				      <th>카테고리</th>
				      <th>내용</th>
				      <th>작성일자</th>
				    </tr>
				  </thead>
				  <tbody id="all_review_tbody"></tbody>
				</table>
				<div id="pageBar" class="pageBar"></div>
			</div>
			
			  <div class="tab-pane fade" id="login_review">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>체크인일자</th>
						      <th>후기내용</th>
						      <th>작성일자</th>
						    </tr>
						  </thead>
			    		 <tbody id="login_review_tbody"></tbody>
					</table>
					<div id="logingPageBar" class="pageBar"></div>
				</div>
				
				<div class="tab-pane fade" id="food_review">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>가게이름</th>
						      <th>후기내용</th>
						      <th>작성일자</th>
						    </tr>
						  </thead>
			    		 <tbody id="food_review_tbody"></tbody>
					</table>
					<div id="foodpageBar" class="pageBar"></div>
				</div>
				
				<div class="tab-pane fade" id="play_review">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>즐길거리이름</th>
						      <th>후기내용</th>
						      <th>작성일자</th>
						    </tr>
						  </thead>
			    		 <tbody id="play_review_tbody"></tbody>
					</table>
					<div id="playpageBar" class="pageBar"></div>
				</div>
			</div>
		</div>
	</form>

</div>