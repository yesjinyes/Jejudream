<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<%-- Main CSS --%>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/admin/foodstoreRegister.css">

<div class="container">

    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">맛집 등록</h2>
    </div>

    <form name="registerFrm" enctype="multipart/form-data">

        <div class="info">

            <div class="info_block">
                <input type="text" name="food_name" id="food_name" placeholder="식당명 입력">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="food_category">
					<option selected>음식 구분</option>
					<option>한식</option>
					<option>일식</option>
					<option>중식</option>
					<option>양식</option>
					<option>카페</option>
					<option>기타</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="local_status">
					<option selected>지역 구분</option>
					<option>제주 시내</option>
					<option>제주시 서부</option>
					<option>제주시 동부</option>
					<option>서귀포시</option>
					<option>서귀포 동부</option>
					<option>서귀포 서부</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
                <input type="text" name="food_mobile" id="food_mobile" placeholder="식당 연락처 ('-' 제외 입력)" maxlength="20">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
            	<div class="d-flex">
	                <select name="starthours">
	                	<option selected>영업 시작 시간</option>
	                	<option>08:00</option>
	                	<option>08:30</option>
	                	<option>09:00</option>
	                	<option>09:30</option>
	                	<option>10:00</option>
	                	<option>10:30</option>
	                	<option>11:00</option>
	                	<option>11:30</option>
	                	<option>12:00</option>
	                	<option>12:30</option>
	                	<option>13:00</option>
	                	<option>13:30</option>
	                	<option>14:00</option>
	                	<option>14:30</option>
	                	<option>15:00</option>
	                	<option>15:30</option>
	                	<option>16:00</option>
	                	<option>16:30</option>
	                	<option>17:00</option>
	                	<option>17:30</option>
	                	<option>18:00</option>
	                	<option>18:30</option>
	                	<option>19:00</option>
	                	<option>19:30</option>
	                	<option>20:00</option>
	                	<option>20:30</option>
	                	<option>21:00</option>
	                	<option>21:30</option>
	                	<option>22:00</option>
	                	<option>22:30</option>
	                	<option>23:00</option>
	                </select>
	                <span style="font-size: 14pt; margin-top: 1%;">~</span>
	                <select name="endhours">
	                	<option selected>영업 종료 시간</option>
	                	<option>08:00</option>
	                	<option>08:30</option>
	                	<option>09:00</option>
	                	<option>09:30</option>
	                	<option>10:00</option>
	                	<option>10:30</option>
	                	<option>11:00</option>
	                	<option>11:30</option>
	                	<option>12:00</option>
	                	<option>12:30</option>
	                	<option>13:00</option>
	                	<option>13:30</option>
	                	<option>14:00</option>
	                	<option>14:30</option>
	                	<option>15:00</option>
	                	<option>15:30</option>
	                	<option>16:00</option>
	                	<option>16:30</option>
	                	<option>17:00</option>
	                	<option>17:30</option>
	                	<option>18:00</option>
	                	<option>18:30</option>
	                	<option>19:00</option>
	                	<option>19:30</option>
	                	<option>20:00</option>
	                	<option>20:30</option>
	                	<option>21:00</option>
	                	<option>21:30</option>
	                	<option>22:00</option>
	                	<option>22:30</option>
	                	<option>23:00</option>
	                </select>
            	</div>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
	            <input type="text" name="address" id="address" placeholder="주소">
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="detail_address" id="detail_address" placeholder="상세주소">
				<span class="error"></span>
	        </div>
            <div class="info_block mt-3">
                <textarea name="food_content" id="food_content" placeholder="식당 설명"></textarea>
                <span class="error"></span>
            </div>
            <div class="mt-3">
                <input type="file" name="food_main_img" id="food_main_img">
                <span class="error"></span>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">등록하기</button>
        </div>

    </form>

</div>