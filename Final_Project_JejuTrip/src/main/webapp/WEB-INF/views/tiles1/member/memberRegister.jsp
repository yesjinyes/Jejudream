<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<%-- Main CSS --%>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/member/memberRegister.css">

<%-- Main JS --%>
<script src="<%=ctxPath%>/resources/js/member/memberRegister.js"></script>

<div class="container">
	
	<div style="width: 80%; margin: 7% auto;">
	    <h2 style="margin-top: 20%;" class="h2 font-weight-bold">회원가입</h2>
	    <h5 class="h5">가입을 통해 다양한 서비스를 만나보세요!</h5>
	</div>
	
	<form name="registerFrm">
	
	    <div class="info">
	
	        <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
	
	        <div class="info_block">
	            <input type="text" name="userid" id="userid" placeholder="아이디 입력 (5~20자)">
	            <span class="error"></span>
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="user_name" id="user_name" placeholder="성명 입력" maxlength="20">
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
	        <div class="mt-3">
	            <div class="d-flex">
	                <input type="text" name="email_id" id="email_id" class="mr-3" placeholder="이메일">
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
	            <input type="text" class="datepicker" name="birthday" id="birthday" placeholder="생년월일">
	            <div id="gender_block">
	                <label id="label_male">남자
	                    <input type="radio" checked="checked" name="gender" value="1">
	                    <span class="checkmark"></span>
	                </label>
	                <label id="label_female">여자
	                    <input type="radio" name="gender" value="2">
	                    <span class="checkmark"></span>
	                </label>
	            </div>
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="mobile" id="mobile" placeholder="휴대폰 번호 입력 ('-' 제외 11자리 입력)">
	            <span class="error"></span>
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="address" id="address" placeholder="주소">
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="detail_address" id="detail_address" placeholder="상세주소">
	        </div>
	    </div>
	
	    <div style="text-align: center; margin-bottom: 13%;">
	        <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">가입하기</button>
	    </div>
	
	</form>

</div>
