<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/company/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
    	
    	$("div.loader").hide();
    	
    	goViewAllReservationList(1);
    	goViewSendReservationList(1);
    	goViewSuccessReservationList(1);
    	goViewFailReservationList(1);
    	
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
        
        
		// === 예약내역 Excel 파일로 다운받기 ===
		$("button#btnExcel").click(function() {
			
            const activeTab = $(".nav-tabs .nav-link.active").attr("href");
            const frm = document.excelTableTypeFrm;
            
            switch (activeTab) {
                   
                case "#ready_reservation_success": // 예약승인대기목록
                	frm.status.value = "0";
                    break;
                    
                case "#reservation_success": // 예약확정목록
                	frm.status.value = "1";
                    break;
                    
                case "#reservation_quit": // 예약취소목록
                	frm.status.value = "2";
                    break;
                    
                default: // 전체예약내역(all_reservation)일 경우
                	frm.status.value = "";
                	break;
            }
			
            frm.method = "post";
            frm.action = "<%=ctxPath%>/downloadExcelFile.trip";
			frm.submit();
		});
        
        
    }); // end of $(document).ready(function(){
    	
    	
	function goViewAllReservationList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/reservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"companyid":"${sessionScope.loginCompanyuser.companyid}"},
			type:"post",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html_all = "";
				let v_html_send = "";
				let v_html_success = "";
				let v_html_fail = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html_all += "<tr>";
					    v_html_all += "<th>"+item.reservation_code+"</th>";
						v_html_all += "<td>"+item.lodging_name+"</td>";
						v_html_all += "<td>"+item.room_name+"</td>";
						v_html_all += "<td>"+item.user_name+"</td>";
						v_html_all += "<td>"+item.check_in+"</td>";
						v_html_all += "<td>"+item.check_out+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.room_stock+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.count+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.remain+"</td>";
						if(item.status == '0'){
							v_html_all += "<td><span style='color:blue; font-weight:bold;'>승인대기</span></td>";
						}
						if(item.status == '1'){
							v_html_all += "<td><span style='color:green; font-weight:bold;'>확정</span></td>";
						}
						if(item.status == '2'){
							v_html_all += "<td><span style='color:red; font-weight:bold;'>취소</span></td>";
						}
						v_html_all += "<td>"
						if(item.status == '0'){
							v_html_all += "<input type='button' class='success_btn' onclick='go_change_reservation_status("+item.reservation_code+",1,"+item.remain+")' value='승인'/>"
							v_html_all += "<input type='button' class='fail_btn' onclick='go_change_reservation_status("+item.reservation_code+",2)' value='취소'/>"
						}
						if(item.status == '1'){
							v_html_all += "<input type='button' class='fail_btn' onclick='go_change_reservation_status("+item.reservation_code+",2)' value='취소'/>"
						}
						if(item.status == '2'){
							v_html_all += "<input type='button' class='success_btn' onclick='go_change_reservation_status("+item.reservation_code+",1,"+item.remain+")' value='승인'/>"
						}
						v_html_all += "</td>"
				    	v_html_all += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#all_reservation_tbody").html(v_html_all);
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeAllReservationListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
		function makeAllReservationListPageBar(currentShowPageNo, totalPage){
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
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewAllReservationList(1)'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewAllReservationList("+(pageNo-1)+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewAllReservationList("+totalPage+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// === #156. 댓글 페이지바 출력하기 === //
			$("div#all_reservation_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function goViewSendReservationList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/reservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"companyid":"${sessionScope.loginCompanyuser.companyid}","status":"0"},
			type:"post",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html_all = "";
				let v_html_send = "";
				let v_html_success = "";
				let v_html_fail = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html_all += "<tr>";
					    v_html_all += "<th>"+item.reservation_code+"</th>";
						v_html_all += "<td>"+item.lodging_name+"</td>";
						v_html_all += "<td>"+item.room_name+"</td>";
						v_html_all += "<td>"+item.user_name+"</td>";
						v_html_all += "<td>"+item.check_in+"</td>";
						v_html_all += "<td>"+item.check_out+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.room_stock+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.count+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.remain+"</td>";
						v_html_all += "<td><span style='color:blue; font-weight:bold;'>승인대기</span></td>";
						v_html_all += "<td>"
						v_html_all += "<input type='button' class='success_btn' onclick='go_change_reservation_status("+item.reservation_code+",1,"+item.remain+")' value='승인'/>"
						v_html_all += "<input type='button' class='fail_btn' onclick='go_change_reservation_status("+item.reservation_code+",2)' value='취소'/>"
						v_html_all += "</td>"
				    	v_html_all += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#send_reservation_tbody").html(v_html_all);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeSendReservationListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
		function makeSendReservationListPageBar(currentShowPageNo, totalPage){
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
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewAllReservationList(1)'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewAllReservationList("+(pageNo-1)+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewAllReservationList("+totalPage+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// === #156. 댓글 페이지바 출력하기 === //
			$("div#send_reservation_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function goViewSuccessReservationList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/reservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"companyid":"${sessionScope.loginCompanyuser.companyid}","status":"1"},
			type:"post",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html_all = "";
				let v_html_send = "";
				let v_html_success = "";
				let v_html_fail = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html_all += "<tr>";
					    v_html_all += "<th>"+item.reservation_code+"</th>";
						v_html_all += "<td>"+item.lodging_name+"</td>";
						v_html_all += "<td>"+item.room_name+"</td>";
						v_html_all += "<td>"+item.user_name+"</td>";
						v_html_all += "<td>"+item.check_in+"</td>";
						v_html_all += "<td>"+item.check_out+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.room_stock+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.count+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.remain+"</td>";
						v_html_all += "<td><span style='color:green; font-weight:bold;'>확정</span></td>";
						v_html_all += "<td>"
						v_html_all += "<input type='button' class='fail_btn' onclick='go_change_reservation_status("+item.reservation_code+",2)' value='취소'/>"
						v_html_all += "</td>"
				    	v_html_all += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#success_reservation_tbody").html(v_html_all);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeSuccessReservationListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
		function makeSuccessReservationListPageBar(currentShowPageNo, totalPage){
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
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewAllReservationList(1)'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewAllReservationList("+(pageNo-1)+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewAllReservationList("+totalPage+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// === #156. 댓글 페이지바 출력하기 === //
			$("div#success_reservation_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function goViewFailReservationList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/reservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"companyid":"${sessionScope.loginCompanyuser.companyid}","status":"2"},
			type:"post",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html_all = "";
				let v_html_send = "";
				let v_html_success = "";
				let v_html_fail = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html_all += "<tr>";
					    v_html_all += "<th>"+item.reservation_code+"</th>";
						v_html_all += "<td>"+item.lodging_name+"</td>";
						v_html_all += "<td>"+item.room_name+"</td>";
						v_html_all += "<td>"+item.user_name+"</td>";
						v_html_all += "<td>"+item.check_in+"</td>";
						v_html_all += "<td>"+item.check_out+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.room_stock+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.count+"</td>";
						v_html_all += "<td style='text-align:center;'>"+item.remain+"</td>";
						v_html_all += "<td><span style='color:red; font-weight:bold;'>취소</span></td>";
						v_html_all += "<td>"
						v_html_all += "<input type='button' class='success_btn' onclick='go_change_reservation_status("+item.reservation_code+",1,"+item.remain+")' value='승인'/>"
						v_html_all += "</td>"
				    	v_html_all += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='11' class='comment'>조회할 정보가 없습니다.</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#fail_reservation_tbody").html(v_html_all);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeFailReservationListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
		function makeFailReservationListPageBar(currentShowPageNo, totalPage){
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
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewAllReservationList(1)'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewAllReservationList("+(pageNo-1)+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewAllReservationList("+pageNo+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewAllReservationList("+totalPage+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// === #156. 댓글 페이지바 출력하기 === //
			$("div#fail_reservation_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function go_change_reservation_status(reservation_code,status,remain){
		if(status == '1'){
			if(remain == '0'){
				alert("잔여객실이 남아아있지 않아 예약승인이 불가능합니다.");
				return;
			}
			if(confirm("예약을 승인하시겠습니까?")){
				$("div.loader").show();
				$.ajax({
					url:"<%= ctxPath%>/goChangeReservationStatusJSON.trip",
					data:{"reservation_code":reservation_code,"status":status},
					type:"post",
					dataType:"json",
					success:function(json){
						if(json.result == '1'){
							if(json.email_send_result){
								alert("메일발송을 성공했습니다.");
							}
							else{
								alert("메일발송을 실패했습니다.");
							}
							goViewAllReservationList(1);
					    	goViewSendReservationList(1);
					    	goViewSuccessReservationList(1);
					    	goViewFailReservationList(1);
							$("div.loader").hide();
						}
						else{
							alert("변경에 실패했습니다.");
						}
					},
					error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			}
		}
		else if(status == '2'){
			if(confirm("예약을 취소하시겠습니까?")){
				$("div.loader").show();
				$.ajax({
					url:"<%= ctxPath%>/goChangeReservationStatusJSON.trip",
					data:{"reservation_code":reservation_code,"status":status},
					type:"post",
					dataType:"json",
					success:function(json){
						if(json.result == 1){
							if(json.email_send_result){
								alert("메일발송을 성공했습니다.");
							}
							else{
								alert("메일발송을 실패했습니다.")
							}
							goViewAllReservationList(1);
					    	goViewSendReservationList(1);
					    	goViewSuccessReservationList(1);
					    	goViewFailReservationList(1);
					    	$("div.loader").hide();
						}
					},
					error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			}
		}
	};
</script>

<div class="body">
	
    <div class="navigation">
        <ul>
            <li class="list active">
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
            <li class="list">
                <a href="<%= ctxPath%>/cmpReview.trip">
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
				<p style="font-size: 20px; font-weight: bold; color:white;">전체 예약 현황</p>
			</div>
			<div class="liblock">
				<ul class="reservation flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">예약전체 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >${requestScope.all_reservation}</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">예약승인대기 <br><br></strong> 
						<a href="#" class="count">
							<span id="reservation_confirmed"  style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.ready_reservation}</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li>
						<strong style="font-size: 18px">예약확정 <br><br></strong>
						<a href="#" class="count">
							<span id="trip_complete" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.success_reservation}</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li><strong style="font-size: 18px">예약취소 <br><br></strong>
						 <a href="#" class="count">
						 	<span id="cancel_Reservation" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.fail_reservation}</span>
					 		<span style="color: gray; font-weight: bold;">건</span>
					 	</a>
					</li>
					
				</ul>
			</div>
		</div>
		
		<div class="reservation_bar" style="margin-top: 10%;">
		
			<div class="text-right">
				<button type="button" id="btnExcel" class="btn btn-success"><i class="fa-solid fa-file-arrow-down"></i>&nbsp;&nbsp;
					Excel 파일로 저장</button>
			</div>
		
		 <!-- Nav tabs -->
			<ul class="nav nav-tabs">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#all_reservation">전체예약내역</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#ready_reservation_success">예약승인대기목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#reservation_success">예약확정목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#reservation_quit">예약취소목록</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  <div class="tab-pane active" id="all_reservation">
				<table class="table table-hover">
				  <thead>
				    <tr>
				      <th>예약번호</th>
				      <th>숙소명</th>
				      <th>룸타입</th>
				      <th>고객명</th>
				      <th>체크인</th>
				      <th>체크아웃</th>
				      <th>총객실수</th>
				      <th>예약된객실수</th>
				      <th>잔여객실수</th>
				      <th>예약상태</th>
				      <th>승인처리</th>
				    </tr>
				  </thead>
				  <tbody id="all_reservation_tbody">
					  
				  </tbody>
				</table>
				<div id="all_reservation_pageBar" class="pageBar"></div>
			</div>
			  <div class="tab-pane fade" id="ready_reservation_success">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>룸타입</th>
						      <th>고객명</th>
						      <th>체크인</th>
						      <th>체크아웃</th>
						      <th>총객실수</th>
						      <th>예약된객실수</th>
						      <th>잔여객실수</th>
						      <th>예약상태</th>
						      <th>승인처리</th>
						    </tr>
						  </thead>
			    		 <tbody id="send_reservation_tbody">
						    
						 </tbody>
					</table>
					<div id="send_reservation_pageBar" class="pageBar"></div>
				</div>
				<div class="tab-pane fade" id="reservation_success">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>룸타입</th>
						      <th>고객명</th>
						      <th>체크인</th>
						      <th>체크아웃</th>
						      <th>총객실수</th>
						      <th>예약된객실수</th>
						      <th>잔여객실수</th>
						      <th>예약상태</th>
						      <th>승인처리</th>
						    </tr>
						  </thead>
			    		 <tbody id="success_reservation_tbody">
						    
						 </tbody>
					</table>
					<div id="success_reservation_pageBar" class="pageBar"></div>
				</div>
				<div class="tab-pane fade" id="reservation_quit">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>예약번호</th>
						      <th>숙소명</th>
						      <th>룸타입</th>
						      <th>고객명</th>
						      <th>체크인</th>
						      <th>체크아웃</th>
						      <th>총객실수</th>
						      <th>예약된객실수</th>
						      <th>잔여객실수</th>
						      <th>예약상태</th>
						      <th>승인처리</th>
						    </tr>
						  </thead>
			    		 <tbody id="fail_reservation_tbody">
						    
						 </tbody>
					</table>
					<div id="fail_reservation_pageBar" class="pageBar"></div>
				</div>
			</div>
		</div>
	</form>
	<div style="display: flex; position: absolute; top: 30%; left: 37%; border: solid 0px blue;">
      <div class="loader" style="margin: auto"><img class="img" src="<%=ctxPath%>/resources/images/logo_circle.png"/></div>
   </div>
</div>


<form name="excelTableTypeFrm">
	<input type="hidden" name="status">
</form>


