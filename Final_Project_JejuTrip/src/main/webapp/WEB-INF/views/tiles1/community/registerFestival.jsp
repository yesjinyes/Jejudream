<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>    
    

<style>
    body {
        font-family: "Noto Sans KR", sans-serif;
        font-optical-sizing: auto;
    }
    .container {
    width: 100%;
    max-width: 800px;
    margin: 5% auto;
    border: solid 1px rgba(0, 0, 0, 0.15);
    border-radius: 40px;
    box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
    overflow: hidden;
    position: relative;
	}

	.ano_in{
	
		margin-left: 15%;
	}

	
	.info {
	    width: 100%;
	}
	
	.info_block {
		
	    margin-bottom: 1em;

	}
	
	span.error {
		margin-left: 15%;
	    font-size: 11pt;
	    
	    color: red;
	}   
	
	.input_error {
	    border: solid 1px red !important;
	}
	
	button#registerBtn {
	    width: 50%;
	    
	    margin: 1% auto;
	    border-radius: 8px;
	    background-color: #ff5000;
	    color: white;
	}
	
	button {
	    margin: 5px;
	}
	
	
	.input_tag  {
	    display: block;
	    width: 50%;
	    
	    height: 50px;
	    margin-left: 15%;
	    border-radius: 8px;
	    border: solid 1px rgba(15, 19, 42, .1);
	    padding: 0 0 0 15px;
	    font-size: 16px;
	    color:gray;
	}
	

</style>


<script type="text/javascript">

let chk_link = false;

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
              
	    });
	 
	    // input을 datepicker로 선언
	    $("input#fromDate").datepicker();                    
	    $("input#toDate").datepicker();
	        
	        
	    // From의 초기값을 오늘 날짜로 설정
	    $('input#fromDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
	    
	    // To의 초기값을 1일후로 설정
	    $('input#toDate').datepicker('setDate', '+1D'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
	    
	} // end of function setDatePickers() {}
	
	
	let fromDate = $("input:text[id='fromDate']").val();
    let toDate = $("input#toDate").val();
	
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
    	
    	if (d1 >= d2) {
    	    
    		let date1 = new Date(d1);
            
    		date1.setDate(date1.getDate()); // d1의 다음 날로 설정
            
    		d2 = date1.toISOString().split('T')[0]; // 'yyyy-mm-dd' 형식으로 변환

            $("input#toDate").val(d2);

        }
    	
    	
    }); // end of  $("input:text[name='datepicker']").change( (e)=>{})
	
    
 	// ==>> 제품이미지 파일선택을 선택하면 화면에 이미지를 미리 보여주기 시작 <<== //
	$(document).on("change", "input#attach", function(e){
		
		const input_file = $(e.target).get(0);
		     
		// 자바스크립트에서 file 객체의 실제 데이터(내용물)에 접근하기 위해 FileReader 객체를 생성하여 사용한다.
        const fileReader = new FileReader();    
        
		fileReader.readAsDataURL(input_file.files[0]); 
		// FileReader.readAsDataURL() --> 파일을 읽고, result속성에 파일을 나타내는 URL을 저장 시켜준다.
		
		fileReader.onload = function(){
		// FileReader.onload --> 파일 읽기 완료 성공시에만 작동하도록 하는 것임.	
			
            // img태그 무조건쓰고 순수 자바스크립트로만 넣어야한다 미리보기는 이렇게!
            document.getElementById("previewImg").src = fileReader.result;
			
		};
    	
	}); // end of $(document).on("change", "input.img_file", function(e){} 
    
	
	$(document).on("blur", "input#festival_link", function() {
		
		const festival_link = $("input#festival_link").val().trim();
		
		const regExp_link = new RegExp("(http|https|ftp|telnet|news|irc)://([-/.a-zA-Z0-9_~#%$?&=:200-377()]+)","gi");
		const bool = regExp_link.test(festival_link);
		
		if(bool){
			
			// alert("오");
			chk_link = true;
			
		}else{
			
			$(this).next('.error').text('올바른 형식의 링크주소를 입력하세요.');
	        $(this).addClass('input_error');
			
		}
		
	}); // end of $(document).on("blur", "input#festival_link", function() {})
	
	
	
}); // end of $(document).ready(function(){})

let isCheck = true;

