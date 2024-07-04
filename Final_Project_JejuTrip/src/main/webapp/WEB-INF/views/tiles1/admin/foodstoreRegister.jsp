<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<%-- Main CSS --%>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/admin/foodstoreRegister.css">

<script type="text/javascript">

let checkName = false;
let checkMobile = false;
let checkContent = false;

$(function() {
	
    $("span.error").hide();
    
    $("select").bind("change", function(e) {
    	
    	if($(e.target).val() != "") {
    		$(e.target).css({"color":"black"});
    		
    	} else {
    		$(e.target).css({"color":"gray"});
    	}
    	 
    });
    
    // 주소 클릭 시
    $('input#address').click(function () {

        new daum.Postcode({
            oncomplete: function (data) {

                let addr = '';

                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }

                document.getElementById("address").value = addr;
                document.getElementById("detail_address").focus();

            }
        }).open();

    });

    // 주소 키보드 입력 막기
    $("input#address").on("keypress", function(e) {
        e.preventDefault();
        return;
    });
    
    
    // ===== 식당명 유효성 검사 =====
    $("input#food_name").blur((e) => {
    	
    	const food_name = $(e.target).val().trim();
    	
    	if(food_name == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("식당명을 입력해주세요.");
            checkName = false;

    	} else if(food_name.length < 5 || food_name.length > 20) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("식당명은 2자 이상 20자 이내로만 입력해주세요.");
            checkName = false;
            
    	} else {
    		$(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkName = true;
    	}
    	
    });
    
    
    // ===== 음식 구분 유효성 검사 =====
    $("select[name='food_category']").bind("change", function(e) {
    	
    	if($(e.target).val() == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("음식 구분을 선택해주세요.");
            
    	} else {
    		$(e.target).removeClass("input_error");
            $(e.target).next().hide();
    	}
    	
    });
    
    
    // ===== 지역 구분 유효성 검사 =====
    $("select[name='local_status']").bind("change", function(e) {
    	
    	if($(e.target).val() == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("지역 구분을 선택해주세요.");
            
    	} else {
    		$(e.target).removeClass("input_error");
            $(e.target).next().hide();
    	}
    	
    });
    
    
    // ===== 연락처 유효성 검사 =====
    $("input#food_mobile").blur((e) => {
    	
    	const mobile = $(e.target).val().trim();

        const regExp_mobile = new RegExp(/^0[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/);
        const bool = regExp_mobile.test(mobile);
		
        if(mobile == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("연락처를 입력해주세요.");
            checkMobile = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("유효하지 않은 연락처입니다.");
            checkMobile = false;

        } else {
            $(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkMobile = true;
        }

    });
    
    
    // ===== 영업시간 유효성 검사 =====
    $("select[name='starthours']").bind("change", function() {
    	checkHours();
    });
    
    $("select[name='endhours']").bind("change", function() {
    	checkHours();
    });


    // 맛집 상세정보 css 수정, 엔터 시 등록
    $("textarea#food_content").keyup(function(e) {
    	
    	$(e.target).css({"color":"black"});
    	
        if(e.keyCode == 13) {
            goRegister();
        }
    });
    
    
    // ===== 맛집 상세정보 유효성 검사 =====
    $("textarea#food_content").blur((e) => {
    	
    	const food_content = $(e.target).val().trim();
    	
    	if(food_content == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("상세 정보를 입력해주세요.");
            checkContent = false;

    	} else if(food_content.length < 5 || food_content.length > 100) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("상세 정보는 5자 이상 입력해주세요.");
            checkContent = false;
            
    	} else {
    		$(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkContent = true;
    	}
    	
    });
    
    
	<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 시작 === --%>
	let file_arr = []; // 첨부된 파일 정보를 담아둘 배열
	
	// == 파일 Drag & Drop 만들기 == //
	$("div#fileDrop").on("dragenter", function(e) { /* "dragenter" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 최초로 들어왔을 때 */
		
		e.preventDefault();
		<%-- 
			브라우저에 어떤 파일을 drop 하면 브라우저 기본 동작이 실행된다. 
			이미지를 drop 하면 바로 이미지가 보여지고, 만약에 pdf 파일을 drop 하게 될 경우도 각 브라우저의 pdf viewer 로 브라우저 내에서 pdf 문서를 열어 보여준다. 
			이것을 방지하기 위해 preventDefault() 를 호출한다. 
			즉, e.preventDefault(); 는 해당 이벤트 이외에 별도로 브라우저에서 발생하는 행동을 막기 위해 사용하는 것이다.
		--%>
		
		e.stopPropagation();
		<%-- 이벤트 버블링을 막기 위해서 사용 --%>
		
	}).on("dragover", function(e) { /* "dragover" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 머물러 있는 중일 때. 필수이벤트이다. dragover 이벤트를 적용하지 않으면 drop 이벤트가 작동하지 않음 */ 
        e.preventDefault();
        e.stopPropagation();
        $(this).css("background-color", "#ffdccc");
        
    }).on("dragleave", function(e) { /* "dragleave" 이벤트는 Drag 한 파일이 드롭대상인 박스 밖으로 벗어났을 때 (마우스로 파일을 잡고 있는 상태)  */
        e.preventDefault();
        e.stopPropagation();
        $(this).css("background-color", "#fff");
        
    }).on("drop", function(e) {      /* "drop" 이벤트는 드롭대상인 박스 안에서 Drag 한 것을 Drop(Drag 한 파일(객체)을 놓는것) 했을 때. 필수이벤트이다. */
        e.preventDefault();
    
        var files = e.originalEvent.dataTransfer.files;  
		<%--  
		    jQuery 에서 이벤트를 처리할 때는 W3C 표준에 맞게 정규화한 새로운 객체를 생성하여 전달한다.
		    이 전달된 객체는 jQuery.Event 객체 이다. 이렇게 정규화된 이벤트 객체 덕분에, 
		    웹브라우저별로 차이가 있는 이벤트에 대해 동일한 방법으로 사용할 수 있습니다. (크로스 브라우징 지원)
		    순수한 dom 이벤트 객체는 실제 웹브라우저에서 발생한 이벤트 객체로, 네이티브 객체 또는 브라우저 내장 객체 라고 부른다.
		--%>
		/*  Drag & Drop 동작에서 파일 정보는 DataTransfer 라는 객체를 통해 얻어올 수 있다. 
		    jQuery를 이용하는 경우에는 event가 순수한 DOM 이벤트(각기 다른 웹브라우저에서 해당 웹브라우저의 객체에서 발생되는 이벤트)가 아니기 때문에,
		    event.originalEvent를 사용해서 순수한 원래의 DOM 이벤트 객체를 가져온다.
		    Drop 된 파일은 드롭이벤트가 발생한 객체(여기서는 $("div#fileDrop")임)의 dataTransfer 객체에 담겨오고, 
		    담겨진 dataTransfer 객체에서 files 로 접근하면 드롭된 파일의 정보를 가져오는데 그 타입은 FileList 가 되어진다. 
		    그러므로 for문을 사용하든지 또는 [0]을 사용하여 파일의 정보를 알아온다. 
        */
        
		if(files != null && files != undefined) {
			
			let html = "";
     		const f = files[0]; // 어차피 files.length 의 값이 1 이므로 위의 for문을 사용하지 않고 files[0] 을 사용하여 1개만 가져오면 된다. 
    		let fileSize = f.size/1024/1024;  /* 파일의 크기는 MB로 나타내기 위하여 /1024/1024 하였음 */
    
	        if( !(f.type == 'image/jpeg' || f.type == 'image/png') ) {
	           alert("jpg 또는 png 파일만 가능합니다.");
	           $(this).css("background-color", "#fff");
	           return;
	           
	        } else if(fileSize >= 10) {
	           alert("10MB 이상인 파일은 업로드가 불가합니다.");
	           $(this).css("background-color", "#fff");
	           return;
	           
	        } else {
	        	file_arr.push(f);
	            const fileName = f.name; // 파일명   
	        
	            fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1);
	            // fileSize 가 1MB 보다 작으면 소수부는 반올림하여 소수점 3자리까지 나타내며, 
	            // fileSize 가 1MB 이상이면 소수부는 반올림하여 소수점 1자리까지 나타낸다. 만약에 소수부가 없으면 소수점은 0 으로 표시한다.
	            /* 
	                numObj.toFixed([digits]) 의 toFixed() 메서드는 숫자를 고정 소수점 표기법(fixed-point notation)으로 표시하여 나타난 수를 문자열로 반환해준다. 
	                               파라미터인 digits 는 소수점 뒤에 나타날 자릿수 로써, 0 이상 20 이하의 값을 사용할 수 있으며, 구현체에 따라 더 넓은 범위의 값을 지원할 수도 있다. 
	                digits 값을 지정하지 않으면 0 을 사용한다.
	                 
	                var numObj = 12345.6789;
	 
		            numObj.toFixed();       // 결과값 '12346'   : 반올림하며, 소수 부분을 남기지 않는다.
		            numObj.toFixed(1);      // 결과값 '12345.7' : 반올림한다.
		            numObj.toFixed(6);      // 결과값 '12345.678900': 빈 공간을 0 으로 채운다.
	            */
	           
				html += 
                   "<div class='fileList d-flex justify-content-between'>" +
                       "<span class='delete mr-2' title='삭제'>&times;</span>" +
                       "<span class='fileName mr-auto'>" + fileName + "</span>" +
                       "<span class='fileSize mr-2'>" + fileSize + " MB</span>" +
                       "<span class='clear'></span>" +
                   "</div>";
				$(this).append(html);
				
			}
		} // end of if(files != null && files != undefined) ------------------
		
		$(this).css("background-color", "#fff");
    });
	
	// == Drop 된 파일목록 제거하기 == //
	$(document).on("click", "span.delete", function(e) {
		
		let idx = $("span.delete").index($(e.target));
		
		file_arr.splice(idx, 1);
		<%-- 
			배열명.splice() : 배열의 특정 위치에 배열 요소를 추가하거나 삭제하는데 사용한다. 
			                 삭제할 경우 리턴값은 삭제한 배열 요소이다. 삭제한 요소가 없으면 빈 배열( [] )을 반환한다.
			
			배열명.splice(start, 0, element);  // 배열의 특정 위치에 배열 요소를 추가하는 경우 
			            start   - 수정할 배열 요소의 인덱스
			              0     - 요소를 추가할 경우
			           element  - 배열에 추가될 요소
			
			배열명.splice(start, deleteCount); // 배열의 특정 위치의 배열 요소를 삭제하는 경우    
			               start   - 수정할 배열 요소의 인덱스
			               deleteCount - 삭제할 요소 개수
		--%>
		
		$(e.target).parent().remove(); // div.fileList 태그 아예 삭제
		
	});
	<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 끝 === --%>
    
});


