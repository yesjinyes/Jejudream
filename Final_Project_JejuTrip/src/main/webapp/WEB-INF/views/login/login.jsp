<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    
    <%-- bootstrap CSS --%>
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" >
	
	<%-- Google font, Font Awesome --%>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

	<%-- Optional JavaScript --%>
	<script type="text/javascript" src="<%=ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%=ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
	
    <%-- Main CSS --%>
    <link rel="stylesheet" href="<%=ctxPath%>/resources/css/login/login.css">

    <script type="text/javascript">
        $(document).ready(function() {

        	$("span#idFind").click(function() {
        		location.href = "<%=ctxPath%>/idFind.trip";
        	});
        	
        	$("span#pwFind").click(function() {
        		location.href = "<%=ctxPath%>/pwFind.trip";
        	});
        	
        	$("span#register").click(function() { // 일반 회원가입으로 임시 이동
        		location.href = "<%=ctxPath%>/memberRegister.trip";
        	});
        	
        });

        function goLogin() {

            const userid = $("input#userid").val().trim();
            const pw = $("input#pw").val().trim();

            if(userid == "") {
                alert("아이디를 입력해주세요!");
                return;
            }

            if(pw == "") {
                alert("비밀번호를 입력해주세요!");
                return;
            }

        }
    </script>
</head>
<body>
    <div class="container">
        <div class="m-4">
            <div style="width: 80%; margin: 7% auto;">
                <h2 style="margin-top: 20%;" class="font-weight-bold">로그인</h2>
                <h5>로그인 후 다양한 서비스를 이용하실 수 있습니다.</h5>

                <form name="loginFrm">
                    <div class="info">
                        <input type="text" name="userid" id="userid" placeholder="아이디">
                        <input type="password" name="pw" id="pw" placeholder="비밀번호">
                    </div>
                    <div style="margin-bottom: 2%;">
                        <input type="checkbox" id="saveid">
                        <span class="checkbox_icon"></span>
                        &nbsp;&nbsp;<label for="saveid">아이디 저장</label>
                    </div>
                    <div class="mb-4">
                        <button type="button" class="btn" id="loginBtn" onclick="goLogin()">로그인</button>
                    </div>

                    <div class="d-flex" style="margin-bottom: 20%;">
                        <div style="width: 70%;">
                            <span id="idFind" style="margin-right: 5%;">아이디 찾기</span> | 
                            <span id="pwFind" style="margin-left: 5%;">비밀번호 찾기</span>
                        </div>
                        <div style="width: 30%;">
                            <span id="register" style="margin-left: 56%;">회원가입</span>
                        </div>
                    </div>
                </form>
            </div>


        </div>
    </div>
</body>
</html>