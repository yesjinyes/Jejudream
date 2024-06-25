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
    <title>아이디 찾기</title>

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
            width: 40%;
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

        button#idFindBtn {
            width: 100%;
            height: 50px;
            margin: 1% auto;
            border-radius: 8px;
            border-color: #ff5000;
            color: #ff5000;
        }

        button#idFindBtn:hover {
            background-color: #ff5000;
            color: white;
        }

        span#idFindResult {
            font-size: 15pt;
        }

        div#idFindDiv {
            border: solid 1px rgba(0, 0, 0, 0.15);
            border-radius: 20px;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function() {
            $("input#email").keyup(function(e) {
                if(e.keyCode == 13) {
                    goIdFind();
                }
            });
        });

        function goIdFind() {
            const name = $("input#name").val().trim();
            const email = $("input#email").val().trim();

            if(name == "") {
                alert("성명을 입력해주세요!");
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

            /* 아이디 찾기 완료 시 화면 임시 구현 */
            let v_html = `<span id="idFindResult">김다영 님의 아이디</span>
                            <div class="mt-4 p-5" id="idFindDiv">
                            <span class="font-weight-bold" style="font-size: 16pt;">kimdy</span>
                            </div>`;
            $("div.info").html(v_html).addClass("text-center");

            v_html = `<button type="button" class="btn btn-success mr-2">로그인하러 가기</button>
                        <button type="button" class="btn btn-outline-success">비밀번호 찾기</button>`;

            $("div.mt-5").html(v_html);
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="m-5">
            <div style="width: 80%; margin: 7% auto;">
                <h2 style="margin-top: 20%;" class="font-weight-bold">아이디 찾기</h2>

                <form name="idFindFrm">
                    <div class="info">
                        <input type="text" name="name" id="name" placeholder="성명">
                        <input type="text" name="email" id="email" placeholder="이메일">
                    </div>

                    <div class="mt-5 text-center" style="margin-bottom: 20%;">
                        <button type="button" class="btn" id="idFindBtn" onclick="goIdFind()">아이디 찾기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>