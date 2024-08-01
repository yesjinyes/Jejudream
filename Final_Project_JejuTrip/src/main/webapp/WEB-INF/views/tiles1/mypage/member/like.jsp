<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageLike.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
    $(document).ready(function(){

    	goLogingLikeList(); //숙소
    	goFoodLikeList(); //맛집
    	goPlayLikeList(); // 즐길거리
    	
    	
    	
    }); // end of $(document).ready(function(){}------------------------------------------------------------------------
    	

////////////////////////////////////////////////////////////////////////
	
//맛집 좋아요 불러오는거
function goFoodLikeList(){
		$.ajax({
		    url:"<%= ctxPath%>/foodLikeListJSON.trip",
		    type:"post",
		    data: {"fk_userid":"${sessionScope.loginuser.userid}"},
		    
		    dataType:"json",
		    success:function(json){
		 	
		 	   let v_html = "";
		       let r_html = "0"; 
		        if (json.length > 0) {    
		           $.each(json, function(index, item){ 
		                             
		              v_html += "<tr>";
		              	v_html += "<td style='font-weight: bold'>"+item.rno+"</td>";
						v_html += "<td style='text-align: left;'>"+item.food_name+"</td>";
						v_html += "<input type='hidden' value='<%= ctxPath%>/foodstoreDetail.trip?food_store_code="+item.parent_code+"'>";
						v_html += "</tr>";
						v_html += "<div class='customDisplay spacediv commentDel' onclick='delMyReview("+item.review_code+")'>후기삭제</div><br><br>"; 
				    	
		               r_html = item.totalCount
		           }); 
		           
		        }// end of if -----------------------
		        
		        else {
		        	v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>좋아요 한 맛집이 없습니다.</td>";
					v_html += "</tr>";
		        }// end of else ---------------------
		        $("tbody#food_like_tbody").html(v_html);
		        $("span#food_count").html(r_html);
		        
		        
		        if (json.length > 0){
			        $("tbody#food_like_tbody tr").each(function() {
		                var link = $(this).find('input[type=hidden]').val();
		                $(this).find('td').click(function() {
		                    window.location.href = link;
		                });
		            });
		        }
		    },
		    error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		     }
		 	   
		 	   
			   });
		
	}

	
	////////////////////////////////////////////////////////////////////////
		
//즐길거리 좋아요 불러오는거
function goPlayLikeList(){
		$.ajax({
		    url:"<%= ctxPath%>/playLikeListJSON.trip",
		    type:"post",
		    data: {"fk_userid":"${sessionScope.loginuser.userid}"},
		    
		    dataType:"json",
		    success:function(json){
		 	
		 	   let v_html = "";
		       let r_html = "0"; 
		        if (json.length > 0) {    
		           $.each(json, function(index, item){ 
		                             
		              v_html += "<tr>";
		              	v_html += "<td style='font-weight: bold'>"+item.rno+"</td>";
						v_html += "<td style='text-align: left;'>"+item.play_name+"</td>";
						v_html += "<input type='hidden' value='<%= ctxPath%>/goAddSchedule.trip?play_code="+item.parent_code+"'>";
						v_html += "</tr>";
				    	
				    	
		               r_html = item.totalCount
		           }); 
		           
		        }// end of if -----------------------
		        
		        else {
		        	v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>좋아요 한 즐길거리가 없습니다.</td>";
					v_html += "</tr>";
		        }// end of else ---------------------
		        $("tbody#play_like_tbody").html(v_html);
		        $("span#play_count").html(r_html);
		        
		        
		        if (json.length > 0){
			        $("tbody#play_like_tbody tr").each(function() {
		                var link = $(this).find('input[type=hidden]').val();
		                $(this).find('td').click(function() {
		                    window.location.href = link;
		                });
		            });
		        }
		        
		    },
		    error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		     }
		 	   
		 	   
			   });
		
}
		
		
////////////////////////////////////////////////////////////////////////
			
