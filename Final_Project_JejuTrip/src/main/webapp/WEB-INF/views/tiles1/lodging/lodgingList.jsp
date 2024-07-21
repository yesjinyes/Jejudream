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



</style>

<script type="text/javascript">

let currentShowPageNo = 1;
let currentSort = "";

$(document).ready(function(){
	
	const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const day = String(today.getDate()).padStart(2, '0');
    
    
    setDatePickers();
 // **** 동기적으로 실행하기 위해서 document.ready 안에다가 함수선언했음  ******    

    // === 전체 datepicker 옵션 일괄 설정하기 ===  
    //     한번의 설정으로 $("input#fromDate"), $('input#toDate')의 옵션을 모두 설정할 수 있다.
    function setDatePickers() {
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
	    
	} // end of function setDatePickers() {}
 	    
    
    
    let fromDate = $("input:text[id='fromDate']").val();
    let toDate = $("input#toDate").val();
    
 // setTimeout을 사용하여 datepicker 설정 후 값을 가져오도록 함
    setTimeout(function() {
    	fromDate = $("input:text[id='fromDate']").val();
    	toDate = $("input#toDate").val();
        
    	const frm = document.filterForm;
    	
    	frm.check_in.value = fromDate;
    	frm.check_out.value = toDate;
    	
    	fetchFilteredData(currentShowPageNo, currentSort);
    	
        // alert('fromDate > ' + fromDate);
        // alert('toDate > ' + toDate);
    }, 100); // 100ms 딜레이를 주어 datepicker 설정이 완료되도록 함
    

    
    $("input:text[name='datepicker']").keyup( (e)=>{
        // input태그가 text 타입인데 키보드로 문자를 입력하려고할때 막아야한다 마우스클릭으로만 가능하게끔
            e.preventDefault(); // 입력막기
        	alert("마우스 클릭으로만 날짜를 입력하세요!"); // 에러메시지 표현
            
            $("input#fromDate").val(fromDate);
            $("input#toDate").val(toDate);

    }); // end of $('input#datepicker').keyup( (e)=>{})
    
    
    $("input:text[name='datepicker']").change( (e)=>{
    	
    	const id = $(e.target).attr('id');
    	// alert(id);
    	
    	let d1 = $("input#fromDate").val();
    	let d2 = $("input#toDate").val();
    	
    	const frm = document.filterForm;
    	
    	if (d1 >= d2) {
    	    
    		let date1 = new Date(d1);
            
    		date1.setDate(date1.getDate() + 1); // d1의 다음 날로 설정
            
    		d2 = date1.toISOString().split('T')[0]; // 'yyyy-mm-dd' 형식으로 변환

            $("input#toDate").val(d2);
    		
            frm.check_in.value = $("input#fromDate").val();
            frm.check_out.value = $("input#toDate").val();
        }
    	else {
        	
        	if (id === "fromDate") {
        	      
                frm.check_in.value = d1;
                
            } else if (id === "toDate") {
            
                frm.check_out.value = d2;
                
            }
        	
        }
    	
    	fetchFilteredData(currentShowPageNo, currentSort);
    	
    }); // end of  $("input:text[name='datepicker']").change( (e)=>{})
    
   
	// 정렬 버튼
	const sortButton = $("button.sort");
	
	sortButton.click(function(e){
		
		// console.log($(e.target).val());
		currentSort = $(e.target).val();
		
		const currentShowPageNo = $("input:hidden[name='currentShowPageNo']").val();
		
		fetchFilteredData(currentShowPageNo, currentSort);
		
	});
	
	
	
    
    
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
    	
    	// console.log(str_category);
    	
    	const frm = document.filterForm;
		
		frm.str_category.value = str_category;
    	
		fetchFilteredData(currentShowPageNo, frm.sort.value);
        
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
    	
    	// console.log(str_convenient);
    	
    	const frm = document.filterForm;
		
		frm.str_convenient.value = str_convenient;
    	
        fetchFilteredData(currentShowPageNo, frm.sort.value);
        
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
    	
    	// console.log(str_local);
    	
    	const frm = document.filterForm;
		
		frm.str_local.value = str_local;
    	
		fetchFilteredData(currentShowPageNo, frm.sort.value);
        
    }); // end of $("input:checkbox[name='lodging_category']").on('change', function() {})
    
    
    
    
    // 인원수 잘못된 키보드 입력시 
    $("input#people").bind("keydown", function(e){
    
    	const num = $(e.target).val();
    	
    	if(num < 1){
    		
    		alert('인원을 올바르게 입력하세요!');
    		
    		$("input#people").val("2");
    		
    		return false;
    		
    	} // end of if 
    	
    }); // end of $("input#people").bind("keydown", function(e){}) 
    
    
 	// 인원수 변경시 데이터 가져오기
 	$("input#people").change(function(){
 		
 		let people = $("input#people").val();
 		
 		if(people >= 1){
 			
 			const frm = document.filterForm;
 			
 			frm.people.value = people;
 	    	
 			fetchFilteredData(currentShowPageNo, frm.sort.value);
 			
 		} // end of if
 		
 	}); // end of $("input#people").change(function(){
    
    
 		
    
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

	
	// ajax로 실시간 반영되는 숙소리스트 함수
	function fetchFilteredData(currentShowPageNo, sort) {
		
	
		$("input:hidden[name='currentShowPageNo']").val(currentShowPageNo);
		
		$("input:hidden[name='sort']").val(sort); 
	
	    // FormData 객체 생성
	    const formData = $("form[name='filterForm']").serialize();
	    
	    // AJAX 요청 보내기
	    $.ajax({
	        url: 'updateLodgingList.trip',
	        type: 'get',
	        data: formData,
	        success: function(json) {
	        	
	        	let v_html = ``;
	        	
	        	const jsonData = JSON.parse(json);
	        	
	        	if(jsonData.length > 0){
	        	
		        	$.each(jsonData, function(index, item){
		        		
		        		v_html += `<div class="fadeInUp single-post" data-wow-delay="0.1s" style="display: flex; width: 100%;">
									  <div style="width: 30%;">
		                    			 <a href="javascript:goDetail('\${item.lodging_code}')">
		                        		 	<img src="<%=ctxPath%>/resources/images/lodginglist/\${item.main_img}" style="width: 100%; height: auto;">
		                    			 </a>
		                			  </div>
		                			  <div style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding-left: 20px;">
										 <h3 class="pt-3 title"><a href="javascript:goDetail('\${item.lodging_code}')">\${item.lodging_name}</a></h3>
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
		        	
		        	// console.log("totalPage ==> ", totalPage);
		        	// console.log("totalPage type==> ", typeof totalPage);
		        	
		        	makePageBar(currentShowPageNo, totalPage, sort);
		        	
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
	
	
	
	// 페이지바 호출하는 함수
	function makePageBar(currentPageNo, totalPage, sort){
		
	    const blockSize = 5;
	    let loop = 1;
	    let pageNo = Math.floor((currentPageNo - 1)/blockSize) * blockSize + 1;
	    let pageBar_HTML = "<ul style='list-style:none;'>";
	
	    if(pageNo != 1) {
	        pageBar_HTML += `<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:fetchFilteredData(1, "\${sort}")'>[맨처음]</a></li>`;
	        pageBar_HTML += `<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:fetchFilteredData(\${pageNo-1}, "\${sort}")'>[이전]</a></li>`;
	    }
	
	    while( !(loop > blockSize || pageNo > totalPage) ) {			 
	        if(pageNo == currentPageNo) {
	            pageBar_HTML += `<li style='display:inline-block; width:30px; font-size:12pt; font-weight:bold; padding:2px 4px;'>\${pageNo}</li>`;
	        } else {
	            pageBar_HTML += `<li style='display:inline-block; width:30px; font-size:12pt;'><a href='javascript:fetchFilteredData(\${pageNo}, "\${sort}")'>\${pageNo}</a></li>`;
	        }
	        loop++;
	        pageNo++;
	    }
	
	    if(pageNo <= totalPage) {
	        pageBar_HTML += `<li style='display:inline-block; width:50px; font-size:12pt;'><a href='javascript:fetchFilteredData(\${pageNo+1}, "\${sort}")'>[다음]</a></li>`;
	        pageBar_HTML += `<li style='display:inline-block; width:70px; font-size:12pt;'><a href='javascript:fetchFilteredData(\${totalPage}, "\${sort}")'>[마지막]</a></li>`;
	    }
	    pageBar_HTML += "</ul>";
	
	    $("div#pageBar").html(pageBar_HTML);
	    
	} // end of function makePageBar(currentPageNo, totalPage)
	
	
	// 검색어를 받아주는 (엔터와 검색버튼) 함수
	function goSearch(){
		
		const searchWord = $("input:text[name='inputWord']").val();
		
		const frm = document.filterForm;
		
		frm.searchWord.value = searchWord;
    	
        fetchFilteredData(1,currentSort);
		
	} // end of function goSearch()
	
	
	// 상세페이지로 보내주는 함수
	function goDetail(lodging_code){
		
		
		const checkIn = $("input:text[id='fromDate']").val();
		const checkOut = $("input:text[id='toDate']").val();
		let people = $("input#people").val();
		
		if(people == ""){
			people = 2;	
		}
		
		// alert(checkIn);
		// alert(checkOut);
		
		const frm = document.goDetail;
	
		frm.lodging_code.value = lodging_code;
		frm.detail_check_in.value = checkIn;
		frm.detail_check_out.value = checkOut;
		frm.detail_people.value = people;
		
		frm.method = "get";
		frm.action = "<%= ctxPath%>/lodgingDetail.trip";
		
		frm.submit();
		
	} // end of function goDetail(lodging_code) 
	
	
	
</script>


    <div class="container">
       
    
        <div class="row">
         	
            <div class="col-md-3">
           	 
            	<div class="tab_check" style="display: flex;">
			    	<div class="date_wrap mt-3">
			    		
			    		<h3>숙소 체크인 일정</h3>
				        <div class="fromDate">
				            <label>체크인</label>
				            <div>
				                <div class="date-container">
				                    <span class="date-pick">
				                        <input class="datepicker" style="cursor: pointer;" type="text" id="fromDate" name="datepicker" value="${requestScope.dateSendMap.detail_check_in}" placeholder="입실일 선택">
				                    </span>
				                </div>
				            </div>
				        </div>
				        <div class="toDate">
				            <label>체크아웃</label>
				            <div>
				                <div class="date-container">
				                    <span class="date-pick">
				                        <input class="datepicker" style="cursor: pointer;" type="text" id="toDate" name="datepicker" value="${requestScope.dateSendMap.detail_check_out}" placeholder="퇴실일 선택">
				                    </span>
				                </div>
				            </div>
				        </div>
				        <div class="people">
				            <label>인원</label>
				            <div>
				                <div class="people-container">
				                    <span class="people-pick">
				                        <input type="number" min="2" max="10" id="people" style="cursor: pointer; width:100px;" name="people" value="${requestScope.dateSendMap.detail_people}" placeholder="인원 선택">
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
                        
                        <c:forEach var="convenientList" items="${requestScope.convenientList}" varStatus="status">
                        <div>
                        	<input type="checkbox" name="convenient" id="convenient${status.count}" value="${convenientList.convenient_name}" />
                        	<label for="convenient${status.count}">${convenientList}</label>
                        </div>
                        </c:forEach>
                        
                    </li>
                    
                    <%-- 
                    <li class="nav-item">
                    	<h4>숙소 가격범위</h4>
                    	<div class="slider">
					        <input type="range" id="input-left" min="1" max="100" value="1" />
					        <input type="range" id="input-right" min="1" max="100" value="100" />
					        <div class="track">
					          <div class="range"></div>
					          <div class="thumb left"></div>
					          <div class="thumb right"></div>
					        </div>
					    </div>
                    </li>
                    --%>
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
                        <button type="button" class="sort btn btn-outline-warning" value="">최신등록순</button>
                        <button type="button" class="sort btn btn-outline-warning" value="price_asc">낮은가격순</button>
                        <button type="button" class="sort btn btn-outline-warning" value="price_desc">높은가격순</button>
                    </div>
                    <div>
                        <input type="text" name="inputWord"  placeholder="검색 결과 내 숙소명 검색">
                        <button type="button" id="search" title="검색">검색</button>
                    </div>
                </div>
                
                <div class="mt-3" id="result_list">
                  	<!-- ajax 뿌릴곳 -->
                </div>
                    
                <div id="pageBar" style="text-align: center;">
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
          	<input type="hidden" name="people" />
          	<input type="hidden" name="check_in" />
          	<input type="hidden" name="check_out" />
          	<input type="hidden" name="sort" />
          </form>
          
          
          <form name="goDetail">
          	<input type="hidden" name="lodging_code" />
          	<input type="hidden" name="detail_check_in" />
          	<input type="hidden" name="detail_check_out" />
          	<input type="hidden" name="detail_people" />
          </form>
          
 
</body>
</html>
