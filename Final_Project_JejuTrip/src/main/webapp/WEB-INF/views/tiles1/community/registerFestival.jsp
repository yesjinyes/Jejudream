<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>    
    

<style>
    body {
        font-family: "Noto Sans KR", sans-serif;
        font-optical-sizing: auto;
    }
    .container {
    width: 100%;
    max-width: 800px;
    margin: 5% auto;
    border: solid 1px rgba(0, 0, 0, 0.15);
    border-radius: 40px;
    box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
    overflow: hidden;
    position: relative;
	}

	.ano_in{
	
		margin-left: 15%;
	}

	
	.info {
	    width: 100%;
	}
	
	.info_block {
		
	    margin-bottom: 1em;

	}
	
	.error {
	    color: red;
	}
	
	.input_error {
	    border: solid 1px red !important;
	}
	
	button#registerBtn {
	    width: 50%;
	    
	    margin: 1% auto;
	    border-radius: 8px;
	    background-color: #ff5000;
	    color: white;
	}
	
	button {
	    margin: 5px;
	}
	
	
	div.info_block > input  {
	    display: block;
	    width: 50%;
	    
	    height: 50px;
	    margin-left: 15%;
	    border-radius: 8px;
	    border: solid 1px rgba(15, 19, 42, .1);
	    padding: 0 0 0 15px;
	    font-size: 16px;
	    color:gray;
	}
	

</style>
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
            
            <div class="info_block ano_in mt-3">
            	<h4 style="margin-top: 1%;" >지역구분</h4>
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
	        
			
            <div class="info_block ano_in mt-3">
                <textarea name="lodging_content" id="lodging_content" placeholder="숙소 설명"></textarea>
                <span class="error"></span>
            </div>
            <div class="mt-3 ano_in">
                <input type="file" name="attach" id="attach">
                <span class="error"></span>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goRegister('<%=ctxPath%>')">등록하기</button>
        </div>

    </form>

</div>    
    