function goRegister(){
	
	const fromdate = $("input:text[id='fromDate']").val();
    const todate = $("input#toDate").val();
    
    isCheck = true;
    
    // 축제명 검사하기
    const title_name = $("input#title_name").val().trim();
    
    if (title_name === '') {
    	
        $("input#title_name").next('.error').text('축제 및 행사명을 입력하세요.');
        $("input#title_name").addClass('input_error');
        isCheck = false;
        
    } else {
    	
        $("input#title_name").next('.error').text('');
        $("input#title_name").removeClass('input_error');
        
    }
    
    // 지역구분 검사하기
    const local_status = $("select[name='local_status']").val();
    
	if (local_status == "지역구분") {
    	
        $("select[name='local_status']").next('.error').text('지역구분을 선택하세요.');
        $("select[name='local_status']").addClass('input_error');
        isCheck = false;
        
    }  else {
    	
        $("select[name='local_status']").next('.error').text('');
        $("select[name='local_status']").removeClass('input_error');
        
    }
    
    
    // 링크 검사하기
    const festival_link = $("input#festival_link").val().trim();
    const regExp_link = new RegExp("(http|https|ftp|telnet|news|irc)://([-/.a-zA-Z0-9_~#%$?&=:200-377()]+)", "gi");
    
    if(festival_link == ""){
    	
    	$("input#festival_link").next('.error').text('필수로 링크주소를 입력하세요.');
        $("input#festival_link").addClass('input_error');
        isCheck = false;
    	
    }else if (!regExp_link.test(festival_link)) {
    	
        $("input#festival_link").next('.error').text('올바른 형식의 링크주소를 입력하세요.');
        $("input#festival_link").addClass('input_error');
        isCheck = false;
        
    } else {
    	
        $("input#festival_link").next('.error').text('');
        $("input#festival_link").removeClass('input_error');
        
    }

    // 첨부파일 검사하기
    $('input[name="attach"]').each(function() {
        if ($(this).get(0).files.length === 0) {
        	
            $(this).next('.error').text('사진을 추가하세요.');
            $(this).addClass('input_error');
            isCheck = false;
            
        } else {
        	
            $(this).next('.error').text('');
            $(this).removeClass('input_error');
        }
        
    });

    if (!isCheck) {
    	
        alert("모든 정보를 입력하셔야 합니다.");
        
        return;
    }

	// 축제 및 행사 등록 처리하기.
    const frm = document.registerFrm;
    
    frm.send_fromdate.value = fromdate;
    frm.send_todate.value = todate;

	frm.method = "post";
	frm.action = "<%= ctxPath%>/admin_RegisterFestival.trip";
	
   	frm.submit();
    
	
	
} // end of function goRegister(){}


</script>


<div class="container">

    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">축제 및 행사 등록</h2>
       
    </div>

    <form name="registerFrm" enctype="multipart/form-data">

        <div class="info">

            <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
            <div class="info_block">
            	<h4 class="ano_in" style="margin-top: 1%; " >축제 및 행사명</h4>
                <input type="text" class="input_tag" name="title_name" id="title_name" placeholder="축제 명칭 입력">
                <span class="error"></span>
            </div>
            
            <div class="info_block mt-3">
            	<h4 style="margin-left: 15%;">지역구분</h4>
				<select style="cursor: pointer; width:20%; margin-left: 15%;" class="input_tag" name="local_status">
					<option selected>지역구분</option>
					<option>제주시 시내</option>
					<option>제주시 서부</option>
					<option>제주시 동부</option>
					<option>서귀포시 시내</option>
					<option>서귀포 동부</option>
					<option>서귀포 서부</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block ano_in mt-3">
                
                 <h4 style="margin-top: 1%;" >축제 시작날짜</h4>
                 <div class="info_block">
                     <div class="date-container">
                         <span class="date-pick">
                             <input class="datepicker input_tag" style="cursor: pointer; width:20%; margin-left: 0;" type="text" id="fromDate" name="datepicker" />
                             <input type="hidden" name="send_fromdate" />
                         </span>
                     </div>
                 </div>
             
                 <h4 style="margin-top: 1%;" >축제 종료날짜</h4>
                 <div class="info_block">
                     <div class="date-container">
                         <span class="date-pick">
                             <input class="datepicker input_tag" style="cursor: pointer; width:20%; margin-left: 0;" type="text" id="toDate" name="datepicker" />
                             <input type="hidden" name="send_todate" />
                         </span>
                     </div>
                 </div>
                        
            </div>
            <div class="info_block mt-3">
            	<h4 class="ano_in" style="margin-top: 1%;" >관광공사 상세링크</h4>
	            <input type="text" name="festival_link" class="input_tag" id="festival_link" placeholder="연결될 상세링크 입력">
	            <span class="error"></span>
	        </div>

            <div class="mt-3 ano_in">
            	<h4 style="margin-top: 1%; " >축제 및 행사 이미지</h4>
                <input type="file" name="attach" id="attach">
                <span class="error"></span>
                
                
            </div>
            <div class="mt-3 ano_in">
            	<h4 style="margin-top: 2%;" >축제 및 행사 이미지 미리보기</h4>
                <img class="img-fluid" style="width: 200px; height: 200px;" id="previewImg" />
           	</div>
        </div>

        <div class="pt-4" style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">등록하기</button>
        </div>

    </form>

</div>    
    