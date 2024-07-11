<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        
    	goViewLodgingList(1); // 페이징 처리 한 숙소 리스트
    	goViewFoodstoreList(1); // 페이징 처리 한 숙소 리스트
    	goViewPlayList(1);
    	
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
    }); // end of $(document).ready(function(){
    	
	function goViewLodgingList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/LodgingListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo},
			type:"post",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html += "<tr class='click'>";
					    v_html += "<th>"+item.lodging_code+"</th>";
						v_html += "<td>"+item.lodging_name+"</td>";
						v_html += "<td>"+item.lodging_tell+"</td>";
						v_html += "<td>"+item.lodging_address+"</td>";
				    	v_html += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='2' class='comment'>유저가 없습니다</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#lodgingList").html(v_html);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeLodgingListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function makeLodgingListPageBar(currentShowPageNo, totalPage){
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
			pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewLodgingList(1)'>맨처음</a></li>";
			pageBar_HTML += "<li class='before_page'><a href='javascript:goViewLodgingList("+(pageNo-1)+")'>이전</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
			}
			else {
				pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewLodgingList("+pageNo+")'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewLodgingList("+pageNo+")'>다음</a></li>";
			pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewLodgingList("+totalPage+")'>마지막</a></li>"; 
		}
		
		pageBar_HTML += "</ul>";		
		
		// === #156. 댓글 페이지바 출력하기 === //
		$("div#lodgingListPageBar").html(pageBar_HTML);
	}
	
	function goViewFoodstoreList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/FoodstoreJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo},
			type:"post",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html += "<tr class='click'>";
					    v_html += "<th>"+item.food_store_code+"</th>";
						v_html += "<td>"+item.food_name+"</td>";
						v_html += "<td>"+item.food_mobile+"</td>";
						v_html += "<td>"+item.food_address+"</td>";
				    	v_html += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='2' class='comment'>유저가 없습니다</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#foodstoreList").html(v_html);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makeFoodstoreListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function makeFoodstoreListPageBar(currentShowPageNo, totalPage){
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
			pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewFoodstoreList(1)'>맨처음</a></li>";
			pageBar_HTML += "<li class='before_page'><a href='javascript:goViewFoodstoreList("+(pageNo-1)+")'>이전</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
			}
			else {
				pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewFoodstoreList("+pageNo+")'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewFoodstoreList("+pageNo+")'>다음</a></li>";
			pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewFoodstoreList("+totalPage+")'>마지막</a></li>"; 
		}
		
		pageBar_HTML += "</ul>";		
		
		// === #156. 댓글 페이지바 출력하기 === //
		$("div#foodstoreListPageBar").html(pageBar_HTML);
	}
	
	function goViewPlayList(currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/PlayJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo},
			type:"post",
			dataType:"json",
			success:function(json){
				// console.log(JSON.stringify(json));
				// [{"fileName":"20240701121456357667780733900.jpg","fileSize":"334004","name":"엄정화","regdate":"2024-07-01 12:14:56","totalCount":1,"sizePerPage":5,"fk_userid":"eomjh","seq":"3","content":"첨부파일이 있는 댓글쓰기입니다.","orgFilename":"증명_DSC_6505.jpg"}] 
				
				let v_html = "";
				if(json.length > 0){
					$.each(json, function(index, item){
					    v_html += "<tr class='click'>";
					    v_html += "<th>"+item.play_code+"</th>";
						v_html += "<td>"+item.play_name+"</td>";
						v_html += "<td>"+item.play_mobile+"</td>";
						v_html += "<td>"+item.play_address+"</td>";
				    	v_html += "</tr>";
				    	 
					}); // end of $.each(json, function(index, item){})-------- 
				}
				else {
					v_html += "<tr>";
					v_html +=   "<td colspan='2' class='comment'>유저가 없습니다</td>";
					v_html += "</tr>";
				}
				
			    $("tbody#playList").html(v_html);
			    
			    // === #154. 페이지바 함수 호출  === //
			    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
			 // console.log("totalPage : ", totalPage);
			 // totalPage : 3
			    
			    makePlayListPageBar(currentShowPageNo, totalPage);
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function goViewComment(currentShowPageNo)------
	
	function makePlayListPageBar(currentShowPageNo, totalPage){
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
			pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewPlayList(1)'>맨처음</a></li>";
			pageBar_HTML += "<li class='before_page'><a href='javascript:goViewPlayList("+(pageNo-1)+")'>이전</a></li>"; 
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
			}
			else {
				pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewPlayList("+pageNo+")'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewPlayList("+pageNo+")'>다음</a></li>";
			pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewPlayList("+totalPage+")'>마지막</a></li>"; 
		}
		
		pageBar_HTML += "</ul>";		
		
		// === #156. 댓글 페이지바 출력하기 === //
		$("div#playListPageBar").html(pageBar_HTML);
	}
	
