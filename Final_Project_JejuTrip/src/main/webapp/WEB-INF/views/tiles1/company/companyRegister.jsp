<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<%-- Main CSS --%>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/company/companyRegister.css">

<%-- Main JS --%>
<script src="<%=ctxPath%>/resources/js/company/companyRegister.js"></script>

<div class="container">

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
                <span class="error"></span>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister()">가입하기</button>
        </div>

    </form>

</div>
