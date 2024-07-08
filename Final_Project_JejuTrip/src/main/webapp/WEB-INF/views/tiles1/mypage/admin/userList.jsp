<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/userList.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
    	
    	goViewMemberList(1); // 페이징 처리 한 멤버 리스트
    	goViewCompanyList(1); // 페이징 처리 한 멤버 리스트
    	
        const list = document.querySelectorAll('.list');

        function activeLink() {
            // 모든 네비게이션 항목에서 active 클래스를 제거합니다.
            list.forEach((item) => item.classList.remove('active'));
            // 클릭된 네비게이션 항목에 active 클래스를 추가합니다.
            this.classList.add('active');
        }

        list.forEach((item) => {
            item.addEventListener('click', function () {
                // active 클래스를 변경하는 함수 호출
                activeLink.call(this);
                // iframe의 src 속성을 변경하여 콘텐츠를 로드
                const link = this.getAttribute('data-link');
                document.getElementById('contentFrame').src = link;
            });
        });
        
        $("tr").bind("click",function(e){
        	const lodgingCode = $(e.target).parent().next().val();
        	if(Number(lodgingCode) > 0){
        		open_modal(lodgingCode);	
        	}
        });
        
    }); // end of $(document).ready(function(){
    	
    function open_modal(lodgingCode){
    	
    	$.ajax({
			url:"<%= ctxPath%>/selectRegisterHotelJSON.trip",
			data:{"lodging_code":lodgingCode}, 
			type:"post",
			dataType:"json",
			success:function(json){
				let v_html = `<div style="margin-bottom:5px;">숙소명 : \${json.lodging_name}</div>`;
				v_html += `<div style="margin-bottom:5px;">숙소구분 : \${json.lodging_category}</div>`;
				v_html += `<div style="margin-bottom:5px;">위치 구분 : \${json.local_status}</div>`;
				v_html += `<div style="margin-bottom:5px;">주소 : \${json.lodging_address}</div>`;
				v_html += `<div style="margin-bottom:5px;">전화번호 : \${json.lodging_tell}</div>`;
				v_html += `<div style="margin-bottom:5px;">상세설명 : \${json.lodging_content}</div>`;
				v_html += `<img src="<%=ctxPath%>/resources/images/lodginglist/\${json.main_img}" style="width:100%; margin-bottom:20px;"/>`;
				if(json.status == '0'){
					v_html += `<div style="margin-bottom:5px;">처리상태 : <span style="color:blue; font-weight:bold;">처리중</span></div>`;
				}
				else if(json.status == '1'){
					v_html += `<div style="margin-bottom:5px;">처리상태 : <span style="color:green; font-weight:bold;">승인</span></div>`;
				}
				else if(json.status == '2'){
					v_html += `<div style="margin-bottom:5px;">처리상태 : <span style="color:red; font-weight:bold;">반려</span></div>`;
					v_html += `<div style="margin-bottom:5px;">반려사유 : \${json.feedback_msg}</div>`;
				}
			    $("div.modal-body").html(v_html);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); 
    	
    	$('#modal_showDetail').modal('show'); // 모달창 보여주기
    }
    
	function goViewMemberList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/MemberListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo},
			type:"post",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html += "<tr>";
					    v_html += "<th>"+item.userid+"</th>";
						v_html += "<td>"+item.user_name+"</td>";
						v_html += "<td>"+item.mobile+"</td>";
						v_html += "<td>"+item.address+"</td>";
						v_html += "<td>"+item.registerday+"</td>";
						if(item.status == '1'){
							v_html += "<td style='color:green; font-weight:bold;'>정상</td>";
						}
						else{
							v_html += "<td style='color:red; font-weight:bold;'>탈퇴</td>";
						}
						
				    	v_html += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='2' class='comment'>유저가 없습니다</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#memberList").html(v_html);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeMemberListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function goViewComment(currentShowPageNo)------
	
	
	function makeMemberListPageBar(currentShowPageNo, totalPage){
		const blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		/*
			             1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
			[맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
			[맨처음][이전]  21 22 23
		*/
		
		let loop = 1;
		/*
	    	loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
	    */
		
		let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		// *** !! 공식이다. !! *** //
		
	/*
		currentShowPageNo 가 3페이지 이라면 pageNo 는 1 이 되어야 한다.
	    ((3 - 1)/10) * 10 + 1;
		( 2/10 ) * 10 + 1;
		( 0.2 ) * 10 + 1;
		Math.floor( 0.2 ) * 10 + 1;  // 소수부가 있을시 Math.floor(0.2) 은 0.2 보다 작은 최대의 정수인 0을 나타낸다.
		0 * 10 + 1 
		1
			       
		currentShowPageNo 가 11페이지 이라면 pageNo 는 11 이 되어야 한다.
		((11 - 1)/10) * 10 + 1;
		( 10/10 ) * 10 + 1;
		( 1 ) * 10 + 1;
		Math.floor( 1 ) * 10 + 1;  // 소수부가 없을시 Math.floor(1) 은 그대로 1 이다.
		1 * 10 + 1
		11
			       
		currentShowPageNo 가 20페이지 이라면 pageNo 는 11 이 되어야 한다.
		((20 - 1)/10) * 10 + 1;
		( 19/10 ) * 10 + 1;
		( 1.9 ) * 10 + 1;
		Math.floor( 1.9 ) * 10 + 1;  // 소수부가 있을시 Math.floor(1.9) 은 1.9 보다 작은 최대의 정수인 1을 나타낸다.
		1 * 10 + 1
		11
			    
			       
		1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 이다.
		11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.
		21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
				    
		currentShowPageNo         pageNo
		----------------------------------
		   1                      1 = Math.floor((1 - 1)/10) * 10 + 1
		   2                      1 = Math.floor((2 - 1)/10) * 10 + 1
		   3                      1 = Math.floor((3 - 1)/10) * 10 + 1
		   4                      1
		   5                      1
		   6                      1
		   7                      1 
		   8                      1
		   9                      1
		   10                     1 = Math.floor((10 - 1)/10) * 10 + 1
				        
		   11                    11 = Math.floor((11 - 1)/10) * 10 + 1
		   12                    11 = Math.floor((12 - 1)/10) * 10 + 1
		   13                    11 = Math.floor((13 - 1)/10) * 10 + 1
		   14                    11
		   15                    11
		   16                    11
		   17                    11
		   18                    11 
		   19                    11 
		   20                    11 = Math.floor((20 - 1)/10) * 10 + 1
				         
		   21                    21 = Math.floor((21 - 1)/10) * 10 + 1
		   22                    21 = Math.floor((22 - 1)/10) * 10 + 1
		   23                    21 = Math.floor((23 - 1)/10) * 10 + 1
		   ..                    ..
		   29                    21
		   30                    21 = Math.floor((30 - 1)/10) * 10 + 1	    
	*/
		
		let pageBar_HTML = "<ul style='list-style:none;'>";
		
		// === [맨처음][이전] 만들기 === //
		if(pageNo != 1) {
			pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewMemberList(1)'>[맨처음]</a></li>";
			pageBar_HTML += "<li class='before_page'><a href='javascript:goViewMemberList("+(pageNo-1)+")'>[이전]</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
			}
			else {
				pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewMemberList("+pageNo+")'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewMemberList("+pageNo+")'>[다음]</a></li>";
			pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewMemberList("+totalPage+")'>[마지막]</a></li>"; 
		}
		
		pageBar_HTML += "</ul>";		
		
		// === #156. 댓글 페이지바 출력하기 === //
		$("div#MemberListPageBar").html(pageBar_HTML);
	}
	
	function goViewCompanyList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/CompanyListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo},
			type:"post",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html += "<tr>";
					    v_html += "<th>"+item.companyid+"</th>";
						v_html += "<td>"+item.company_name+"</td>";
						v_html += "<td>"+item.mobile+"</td>";
						v_html += "<td>"+item.registerday+"</td>";
						if(item.status == '1'){
							v_html += "<td style='color:green; font-weight:bold;'>정상</td>";
						}
						else{
							v_html += "<td style='color:red; font-weight:bold;'>탈퇴</td>";
						}
						
				    	v_html += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='2' class='comment'>유저가 없습니다</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#companyList").html(v_html);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeCompanyListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function goViewComment(currentShowPageNo)------
	
	
	function makeCompanyListPageBar(currentShowPageNo, totalPage){
		const blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		/*
			             1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
			[맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
			[맨처음][이전]  21 22 23
		*/
		
		let loop = 1;
		/*
	    	loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
	    */
		
		let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		// *** !! 공식이다. !! *** //
		
	/*
		currentShowPageNo 가 3페이지 이라면 pageNo 는 1 이 되어야 한다.
	    ((3 - 1)/10) * 10 + 1;
		( 2/10 ) * 10 + 1;
		( 0.2 ) * 10 + 1;
		Math.floor( 0.2 ) * 10 + 1;  // 소수부가 있을시 Math.floor(0.2) 은 0.2 보다 작은 최대의 정수인 0을 나타낸다.
		0 * 10 + 1 
		1
			       
		currentShowPageNo 가 11페이지 이라면 pageNo 는 11 이 되어야 한다.
		((11 - 1)/10) * 10 + 1;
		( 10/10 ) * 10 + 1;
		( 1 ) * 10 + 1;
		Math.floor( 1 ) * 10 + 1;  // 소수부가 없을시 Math.floor(1) 은 그대로 1 이다.
		1 * 10 + 1
		11
			       
		currentShowPageNo 가 20페이지 이라면 pageNo 는 11 이 되어야 한다.
		((20 - 1)/10) * 10 + 1;
		( 19/10 ) * 10 + 1;
		( 1.9 ) * 10 + 1;
		Math.floor( 1.9 ) * 10 + 1;  // 소수부가 있을시 Math.floor(1.9) 은 1.9 보다 작은 최대의 정수인 1을 나타낸다.
		1 * 10 + 1
		11
			    
			       
		1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 이다.
		11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.
		21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
				    
		currentShowPageNo         pageNo
		----------------------------------
		   1                      1 = Math.floor((1 - 1)/10) * 10 + 1
		   2                      1 = Math.floor((2 - 1)/10) * 10 + 1
		   3                      1 = Math.floor((3 - 1)/10) * 10 + 1
		   4                      1
		   5                      1
		   6                      1
		   7                      1 
		   8                      1
		   9                      1
		   10                     1 = Math.floor((10 - 1)/10) * 10 + 1
				        
		   11                    11 = Math.floor((11 - 1)/10) * 10 + 1
		   12                    11 = Math.floor((12 - 1)/10) * 10 + 1
		   13                    11 = Math.floor((13 - 1)/10) * 10 + 1
		   14                    11
		   15                    11
		   16                    11
		   17                    11
		   18                    11 
		   19                    11 
		   20                    11 = Math.floor((20 - 1)/10) * 10 + 1
				         
		   21                    21 = Math.floor((21 - 1)/10) * 10 + 1
		   22                    21 = Math.floor((22 - 1)/10) * 10 + 1
		   23                    21 = Math.floor((23 - 1)/10) * 10 + 1
		   ..                    ..
		   29                    21
		   30                    21 = Math.floor((30 - 1)/10) * 10 + 1	    
	*/
		
		let pageBar_HTML = "<ul style='list-style:none;'>";
		
		// === [맨처음][이전] 만들기 === //
		if(pageNo != 1) {
			pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewCompanyList(1)'>[맨처음]</a></li>";
			pageBar_HTML += "<li class='before_page'><a href='javascript:goViewCompanyList("+(pageNo-1)+")'>[이전]</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
			}
			else {
				pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewCompanyList("+pageNo+")'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewCompanyList("+pageNo+")'>[다음]</a></li>";
			pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewCompanyList("+totalPage+")'>[마지막]</a></li>"; 
		}
		
		pageBar_HTML += "</ul>";		
		
		// === #156. 댓글 페이지바 출력하기 === //
		$("div#CompanyListPageBar").html(pageBar_HTML);
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
            <li class="list active">
                <a href="<%= ctxPath%>/show_userList.trip">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원관리</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/cash_points.trip">
                    <span class="icon"><ion-icon name="bar-chart-outline"></ion-icon></ion-icon></span>
                    <span class="title">통계</span>
                </a>
            </li>
            <li class="list">
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
	
    <form class = "reservationFrm" name="reservationFrm">
		<div id="reservation">
			<div id="top_color">
				<p style="font-size: 20px; font-weight: bold; color:white;">회원 현황</p>
			</div>
			<div class="liblock">
				<ul class="reservation flex-col" style="margin-top: 15px;">
					
					<li>
						<strong style="font-size: 18px">전체 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >
						 		${requestScope.count_all_user}
						 	</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">개인회원 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >
						 		${requestScope.count_all_member}
						 	</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">업체회원 <br><br></strong> 
						<a href="#" class="count">
							<span id="reservation_confirmed"  style="color: ff8000; font-weight: bold; font-size: 30px;">
								${requestScope.count_all_company}
							</span>
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
			    <a class="nav-link active" data-toggle="tab" href="#member">개인회원</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#company">업체회원</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  	
			  	<div class="tab-pane container active" id="member">
					<table class="table table-hover">
				  		<thead>
				    		<tr>
				      			<th>ID</th>
				      			<th>이름</th>
				      			<th>전화번호</th>
				      			<th>주소</th>
				      			<th>가입일자</th>
				      			<th>상태</th>
				    		</tr>
				  		</thead>
				  		<tbody id="memberList">
				    	
				  		</tbody>
					</table>
					<div id="MemberListPageBar" class="pageBar"></div>
			  </div>
				
				<div class="tab-pane container fade" id="company">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      	<th>ID</th>
			      				<th>이름</th>
			      				<th>전화번호</th>
			      				<th>가입일자</th>
			      				<th>상태</th>
						    </tr>
						  </thead>
			    		 <tbody id="companyList">
						    
						 </tbody>
					</table>
					<div id="CompanyListPageBar" class="pageBar"></div>
				</div>
				
			</div>
		</div>
	</form>
</div>

<%-- === 내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_showDetail" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">등록 신청 상세정보</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
      		
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	  <!-- <button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goEditMyCal()">수정</button> -->
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>