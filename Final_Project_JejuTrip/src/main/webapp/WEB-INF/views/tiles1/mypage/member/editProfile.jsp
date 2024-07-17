<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageEditProfile.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script type="text/javascript">
	let checkName = true;
	let checkEmailId = false;
	let checkMobile = true;
	
	$(function () {
	
	    $("span.error").hide();
	    
	    // 생년월일 Date Picker
	    $('.datepicker').daterangepicker({
	        singleDatePicker: true,
	         locale: {
	            "format": 'YYYY-MM-DD',
	            "applyLabel": "확인",
	            "cancelLabel": "취소",
	            "daysOfWeek": ["일", "월", "화", "수", "목", "금", "토"],
	            "monthNames": ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
	         },
	        showDropdowns: true,
	        minYear: 1900,
	        maxYear: 2025,
	        maxDate: moment()
	    }, function(start, end, label) {
	        // 생년월일 선택 후의 콜백 함수
	        const selectedDate = start.format('YYYY-MM-DD');
	        const today = moment().format('YYYY-MM-DD');
	    
	        if (selectedDate === today) {
	            alert("생년월일은 오늘 날짜 이전으로만 선택 가능합니다.");
	            // 선택된 값을 초기화
	            $("input#birthday").val("");
	        }
	    });
	  
	    // 생년월일 키보드 입력 막기
	    $("input#birthday").on("keypress keydown keyup", function(e) {
	        e.preventDefault();
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
	
	    // ===== 성명 유효성 검사 =====
	    $("input#user_name").blur((e) => {
	
	        const name = $(e.target).val().trim();
	
	        const regExp_name = new RegExp(/^[가-힣]{2,6}$/);
	        const bool = regExp_name.test(name);
	
	        if(name == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("성명을 입력해주세요.");
	            checkName = false;
	
	        } else if(!bool) {
	            $(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("성명은 2~6자 이내 한글로만 입력해주세요.");
	            checkName = false;
	
	        } else {
	            $(e.target).removeClass("input_error");
	            $(e.target).next().hide();
	            checkName = true;
	        }
	    });
	
	    // ===== 이메일 유효성 검사 =====
	    $("input#email_id").blur((e) => {
	
	        const email_id = $(e.target).val().trim();
	
	        const regExp_emailId = new RegExp(/^(?=.*[A-Za-z])[A-Za-z0-9]{5,20}$/);
	        const bool = regExp_emailId.test(email_id);
	
	        if(email_id == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).parent().next().show();
	            $(e.target).parent().next().text("이메일 아이디를 입력해주세요.");
	            checkEmailId = false;
	
	        } else if(!bool) {
	            $(e.target).addClass("input_error");
	            $(e.target).parent().next().show();
	            $(e.target).parent().next().text("이메일 아이디는 5~20자 이내의 영문, 숫자로만 입력해주세요.");
	            checkEmailId = false;
	
	        } else {
	
	            $.ajax({
	                url: "userEmailDuplicateCheck.trip",
	                type: "post",
	                data: {"email":$(e.target).val() + "@" + $(e.target).next().next().val()},
	                dataType: "json",
	                success: function(json) {
	                    if(json.isExist) {
	                        $(e.target).addClass("input_error");
	                        $(e.target).parent().next().show();
	                        $(e.target).parent().next().text("중복된 이메일입니다. 다시 입력해주세요.");
	                        checkEmailId = false;
	                        
	                    } else {
	                        $(e.target).removeClass("input_error");
	                        $(e.target).parent().next().hide();
	                        checkEmailId = true;
	                    }
	                },
	                error: function(request, status, error) {
	                    alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	                }
	            });
	        }
	
	    });
	
	    $("select#email_dropdown").change(function(e) {
	
	        $.ajax({
	            url: "userEmailDuplicateCheckEdit.trip",
	            type: "post",
	            data: {"email":$(e.target).prev().prev().val() + "@" + $(e.target).val()},
	            dataType: "json",
	            success: function(json) {
	                if(json.isExist) {
	                    $(e.target).prev().prev().addClass("input_error");
	                    $(e.target).parent().next().show();
	                    $(e.target).parent().next().text("중복된 이메일입니다. 다시 입력해주세요.");
	                    checkEmailId = false;
	                    
	                } else {
	                    $(e.target).prev().prev().removeClass("input_error");
	                    $(e.target).parent().next().hide();
	                    checkEmailId = true;
	                }
	            },
	            error: function(request, status, error) {
	                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	            }
	        });
	
	    });
	
	
	    // ===== 휴대폰 유효성 검사 =====
	    $("input#mobile").blur((e) => {
	
	        const mobile = $(e.target).val().trim();
	
	        const regExp_mobile = new RegExp(/^01[016789]{1}[0-9]{3,4}[0-9]{4}$/);
	        const bool = regExp_mobile.test(mobile);
	
	        if(mobile == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("휴대폰 번호를 입력해주세요.");
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
	
	    // 주소 키보드 입력 막기
	    $("input#address").on("keypress", function(e) {
	        e.preventDefault();
	    });
	
	
	    $("input#detail_address").keyup(function(e) {
	        if(e.keyCode == 13) {
	            goRegister();
	        }
	    });
	
	});
	
	
	function goRegister(ctxPath) {
	
	    if(checkName && checkEmailId && checkMobile) {
	
	        const email_dropdown = $("select#email_dropdown").val();
	
	        if(email_dropdown == "") {
	            alert("이메일 주소를 선택해주세요.");
	            return;
	        }
	
	        // 생년월일 값 확인
	        const birthday = $("input#birthday").val().trim();
	        const today = new Date().toISOString().split('T')[0]; // 오늘 날짜를 YYYY-MM-DD 형식으로 변환
	
	        if (birthday == today) {
	            alert("생년월일을 선택해주세요.");
	            return;
	        }
	
	        const address = $("input#address").val().trim();
	        const detail_address = $("input#detail_address").val().trim();
	
	        if(address == "") {
	            alert("주소를 입력해주세요.");
	            return;
	
	        } else if(detail_address == "") {
	            alert("상세주소를 입력해주세요.");
	            return;
	        }
	
	        // const frm = document.registerFrm;
	        // frm.action = "";
	        // frm.method = "post";
	        // // frm.submit();
	
	        let queryString = $("form[name='editFrm']").serialize();
	        
	        const email = $("input#email_id").val() + "@" + email_dropdown;
	
	        // email 값을 쿼리 문자열에 추가
	        if (queryString) {
	            queryString += "&";
	        }
	        queryString += "email=" + encodeURIComponent(email);
	
	        // 회원가입 처리하기
	        $.ajax({
	            url: ctxPath + "/memberEditEnd.trip",
	            type: "post",
	            data: queryString,
	            dataType: "json",
	            success: function(json) {
	                if(json.n == 1) {
	                    alert("정보수정이 성공되었습니다.");
	                    location.href = ctxPath + "/index.trip";
	
	                } else {
	                    alert("정보수정에 실패했습니다.");
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

<div class="body">
    <div class="navigation">
        <ul>
            <li class="list">
                <a href="<%= ctxPath%>/requiredLogin_goMypage.trip">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
                </a>
            </li>
            <li class="list active">
                <a href="<%= ctxPath%>/editProfile.trip">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원정보수정</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/cash_points.trip">
                    <span class="icon"><ion-icon name="calendar-number-outline"></ion-icon></span>
                    <span class="title">내 일정</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/review.trip">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <br><br><br>
            <li class="list">
                <a href="<%= ctxPath%>/support.trip">
                    <span class="icon"><ion-icon name="help-circle-outline"></ion-icon></span>
                    <span class="title">고객센터</span>
                </a>
            </li>
        </ul>
    </div>
	
	<div class="container">
	    <div style="width: 80%; margin: 7% auto;">
		    <h2 style="margin-top: 20%;" class="h2 font-weight-bold">회원정보수정</h2>
		</div>
		
		<form name="editFrm">
		
		    <div class="info">
		
		        <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
		        <div class="info_block mt-3">
		            <input type="text" name="user_name" id="user_name" placeholder="성명 입력" maxlength="20" value="${sessionScope.loginuser.user_name}">
		            <span class="error"></span>
		        </div>
		        <div class="mt-3">
		            <div class="d-flex">
		                <input type="text" name="email_id" id="email_id" class="mr-3" placeholder="이메일" value="${sessionScope.loginuser.email.substring(0,sessionScope.loginuser.email.indexOf('@')) }">
		                <span style="font-size: 14pt; margin-top: 1%;">@</span>
		                <select name="email_dropdown" id="email_dropdown" class="ml-3">
		                    <option value="">선택하세요</option>
		                    <option value="naver.com">naver.com</option>
		                    <option value="gmail.com">gmail.com</option>
		                    <option value="daum.net">daum.net</option>
		                    <option value="kakao.com">kakao.com</option>
		                </select>
		            </div>
		            <span class="error"></span>
		        </div>
		        <div class="info_block mt-3 d-flex">
		            <input type="text" class="datepicker" name="birthday" id="birthday" placeholder="생년월일" value="${sessionScope.loginuser.birthday }">
		            
		        </div>
		        <div class="info_block mt-3">
		            <input type="text" name="mobile" id="mobile" placeholder="휴대폰 번호 입력 ('-' 제외 11자리 입력)" value="${sessionScope.loginuser.mobile }">
		            <span class="error"></span>
		        </div>
		        <div class="info_block mt-3">
		            <input type="text" name="address" id="address" placeholder="주소" value="${sessionScope.loginuser.address }">
		        </div>
		        <div class="info_block mt-3">
		            <input type="text" name="detail_address" id="detail_address" placeholder="상세주소" value="${sessionScope.loginuser.detail_address}">
		        </div>
		    </div>
		
		    <div style="text-align: center; margin-bottom: 13%;">
		        <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">수정하기</button>
		    </div>
		
		</form>
	</div>
</div>