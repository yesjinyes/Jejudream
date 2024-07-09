<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
    body {
        font-family: "Noto Sans KR", sans-serif;
        font-optical-sizing: auto;
    }
    div.container {
        width: 45%;
        margin: 5% auto;
        border: solid 1px rgba(0, 0, 0, 0.15);
        border-radius: 40px;
        box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
    }
    div.info {
        width: 100%;
        margin: 10% 5% 0 0;
    }

    div.info input {
        display: block;
        width: 100%;
        max-width: 680px;
        height: 50px;
        margin: 0 auto;
        margin-bottom: 4%;
        border-radius: 8px;
        border: solid 1px rgba(15, 19, 42, .1);
        padding: 0 0 0 15px;
        font-size: 16px;
    }

    button#pwUpdateBtn {
        width: 47%;
        height: 50px;
        margin: 1% 0 1% 0;
        border-radius: 8px;
        background-color: #ff5000;
        color: white;
    }

    button#pwUpdateBtn:hover {
        background-color: #e64900;
    }
    
    button#goBackBtn {
    	width: 47%;
        height: 50px;
        margin: 1% 0 1% 0;
        border-radius: 8px;
    }
</style>

<script type="text/javascript">
    $(document).ready(function() {

        $("input#pwCheck").keyup(function(e) {
            if(e.keyCode == 13) {
                goPwUpdate();
            }
        });
        
    });

    function goPwUpdate() {
        const new_pw = $("input#new_pw").val().trim();
        const pwCheck = $("input#pwCheck").val().trim();

        if(new_pw == "") {
            alert("비밀번호를 입력해주세요!");
            return;
        }

        const regExp_pw = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g); 
        const bool = regExp_pw.test(new_pw);

        if(!bool) {
            alert("올바른 비밀번호 형식이 아닙니다.\n비밀번호를 다시 입력해주세요.");
            $("input#new_pw").val("");
            $("input#new_pw").focus();
            return;
        }

        if(pwCheck == "") {
            alert("비밀번호 확인을 입력해주세요!");
            return;
        }

        if(new_pw != pwCheck) {
            alert("비밀번호가 일치하지 않습니다.");
            $("input#pwCheck").val("");
            $("input#pwCheck").focus();
            return;
        }
        
        const queryString = $("form[name='pwUpdateFrm']").serialize();
        
        $.ajax({
        	url: "<%=ctxPath%>/login/pwUpdateEndJSON.trip",
        	type: "post",
        	data: queryString,
        	dataType: "json",
        	success: function(json) {
        		if(json.isOK) {
        			alert("비밀번호가 변경되었습니다.\n다시 로그인해 주시기 바랍니다.");
        			location.href = "<%=ctxPath%>/login.trip";
        			
        		} else {
        			alert("입력하신 비밀번호가 기존 비밀번호와 동일합니다.\n다시 입력해 주세요.");
        			$("input#new_pw").val("").focus();
        			$("input#pwCheck").val("");
        		}
        	},
        	error: function(request, status, error) {
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
        });
        
    }
    
    
    function goBack() {
    	
    	if(confirm("다음에 변경하시겠습니까?")) {
    		
	    	const frm = document.pwUpdateFrm;
	    	frm.method = "post";
	    	frm.action = "<%=ctxPath%>/login/cancelPwUpdate.trip";
	    	frm.submit();
    	}
    }
</script>

<div class="container">
    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">비밀번호 변경</h2>
        <h5>개인정보 보호를 위해 비밀번호를 변경해 주세요.</h5>

        <form name="pwUpdateFrm">
            <div class="info mt-5">
                <input type="password" name="new_pw" id="new_pw" placeholder="비밀번호">
                <input type="password" name="pwCheck" id="pwCheck" placeholder="비밀번호 재입력">
            </div>
            
            <c:if test="${not empty sessionScope.loginuser}">
	            <input type="hidden" name="memberType" value="member">
	            <input type="hidden" name="id" value="${sessionScope.loginuser.userid}">
            </c:if>
            
            <c:if test="${not empty sessionScope.loginCompanyuser}">
	            <input type="hidden" name="memberType" value="company">
	            <input type="hidden" name="id" value="${sessionScope.loginCompanyuser.companyid}">
            </c:if>
            
            <div class="mt-5 d-flex justify-content-between" style="margin-bottom: 20%;">
                <button type="button" class="btn" id="pwUpdateBtn" onclick="goPwUpdate()">변경하기</button>
                <button type="button" class="btn btn-secondary" id="goBackBtn" onclick="goBack()">다음에 변경하기</button>
            </div>
        </form>
        
    </div>
</div>