</script>

<div class="body">
    <div class="navigation">
        <ul>
            <li class="list active">
                <a href="<%= ctxPath%>/requiredLogin_goMypage.trip">
                    <span class="icon"><ion-icon name="list-outline"></ion-icon></span>
                    <span class="title">등록 컨텐츠</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/show_userList.trip">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원관리</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/admin_chart.trip">
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
				<p style="font-size: 20px; font-weight: bold; color:white;">등록된 컨텐츠 개수</p>
			</div>
			<div class="liblock">
				<ul class="reservation flex-col" style="margin-top: 15px;">
					<li>
						<strong style="font-size: 18px">숙소 <br><br></strong> 
						 <a href="#" class="count">
						 	<span id="reservation_reception" style="color: ff8000; font-weight: bold; font-size: 30px;" >${requestScope.lodging_cnt}</span>
						 	<span style="color: gray; font-weight: bold;">건</span>
					 	 </a>
					</li>
					
					<li>
						<strong style="font-size: 18px">맛집 <br><br></strong> 
						<a href="#" class="count">
							<span id="reservation_confirmed"  style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.foodstore_cnt}</span>
							<span style="color: gray; font-weight: bold;">건</span>
						</a>
					</li>
					
					<li>
						<strong style="font-size: 18px">즐길거리 <br><br></strong>
						<a href="#" class="count">
							<span id="trip_complete" style="color: ff8000; font-weight: bold; font-size: 30px;">${requestScope.play_cnt}</span>
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
			    <a class="nav-link active" data-toggle="tab" href="#lodging_list">등록 숙소 목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#foodstore_list">등록 맛집 목록</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#play_list">즐길거리 목록</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  <div class="tab-pane container active" id="lodging_list">
				<table class="table table-hover">
				  <thead>
				    <tr>
				      <th>#</th>
				      <th>숙소명</th>
				      <th>연락처</th>
				      <th>주소</th>
				    </tr>
				  </thead>
				  <tbody id="lodgingList">
				  	
				  </tbody>
				</table>
				<div id="lodgingListPageBar" class="pageBar"></div>
			</div>
			
			  <div class="tab-pane container fade" id="foodstore_list">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>식당명</th>
						      <th>연락처</th>
						      <th>주소</th>
						    </tr>
						  </thead>
			    		 <tbody id="foodstoreList">
			    		 
						 </tbody>
					</table>
					<div id="foodstoreListPageBar" class="pageBar"></div>
				</div>
				
				<div class="tab-pane container fade" id="play_list">
					<table class="table table-hover">
				 		 <thead>
						    <tr>
						      <th>#</th>
						      <th>업체명</th>
						      <th>연락처</th>
						      <th>주소</th>
						    </tr>
						  </thead>
			    		 <tbody id="playList">
			    		 
						 </tbody>
					</table>
					<div id="playListPageBar" class="pageBar"></div>
				</div>
				
			</div>
		</div>
	</form>

</div>