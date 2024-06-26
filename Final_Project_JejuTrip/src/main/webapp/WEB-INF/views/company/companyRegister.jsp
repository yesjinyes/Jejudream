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
    <title>업체 회원가입</title>

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
    <link rel="stylesheet" href="<%=ctxPath%>/resources/css/company/companyRegister.css">

    <%-- Main JS --%>
    <script src="<%=ctxPath%>/resources/js/company/companyRegister.js"></script>
    
</head>

<body>
    <div class="container">
        <div class="m-5">

            <div style="width: 80%; margin: 7% auto;">
                <h2 style="margin-top: 20%;" class="font-weight-bold">업체 회원가입</h2>
                <h5>가입을 통해 다양한 서비스를 제공해보세요!</h5>
            </div>

            <form name="registerFrm">

                <div class="info">
        
                    <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
        
                    <div class="info_block">
                        <input type="text" name="companyid" id="companyid" placeholder="업체 아이디 입력 (5~20자)">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <input type="text" name="company_name" id="company_name" placeholder="업체명 입력" maxlength="20">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <input type="password" name="pw" id="pw" placeholder="비밀번호 입력 (영문, 숫자, 특수문자 포함 8~15자)">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <input type="password" name="pwCheck" id="pwCheck" placeholder="비밀번호 재입력">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <input type="text" name="email" id="email" placeholder="업체 이메일 주소">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <input type="text" name="mobile" id="mobile" placeholder="업체 연락처 입력 ('-' 제외 입력)">
                        <span class="error">유효하지 않은 연락처입니다.</span>
                    </div>
                </div>
        
                <div style="text-align: center; margin-bottom: 13%;">
                    <button type="button" class="btn" id="registerBtn" onclick="goRegister()">가입하기</button>
                </div>

            </form>

        </div>
    </div>
</body>

</html>