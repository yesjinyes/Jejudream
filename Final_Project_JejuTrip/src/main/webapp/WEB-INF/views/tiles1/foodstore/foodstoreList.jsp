<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>


<style type="text/css">


.single-post {
  margin-bottom: 20px;
  border: 1px solid #ebebeb;
  border-radius: 5px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.single-post:hover {
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}


.title a {
  margin: 10px 0;
  color: black;
  text-decoration: none;
  transition-duration: 300ms;
  text-transform: capitalize;
}

.title a:hover {
  color: #ff854d;
  text-decoration: none;
}

.foodRecommend,
.foodRecommend:hover {
  text-decoration-line: none;
  color: black;
  font-size: 15pt;
}

.areamapList {
  border: solid 0px black;
  display: flex;
  width: 85%; 
  margin-right: 5%;
}

.select-area {
  border: solid 0px black;
  width: 10%;
  margin-left: 2.7%;
  margin-right: 3%;
}

.areamap {
  border: solid 0px gray;
  margin-right: 1%;
}

.imgMainList {
  width: 35%;
  height: 190px;
}

.imgMain {
  height: 190px;
  width: 100%;
  object-fit: cover;
}

.contentList {
  flex: 1; 
  display: flex; 
  flex-direction: column; 
  justify-content: space-between; 
  padding-left: 20px;
  margin-right: 1%;
}

/* 버튼 */
button.sort {
  border: #737373;
  border-radius: 5px;
  padding: 0.8% 2%;
  background-color: #ffdccc;
  color: #404040;
}

button.sort:hover {
  background-color: #ffa880;
}

button#btnAll {
  border: #737373;
  border-radius: 5px;
  padding: 0.8% 2%;
  background-color: #e6e6e6;
}

button#btnAll:hover {
  background-color: #b3b3b3;
  font-weight: bold;  
}

button#btnSearch {
  border: gray;
  border-radius: 5px;
}

/* 맛집추천 스크롤 고정  */
@media all and (min-width: 1101px) {
  .foodRecommendList {
  position: -webkit-sticky;
  position: sticky;
  align-self: flex-start;
  top: 0;
  }
}

span#data {
  font-size: 17pt;
  font-weight: bold;
  margin-top: 10%;
}


</style>

