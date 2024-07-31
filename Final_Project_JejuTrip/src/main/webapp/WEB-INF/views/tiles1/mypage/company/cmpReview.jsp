<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ page import="java.net.InetAddress" %>
<%-- <link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageReview.css"/> --%>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<style type="text/css">
.body{
    display: flex;
    float: none;
    width: 100%;
    justify-content: left;
}


.navigation {
   position: relative;
   width: 250px;
   background: #ff8000;
}


.navigation ul {
   position: absolute;
   width: 100%;
   padding-left: 5px;
   padding-right: 5px;
   padding-top: 40px;
}

.navigation ul li {
   position: relative;
   list-style: none;
   width: 90%;
   border-radius: 20px 20px;
}

.navigation ul li.active {
   background: #ffcccc;/* 고정되어있을때 강조색 [1] */
}

.navigation ul li a {
   position: relative;
   display: block;
   width: 100%;
   display: flex;
   text-decoration: none;
   color: #fff;
}



.navigation ul li a .icon {
   position: relative;
   display: block;
   min-width: 60px;
   height: 60px;
   line-height: 70px;
   text-align: center;
}

.navigation ul li a .icon ion-icon {
   position: relative;
   font-size: 1.5em;
   z-index: 1;
}

.navigation ul li a .title {
   position: relative;
   display: block;
   height: 60px;
   line-height: 60px;
   white-space: nowrap;
   font-weight:bold;
}


.flex-row {
	display: flex;
	flex-direction: row;
}

.flex-col {
	display: flex;
	flex-direction: col;
}

form.reviewFrm {
    width:65%;
    margin:2% auto;
    border:solid 0px red;
}

#review {
	width: 100%;
	border-top: 2px solid black;
	border-left: 1px solid gray;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	border-radius: 10px 10px;
    margin:auto;
}

#top_color{
padding: 0px 10px 0px 20px; 
border-bottom: solid 1px #ff8000; 
background: #ff8000; 
border-radius: 10px 10px 0px 0px;
}

li a {
	color: black;
}

.review li {
	list-style: none;
	display: block;
	float: left;
	width: 55%;
	margin: 0 auto;
	border-right: 1px dotted #c9c7ca;
	text-align: center;
}

tr:hover{
	cursor: pointer;
}

div.pageBar {
    width:40%;
    margin:auto;
}

div.pageBar > ul{
    margin:auto;
    text-align: center;
    display: flex;
}

div.pageBar > ul > li {
    margin:0 4px;
}


#tblcontent::-webkit-scrollbar {
    width: 5px;
  }
#tblcontent::-webkit-scrollbar-thumb {
  background-color: #ff8000;
  border-radius: 5px;
  background-clip: padding-box;
  border: 2px solid transparent;
}
#tblcontent::-webkit-scrollbar-track {
  background-color: grey;
  border-radius: 5px;
  box-shadow: inset 0px 0px 5px white;
}


div#tblcontent{
	
	overflow: scroll;
  	overflow-x: hidden;
  	height: 500px;
}

</style>



<script type="text/javascript">
$(document).ready(function(){
	
	goViewCmpLoginReviewList(''); // 초기에는 모든 리뷰를 가져옴

	$(document).on('change', '#local_status', function() {
	    const selectedValue = $(this).val();
	    goViewCmpLoginReviewList(selectedValue); // 선택된 숙소에 대한 리뷰를 가져옴
	});
});

// 숙소 리뷰 불러오는 함수
function goViewCmpLoginReviewList(selectedValue){
	$.ajax({
	    url:"<%= ctxPath%>/companyLogingReviewListJSON.trip",
	    type:"post",
	    data: {
	    	"fk_companyid": "${sessionScope.loginCompanyuser.companyid}",
	    	"lodging_name": selectedValue // 추가된 매개변수
	    },
	    dataType:"json",
	    success:function(json){
	 	    let v_html = "";
	        let r_html = "0"; 
	        if (json.length > 0) {    
	           $.each(json, function(index, item){ 
	              v_html += "<tr>";
	              	v_html += "<td>"+item.rno+"</td>";
					v_html += "<td>"+item.lodging_name+"</td>";
              	    v_html += "<td>"+item.review_content+"</td>";
					v_html += "<td>"+item.fk_userid+"</td>";
					v_html += "<td>"+item.registerday+"</td>";
					v_html += "<input type='hidden' value='<%= ctxPath%>/lodgingDetail.trip?lodging_code="+item.lodging_code+"'>";
					v_html += "</tr>";
		            r_html = item.totalCount
		           }); 
		           
		        } else {
		        	v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>작성된 리뷰가 없습니다</td>";
					v_html += "</tr>";
		        }
		        $("tbody#login_review_tbody").html(v_html);
		        $("span#lodging_count").html(r_html);
		        
		        if (json.length > 0){
			        $("tbody#login_review_tbody tr").each(function() {
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
                <a href="<%= ctxPath%>/company_chart.trip">
                    <span class="icon"><ion-icon name="bar-chart-outline"></ion-icon></ion-icon></span>
                    <span class="title">통계</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/myRegisterHotel.trip">
                    <span class="icon"><ion-icon name="wallet-outline"></ion-icon></span>
                    <span class="title">숙소등록신청현황</span>
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

	<form class="reviewFrm" name="reviewFrm">
		<div class="info_block mt-3">
			<span style="font-weight: bold; font-size: 40pt; color: #ff8000;">${sessionScope.loginCompanyuser.company_name}</span><br>
			<div style="float: right;">
				<span style="font-weight: bold; font-size: 15pt; color: #ff8000;">숙소별 후기 </span>
				<select id="local_status">
					<option selected value="">전체후기</option>
					<c:forEach var="lodgingvo" items="${requestScope.lodgingList}">
						<option value="${lodgingvo.lodging_name}">${lodgingvo.lodging_name}</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<div class="reservation_bar" style="margin-top: 5%; height: 400px;">
			<div class="tab-content" style="height: 400px;" id="tblcontent">
				<table class="table table-borderless table-hover" >
					<thead>
						<tr>
							<th>#</th>
							<th>숙소명</th>
							<th>후기내용</th>
							<th>작성자ID</th>
							<th>작성일자</th>
						</tr>
					</thead>
					<tbody id="login_review_tbody"></tbody>
				</table>
			</div>
		</div>
	</form>

</div>