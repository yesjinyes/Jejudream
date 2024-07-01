<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<%-- Main CSS --%>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/login/login.css">

<script type="text/javascript">
    $(document).ready(function() {

    	$("span#idFind").click(function() {
    		location.href = "<%=ctxPath%>/login/idFind.trip";
    	});
    	
    	$("span#pwFind").click(function() {
    		location.href = "<%=ctxPath%>/login/pwFind.trip";
    	});
    	
    	$("input#pw").keyup(function(e) {
    		
    		if(e.keyCode == 13) {
    			goLogin();
    		}
    		
    	});
    	
    	
		// === 로그인을 하지 않은 상태일 때 
		//     로컬스토리지(localStorage)에 저장된 key가 'saveid' 인 userid 값을 불러와서 
		//     input 태그 userid 에 넣어주기 ===
    	if(${empty sessionScope.loginuser}) {
    		
    		const loginId = localStorage.getItem('saveid');
			
			if(loginId != null) {
				$("input#id").val(loginId);
				$("input:checkbox[id='saveid']").prop("checked", true);
			}
    	}
    	
    });

    function goLogin() {

        const id = $("input#id").val().trim();
        const pw = $("input#pw").val().trim();

        if(id == "") {
            alert("아이디를 입력해주세요!");
            return;
        }

        if(pw == "") {
            alert("비밀번호를 입력해주세요!");
            return;
        }
        
        
        // 아이디 저장 체크 시
        if($("input:checkbox[id='saveid']").prop("checked")) {
        	
            localStorage.setItem('saveid', $("input#id").val());
                                //  key                value
            
        } else {
            localStorage.removeItem('saveid');
        }

        
        const frm = document.loginFrm;
        frm.action = "<%=ctxPath%>/loginEnd.trip";
        frm.method = "post";
        frm.submit();
    }
</script>

<div class="container">
    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">로그인</h2>
        <h5>로그인 후 다양한 서비스를 이용하실 수 있습니다.</h5>

        <form name="loginFrm">
        
            <div class="d-flex justify-content-center mt-5">
               <div class="form-check form-check-inline">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio1" value="member" checked>
                 <label class="form-check-label" for="inlineRadio1">일반회원</label>
               </div>
               <div class="form-check form-check-inline pl-3">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio2" value="company">
                 <label class="form-check-label" for="inlineRadio2">업체회원</label>
               </div>
               <%--
               <div class="form-check form-check-inline pl-3">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio3" value="member">
                 <label class="form-check-label" for="inlineRadio3">관리자</label>
               </div>
               --%>
            </div>
        
            <div class="info">
                <input type="text" name="id" id="id" placeholder="아이디">
                <input type="password" name="pw" id="pw" placeholder="비밀번호">
            </div>
            <div style="margin: 0 0 1% 2%;">
                <input type="checkbox" id="saveid">
                <span class="checkbox_icon"></span>
                &nbsp;&nbsp;<label for="saveid">아이디 저장</label>
            </div>
            <div class="mb-4">
                <button type="button" class="btn" id="loginBtn" onclick="goLogin()">로그인</button>
            </div>

            <div class="d-flex idPwFind" style="margin-bottom: 20%;">
	            <span id="idFind" style="margin-right: 4%;">아이디 찾기</span> | 
	            <span id="pwFind" style="margin-left: 4%;">비밀번호 찾기</span>
            </div>
        </form>
    </div>
</div>
