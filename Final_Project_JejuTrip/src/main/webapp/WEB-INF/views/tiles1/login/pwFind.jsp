<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

    button#pwFindBtn {
        width: 100%;
        height: 50px;
        margin: 1% auto;
        border-radius: 8px;
        border-color: #ff5000;
        color: #ff5000;
    }

    button#pwFindBtn:hover {
        background-color: #ff5000;
        color: white;
    }

    input[name='input_confirmCode'] {
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

    button#confirmBtn {
        position: absolute;
        width: 90px;
        height: 40px;
        top: 0;
        bottom: 0;
        right: 5px;
        margin: auto 0;
        border-radius: 8px;
    }
</style>

<script type="text/javascript">
    $(document).ready(function() {

        /* 비밀번호 찾기 후 이메일 인증 화면 임시 구현 */
        $("div#emailConfirm").hide();

        $("input#email").keyup(function(e) {
            if(e.keyCode == 13) {
                goPwFind();
            }
        });

    });

    function goPwFind() {

        const userid = $("input#userid").val().trim();
        const email = $("input#email").val().trim();

        if(userid == "") {
            alert("아이디를 입력해주세요!");
            return;
        }

        if(userid.length < 5 || userid.length > 20) {
            alert("아이디는 5~20자 이내로 입력해주세요!");
            return;
        }

        if(email == "") {
            alert("이메일을 입력해주세요!");
            return;
        }

        const regExp_email = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);  
        const bool = regExp_email.test(email);

        if(!bool) {
            alert("올바른 이메일 형식이 아닙니다.\n이메일을 다시 입력해주세요.");
            $("input#email").val("");
            return;
        }

        /* 비밀번호 찾기 후 이메일 인증 임시 구현 */
        $("div#emailConfirm").show();
    }
    
    function goPwUpdate() {
    	const input_confirmCode = $("input[name='input_confirmCode']").val().trim();
    	
    	if(input_confirmCode == "") {
    		alert("인증번호를 입력해주세요.");
    		return;
    	}
    	
    	alert("인증이 완료되었습니다.\n비밀번호 변경 페이지로 이동합니다.");
    	location.href = "<%=ctxPath%>/pwFindEnd.trip";
    }
</script>

<div class="container">
    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">비밀번호 찾기</h2>

        <form name="pwdFindFrm">
        
            <div class="d-flex justify-content-center mt-5">
               <div class="form-check form-check-inline">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio1" value="member" checked>
                 <label class="form-check-label" for="inlineRadio1">일반회원</label>
               </div>
               <div class="form-check form-check-inline pl-3">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio2" value="company">
                 <label class="form-check-label" for="inlineRadio2">업체회원</label>
               </div>
               <div class="form-check form-check-inline pl-3">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio3" value="admin">
                 <label class="form-check-label" for="inlineRadio3">관리자</label>
               </div>
            </div>
        
        
            <div class="info">
                <input type="text" name="userid" id="userid" placeholder="아이디">
                <input type="text" name="email" id="email" placeholder="이메일">
            </div>

            <div class="mt-5 text-center">
                <button type="button" class="btn" id="pwFindBtn" onclick="goPwFind()">비밀번호 찾기</button>
            </div>
        </form>

        <div id="emailConfirm" class="mt-5" style="margin-bottom: 20%;">
            <div class="text-center mb-3">
                <span><span class="font-weight-bold">kimdy@naver.com</span> 으로 메일이 발송되었습니다.</span>
            </div>
            <div style="position: relative;">
                <input type="text" name="input_confirmCode" placeholder="인증번호 입력">
                <button type="button" class="btn btn-success" id="confirmBtn" onclick="goPwUpdate()">인증하기</button>
            </div>
        </div>

    </div>
</div>