//숙소 좋아요 불러오는거
function goLogingLikeList(){
		$.ajax({
		    url:"<%= ctxPath%>/lodgingLikeListJSON.trip",
		    type:"post",
		    data: {"fk_userid":"${sessionScope.loginuser.userid}"},
		    dataType:"json",
		    success:function(json){
		 	
		 	   let v_html = "";
		       let r_html = "0"; 
		        if (json.length > 0) {    
		           $.each(json, function(index, item){ 
		                             
		              v_html += "<tr>";
		              	v_html += "<td style='font-weight: bold'>"+item.rno+"</td>";
						v_html += "<td style='text-align: left;'>"+item.lodging_name+"</td>";
						v_html += "<input type='hidden' value='<%= ctxPath%>/lodgingDetail.trip?lodging_code="+item.parent_code+"'>";
						v_html += "</tr>";
				    	
				    	
		               r_html = item.totalCount
		           }); 
		        }// end of if -----------------------
		        
		        else {
		        	v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>좋아요 한 숙소가 없습니다.</td>";
					v_html += "</tr>";
		        }// end of else ---------------------
		        $("tbody#loging_like_tbody").html(v_html);
		        $("span#lodging_count").html(r_html);
		        
		        if (json.length > 0){
			        $("tbody#loging_like_tbody tr").each(function() {
		                var link = $(this).find('input[type=hidden]').val();
		                $(this).find('td').click(function() {
		                    window.location.href = link;
		                });
		            });
		        }
		    },
		    error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		     }
		 	   
		 	   
			   });
		
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
            <li class="list">
                <a href="<%= ctxPath%>/review.trip">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <li class="list active">
                <a href="<%= ctxPath%>/like.trip">
                    <span class="icon"><ion-icon name="heart-outline"></ion-icon></span>
                    <span class="title">좋아요</span>
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
	
	
    <form class = "likeFrm" name="likeFrm">
		<div id="like">
			<div id="top_color">
				<p style="font-size: 20px; font-weight: bold; color:white;">좋아요</p>
			</div>
			<div class="liblock">
				<ul class="like flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">숙소 <br><br></strong> 
						<a href="#" class="count">
							<span id="lodging_count"  style="color: ff8000; font-weight: bold; font-size: 30px;"></span>
							<span style="color: gray; font-weight: bold;">개</span>
						</a>
						<br><br>
						<div class="tab-pane" id="divcontent">
							<table class="table table-hover">
						 		 <thead>
								    <tr>
								      <th>#</th>
								      <th>숙소명</th>
								    </tr>
								  </thead>
								   <tbody id="loging_like_tbody"></tbody>
							</table>
						</div>
					</li>
					
					<li>
						<strong style="font-size: 18px">맛집 <br><br></strong>
						<a href="#" class="count">
							<span id="food_count" style="color: ff8000; font-weight: bold; font-size: 30px;"></span>
							<span style="color: gray; font-weight: bold;">개</span>
						</a><br><br>
						<div class="tab-pane" id="divcontent">
							<table class="table table-hover">
						 		 <thead>
								    <tr>
								      <th>#</th>
								      <th>가게이름</th>
								    </tr>
								  </thead>
								  <tbody id="food_like_tbody"></tbody>
							</table>
						</div>
					</li>
					
					<li><strong style="font-size: 18px">즐길거리 <br><br></strong>
						 <a href="#" class="count">
						 	<span id="play_count" style="color: ff8000; font-weight: bold; font-size: 30px;"></span>
					 		<span style="color: gray; font-weight: bold;">개</span>
					 	</a><br><br>
					 	<div class="tab-pane" id="divcontent">
							<table class="table table-hover">
						 		 <thead>
								    <tr>
								      <th>#</th>
								      <th>즐길거리이름</th>
								    </tr>
								  </thead>
					    		 <tbody id="play_like_tbody"></tbody>
							</table>
						</div>
					</li>
					
				</ul>
			</div>
		</div>
		
	</form>

</div>