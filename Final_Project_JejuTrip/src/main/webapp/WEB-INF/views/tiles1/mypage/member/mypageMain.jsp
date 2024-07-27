<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); 
	//=== #221. (웹채팅관련3) === 
	// === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) === 
	
	InetAddress inet = InetAddress.getLocalHost();
		String serverIP = inet.getHostAddress();
	 
		// System.out.println("serverIP : " + serverIP);
		// serverIP : 192.168.0.191
	
	// String serverIP = "192.168.10.101";
		// String serverIP = "211.238.142.72"; 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다. 
	
	// === 서버 포트번호 알아오기 === //
	int portnumber = request.getServerPort();
		// System.out.println("portnumber : " + portnumber);
		// portnumber : 9099
	
	String serverName = "http://"+serverIP+":"+portnumber;
		// System.out.println("serverName : " + serverName);
		// serverName : http://172.18.80.1:9090

%>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
	
	$(document).ready(function(){
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
        
       	$(document).on('click','.go_chat',function(){
       		const reservation_code = $(this).find("input").val();
       		
       		const name = "${sessionScope.loginuser.user_name}";
       		const userid = "${sessionScope.loginuser.userid}";
       		
   			// >>> 팝업창 띄우기 <<<
   		    // 너비 1000, 높이 600 인 팝업창을 화면 가운데 위치시키기
   			const width = 500;
   			const height = 700;

   		    const left = Math.ceil( (window.screen.width - width)/2 ); // 정수로 만듬
   		    const top = Math.ceil( (window.screen.height - height)/2 ); // 정수로 만듬
   		    
   		 	let companyid = "";
   	   		let lodging_name = "";
   	   		
	   		 $.ajax({
	 			url:"<%= ctxPath%>/getCompanyIdAndNameJSON.trip",
	 			data:{"reservation_code":reservation_code},
	 			type:"post",
	 			dataType:"json",
	 			success:function(json){
	 				companyid = json.companyid
	 				lodging_name = json.lodging_name;
	 				const url = "<%= serverName%><%=ctxPath%>/reservationChatToCompany.trip?reservation_code=" + reservation_code +"&name="+name+"&userid="+userid+"&companyid="+companyid+"&lodging_name="+lodging_name+"&status=1";
	 				window.open(url, "mypage_chatting_toCompany",
 		               `left=\${left}, top=\${top}, width=\${width}, height=\${height}`);
	 			},
	 			error: function(request, status, error){
	 			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	 			}
	 		});

   		   
       		
       	});
        
       	
       	
       	$(document).on("click", "tr", function(e){
       		
       		// const reservation_code = $(e.target).firstChild;
       		const reservation_code = $(this).find("input").val();
        	
       		// alert('히히');
       		// alert(reservation_code);
       		
       		open_modal(reservation_code);
       		
        }); // end of $(document).on("click", "tbody", function(e){
        	
        	
        	
        	
       $(document).on("click", "button#cancelReserve" , function(){
    	   
			// alert('히히');
			// alert($("input:hidden[name='modal_reservation_code']").val());
			
			const reservation_code = $("input:hidden[name='modal_reservation_code']").val();
			
			if(confirm('정말 예약을 취소하시겠습니까 ?')){
				
				$.ajax({
		 			url:"<%= ctxPath%>/JSONMemberCancelReserve.trip",
		 			data:{"reservation_code":reservation_code},
		 			type:"post",
		 			dataType:"json",
		 			success:function(json){
		 				
		 				if(json.result == "1"){
		 				
		 					alert("예약이 취소되었습니다.");
			 				location.reload(true);
		 				
		 				}
		 				else {
		 					
		 					alert("예약이 취소 실패");
		 					return false;
		 				}
		 				
		 			},
		 			error: function(request, status, error){
		 			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 			}
		 		});
			
			} // end of if
			
       });
       
        
        
    }); // end of $(document).ready(function(){
    	
    	
