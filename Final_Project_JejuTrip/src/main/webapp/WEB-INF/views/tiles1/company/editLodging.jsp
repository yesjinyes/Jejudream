<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath();%>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/company/registerHotel.css"/>
<script type="text/javascript">
	let checkLodging_name = false;
	let checkLodging_tell = false;
	let checkLodging_address_detail = false;
	let checkLodging_content = false;
	
	$(document).ready(function(){
		$("span.error").hide();
	    
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
		
	    // ===== 숙소명 유효성 검사 =====
	    $("input#lodging_name").blur((e) => {

	        const lodging_name = $(e.target).val().trim();

	        if(lodging_name == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("호텔명을 입력해주세요.");
	            checkLodging_name = false;
	        } 
			else {
	            $(e.target).removeClass("input_error");
	            $(e.target).next().hide();
	            checkLodging_name = true;
	        }
	    });

		// ===== 휴대폰 유효성 검사 =====
	    $("input#lodging_tell").blur((e) => {

			const lodging_tell = $(e.target).val().trim();
			
			const regExp_mobile = new RegExp(/^[0-9]{3,4}[0-9]{3,4}[0-9]{4}$/);
			// 01[016789]{1} << 원래거
			const bool = regExp_mobile.test(lodging_tell);

			if(lodging_tell == "") {
				$(e.target).addClass("input_error");
				$(e.target).next().show();
				$(e.target).next().text("업체 연락처를 입력해주세요.");
				checkLodging_tell = false;

			} else if(!bool) {
				$(e.target).addClass("input_error");
				$(e.target).next().show();
				$(e.target).next().text("유효하지 않은 연락처입니다.");
				checkLodging_tell = false;

			} else {
				$(e.target).removeClass("input_error");
				$(e.target).next().hide();
				checkLodging_tell = true;
			}

		});

	    // ===== 상세주소 유효성 검사 =====
	    $("input#detail_address").blur((e) => {

	        const lodging_address_detail = $(e.target).val().trim();

	        if(lodging_address_detail == "") {
	        	
	        	if(confirm('상세주소가 없습니까?')){
	        		
	        		$(e.target).removeClass("input_error");
		            $(e.target).next().hide();
		            checkLodging_address_detail = true;
	        		
	        	}else{
	        		
	        		$(e.target).addClass("input_error");
		            $(e.target).next().show();
		            $(e.target).next().text("상세주소를 입력해주세요.");
		            checkLodging_address_detail = false;
	        		
	        	}
	           
	        } 
			else {
				$(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("상세주소를 입력해주세요.");
	            checkLodging_address_detail = false;
	            
	        }
	    });

		// ===== 숙소설명 유효성 검사 =====
	    $("textarea#lodging_content").blur((e) => {

			const lodging_content = $(e.target).val().trim();

			if(lodging_content == "") {
				$(e.target).addClass("input_error");
				$(e.target).next().show();
				$(e.target).next().text("상세주소를 입력해주세요.");
				checkLodging_content = false;

			} 
			else {
				$(e.target).removeClass("input_error");
				$(e.target).next().hide();
				checkLodging_content = true;
			}
		});

	    $("input#mobile").keyup(function(e) {
	        if(e.keyCode == 13) {
	            goRegister();
	        }
	    });
	}); // end of $(document).ready(function(){
		
	function goRegister(ctxPath) {

	    if(checkLodging_name && checkLodging_tell && checkLodging_address_detail && checkLodging_content) {
			
			const lodging_category = $("select[name='lodging_category']").val();
			if(lodging_category=="숙소구분"){
				alert("숙소구분을 선택하세요.");
	        	return;
			}

			const local_status = $("select[name='local_status']").val();
			if(local_status=="지역구분"){
				alert("지역구분을 선택하세요.");
	        	return;
			}

			const main_img = $("input[name='attach']").val();
			if(main_img==""){
				alert("대표 이미지를 첨부하세요.");
	        	return;
			}

			let queryString = $("form[name='registerFrm']").serialize();
			const convenient_arr = new Array();
			
			$("input[name='fk_convenient_code']:checked").each(function(index,item){
				convenient_arr.push($(item).val());
			});
			const str_convenient = convenient_arr.join();

	        // 숙소 등록 처리하기.
	        const frm = document.editFrm;
			frm.str_convenient.value = str_convenient;
		   	frm.method = "post";
		   	frm.action = "<%= ctxPath%>/editLodgingEnd.trip";
		   	frm.submit();
	    } else {
	        alert("가입 정보를 모두 입력하세요.");
	        return;
	    }

	}
</script>

<div class="container">
	<c:set var="lvo" value="${requestScope.lvo}"/>
    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">숙소 수정</h2>
        <h5>변경된 사항이 있다면 최신화 해주세요!</h5>
    </div>

    <form name="editFrm" enctype="multipart/form-data">

        <div class="info">

            <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
            <div class="info_block">
            	<input type="text" name="lodging_name" id="lodging_name" value="${lvo.lodging_name}" placeholder="숙소 명 입력">
            	<span class="error"></span>
                <input type="hidden" name="lodging_code" value="${lvo.lodging_code}" />
            </div>
            <div class="info_block mt-3">
				<select name="lodging_category">
					<option selected>${lvo.lodging_category}</option>
					<option>호텔</option>
					<option>펜션</option>
					<option>리조트</option>
					<option>게스트하우스</option>
					<option>에어비앤비</option>
					<option>기타</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="local_status">
					<option selected>${lvo.local_status}</option>
					<option>제주시 시내</option>
					<option>제주시 서부</option>
					<option>제주시 동부</option>
					<option>서귀포시 시내</option>
					<option>서귀포 동부</option>
					<option>서귀포 서부</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
                <input type="text" name="lodging_tell" id="lodging_tell" placeholder="숙소 연락처" maxlength="20" value="${lvo.lodging_tell}">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
	            <input type="text" name="address" id="address" placeholder="주소" value="${lvo.lodging_address}">
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="detail_address" id="detail_address" placeholder="상세주소">
				<span class="error"></span>
	        </div>
	        <div class="mt-3 convenient">
	        	편의시설
	        </div>
        	<c:forEach var="convenient" items="${requestScope.convenientList}" varStatus="status">
        		<c:if test="${status.index % 6 == 0}">
        			<div></div>
        		</c:if>
        		<label class="checkbox_label" for="fk_convenient_code${status.index}">${convenient.convenient_name}
        			<input type="checkbox" class="fk_convenient_code" name="fk_convenient_code" id="fk_convenient_code${status.index}" value="${convenient.convenient_code}"
        			<c:forEach var="selected" items="${requestScope.selectedConvenientList}">
            		<c:if test="${selected.convenient_code eq convenient.convenient_code}">checked</c:if>
        			</c:forEach> />
					
				</label>
			</c:forEach>    
			<input type="hidden" name="str_convenient"/>
            <div class="info_block mt-3">
                <textarea name="lodging_content" id="lodging_content" placeholder="숙소 설명" >${lvo.lodging_content}</textarea>
                <span class="error"></span>
            </div>
            <div class="mt-3">
            	<span>현재 숙소 이미지 파일명 : ${lvo.orgFilename}</span><br>
                <input type="file" name="attach" id="attach">
                <span class="error"></span>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">숙소 수정하기</button>
            <button type="button" style="border-radius: 8px; height: 50px; margin: 1% auto;"class="btn btn-danger" onclick="javascript:history.back()">취소하기</button>
        </div>

    </form>

</div>