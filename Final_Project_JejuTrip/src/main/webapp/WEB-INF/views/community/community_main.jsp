<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 메인</title>



<!-- Required meta tags -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<script src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js" type="text/javascript"></script>
<script src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/community/community_main.css" />



<script type="text/javascript">

	$(document).ready(function(){
	    	
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
		
	});// end of $(document).ready(function(){})-------------------
	
</script>

</head>


<body>

	<!-- === 상단 카테고리 탭 === -->
    <div id="category">
    	<h2>커뮤니티</h2>
		<div class="tabs">
			<input type="radio" id="radio-1" name="tabs" checked />
			<label class="tab" for="radio-1">커뮤니티 전체</label>
			
			<input type="radio" id="radio-2" name="tabs" />
			<label class="tab" for="radio-2">자유게시판</label>
			
			<input type="radio" id="radio-3" name="tabs" />
			<label class="tab" for="radio-3">숙박</label>
			
			<input type="radio" id="radio-4" name="tabs" />
			<label class="tab" for="radio-4">관광지,체험</label>
			
			<input type="radio" id="radio-5" name="tabs" />
			<label class="tab" for="radio-5">맛집</label>
			
			<input type="radio" id="radio-6" name="tabs" />
			<label class="tab" for="radio-6">구인</label>
			<span class="glider"></span>
		</div>
		
		<div class="search">
			<input type="text" id="inputSearch" placeholder="검색어 입력">
			<img id="imgSearch" src="<%= ctxPath%>/resources/images/community/search.png">
		</div>
	</div>	

	
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


	<div style="display: flex;">	
		
		<!-- === 실시간 인기글 === -->
		<!-- 조회수 순으로 정렬할 예정 -->
		<!-- 테이블 제목 길어지면 뒤에 내용 '...' 처리해야함 -->
		<div id="content2">
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


		<!-- === 이달의 행사 === -->
		<div id="content3">
			<h4>이달의 행사</h4>
			<div id="festivalList">
				<div class="festivalObject">
					<h2 class="festivalTitle">⦁ 비체올린 여름꽃 & 능소화축제</h2>
					<figure class="snip1504">
						<img src="<%= ctxPath%>/resources/images/community/festival_1.jpg" class="img-fluid imgFestival" alt="..." />
						<figcaption>
							<h3>햇빛 위에 올려놓은 자연 속에 조성된 힐링테마파크에서 펼쳐지는 ‘여름꽃 & 능소화 축제’ </h3>
							<h5>2024.5.15 ~ 7.20</h5>
						</figcaption>
						<a href="#"></a>
					</figure>
				</div>
				  
				<div class="festivalObject">
					<h2 class="festivalTitle">⦁ 세상에 이런(E-RUN) 트립 in 우도</h2>
					<figure class="snip1504 festivalHover">
						<img src="<%= ctxPath%>/resources/images/community/festival_7.jpg" class="img-fluid imgFestival" alt="..." />
						<figcaption>
							<h3>청정 제주를 위해 제주를 사랑하는 여러 기업/단체가 모여 기획한 친환경 관광 프로젝트</h3>
							<h5>2024.6.2 ~ 8.1</h5>
						</figcaption>
						<a href="#"></a>
					</figure>
				</div>	
						
				<!-- <div class="festivalObject">
					<h2 class="festivalTitle">⦁ 제주목관아 야간개장</h2>
					<figure class="snip1504">
						<img src="../images/festival_4.jpg" class="img-fluid imgFestival" alt="..." />
						<figcaption>
							<h3>제주의 역사문화유적인 제주목 관아의 가치와 아름다움을 알리는 제주목 관아 귤림야행</h3>
							<h5>2024.5.1 ~ 8.30</h5>
						</figcaption>
						<a href="#"></a>
					</figure>
				</div> -->
			</div>
		</div>
		
		
		<!-- === 스텝 게시판 === -->
		<!-- 최신순으로 정렬할 예정 -->
		<!-- 테이블 제목 길어지면 뒤에 내용 '...' 처리해야함 -->
		<div id="content4">
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
		
		
	</div>
	<!-- 두번째 줄(실시간 인기글, 이달의 행사, 스텝게시판) 끝 icons8 -->


	<form name="goStaffFrm">
		<input type="text" name="staffNo" />

	</form>

</body>
</html>