function goViewAllReservationList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/userReservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"userid":"${sessionScope.loginuser.userid}"},
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
						if(item.status == '0'){
							v_html_all += "<td><span style='color:blue; font-weight:bold;'>승인대기</span></td>";
						}
						if(item.status == '1'){
							v_html_all += "<td><span style='color:green; font-weight:bold;'>확정</span></td>";
						}
						if(item.status == '2'){
							v_html_all += "<td><span style='color:red; font-weight:bold;'>취소</span></td>";
						}
						v_html_all += "<td class='go_chat'><ion-icon name='chatbubble-sharp'><input type='button' value='"+item.reservation_code+"'/></ion-icon></td>";
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
			url:"<%= ctxPath%>/userReservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"userid":"${sessionScope.loginuser.userid}","status":"0"},
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
						v_html_all += "<td><span style='color:blue; font-weight:bold;'>승인대기</span></td>";
						v_html_all += "<td><ion-icon name='chatbubble-sharp'></ion-icon></td>";
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
			url:"<%= ctxPath%>/userReservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"userid":"${sessionScope.loginuser.userid}","status":"1"},
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
						v_html_all += "<td><span style='color:green; font-weight:bold;'>확정</span></td>";
						v_html_all += "<td><ion-icon name='chatbubble-sharp'></ion-icon></td>";
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
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewSuccessReservationList("+pageNo+")'>"+pageNo+"</a></li>"; 
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
			url:"<%= ctxPath%>/userReservationListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo,"userid":"${sessionScope.loginuser.userid}","status":"2"},
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
						v_html_all += "<td><span style='color:red; font-weight:bold;'>취소</span></td>";
						v_html_all += "<td><ion-icon name='chatbubble-sharp'></ion-icon></td>";
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
	
	
	
	
// 유저가 예약한 숙소정보를 모달로 띄우는 함수 (정수)
function open_modal(reservation_code){
    	
    	$.ajax({
    		
    	
			url:"<%= ctxPath%>/JSONMemberReservationInfo.trip",
			data:{"reservation_code":reservation_code}, 
			type:"post",
			dataType:"json",
			success:function(json){
				let v_html = ``;
				let b_html = ``;
				
			
				v_html += `<div style="margin-bottom:5px;">숙소명 : \${json.lodging_name}</div>
				 		   <div style="margin-bottom:5px;">숙소구분 : \${json.lodging_category}</div>
						   <div style="margin-bottom:5px;">주소 : \${json.lodging_address}</div>
				           <div style="margin-bottom:5px;">전화번호 : \${json.lodging_tell}</div>
						   <div style="margin-bottom:5px;">객실명 : \${json.room_name}</div>
					  	   <div style="margin-bottom:5px;">체크인 시간 : \${json.check_intime}</div>
					  	   <div style="margin-bottom:5px;">체크아웃 시간 : \${json.check_outtime}</div>
						   <div style="margin-bottom:5px;">예약결제일자 : \${json.reservation_date}</div>
						   <div style="margin-bottom:5px;">예약결제금액 : \${json.reservation_price}</div>
						   <div style="margin-bottom:5px;">예약 체크인일자 : \${json.check_in}</div>
						   <div style="margin-bottom:5px;">예약 체크아웃일자 : \${json.check_out}</div>
						   <img src="<%=ctxPath%>/resources/images/lodginglist/room/\${json.room_img}" style="width:100%; margin-bottom:20px;"/>`;
						   
						   
				if(json.status == '0'){
					v_html += `<div style="margin-bottom:5px;">예약상태 : <span style="color:blue; font-weight:bold;">예약대기중</span></div>`;
					b_html += `<button type="button" id="cancelReserve" class="btn btn-warning btn-sm">예약취소하기</button>
							   <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">닫기</button>`;
				}
				else if(json.status == '1'){
					v_html += `<div style="margin-bottom:5px;">예약상태 : <span style="color:green; font-weight:bold;">예약확정</span></div>`;
					b_html += `<button type="button" id="cancelReserve" class="btn btn-warning btn-sm">예약취소하기</button>
						       <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">닫기</button>`;
				}
				else if(json.status == '3'){
					v_html += `<div style="margin-bottom:5px;">예약상태 : <span style="color:green; font-weight:bold;">예약기간만료</span></div>`;
					b_html += `<button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">닫기</button>`;
					
				}
				else if(json.status == '2'){
					v_html += `<div style="margin-bottom:5px;">예약상태 : <span style="color:red; font-weight:bold;">예약취소</span></div>`;
					b_html += `<button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">닫기</button>`;
				}
				
				v_html += `<input type="hidden" name="modal_reservation_code" value="\${reservation_code}" />`;
				
			    $("div.modal-body").html(v_html);
			    $("div.modal-footer").html(b_html);
			    
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});  // end of $.ajax
    	
    	
    	
    	$('#modal_showDetail').modal('show'); // 모달창 보여주기
    	 
    } // end of 
	
	
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
				<p style="font-size: 20px; font-weight: bold; color:white;">나의 예약현황</p>
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
						<strong style="font-size: 18px">예약접수중 <br><br></strong> 
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
				      <th>예약상태</th>
				      <th>1:1문의</th>
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
						      <th>예약상태</th>
						      <th>1:1문의</th>
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
						      <th>예약상태</th>
						      <th>1:1문의</th>
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
						      <th>예약상태</th>
						      <th>1:1문의</th>
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

</div>


<div class="modal fade" id="modal_showDetail" data-backdrop="static">

	<div class="modal-dialog">
		<div class="modal-content">
	    
	      <!-- Modal header -->
	      <div class="modal-header">
	        <h4 class="modal-title">예약 상세정보</h4>
	        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
	      </div>
	      
	      <!-- Modal body -->
	      <div class="modal-body">
	      		
	      </div>
	      
	      <!-- Modal footer -->
	      <div class="modal-footer">
	      	  
	      </div>
	      
	    </div>    
	</div>
</div>