<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<style type="text/css">
body {
    font-family: 'Poppins', sans-serif;
}

li {

list-style: none;
}


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
    color: #ffdccc;
    text-decoration: none;
}

.slider-container {
    width: 80%;
 
    text-align: center;
}

.slider {
    width: 100%;

}

.price-display {
    font-size: 20px;

}

</style>

<script type="text/javascript">

let currentShowPageNo = 1;

$(document).ready(function(){
	
	const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const day = String(today.getDate()).padStart(2, '0');
    
    fetchFilteredData(currentShowPageNo);
    
    
    $('input#datepicker').keyup( (e)=>{
        // 생년월일 input태그가 text 타입인데 키보드로 문자를 입력하려고할때 막아야한다 마우스클릭으로만 가능하게끔
            $(e.target).val("").next().show(); // 에러메시지 표현

    }); // end of $('input#datepicker').keyup( (e)=>{})

       
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // **** 아래거는 jsp파일에 주석처리된 투숙날짜달력에 적용되는 태그로서 시작일자 종료일자를 세팅해주게끔 해주는 것이다!!! 유용할듯 ******    

    // === 전체 datepicker 옵션 일괄 설정하기 ===  
    //     한번의 설정으로 $("input#fromDate"), $('input#toDate')의 옵션을 모두 설정할 수 있다.
    $(function() {
	    //모든 datepicker에 대한 공통 옵션 설정
	    $.datepicker.setDefaults({
	         dateFormat: 'yy-mm-dd' //Input Display Format 변경
	        ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
	        ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
	        ,changeYear: true //콤보박스에서 년 선택 가능
	        ,changeMonth: true //콤보박스에서 월 선택 가능                
	     // ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
	     // ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
	     // ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
	     // ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
	        ,yearSuffix: "년" //달력의 년도 부분 뒤에 붙는 텍스트
	        ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
	        ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
	        ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
	        ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
	      ,minDate: "0D" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
	      ,maxDate: "+1Y" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)                    
	    });
	 
	    // input을 datepicker로 선언
	    $("input#fromDate").datepicker();                    
	    $("input#toDate").datepicker();
	        
	        
	    // From의 초기값을 오늘 날짜로 설정
	    $('input#fromDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
	    
	    // To의 초기값을 1일후로 설정
	    $('input#toDate').datepicker('setDate', '+1D'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
	    
	    $('input#toDate').datepicker('option', 'minDate', '+1D');
    });
   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    $('input#datepicker').bind("change", (e)=> {
    // 생년월일에 입력되어진값이 변경되었다면 에러메시지를 지워야한다

        if($(e.target).val() != "" ){
        // 정상적이지않으면 자동으로 값이 ""로 된다! 그렇기때문에 올바른값을 검사하는 기준이 된다
            $(e.target).next().hide();
            
        }// 생년월일에 마우스로 달력에 있는 날짜를 선택한 경우 이벤트 처리 한것 


    }); // end of $('input#datepicker').bind("change", (e)=> {})
    
    
    
	
	
	
	
    
    
 	// 숙소구분 체크박스
    const categoryAllCheckbox = $('input#all_lod');
    const categoryCheckboxes = $('input[name="lodging_category"]').not('#all_lod');

    // 전체 체크박스를 체크하면 나머지 체크박스를 해제
    categoryAllCheckbox.change(function () {
        if (categoryAllCheckbox.is(':checked')) {
        	
        	$("input:hidden[name='str_category']").val(""); 
            categoryCheckboxes.prop('checked', false);
            
        }
    }); // end of categoryAllCheckbox.change(function () {})

    
    // 나머지 체크박스를 체크하면 전체 체크박스의 상태를 업데이트
    categoryCheckboxes.change(function () {
    	
        const allChecked = categoryCheckboxes.length === categoryCheckboxes.filter(':checked').length;
        
        categoryAllCheckbox.prop('checked', allChecked);
        
        if(allChecked) {
        	categoryCheckboxes.prop('checked', false);
        }
    });

    // 편의시설 체크박스
    const conAllCheckbox = $('#all_con');
    const conCheckboxes = $('input[name="convenient"]').not('#all_con');

    // 전체 체크박스를 체크하면 나머지 체크박스를 해제
    conAllCheckbox.change(function () {
        if (conAllCheckbox.is(':checked')) {
        	$("input:hidden[name='str_convenient']").val("");
            conCheckboxes.prop('checked', false);
        }
    });

    // 나머지 체크박스를 체크하면 전체 체크박스의 상태를 업데이트
    conCheckboxes.change(function () {
        const allChecked = conCheckboxes.length === conCheckboxes.filter(':checked').length;
        conAllCheckbox.prop('checked', allChecked);
        if (allChecked) {
            conCheckboxes.prop('checked', false);
        }
    });
    
 	// 지역구분 체크박스
    const localAllCheckbox = $('input#all_local');
    const localCheckboxes = $('input[name="local_status"]').not('#all_local');

    
    // 전체 체크박스를 체크하면 나머지 체크박스를 해제
    localAllCheckbox.change(function () {
        if (localAllCheckbox.is(':checked')) {
        	$("input:hidden[name='str_local']").val("");
        	localCheckboxes.prop('checked', false);
        }
    });

    // 나머지 체크박스를 체크하면 전체 체크박스의 상태를 업데이트
    localCheckboxes.change(function () {
        const allChecked = localCheckboxes.length === localCheckboxes.filter(':checked').length;
        localAllCheckbox.prop('checked', allChecked);
        if (allChecked) {
        	localCheckboxes.prop('checked', false);
        }
    });
    
    
 // 숙소 구분 체크박스 change 이벤트 리스너 
    $("input:checkbox[name='lodging_category']").on('change', function() {
    	
    	// 숙소카테고리 requestParam 처리
    	const arr_category = [];
		
		$("input:checkbox[name='lodging_category']:checked").each(function(index, item){
			// 체크된것만 배열에 반복문으로 input 밸류를 담는다
			arr_category.push($(item).val());
			
		}); // end of $("input:checkbox[name='deptId']:checked").each(function(index, item){}) 
		
		const str_category = arr_category.join();
    	
    	console.log(str_category);
    	
    	const frm = document.filterForm;
		
		frm.str_category.value = str_category;
    	
        fetchFilteredData(1);
        
    }); // end of $("input:checkbox[name='lodging_category']").on('change', function() {})
    
    
    
    
 	// 편의시설 구분 체크박스 change 이벤트 리스너 
    $("input:checkbox[name='convenient']").on('change', function() {
    	
    	// 숙소카테고리 requestParam 처리
    	const arr_convenient = [];
		
		$("input:checkbox[name='convenient']:checked").each(function(index, item){
			// 체크된것만 배열에 반복문으로 input 밸류를 담는다
			arr_convenient.push($(item).val());
			
		}); // end of $("input:checkbox[name='deptId']:checked").each(function(index, item){}) 
		
		const str_convenient = arr_convenient.join();
    	
    	console.log(str_convenient);
    	
    	const frm = document.filterForm;
		
		frm.str_convenient.value = str_convenient;
    	
        fetchFilteredData(1);
        
    }); // end of $("input:checkbox[name='lodging_category']").on('change', function() {})
    
    
    
    
 	// 지역 구분 체크박스 change 이벤트 리스너 
    $("input:checkbox[name='local_status']").on('change', function() {
    	
    	// 숙소카테고리 requestParam 처리
    	const arr_local = [];
		
		$("input:checkbox[name='local_status']:checked").each(function(index, item){
			// 체크된것만 배열에 반복문으로 input 밸류를 담는다
			arr_local.push($(item).val());
			
		}); // end of $("input:checkbox[name='deptId']:checked").each(function(index, item){}) 
		
		const str_local = arr_local.join();
    	
    	console.log(str_local);
    	
    	const frm = document.filterForm;
		
		frm.str_local.value = str_local;
    	
        fetchFilteredData(1);
        
    }); // end of $("input:checkbox[name='lodging_category']").on('change', function() {})
    
    
    
    
    
    // 검색 버튼 클릭 시 데이터 가져오기 시작
    $("input:text[name='inputWord']").bind("keydown", function(e){
			
		if(e.keyCode == 13){
			
			goSearch();
		}
		
	}); 
    $("button[id='search']").on('click', function() {
    	
    	goSearch();
        
    });
 	// 검색 버튼 클릭 시 데이터 가져오기 끝 
    
	
}); // end of $(document).ready(function(){})

	function fetchFilteredData(currentShowPageNo) {
	
		$("input:hidden[name='currentShowPageNo']").val(currentShowPageNo);
	
	
	    // FormData 객체 생성
	    const formData = $("form[name='filterForm']").serialize();
	    
	    
	    // AJAX 요청 보내기
	    $.ajax({
	        url: 'updateLodgingList.trip',
	        type: 'get',
	        data: formData,
	        success: function(json) {
	        	
	        	let v_html = ``;
	        	
	        	if(json.length > 0){
	        	
		        	const jsonData = JSON.parse(json);
		            
		        	$.each(jsonData, function(index, item){
		        		
		        		v_html += `<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
									  <div style="width: 30%;">
		                    			 <a href="#">
		                        		 	<img src="<%=ctxPath%>/resources/images/lodginglist/\${item.main_img}" style="width: 100%; height: auto;">
		                    			 </a>
		                			  </div>
		                			  <div style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
										 <h3 class="pt-3 title"><a href="#">\${item.lodging_name}</a></h3>
										 <div class="pb-3">
		                        			<span style="color:#b5aec4;">\${item.lodging_category}</span><br>
		                        			<span>\${item.local_status}</span><br>
		                        			<span>\${item.lodging_address}</span>
		                    			 </div>
		                			  </div>
		                			  <div style="border-left: solid 2px #ffdccc; height:75%; align-self:center; margin-right: 1%;"></div>
									  <div class="px-3" style="align-self: flex-end;">
										  <span style="color:#b5aec4;">1박 기준</span>
		                    			  <h4 class="pb-2" style="color: #ffdccc;">\${Number(item.price).toLocaleString('en')}원</h4>
									  </div>
		            			   </div>`;
		        		
		        	}); // end of $.each
		        	
		        	console.log("json[0].sizePerPage" , jsonData[0].sizePerPage);
		        	console.log("json[0].totalCount" , jsonData[0].totalCount);
		        	console.log("json[0].currentShowPageNo" , jsonData[0].currentShowPageNo);
		        	
					if( Number(currentShowPageNo) != 1){
		        		
		        		currentShowPageNo =  Number(jsonData[0].currentShowPageNo);
		        		
		        	}
		        	
		        	
		        	
		        	const totalPage = Math.ceil( Number(jsonData[0].totalCount) / Number(jsonData[0].sizePerPage));
		        	
		        	console.log("totalPage ==> ", totalPage);
		        	console.log("totalPage type==> ", typeof totalPage);
		        	
		        	makePageBar(currentShowPageNo, totalPage);
		        	
	        	}else{
	        		
	        		v_html += "<span>해당하는 숙소가 없습니다</span>";
	        		
	        	}
		        	
		        	
	        	$('div#result_list').html(v_html);
	        	
	        	
	        	
	        },
	        error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
	        
	    }); // end of $.ajax({})
	    
	    
	}// end of function fetchFilteredData() {}
	
	
	
	
	function makePageBar(currentPageNo, totalPage){
		
		const blockSize = 10;
		let loop = 1;
		let pageNo = Math.floor((currentPageNo - 1)/blockSize) * blockSize + 1;
		let pageBar_HTML = "<ul style='list-style:none;'>";
	      
		if(pageNo != 1) {
			pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:fetchFilteredData(1)'>[맨처음]</a></li>";
			pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:fetchFilteredData("+(pageNo-1)+")'>[이전]</a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {			 
			if(pageNo == currentPageNo) {
	            pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</a></li>";
	        } else {
	            pageBar_HTML += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:fetchFilteredData("+pageNo+")'>"+pageNo+"</li>";
	        }
			loop++;
			pageNo++;
		}
		
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:fetchFilteredData("+(pageNo+1)+")'>[다음]</a></li>";
			pageBar_HTML += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:fetchFilteredData("+totalPage+")'>[마지막]</a></li>";
		}
		pageBar_HTML += "</ul>";
		
		$("div#pageBar").html(pageBar_HTML);
		
	} // end of function makePageBar(currentPageNo, totalPage)
	
	
	function goSearch(){
		
		const searchWord = $("input:text[name='inputWord']").val();
    	
		const frm = document.filterForm;
		
		frm.searchWord.value = searchWord;
    	
        fetchFilteredData(1);
		
	} // end of function goSearch()
	

