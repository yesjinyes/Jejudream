<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>    
    

<div class="container">

    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">축제 및 행사 등록</h2>
       
    </div>

    <form name="registerFrm" enctype="multipart/form-data">

        <div class="info">

            <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
            <div class="info_block">
                <input type="text" name="title_name" id="title_name" placeholder="축제 명칭 입력">
                <span class="error"></span>
            </div>
            
            <div class="info_block mt-3">
				<select name="local_status">
					<option selected>지역구분</option>
					<option>제주시 시내</option>
					<option>제주시 서부</option>
					<option>제주시 동부</option>
					<option>서귀포시 시내</option>
					<option>서귀포 동부</option>
					<option>서귀포 서부</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
                <input type="text" name="lodging_tell" id="lodging_tell" placeholder="숙소 연락처" maxlength="20">
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
                <textarea name="lodging_content" id="lodging_content" placeholder="숙소 설명"></textarea>
                <span class="error"></span>
            </div>
            <div class="mt-3">
                <input type="file" name="attach" id="attach">
                <span class="error"></span>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">등록하기</button>
        </div>

    </form>

</div>    
    