<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath();%>


<style type="text/css">

body {
    font-family: "Noto Sans KR", sans-serif;
    font-optical-sizing: auto;
}

@media screen and (min-width: 768px) and (max-width: 1024px) {
    div.container {
        width: 70vw !important;
    }
}

@media screen and (max-width: 768px) {
    div.container {
        width: 80vw !important;
    }
}

@media screen and (max-width: 425px) {
    div.container {
        width: 100vw !important;
        margin-top: 0 !important;
    }

    h2 {
        font-size: 1.4rem !important;
    }

    h5 {
        font-size: 1rem !important;
    }

    div.info_block > input,
    input#email,
    span.error {
        font-size: 0.8rem !important;
    }
}

div.container {
    width: 45%;
    margin: 5% auto;
    border: solid 1px rgba(0, 0, 0, 0.15);
    border-radius: 40px;
    box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
}

div.info {
    border: solid 0px red;
    width: 80%;
    margin: 10% auto;
}

div.info_block > input:first-child {
    display: block;
    width: 100%;
    max-width: 680px;
    height: 50px;
    margin: 0 auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
}

div.info_block > select {
    display: block;
    width: 100%;
    max-width: 680px;
    height: 50px;
    margin: 0 auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
    color:gray;
}

div.info_block > textarea {
    display: block;
    width: 100%;
    max-width: 680px;
    height: 150px;
    margin: 0 auto;
    border-radius: 8px;
    border: solid 1px rgba(15, 19, 42, .1);
    padding: 0 0 0 15px;
    font-size: 16px;
    color:gray;
}

span.error {
    font-size: 11pt;
    margin: 0 3%;
    color: red;
}

/* 유효성 검사 에러 시 input 테두리 색 변경 */
.input_error {
    border: solid 1px red !important;
}

button#registerBtn {
    width: 25%;
    height: 50px;
    margin: 1% 5% 1%;
    border-radius: 8px;
    background-color: #ff5000;
    color: white;
}

div.convenient{
    font-size: 17pt;
    margin-bottom: 10px;
    margin-left: 10px;
    color:gray;
}

label{
    margin-left: 10px;
    color:gray;
}



</style>



<script type="text/javascript">


	let checkPlay_name = false;
	let checkPlay_tell = false;
	let checkPlay_content = false;
	let checkPlay_businesshours = false;
	
	
	$(document).ready(function(){
		$("span.error").hide();
		//console.log("play_address" ,play_address);	
	    
		// 주소 클릭 시
	    $('input#play_address').click(function () {

	        new daum.Postcode({
	            oncomplete: function (data) {

	                let addr = '';

	                if (data.userSelectedType === 'R') {
	                    addr = data.roadAddress;
	                } else {
	                    addr = data.jibunAddress;
	                }

	                document.getElementById("play_address").value = addr;
	                document.getElementById("detail_address").focus();
	            }
	        }).open();

	    });
		
	    // ===== 숙소명 유효성 검사 =====
	    $("input#play_name").blur((e) => {

	        const play_name = $(e.target).val().trim();

	        if(play_name == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("즐길거리 명을 입력해주세요.");
	            checkPlay_name = false;
	        } 
			else {
	            $(e.target).removeClass("input_error");
	            $(e.target).next().hide();
	            checkPlay_name = true;
	        }
	    });

		// ===== 휴대폰 유효성 검사 =====
	    $("input#play_mobile").blur((e) => {

			const play_mobile = $(e.target).val().trim();

			if(play_mobile == "") {
				$(e.target).addClass("input_error");
				$(e.target).next().show();
				$(e.target).next().text("업체 연락처를 입력해주세요.");
				checkPlay_tell = false;

			} else {
				$(e.target).removeClass("input_error");
				$(e.target).next().hide();
				checkPlay_tell = true;
			}

		});
	
	    // ===== 영업시간 유효성 검사 =====
	    $("input#play_businesshours").blur((e) => {

	        const play_businesshours = $(e.target).val().trim();

	        if(play_businesshours == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).next().show();
	            $(e.target).next().text("영업시간을 입력해주세요.");
	            checkPlay_businesshours = false;

	        } 
			else {
	            $(e.target).removeClass("input_error");
	            $(e.target).next().hide();
	            checkPlay_businesshours = true;
	        }
	    });


		// ===== 즐길거리설명 유효성 검사 =====
	    $("textarea#play_content").blur((e) => {

			const play_content = $(e.target).val().trim();

			if(play_content == "") {
				$(e.target).addClass("input_error");
				$(e.target).next().show();
				$(e.target).next().text("즐길거리 설명을 입력해주세요.");
				checkPlay_content = false;

			} 
			else {
				$(e.target).removeClass("input_error");
				$(e.target).next().hide();
				checkPlay_content = true;
			}
		});

	}); // end of $(document).ready(function(){
		
	function goeditPlay(ctxPath) {

		let queryString = $("form[name='editPlayFrm']").serialize();
		
	       // 숙소 등록 처리하기.
	    const frm = document.editPlayFrm;
	   	frm.method = "post";
	   	frm.action = "<%= ctxPath%>/editPlayEnd.trip";
	   	frm.submit();
	  

	}
	
	
	
	
	
</script>

<div class="container">

    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">즐길거리 등록</h2>
        <h5>얏호~~!! 씬난다~~~ </h5>
    </div>

    <form name="editPlayFrm" enctype="multipart/form-data">

        <div class="info">

            <!-- 유효성 검사 시 input 테두리 색 변경 및 span error 띄우기 -->
            <div class="info_block">
                <input type="text" name="play_name" id="play_name" value="${requestScope.playvo.play_name}">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="play_category">
					<option selected>${requestScope.playvo.play_category}</option>
					<option>관광지</option>
					<option>전시회</option>
					<option>체험</option>
					<option>기타</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
                <input type="text" name="play_businesshours" id="play_businesshours" value="${requestScope.playvo.play_businesshours}" maxlength="20">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
				<select name="local_status">
					<option selected>${requestScope.playvo.local_status}</option>
					<option>제주시 시내</option>
					<option>제주시 서부</option>
					<option>제주시 동부</option>
					<option>서귀포시</option>
					<option>서귀포 동부</option>
					<option>서귀포 서부</option>
				</select>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
                <input type="text" name="play_mobile" id="play_mobile" value="${requestScope.playvo.play_mobile}" maxlength="20">
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
	            <input type="text" name="play_address" id="play_address" value="${requestScope.playvo.play_address}">
	        </div>
	        <div class="info_block mt-3">
	            <input type="text" name="detail_address" id="detail_address" placeholder="상세주소">
				<span class="error"></span>
	        </div>
            <div class="info_block mt-3">
                <textarea name="play_content" id="play_content" >${requestScope.playvo.play_content}</textarea>
                <span class="error"></span>
            </div>
            <div class="mt-3">
                <input type="file" name="attach" id="attach">
                <span class="error"></span>
            </div>
			<input type="hidden" name="play_code" id="play_code" value="${requestScope.playvo.play_code}">
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goeditPlay('<%=ctxPath%>')">수정하기</button>
            <button type="button" class="btn" id="registerBtn" onclick="javascript:history.back()">취소</button>  
        </div>
    </form>

</div>