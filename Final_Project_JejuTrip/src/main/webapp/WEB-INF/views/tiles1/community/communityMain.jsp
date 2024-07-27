<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>    

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/community/community_main.css" />

<script type="text/javascript">
	$(document).ready(function() {
		
		
		getFestival();
		
		getPopularBoard();
		
	    // 커뮤니티 카테고리 탭
	    $('input[name="category"]').change(function(e) {
	    	if($(e.target).val() == "") {
	    		location.href = "<%=ctxPath%>/communityMain.trip";
	    		
	    	} else if($(e.target).val() == "1") {
	    		location.href = "<%=ctxPath%>/community/freeBoard.trip";
	    		
	    	} else if($(e.target).val() == "2") {
	    		location.href = "<%=ctxPath%>/community/lodgingBoard.trip";
	    		
	    	} else if($(e.target).val() == "3") {
	    		location.href = "<%=ctxPath%>/community/playBoard.trip";
	    		
	    	} else if($(e.target).val() == "4") {
	    		location.href = "<%=ctxPath%>/community/foodBoard.trip";
	    		
	    	}
	    });
	    
	 
		
		/* Demo purposes only */
		$(".festivalHover").mouseleave(
		  function() {
		    $(this).removeClass("hover");
		  }
		);
		
	});
	
	
	// ========================= 랜덤 방언 보여주는거 시작  ========================= //
    let jsonData = [];
    let currentIndex = sessionStorage.getItem('currentIndex') ? parseInt(sessionStorage.getItem('currentIndex')) : 0;

    function fetchData() {
        $.ajax({
            url: "<%= ctxPath%>/api/jejuBang_eon_JSON.trip",
            type: "get",
            dataType: "json",
            success: function(json) {
                jsonData = json;
                displayData();
                setInterval(displayData, 50000);
            },
            error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }

    function displayData() {
        if (jsonData.length === 0) return;

        let randomIndex = Math.floor(Math.random() * jsonData.length);
        const item = jsonData[randomIndex];
        $('#result').css('background-image', `url(https://source.unsplash.com/random/?coding=${Math.random()})`);
        $('.seq').html(item.seq + ".");
        $('.name').html(item.name);
        $('.sitename').html(item.sitename);
        $('.contents').html(item.contents);
        $('.solution').html(item.solution);

        currentIndex = (currentIndex + 1) % jsonData.length;
        sessionStorage.setItem('currentIndex', currentIndex);
    }

    fetchData(); 
 // ================================= 끝 =========================================== //
	
	function getFestival() {
		let c_html = ``;
		
		// 정수 - 현재일을 기준으로 크롤링한 축제행사에 포함되는 데이터 뿌리기
		$.ajax({
		    url: "<%= ctxPath %>/JSONcurrent_festival.trip",
		    type: "get",
		    dataType: "json",
		    success: function(json) {
		    	
		    	
		    	$.each(json, function(index, item) {
		    		
		            c_html += `
		             			<div class="festival-item">
				                    <img src="<%= ctxPath %>/resources/images/festival/\${item.img}" alt="\${item.title_name}">
				                    <div class="info">
				                    <a href="\${item.link}"><h5>\${item.title_name}</h5></a>
				                        <p>\${item.local_status}</p>
				                        <span>축제기간 : \${item.startdate} ~ \${item.enddate}</span>
				                    </div>
				                	</div>
				                `;
	            }); // end of $.each
	
	            $("div#festivalcontent").html(c_html);
		
	        },
	        error: function(request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	        
	    }); // end of $.ajax
		
	} // end of function getFestival(){}
	
	
	function getPopularBoard(){
		
		let b_html = `<tbody>`;
		let cnt = 1;
	
		// 정수 - 현재일을 기준으로 크롤링한 축제행사에 포함되는 데이터 뿌리기
		$.ajax({
		    url: "<%= ctxPath %>/JSONgetPopularBoard.trip",
		    type: "get",
		    dataType: "json",
		    success: function(json) {
		    	
		    	if(json.length == 0 ){
		    		
		    		b_html = `<tr style="border-top: 1px solid #eee;">
		    			<td class="tableNo">최근 작성된 인기글이 없습니다 ㅠㅠ</td>`;
		    		
		    	}
		    	$.each(json, function(index, item) {
		    		
		    		b_html += `<tr style="border-top: 1px solid #eee;">
									<td class="tableNo">\${cnt}</td>
									<td><span class="categoryName">`;
					
					let category = `\${item.category}`;				
									
					switch (category) {
					
						case "2":
							category = `[숙박]</span>
						  		<a class='rankTitle' href='<%=ctxPath%>/community/viewBoard.trip?seq=\${item.seq}&category=\${item.category}'`;
							break;
						case "3":
							category = `[관광지,체험]</span>
						  		<a class='rankTitle' href='<%=ctxPath%>/community/viewBoard.trip?seq=\${item.seq}&category=\${item.category}'`;
							break;
						case "4":
							category = `[맛집]</span>
						  		<a class='rankTitle' href='<%=ctxPath%>/community/viewBoard.trip?seq=\${item.seq}&category=\${item.category}'`;
							break;	
	
						default:
							category = `[자유게시판]</span>
						  		<a class='rankTitle' href='<%=ctxPath%>/community/viewBoard.trip?seq=\${item.seq}&category=\${item.category}'`;
							break;
					} // end of switch
							
					b_html +=	`\${category}>\${item.subject}</a>
									</td>
								</tr>`;
								
					cnt++;			
		    		
	            }); // end of $.each
	
	           	b_html += `</tbody>`;
	            
	           	$("table#rankTable").html(b_html);
			
	        },
	        error: function(request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	        
	    }); // end of $.ajax
		
		
	} // end of 
	
	  
</script>


<style>
#festivalcontent {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 1rem;
}

.festival-item {
    width: 100%;
    max-width: 23%;
    height: 250px;
    border: 1px solid #ddd;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
}

.festival-item img {
    width: 100%;
    height: 120px;
    object-fit: cover;
}

.festival-item .info {
    padding: 10px;
    flex-grow: 1;
}

.festival-item .info h5 {
    margin: 0 0 10px;
    font-size: 1.25rem;
}

.festival-item .info p {
    margin: 0 0 10px;
    font-size: 1rem;
}

.festival-item .info span {
    font-size: 0.8rem;
    color: #555;
}

@media (max-width: 1200px) {
    .festival-item {
        max-width: 45%;
    }
}

@media (max-width: 768px) {
    .festival-item {
        max-width: 100%;
    }
}

</style>

<!-- === 상단 카테고리 탭 === -->
<div id="category" class="d-flex justify-content-between">
   	<h2>커뮤니티</h2>
	<div class="tabs">
		<input type="radio" id="radio-1" name="category" value="" />
		<label class="tab" for="radio-1">커뮤니티 전체</label>
		
		<input type="radio" id="radio-2" name="category" value="1" />
		<label class="tab" for="radio-2">자유게시판</label>
		
		<input type="radio" id="radio-3" name="category" value="2" />
		<label class="tab" for="radio-3">숙박</label>
		
		<input type="radio" id="radio-4" name="category" value="3" />
		<label class="tab" for="radio-4">관광지,체험</label>
		
		<input type="radio" id="radio-5" name="category" value="4" />
		<label class="tab" for="radio-5">맛집</label>
		<span class="glider"></span>
	</div>
	
	<div style="width: 7%;">
		<button type="button" id="writeBtn" class="btn" onclick="location.href='<%=ctxPath%>/community/addBoard.trip'">글쓰기</button>
	</div>
</div>

<div style="width: 70%; margin: 0 auto;">
	<!-- === 추천 게시물 === -->
 	<div id="content1">
 		<h4>진행중인 축제 / 행사</h4>
		<div class="text-right my-1">
		    <div class="row mx-auto my-auto" id="festivalcontent">
	            <!-- 축제 아이템들이 이곳에 삽입됩니다 -->
	        </div>
		</div>
	</div>

	<div class="d-flex">	
		<!-- === 실시간 인기글 === -->
		<div id="content2" class="col-md-5">
			<h4>실시간 인기글</h4>
			<main>
				<table id="rankTable">
					<!-- 인기글이 이곳에 삽입됩니다 -->
				</table>
			</main>
		</div>

		<!-- === 스텝 게시판 === -->
		<div class="col-md-7">
			
			<div id="content3">
				<h4>게하 스텝 구해요</h4>
				<ul>
					<li><a class="staffTitle" href="#">[제주멍] 가족같이 일할 직원 구해요.</a></li>
					<li><a class="staffTitle" href="#">[제주온도] 주3일 출근, 숙식제공</a></li>
					<li><a class="staffTitle" href="#">[숨게스트하우스] 성격 활발하고 사람 좋아하는 스텝 모집합니다.</a></li>
					<li><a class="staffTitle" href="#">[감성애월] 서핑 가능한 스텝님 모십니다!</a></li>
					<li><a class="staffTitle" href="#">[소낭게스트하우스] 카페, 객실 정리, 파티 (숙식제공)</a></li>
					<li><a class="staffTitle" href="#">[또랑] 성실하신 직원분 모집합니다.</a></li>
					<li><a class="staffTitle" href="#">[쌍용게하] 조용한 게하에서 일하실 분 구해요</a></li>
				</ul>
			</div>
			
			<div id="content4">
			    <h4>알쓸신잡 제주 방언</h4>
			    <ul>
					<li>
						<span class="jejuBang_eon">[ 방언 ]</span><br>
						<span class="name" id="jejuBang_eonText"></span>
					</li>
					<li>
						<span class="jejuBang_eon"> [ 표준어 ]</span><br>
			            <span class="sitename" id="jejuBang_eonText"></span>
					</li>
					<li>
						<span class="jejuBang_eon"> [ 방언 활용 문장 ]</span><br>
			            <span class="contents" id="jejuBang_eonText"></span>
					</li>
					
					<li>
						<span class="jejuBang_eon"> [ 표준어 문장 ]</span><br>
			            <span class="solution" id="jejuBang_eonText"></span>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<form name="goStaffFrm">
	<input type="hidden" name="staffNo" />
</form>