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
    <title>비밀번호 찾기</title>

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
                return;
            }

            /* 비밀번호 찾기 후 이메일 인증 임시 구현 */
            $("div#emailConfirm").show();
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="m-4">
            <div style="width: 80%; margin: 7% auto;">
                <h2 style="margin-top: 20%;" class="font-weight-bold">비밀번호 찾기</h2>

                <form name="pwdFindFrm">
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
                        <button type="button" class="btn btn-success" id="confirmBtn">인증하기</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>