// ===== 영업시간 유효성 검사 함수 =====
function checkHours() {
	
	const starthours = $("select[name='starthours']").val();
	const endhours = $("select[name='endhours']").val();
	
	if(starthours != "" && endhours != "") {
		
		if(starthours >= endhours) {
			$("select[name='starthours']").addClass("input_error");
			$("select[name='endhours']").addClass("input_error");
			$("select[name='endhours']").parent().next().show();
			$("select[name='endhours']").parent().next().text("영업 시간을 올바르게 선택해주세요.");
			
		} else {
			$("select[name='starthours']").removeClass("input_error");
			$("select[name='endhours']").removeClass("input_error");
			$("select[name='endhours']").parent().next().hide();
		}
		
	}
	
}


// ===== 맛집 등록 함수 =====
function goRegister() {
	
	if(checkName && checkMobile && checkContent) {
		
        const food_category = $("select[name='food_category']").val();

        if(food_category == "") {
            alert("음식 구분을 선택해주세요.");
            return;
        }
        
        
        const local_status = $("select[name='local_status']").val();
        
        if(local_status == "") {
        	alert("지역 구분을 선택해주세요.");
        	return;
        }
        
        
        const starthours = $("select[name='starthours']").val();
        
        if(starthours == "") {
        	alert("영업 시간을 선택해주세요.");
        	return;
        }
        
        
        const endhours = $("select[name='endhours']").val();
        
        if(endhours == "") {
        	alert("영업 시간을 선택해주세요.");
        	return;
        }
        
        
        const address = $("input#address").val().trim();

        if(address == "") {
            alert("주소를 입력해주세요.");
            return;

        }

        
        const food_main_img = $("input#food_main_img").val();
        
        if(food_main_img == "") {
        	alert("대표 이미지를 추가해주세요.");
        	return;
        }
        
        ///////////////////// 등록 시 이미지 파일 처리 시작 ///////////////////////
		var formData = new FormData($("form[name='registerFrm']").get(0));
        
		const food_businesshours = $("select[name='starthours']").val() + "~" + $("select[name='endhours']").val();
        const food_address = "";
        
        if($("input#detail_address").val() != "") {
        	
        	food_address = $("input#address").val() + " " + $("input#detail_address").val();
        	
        } else {
        	food_address = $("input#address").val();
        }
        
		formData.append("food_businesshours", food_businesshours);
		formData.append("food_address", food_address);
		
		if(file_arr.length > 0) { // 추가이미지파일을 추가했을 경우
			
			// 첨부한 파일의 총합의 크기가 10MB 이상이라면 폼 전송을 하지 못하게 막는다.
			let sum_file_size = 0;
			
			for(let i=0; i<file_arr.length; i++) {
				
				sum_file_size += file_arr[i].size;
				
			} // end of for ------------------------
			
			
			////////////////////////////////////////
                  // 첨부한 파일의 총량을 누적하는 용도 
                  total_fileSize += sum_file_size;
             	////////////////////////////////////////
			
             	
			if( sum_file_size >= 10*1024*1024 ) { // 첨부한 파일의 총합의 크기가 10MB 이상 이라면 
				
				alert("첨부한 추가이미지 파일의 총합의 크기가 10MB 이상이므로 등록이 불가합니다.");
				return; // 종료
				
			} else { // 첨부한 파일의 총합의 크기가 10MB 미만이라면, formData 속에 첨부파일 넣어주기
				
				formData.append("attachCount", file_arr.length); // 추가이미지파일 개수
				
				file_arr.forEach(function(item, index) {
					
					formData.append("attach"+index, item); // 첨부파일 추가하기. item 이 첨부파일이다.
				});
			}
			
			
		} // end of if(file_arr.length > 0) --------------------
		//   end of 추가이미지파일을 추가했을 경우 ----------------------
		
		
		// 첨부한 파일의 총량이 20MB 초과 시
		if( total_fileSize > 20*1024*1024 ) {
			alert("첨부한 파일의 총합의 크기가 20MB를 초과하여 등록이 불가합니다.");
		    return; // 종료
		}
        ///////////////////// 등록 시 이미지 파일 처리 끝 ///////////////////////
        
        // 맛집 등록 처리하기
        $.ajax({
            url: "<%=ctxPath%>/admin/foodstoreRegisterEnd.trip",
            type: "post",
            data: formData,
			processData: false,  // 파일 전송 시 설정 ★★★
            contentType: false,  // 파일 전송 시 설정 ★★★
            dataType: "json",
            success: function(json) {
                if(json.n == 1) {
                    alert("등록이 성공되었습니다.");
                    location.href = "<%=ctxPath%>/index.trip";

                } else {
                    alert("등록에 실패했습니다.");
                    history.back();
                }
            },
            error: function(request, status, error) {
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
        });
		
	} else {
		alert("가입 정보를 모두 입력하세요.");
        return;
	}
	
}



</script>

<div class="container">

    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">맛집 등록</h2>
    </div>

    <form name="registerFrm" enctype="multipart/form-data">

        <div class="info">

            <div class="info_block">
                <input type="text" name="food_name" id="food_name" placeholder="식당명 입력" maxlength="20">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="food_category">
					<option value="">음식 구분</option>
					<option>한식</option>
					<option>일식</option>
					<option>중식</option>
					<option>양식</option>
					<option>카페</option>
					<option>기타</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="local_status">
					<option value="">지역 구분</option>
					<option>제주 시내</option>
					<option>제주시 서부</option>
					<option>제주시 동부</option>
					<option>서귀포 시내</option>
					<option>서귀포시 동부</option>
					<option>서귀포시 서부</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
                <input type="text" name="food_mobile" id="food_mobile" placeholder="식당 연락처 ('-' 포함 입력)" maxlength="20">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
            	<div class="businesshours d-flex justify-content-between">
	                <select name="starthours">
	                	<option value="">영업 시작 시간</option>
	                	<option>08:00</option>
	                	<option>08:30</option>
	                	<option>09:00</option>
	                	<option>09:30</option>
	                	<option>10:00</option>
	                	<option>10:30</option>
	                	<option>11:00</option>
	                	<option>11:30</option>
	                	<option>12:00</option>
	                	<option>12:30</option>
	                	<option>13:00</option>
	                	<option>13:30</option>
	                	<option>14:00</option>
	                	<option>14:30</option>
	                	<option>15:00</option>
	                	<option>15:30</option>
	                	<option>16:00</option>
	                	<option>16:30</option>
	                	<option>17:00</option>
	                	<option>17:30</option>
	                	<option>18:00</option>
	                	<option>18:30</option>
	                	<option>19:00</option>
	                	<option>19:30</option>
	                	<option>20:00</option>
	                	<option>20:30</option>
	                	<option>21:00</option>
	                	<option>21:30</option>
	                	<option>22:00</option>
	                	<option>22:30</option>
	                	<option>23:00</option>
	                </select>
	                <span style="font-size: 14pt; margin-top: 1%;">~</span>
	                <select name="endhours">
	                	<option value="">영업 종료 시간</option>
	                	<option>08:00</option>
	                	<option>08:30</option>
	                	<option>09:00</option>
	                	<option>09:30</option>
	                	<option>10:00</option>
	                	<option>10:30</option>
	                	<option>11:00</option>
	                	<option>11:30</option>
	                	<option>12:00</option>
	                	<option>12:30</option>
	                	<option>13:00</option>
	                	<option>13:30</option>
	                	<option>14:00</option>
	                	<option>14:30</option>
	                	<option>15:00</option>
	                	<option>15:30</option>
	                	<option>16:00</option>
	                	<option>16:30</option>
	                	<option>17:00</option>
	                	<option>17:30</option>
	                	<option>18:00</option>
	                	<option>18:30</option>
	                	<option>19:00</option>
	                	<option>19:30</option>
	                	<option>20:00</option>
	                	<option>20:30</option>
	                	<option>21:00</option>
	                	<option>21:30</option>
	                	<option>22:00</option>
	                	<option>22:30</option>
	                	<option>23:00</option>
	                </select>
            	</div>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
	            <input type="text" name="address" id="address" placeholder="주소">
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="detail_address" id="detail_address" placeholder="상세주소">
				<span class="error"></span>
	        </div>
            <div class="info_block mt-3">
                <textarea name="food_content" id="food_content" class="p-3" placeholder="맛집 상세 정보" maxlength="100"></textarea>
                <span class="error"></span>
            </div>
            <div class="d-flex justify-content-between mt-3">
            	<label for="food_main_img" class="mt-3 mr-2">대표 이미지</label>
                <input type="file" name="food_main_img" id="food_main_img" class="ml-4">
                <span class="error"></span>
            </div>
            <div class="d-flex justify-content-between mt-3">
            	<label for="food_add_img" class="" style="margin-top: 10%;">추가 이미지</label>
				<div id="fileDrop" class="fileDrop">
					<span style="font-size: 10pt;">파일을 1개씩 마우스로 끌어 오세요</span>
				</div>
                <span class="error"></span>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister()">등록하기</button>
        </div>

    </form>

</div>