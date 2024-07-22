<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>    

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/community/community_main.css" />

<script type="text/javascript">
	$(document).ready(function() {
		
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
	    
		
		$('#recipeCarousel').carousel({
			  interval: 10000
		});
	
		$('.carousel .carousel-item').each(function(){
		    var minPerSlide = 3;
		    var next = $(this).next();
		    if (!next.length) {
		        next = $(this).siblings(':first');
		    }
		    next.children(':first-child').clone().appendTo($(this));
		    
		    for (var i=0;i<minPerSlide;i++) {
		        next=next.next();
		        if (!next.length) {
		        	next = $(this).siblings(':first');
		      	}
		        
		        next.children(':first-child').clone().appendTo($(this));
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
	
	
</script>


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
		
		<input type="radio" id="radio-6" name="category" value="5" />
		<label class="tab" for="radio-6">구인</label>
		<span class="glider"></span>
	</div>
	<%--
	<div class="search">
		<input type="text" id="inputSearch" placeholder="검색어 입력">
		<img id="imgSearch" src="<%= ctxPath%>/resources/images/community/search.png">
	</div>
	--%>
	
	<div style="width: 7%;">
		<button type="button" id="writeBtn" class="btn" onclick="location.href='<%=ctxPath%>/community/addBoard.trip'">글쓰기</button>
	</div>
</div>
	
	
	
<div style="width: 70%; margin: 0 auto;">
	<!-- === 추천 게시물 === -->
 	<div id="content1">
 		<h4>추천 게시물</h4>
		<div class="text-right my-1">
		    <div class="row mx-auto my-auto">
		        <div id="recipeCarousel" class="carousel slide w-100" data-ride="carousel">
		            
		            <div class="carousel-inner w-100" role="listbox">
		                
		                <div class="carousel-item active">
		                    <div class="col-md-3">
		                        <div class="card"> 
		                            <img class="img-fluid card-img-top" src="<%= ctxPath%>/resources/images/community/jeju1.jpg">
		                            <div class="card-body">
									    <h5 class="card-title" align="left">뷰가 장난 아니었던 일몰 맛집 추천(제주 동쪽, 남쪽)</h5>
									    <a href="#" class="btn btn-light stretched-link">글보기</a>
								    </div>
		                        </div>
		                    </div>
		                </div>
		                
		                <div class="carousel-item">
		                    <div class="col-md-3">
		                        <div class="card">  
		                            <img class="img-fluid card-img-top" src="<%= ctxPath%>/resources/images/community/jeju2.jpg">
		                            <div class="card-body">
									    <h5 class="card-title" align="left">여름엔 청보리밭도 좋지만 여기 한번 가보세요</h5>
										<a href="#" class="btn btn-light stretched-link">글보기</a>
									</div>
		                        </div>
		                    </div>
		                </div>
		                
		                <div class="carousel-item">
		                    <div class="col-md-3">
		                        <div class="card"> 
		                            <img class="img-fluid card-img-top" src="<%= ctxPath%>/resources/images/community/jeju3.jpg">
		                            <div class="card-body">
								    <h5 class="card-title" align="left">합리적인 가격에 제주 해산물을 먹을 수 있는 해녀마을</h5>
									 <a href="#" class="btn btn-light stretched-link">글보기</a>
								  </div>
		                        </div>
		                    </div>
		                </div>
		                
		                <div class="carousel-item">
		                    <div class="col-md-3">
		                        <div class="card"> 
		                            <img class="img-fluid card-img-top" src="<%= ctxPath%>/resources/images/community/jeju4.jpg">
		                            <div class="card-body">
								    <h5 class="card-title" align="left">친구랑 둘이 뚜벅이 제주여행 (버스시간표, 어플추천)</h5>
									<a href="#" class="btn btn-light stretched-link">글보기</a>
								  </div>
		                        </div>
		                    </div>
		                </div>
		                
		                <div class="carousel-item">
		                    <div class="col-md-3">
		                        <div class="card">  
		                            <img class="img-fluid card-img-top" src="<%= ctxPath%>/resources/images/community/jeju5.jpg">
		                            <div class="card-body">
								    <h5 class="card-title" align="left">부모님 모시고 가기 좋은 제주 동쪽 맛집 추천</h5>
									 <a href="#" class="btn btn-light stretched-link">글보기</a>
								  </div>
		                        </div>
		                    </div>
		                </div>
		                
		                <div class="carousel-item">
		                    <div class="col-md-3">
		                        <div class="card">  
		                            <img class="img-fluid card-img-top" src="<%= ctxPath%>/resources/images/community/jeju6.jpg">
		                            <div class="card-body">
								    <h5 class="card-title" align="left">여자친구한테 칭찬받는 제주도 숙소 TOP 10</h5>
									 <a href="#" class="btn btn-light stretched-link">글보기</a>
								  </div>
		                        </div>
		                    </div>
		                </div>
		                
		            </div>
		            
 		            <a class="carousel-control-prev w-auto" href="#recipeCarousel" role="button" data-slide="prev">
		                <img class="prev_icon" src="<%= ctxPath%>/resources/images/community/prev_icon.png"/>
		            </a>
		            <a class="carousel-control-next w-auto" href="#recipeCarousel" role="button" data-slide="next">
		                <img class="next_icon" src="<%= ctxPath%>/resources/images/community/next_icon.png"/>
		            </a>
		            
		        </div>
		    </div>
		</div>
	</div>


	<div class="d-flex">	
		
		<!-- === 실시간 인기글 === -->
		<!-- 조회수 순으로 정렬할 예정 -->
		<!-- 테이블 제목 길어지면 뒤에 내용 '...' 처리해야함 -->
		<div id="content2" style = "width: 39%">
			<h4>실시간 인기글</h4>
			<main>
				<table id="rankTable">
					<tbody>
						<tr style="border-top: 1px solid #eee;">
							<td class="tableNo">1</td>
							<td><span class="categoryName">맛집</span>
						  		<a class="rankTitle" href="#">갈치조림이 진짜 맛있는 내돈내산 맛집 소개해드립니다!</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">2</td>
							<td><span class="categoryName">맛집</span>
							  	<a class="rankTitle" href="#">바다 보면서 고기 먹을 수 있는 고깃집</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">3</td>
							<td><span class="categoryName">관광지,체험</span>
							  	<a class="rankTitle" href="#">스릴 넘치는 카트체험 하고 왔습니다.</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">4</td>
							<td><span class="categoryName">숙박</span>
							  	<a class="rankTitle" href="#">아이와 함께 가기 좋은 펜션 (가격,예약,꿀팁)</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">5</td>
							<td><span class="categoryName">자유게시판</span>
							  	<a class="rankTitle" href="#">한라산 같이 등반하실 분?</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">6</td>
							<td><span class="categoryName">관광지,체험</span>
							  	<a class="rankTitle" href="#">전국 벚꽃명소 1위는 바로 여기 (데이트, 드라이브)</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">7</td>
							<td><span class="categoryName">숙박</span>
							 	 <a class="rankTitle" href="#">재방문의사 100%! 부모님한테 칭찬 받은 숙소 추천해드려요</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">8</td>
							<td><span class="categoryName">맛집</span>
							  	<a class="rankTitle" href="#">분위기 좋은 카페에서 데이트 하고왔어요~</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">9</td>
							<td><span class="categoryName">맛집</span>
								  <a class="rankTitle" href="#">항상 실패하는 고기국수 드디어 성공</a>
							</td>
						</tr>
						
						<tr>
							<td class="tableNo">10</td>
							<td><span class="categoryName">관광지,체험</span>
							  	<a class="rankTitle" href="#">유채꽃 뷰가 너무 예뻤던 오름 소개해요(일출, 일몰)</a>
							</td>
						</tr>
								    
					</tbody>
				</table>
			</main>
		</div>


		<!-- === 스텝 게시판 === -->
		<!-- 최신순으로 정렬할 예정 -->
		<!-- 테이블 제목 길어지면 뒤에 내용 '...' 처리해야함 -->
		<div style = "width: 60%">
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
			    <h4>제주 방언</h4>
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
	
	<!-- 두번째 줄(실시간 인기글, 이달의 행사, 스텝게시판) 끝 icons8 -->


	<form name="goStaffFrm">
		<input type="text" name="staffNo" />

	</form>
</div>