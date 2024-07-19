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

div.info-content {
  display: flex;
}

div.info-content > span {
  border: solid 0px red;
  width: 18%;
  padding: 1.5% 0 0 2%;
  font-weight: 600;
  font-size: 13pt;
  color: #ff7433;
}

div.info_block > .info-content > input {
  display: block;
  width: 80%;
  height: 50px;
  border-radius: 8px;
  border: solid 1px rgba(15, 19, 42, .1);
  padding: 0 0 0 15px;
  font-size: 16px;
  color: #404040;
}

div.info_block > .info-content  > select {
  display: block;
  width: 80%;
  height: 50px;
  border-radius: 8px;
  border: solid 1px rgba(15, 19, 42, .1);
  padding: 0 0 0 15px;
  font-size: 16px;
  color: gray;
}

div.info_block > .info-content  > textarea {
  display: block;
  width: 80%;
  max-width: 680px;
  height: 150px;
  border-radius: 8px;
  border: solid 1px rgba(15, 19, 42, .1);
  padding: 0 0 0 15px;
  font-size: 16px;
  color: #404040;
}

span.error {
  font-size: 11pt;
  margin-left: 20%;
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

	let checkFood_name = false;
	let checkFood_businesshours = false;
	let checkFood_mobile = false;
	let checkFood_address = false;
	let checkFood_content = false;

	
	$(document).ready(function(){
		
		$("span.error").hide();
		
	    // == 맛집 이름 유효성 검사 == //
	    $("input#food_name").blur((e) => {

	        const food_name = $(e.target).val().trim();

	        if(food_name == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).parent().next().show();
	            $(e.target).parent().next().text("맛집 이름을 입력해주세요.");
	            checkFood_name = false;
	        } 
			else {
	            $(e.target).removeClass("input_error");
	            $(e.target).parent().next().hide();
	            checkFood_name = true;
	        }
	    });

	    // == 영업시간 유효성 검사 == //
	    $("input#food_businesshours").blur((e) => {

	        const food_businesshours = $(e.target).val().trim();

	        if(food_businesshours == "") {
	            $(e.target).addClass("input_error");
	            $(e.target).parent().next().show();
	            $(e.target).parent().next().text("영업시간을 입력해주세요.");
	            checkFood_businesshours = false;
	        } 
			else {
	            $(e.target).removeClass("input_error");
	            $(e.target).parent().next().hide();
	            checkFood_businesshours = true;
	        }
	    });

		// == 전화번호 유효성 검사 == //
	    $("input#food_mobile").blur((e) => {

			const food_mobile = $(e.target).val().trim();

			if(food_mobile == "") {
				$(e.target).addClass("input_error");
				$(e.target).parent().next().show();
				$(e.target).parent().next().text("전화번호를 입력해 주세요.");
				checkFood_mobile = false;

			}
			else {
				$(e.target).removeClass("input_error");
				$(e.target).parent().next().hide();
				checkFood_mobile = true;
			}
		});

		// == 주소 클릭 시 주소입력 팝업 띄우기 == //
	    $('input#food_address').click(function () {
	        new daum.Postcode({
	            oncomplete: function (data) {

	                let addr = '';

	                if (data.userSelectedType === 'R') {
	                    addr = data.roadAddress;
	                }
	                else {
	                    addr = data.jibunAddress;
	                }

	                document.getElementById("food_address").value = addr;
	            }
	        }).open();
	    });
	
		// == 상세 설명 유효성 검사 == //
	    $("textarea#food_content").blur((e) => {

			const food_content = $(e.target).val().trim();

			if(food_content == "") {
				$(e.target).addClass("input_error");
				$(e.target).parent().next().show();
				$(e.target).parent().next().text("맛집 상세 설명을 입력해주세요.");
				checkFood_content = false;
			} 
			else {
				$(e.target).removeClass("input_error");
				$(e.target).parent().next().hide();
				checkFood_content = true;
			}
		});

		///////////////////////////////////////////////////////////////////////////////

		const category_selected = $("selectbox#category-selectbox option:selected").text();
		console.log("선택된 카테고리 확인 => " + category_selected);
		
		$("input:text[id='food_category']").html(category_selected);
		
		
		
	}); // end of $(document).ready(function(){})----------------------------------
		
	
	function goEdit() {

		let queryString = $("form[name='editFoodFrm']").serialize();
		
	    const frm = document.editFoodFrm;
	    
	   	frm.method = "post";
	   	//frm.action = "<%= ctxPath%>/editFoodEnd.trip";
	   	//frm.submit();
	}
	
	
	
	
	
</script>

<div class="container">

    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">맛집 수정</h2>
    </div>

    <form name="editFoodFrm" enctype="multipart/form-data">

        <div class="info">
            <div class="info_block">
            	<div class="info-content">
	            	<span>맛집 이름</span>
	                <input type="text" name="food_name" id="food_name" value="${requestScope.foodstorevo.food_name}">
                </div>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
            	<div class="info-content">
	            	<span>카테고리</span>
					<select id="category-selectbox" name="local_status">
						<%-- <option selected>${requestScope.foodstorevo.food_category}</option> --%>
						<option>한식</option>
						<option>일식</option>
						<option>양식</option>
						<option>중식</option>
						<option>기타</option>
						<option>카페</option>
					</select>
					<input type="text" name="food_category" id="food_category" />
	        	</div>
            </div>
            <div class="info_block mt-3">
            	<div class="info-content">
	            	<span>지역구분</span>
					<select name="local_status">
						<option selected>${requestScope.foodstorevo.local_status}</option>
						<option>제주시 시내</option>
						<option>제주시 서부</option>
						<option>제주시 동부</option>
						<option>서귀포시</option>
						<option>서귀포 동부</option>
						<option>서귀포 서부</option>
					</select>
	        	</div>
            </div>
            <div class="info_block mt-3">
            	<div class="info-content">
	            	<span>영업시간</span>
	                <input type="text" name="food_businesshours" id="food_businesshours" value="${requestScope.foodstorevo.food_businesshours}" maxlength="20">
            	</div>
                <span class="error"></span>
            </div>
            <div class="info_block mt-3">
            	<div class="info-content">
	            	<span>전화번호</span>
	                <input type="text" name="food_mobile" id="food_mobile" value="${requestScope.foodstorevo.food_mobile}" maxlength="20">
	                <span class="error"></span>
                </div>
            </div>
            <div class="info_block mt-3">
            	<div class="info-content">
	            	<span>주소</span>
		            <input type="text" name="food_address" id="food_address" value="${requestScope.foodstorevo.food_address}" readonly="readonly">
	            </div>
            	<span class="error"></span>
	        </div>
            <div class="info_block mt-3">
            	<div class="info-content">
            		<span>상세설명</span>
	                <textarea name="food_content" id="food_content" style="padding-top: 1.5%;">${requestScope.foodstorevo.food_content}</textarea>
                </div>
                <span class="error"></span>
            </div>
            <div class="mt-3">
                <input type="file" name="attach" id="attach">
            </div>
            <span class="error"></span>
			<input type="hidden" name="food_store_code" id="food_store_code" value="${requestScope.foodstorevo.food_store_code}">
        </div>

        <div style="text-align: center; margin-bottom: 13%;">
            <button type="button" class="btn" id="registerBtn" onclick="goEdit()">수정하기</button>
            <button type="button" class="btn" id="registerBtn" onclick="javascript:history.back()">취소</button>  
        </div>
    </form>

</div>