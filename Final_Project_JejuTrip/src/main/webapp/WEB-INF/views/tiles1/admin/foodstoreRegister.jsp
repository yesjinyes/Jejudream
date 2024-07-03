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
        
        

        let queryString = $("form[name='registerFrm']").serialize();
        
		
        
        
        
		
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
					<option>서귀포시</option>
					<option>서귀포 동부</option>
					<option>서귀포 서부</option>
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
            <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">등록하기</button>
        </div>

    </form>

</div>