<script type="text/javascript">
	$(document).ready(function() {

		let currentShowPageNo = 1;
		goAjax(currentShowPageNo); // 전체 리스트 띄우기
		
		// ▒▒▒▒▒▒▒▒▒ 체크박스 시작 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ //
		//== 카테고리 체크박스 선택 == //
		$("input:checkbox[name='food_category']").change(function(e){
			const arr_category = [];
			
			// 체크된 카테고리만 배열에 담기 
			$("input:checkbox[name='food_category']:checked").each(function(index, item) {
				arr_category.push($(item).val());
			});
	
			const str_category = arr_category.join();
			// console.log("~~확인용 str_category => " + str_category);
			
			const frm = document.dataFrm;
			frm.str_category.value = str_category;

			goAjax(1);
		});
		
		
		//== 카테고리 체크박스 전체 선택 == //
		$("input:checkbox[name='food_category_all']").change(function(e){
			const arr_category = [];
			
			// 체크된 카테고리만 배열에 담기 
			$("input:checkbox[name='food_category']:checked").each(function(index, item) {
				arr_category.push($(item).val());
			});
	
			const str_category = arr_category.join();
			// console.log("~~확인용 str_category => " + str_category);
			
			const frm = document.dataFrm;
			frm.str_category.value = str_category;

			goAjax(1);
		});
		
		////////////////////////////////////////////////////////////////////////
		
		//== 지역 체크박스 선택 == //
		$("input:checkbox[name='area']").change(function(e){
			const arr_area = [];
			
			// 체크된 지역만 배열에 담기 
			$("input:checkbox[name='area']:checked").each(function(index, item) {
				arr_area.push($(item).val());
			});
		
			const str_area = arr_area.join();
			// console.log("~~~확인용 str_area => " + str_area);
			
			const frm = document.dataFrm;
			frm.str_area.value = str_area;
			
			goAjax(currentShowPageNo);
		});
		
		//== 지역 체크박스 전체 선택 == //
		$("input:checkbox[name='allArea']").change(function(e){
			const arr_area = [];
			
			// 체크된 지역만 배열에 담기 
			$("input:checkbox[name='area']:checked").each(function(index, item) {
				arr_area.push($(item).val());
			});
		
			const str_area = arr_area.join();
			// console.log("~~~확인용 str_area => " + str_area);
			
			const frm = document.dataFrm;
			frm.str_area.value = str_area;
			
			goAjax(currentShowPageNo);
		});
		// ▒▒▒▒▒▒▒▒▒ 체크박스 끝 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ //
		
		
		// ▒▒▒▒▒▒▒▒▒ 정렬 시작 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ //
		// == 전체보기 클릭 시 == //
		$("button#btnAll").click(function() {
			const frm = document.dataFrm;
			
			frm.orderValue_asc.value = "";
			frm.orderValue_desc.value = "";
			
			goAjax(currentShowPageNo);
		});
		
		// == 오름차순 정렬 == //
		$("button#btnAsc").click(function() {
			const frm = document.dataFrm;
			
			frm.orderType.value = "food_name";
			frm.orderValue_asc.value = "asc";
			frm.orderValue_desc.value = "";
			
			goAjax(currentShowPageNo);
		});
		
		// == 내림차순 정렬 == //
		$("button#btnDesc").click(function() {
			const frm = document.dataFrm;
			
			frm.orderType.value = "food_name";
			frm.orderValue_desc.value = "desc";
			frm.orderValue_asc.value = "";
			
			goAjax(currentShowPageNo);
		});
		// ▒▒▒▒▒▒▒▒▒ 정렬 끝 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ //
	
		
		// == 검색하기 엔터 == //
		$("input:text[name='searchbox']").bind("keyup", function(e){
			if(e.keyCode == 13) {
				goSearch();
			}
		});
		
	});// end of $(document).ready(function()})-------------------
	
	
	// == 카테고리, 지역 Ajax 처리 == //
	function goAjax(currentShowPageNo) {
		
		$("input:hidden[name='currentShowPageNo']").val(currentShowPageNo);
		
		// form 태그 불러오기
		const form = $("form[name='dataFrm']").serialize();
		
		$.ajax({
			url:"foodstoreListJSON.trip",
			data:form,
			dataType:"json",
			success:function(json) {
				// console.log("json 확인" +JSON.stringify(json));
				
				let v_html_main = ``;
				let v_html_side = ``;
				
				if(json.length > 0) {
				
					json.forEach(function(item, index, array) {
						
						// 맛집 리스트 띄우기
						if(item.status == 0){
							v_html_main += `<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
												<div class="imgMainList">
										            <img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodimg/\${item.food_main_img}" onclick="goDetail(\${item.food_store_code})" style="cursor: pointer;" alt="..." />
									        	</div>
										        <div class="contentList">
										            <div class="mb-3">
										            	<h3 class="pt-3 title"><a href="<%= ctxPath %>/foodstoreDetail.trip?food_store_code=\${item.food_store_code}">\${item.food_name}</a></h3>
										            	<span>\${item.food_content}</span>
										            </div>
										            <div class="pb-3">
										                <span style="color:#b5aec4;">\${item.food_category}</span><br>
										                <span>\${item.food_address}</span>
										            </div>
										        </div>
										    </div>`;
						}
						
						// 맛집 랜덤 추천
						else if(item.status == 1){
							v_html_side += `<div class="border rounded p-3 mb-3">
											    <div class="recommend-img">
										            <img class="imgMain img-fluid" src="<%= ctxPath %>/resources/images/foodimg/\${item.food_main_img}" onclick="goDetailRecommend(\${item.random_recommend_code})" style="cursor: pointer;" alt="..." />
										        </div>
										        <div class="mt-2">
										        	<span>\${item.food_name}</span><br>
										        	<span style="color: #808080;">\${item.food_content}</span>
										        </div>
									      	</div>`
						}
						
					});// end of json.forEach------------------------
					
					// console.log("json[0].sizePerPage" , json[0].sizePerPage);
		        	// console.log("json[0].totalCount" , json[0].totalCount);
		        	// console.log("json[0].currentShowPageNo" , Number(json[0].currentShowPageNo));
		        	
		        	const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
			        PageBar(Number(currentShowPageNo), totalPage);
				}
				
			 	else {
					v_html = "<span>관련 데이터가 없습니다.</span>";
				}	 
					
				$("div#storeList").html(v_html_main);
				$("div#side").html(v_html_side);
			},
			error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});// end of $.ajax------------
		
	}// end of function goAjax()----------------------
	
	
	// ▒▒▒▒▒▒▒▒▒ 페이징 처리 시작 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ //
	// == 페이지바 함수 == //
	function PageBar(currentShowPageNo,totalPage){
	   
	    const blockSize = 10;
		let loop = 1;
		let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		let pageBar_HTML = "<ul style='list-style:none; margin: 5% 0 10% 0;'>";
		
		// [맨처음] [이전] 만들기
		if(pageNo != 1) {
			pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goAjax(1)'>[맨처음]</a></li>";
			pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goAjax("+(pageNo-1)+")'>[이전]</a></li>";
		}
		
		while(!(loop>blockSize || pageNo > totalPage)) {
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
			}
			else {
				pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:goAjax("+pageNo+")'>"+pageNo+"</a></li>";
			}
			loop++;
			pageNo++;
		}//end of while
		
		// [다음] [마지막] 만들기
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:goAjax("+(pageNo+1)+")'>[다음]</a></li>";
			pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:goAjax("+totalPage+")'>[마지막]</a></li>";
		}
		
		pageBar_HTML += "</ul>";
		
		// 페이지바 출력
		$("div#pageBar").html(pageBar_HTML);
	}

	// 페이지바 클릭 시 맨 위로 이동
	function goTop() {
	    $(window).scrollTop(230);
	}
	// ▒▒▒▒▒▒▒▒▒ 페이징 처리 끝 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ //

	
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	// Function Declaration //
	
	// == 검색하기 == //
	function goSearch() {
		const searchWord = $("input[name='searchbox']").val();
		// console.log("검색어 확인 : " + searchWord);
		
		const frm = document.dataFrm;
		frm.searchWord.value = searchWord;
		
		goAjax();
	}// end of function goSearch()--------------------
	

	////////////////////////////////////////////////////////////////////////////////
	
	// == 카테고리 전체 체크 == //
	function selectAllcategory(selectAllcategory) {
		const checkboxes = document.getElementsByName("food_category");
		 
		checkboxes.forEach((checkbox) => {
			checkbox.checked = selectAllcategory.checked;
		})
	}
	
	// == 카테고리 한개라도 체크 해제 시 전체 체크 해제 == //
	function selectCategory() {
		const checkboxes = document.querySelectorAll("input[name='food_category']"); // 모든 체크박스
		const checked = document.querySelectorAll("input[name='food_category']:checked"); // 선택된 체크박스
		const selectAllcategory = document.querySelector('input[name="food_category_all"]'); // '전체' 체크박스
		
		if(checkboxes.length === checked.length)  {
			selectAllcategory.checked = true;
		}
		else {
			selectAllcategory.checked = false;
		}
	}// end of function selectCategory()---------------------
	
	
	// == 지역 전체 체크 == //
	function selectAllarea(allArea) {
		const checkboxes = document.getElementsByName("area");
		 
		checkboxes.forEach((checkbox) => {
			checkbox.checked = allArea.checked;
		});
	}
	
	// == 지역 한개라도 체크 해제 시 전체 체크 해제 == //
	function selectArea() {
		const checkboxes = document.querySelectorAll("input[name='area']"); // 모든 체크박스
		const checked = document.querySelectorAll("input[name='area']:checked"); // 선택된 체크박스
		const selectAllarea = document.querySelector('input[name="allArea"]'); // '전체' 체크박스
		
		if(checkboxes.length === checked.length)  {
			selectAllarea.checked = true;
		}
		else {
			selectAllarea.checked = false;
		}
	}// end of function selectArea()---------------------
	
	//////////////////////////////////////////////////////////////////////////////
	
	// == 맛집 상세 페이지로 이동 == //
	function goDetail(food_store_code) {
		const frm = document.goDetailFrm;
		// console.log("확인용 food_store_code => "+ food_store_code);
		
		frm.food_store_code.value = food_store_code;
		frm.random_recommend_code.value = "";
		
		frm.action = "foodstoreDetail.trip"
		frm.submit();
	}// end of function goDetail(food_store_code)-----------------------
	
	
	// == 맛집 추천 상세 페이지로 이동 == //
	function goDetailRecommend(random_recommend_code) {
		const frm = document.goDetailFrm;
		// console.log("확인용 random_recommend_code => "+ random_recommend_code);
		
		frm.random_recommend_code.value = random_recommend_code;
		frm.food_store_code.value = "";
		
		frm.action = "foodstoreDetail.trip"
		frm.submit();
	}// end of function goDetailRecommend(random_recommend_code)------------------
	