</script>


    <div class="container">
       
    
        <div class="row">
         	
            <div class="col-md-3">
           	 
            	<div class="tab_check" style="display: flex;">
			    	<div class="date_wrap mt-3">
			    		
			    		<h3>숙소 체크인</h3>
				        <div class="date_checkin" >
				            <label>체크인</label>
				            <div class="value-text">
				                <div class="date-container">
				                    <span class="date-pick">
				                        <input class="datepicker" style="cursor: pointer;" type="text" id="fromDate" name="fromDate" value="" placeholder="입실일 선택">
				                    </span>
				                </div>
				            </div>
				        </div>
				        <div class="date_checkout">
				            <label>체크아웃</label>
				            <div class="value-text">
				                <div class="date-container">
				                    <span class="date-pick">
				                        <input class="datepicker" style="cursor: pointer;" type="text" id="toDate" name="toDate" value="" placeholder="퇴실일 선택">
				                    </span>
				                </div>
				            </div>
				        </div>
				        <div class="people">
				            <label>인원</label>
				            <div class="value-text">
				                <div class="people-container">
				                    <span class="people-pick">
				                        <input type="text" id="people" style="cursor: pointer;" name="people" value="" placeholder="인원 선택">
				                    </span>
				                </div>
				            </div>
				        </div>
				    </div>
			    </div>
            
                
                <ul class="nav flex-column">
                    <li class="nav-item lod">
                        <h4 class="py-3">숙소구분</h4>
                        <div>
                            <input type="checkbox" name="lodging_category" id="all_lod" value="" />
                            <label for="all_lod">전체</label>
                        </div>
                        <div>
                            <input type="checkbox" name="lodging_category" id="pension" value="펜션" />
                            <label for="pension">펜션</label>
                        </div>
                        <div>
                            <input type="checkbox" name="lodging_category" id="guesthouse" value="게스트하우스" />
                            <label for="guesthouse">게스트하우스</label>
                        </div>
                        <div>
                            <input type="checkbox" name="lodging_category" id="hotel" value="호텔" />
                            <label for="hotel">호텔</label>
                        </div>
                        <div>
                            <input type="checkbox" name="lodging_category" id="resort" value="리조트" />
                            <label for="resort">리조트</label>
                        </div>
                    </li>
                    
                    <li class="nav-item convenient">
                        <h4 class="py-3">편의시설</h4>
                        <div>
                            <input type="checkbox" name="convenient" id="all_con" value="" />
                            <label for="all_con">전체</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="pool" value="수영장" />
                            <label for="pool">수영장</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="bbq" value="바비큐" />
                            <label for="bbq">바비큐</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="free_breakfast" value="조식무료" />
                            <label for="free_breakfast">조식무료</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="breakfast" value="조식운영" />
                            <label for="breakfast">조식운영</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="pet" value="애완동물" />
                            <label for="pet">애완동물</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="store" value="매점" />
                            <label for="store">매점</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="spa" value="스파/사우나" />
                            <label for="spa">스파/사우나</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="wifi" value="WIFI" />
                            <label for="wifi">WIFI</label>
                        </div>
                        <div>
                            <input type="checkbox" name="convenient" id="ev_charge" value="전기차충전소" />
                            <label for="ev_charge">전기차충전소</label>
                        </div>
                    </li>
                    
                    <li class="nav-item">
                    	<h4>숙소 가격범위</h4>
                    	<input class="" type="range" min="0;" max="1000000;" />
                    </li>
                    
                </ul>
               	 
            </div>
            <div class="col-md-9 py-3">
            	<div class="py-3">
            		<div id="tabArea" class="tabArea1 text-center" style="display: flex; border: solid 0px black; align-items: center;">
			            <div class="tabTitle pr-3" style="align-self: center; width:15%;">
			                <span>여행하실 곳을 <br> 선택해주세요.</span>
			            </div>
			            <div class="areaMap" style="display: flex;">
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_total.png" />
			                    <div>
			                        <input name="local_status" id="all_local" type="checkbox" class="are_map" value="">
			                        <br><label for="all_local" class="label_chk">전체</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_city.png" />
			                    <div>
			                        <input name="local_status" id="area02" type="checkbox" class="are_map" value="제주시 시내">
			                        <label for="area02" class="label_chk">제주시 시내</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_east.png" />
			                    <div>
			                        <input name="local_status" id="area03" type="checkbox" class="are_map" value="제주시 동부">
			                        <label for="area03" class="label_chk">제주시 동부</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_jeju_west.png" />
			                    <div>
			                        <input name="local_status" id="area04" type="checkbox" class="are_map" value="제주시 서부">
			                        <label for="area04" class="label_chk">제주시 서부</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_city.png" />
			                    <div>
			                        <input name="local_status" id="area05" type="checkbox" class="are_map" value="서귀포시 시내">
			                        <label for="area05" class="label_chk">서귀포시 시내</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_east.png" />
			                    <div>
			                        <input name="local_status" id="area06" type="checkbox" class="are_map" value="서귀포시 동부">
			                        <label for="area06" class="label_chk">서귀포시 동부</label>
			                    </div>
			                </div>
			                <div class="areamap mx-2" style="width: 15%;">
			                    <img src="<%= ctxPath %>/resources/images/areamap_bt_west.png" />
			                    <div>
			                        <input name="local_status" id="area07" type="checkbox" class="are_map" value="서귀포시 서부">
			                        <label for="area07" class="label_chk">서귀포시 서부</label>
			                    </div>
			                </div>
			            </div>
			        </div>
            	</div>	
            	
            	
            		
                    <div class="sort-filter main" style="display: flex; justify-content:space-between; width:100%;">
                    	
                        <div> 
                                <button type="button" onclick="" class="sort active" value="">추천순</button>
                           
                                <button type="button" onclick="" class="sort" value="PRICE">낮은가격순</button>
                          
                                <button type="button" onclick="" class="sort" value="PRICE_DESC">높은가격순</button>
                             
                                <button type="button" onclick="" class="sort" value="NEW">최신등록순</button>
                             
                        </div>
                        
                        <div>
                            <input type="text" name="inputWord"  placeholder="검색 결과 내 숙소명 검색">
                            <button type="button" id="search" title="검색">검색</button>
                        </div>
                    </div>
                    
                    
                    <div id="result_list">
                    	<!-- ajax 뿌릴곳 -->
                    </div>
                    
                    <div id="pageBar">
                    </div>
           		 </div>
            </div>
            
            	
             
            	
                
		</div> 
		
		
          <form name="filterForm">
          	<input type="hidden" name="str_category" /> 
          	<input type="hidden" name="str_convenient" /> 
          	<input type="hidden" name="str_local" /> 
          	<input type="hidden" name="searchWord" />
          	<input type="hidden" name="currentShowPageNo" />
          </form>
 
</body>
</html>