</script>


    <div class="container">
	        
        <!-- 맛집 검색 카테고리 -->
    	<div class="row py-3 mt-5 border rounded">
            <div class="row mt-2" style="width: 70%; margin-left: 4%;">
    			<h5 class="mr-5">카테고리 검색</h5>
    			<div class="mr-4">
                    <input type="checkbox" class="mr-1" id="selectAllcategory" name="food_category_all" value="전체" onclick="selectAllcategory(this)"/>
                    <label for="selectAllcategory">전체</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" class="mr-1" id="korean" name="food_category" value="한식" onclick="selectCategory()"/>
                    <label for="korean">한식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" class="mr-1" id="japanese" name="food_category" value="일식" onclick="selectCategory()"/>
                    <label for="japanese">일식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" class="mr-1" id="western" name="food_category" value="양식" onclick="selectCategory()"/>
                    <label for="western">양식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" class="mr-1" id="chinese" name="food_category" value="중식" onclick="selectCategory()"/>
                    <label for="chinese">중식</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" class="mr-1" id="etc" name="food_category" value="기타" onclick="selectCategory()"/>
                    <label for="etc">기타</label>
                </div>
                <div class="mr-4">
                    <input type="checkbox" class="mr-1" id="cafe" name="food_category" value="카페" onclick="selectCategory()"/>
                    <label for="cafe">카페</label>
                </div>
     		</div>
    	</div>
   	
           
        <!-- 검색 지역 선택 -->
        <div class="row py-3 mt-1 border rounded">
          	<div id="tabArea" class="tabArea1 text-center mt-2" style="display: flex; width: 100%;">
	            <h5 class="select-area mt-4">지역 선택</h5>
	            <div class="areamapList">
	                
	                <div class="areamap" style="width: 20%;">
                    	<img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_total.png" /><br>
                        <input type="checkbox" id="area01" name="allArea" class="area_map mr-1" value="전체" onclick="selectAllarea(this)">
                        <label for="area01" class="label_chk mt-2">전체</label>
	                </div>
	                <div class="areamap" style="width:20%;">
                    	<img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_city.png" /><br>
                        <input type="checkbox" id="area02" name="area" class="area_map mr-1" value="제주 시내" onclick="selectArea()">
                        <label for="area02" class="label_chk mt-2">제주 시내</label>
	                </div>
	                <div class="areamap" style="width: 20%;">
                    	<img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_jeju_east.png" /><br>
                        <input type="checkbox" id="area03" name="area" class="area_map mr-1" value="제주시 동부" onclick="selectArea()">
                        <label for="area03" class="label_chk mt-2">제주시 동부</label>
	                </div>
	                <div class="areamap" style="width: 20%;">
	                    <img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_jeju_west.png" /><br>
                        <input type="checkbox" id="area04" name="area" class="area_map mr-1" value="제주시 서부" onclick="selectArea()">
                        <label for="area04" class="label_chk mt-2">제주시 서부</label>
	                </div>
	                <div class="areamap" style="width: 20%;">
	                    <img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_bt_city.png" /><br>
                        <input type="checkbox" id="area05" name="area" class="area_map mr-1" value="서귀포 시내" onclick="selectArea()">
                        <label for="area05" class="label_chk mt-2">서귀포 시내</label>
	                </div>
	                <div class="areamap" style="width: 20%;">
	                    <img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_bt_east.png" /><br>
                        <input type="checkbox" id="area06" name="area" class="area_map mr-1" value="서귀포시 동부" onclick="selectArea()">
                        <label for="area06" class="label_chk mt-2">서귀포시 동부</label>
	                </div>
	                <div class="areamap" style="width: 20%;">
	                    <img class="img_area mb-2" src="<%= ctxPath %>/resources/images/areamap_bt_west.png" /><br>
                        <input type="checkbox" id="area07" name="area" class="area_map mr-1" value="서귀포시 서부" onclick="selectArea()">
                        <label for="area07" class="label_chk mt-2">서귀포시 서부</label>
	                </div>
	                
	            </div>
	        </div>
        </div>	
        
        <!-- 정렬 조건 선택 -->
      	<div class="row mt-5">
	       <div class="sort-filter main" style="display: flex; justify-content: space-between; width: 100%">
	            <div style="width: 50%;">
					<button type="button" id="btnAll" class="mr-4">전체보기</button>
					<button type="button" id="btnLike" class="sort">인기순</button>
					<button type="button" id="btnAsc" class="sort">오름차순</button>
					<button type="button" id="btnDesc" class="sort">내림차순</button>
	            </div>
	            <div style="">
	                <input type="text" name="searchbox" id="searchWord" class="" placeholder="맛집 이름으로 검색">
	                <button type="button" id="btnSearch" title="검색" onclick="goSearch()">검색</button>
	            </div>
            </div>
        </div>
        
        <!---------------------------------------------------------------------------------------------->
        
        <!-- 리스트 시작 -->
		<form name="foodstoreFrm">
			<div class="row mt-3">
			
				<!-- 맛집 리스트 -->
				<div class="col-md-8" id="foodstoreList"> 
					<div class="row" id="storeList">
					</div>
				</div>
				
				<!-- 맛집 랜덤 추천 -->
				<div class="foodRecommendList col-md-4">
					<div class="border rounded" style="margin-right: -5%;">
						<div class="m-4"> 
							<h4 class="mb-4">추천맛집</h4>
							<div id="side">
							</div>
						</div>
					</div>
				</div>
				
        	</div>
		</form>
        <!---------------------------------------------------------------------------------------------->
      
      	<!-- 페이지바 -->
		<div id="pageBar" style="margin: auto; text-align: center;">
		</div>
        
	</div> 


	<form name="dataFrm">
		<!-- 카테고리, 지역 체크박스 -->
		<input type="hidden" name="str_category" />
		<input type="hidden" name="str_area" />
		<!-- 오름차순, 내림차순 정렬 -->
		<input type="hidden" name="orderType" />
		<input type="hidden" name="orderValue_asc" />
		<input type="hidden" name="orderValue_desc" />
		<!-- 검색어 -->
		<input type="hidden" name="searchWord" />
		<!-- 페이징처리 -->
		<input type="hidden" name="currentShowPageNo"/>
	</form>
	
	<form name="goDetailFrm">
		<!-- 맛집 리스트에서 상세 페이지로 이동 -->
		<input type="hidden" name="food_store_code" />
		<!-- 맛집 랜덤 추천에서 상세 페이지로 이동 -->
		<input type="hidden" name="random_recommend_code" />
	</form>


