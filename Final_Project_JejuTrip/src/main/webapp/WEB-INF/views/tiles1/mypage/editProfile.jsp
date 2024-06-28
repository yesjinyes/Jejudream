<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> 

<%
    String ctxPath = request.getContextPath();
%>   

<%-- Bootstrap CSS --%>
<link rel="stylesheet" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

     
<style type="text/css">


div#divEditFrm {
    text-align: center;
}

#tblMemberEdit {
    border: solid 1px #d9d9d9;
    border-radius: 10px 10px 0px 0px;
    width: 98%;
    margin: 1% 2%;
    text-align: center;
}


table#tblMemberEdit th {
    height: 80px;
    background-color: #ff8000;
    border-radius: 10px 10px 0px 0px;
    font-size: 14pt;
}

table#tblMemberEdit td {
    line-height: 400%;
    font-size: 13px;
    padding: 1.2% 0;
}

span.star {
    color: red;
    font-weight: bold;
    font-size: 13pt;
}

table#tblMemberEdit > tbody > tr > td:first-child {
    font-weight: bold;
    font-size:15px;
    text-align: center;
    min-width: 130px;
}

table#tblMemberEdit > tbody > tr > td:nth-child(2) {
    text-align: left;
}


button#postcodecheck,
button#emailcheck{
	width: 110px;
	font-size: 12px;
	margin-left: 10px;
    
}


#tblMemberEdit
#tblMemberEdit > tbody > tr:nth-child(9) > td
/* #tblMemberEdit > tbody > tr:nth-child(6) > td:nth-child(2)  */{
    display: flex;
    justify-content: center;
}

.customWidth {
    width: 180px;
    height: 30px;
    
    
}
#address_extra {
    width: 280px;
}

</style>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


<script type="text/javascript">

	let b_emailcheck_click = false;
	//"이메일중복확인" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도
	let b_email_change = false;
	//이메일값을 변경했는지 여부를 알아오기 위한 용도

	$(document).ready(function(){
	
		$("span.error").hide();
		
$("input#name").blur( (e) => {
			
			const name = $(e.target).val().trim();
			if(name == "") {
				// 입력하지 않거나 공백만 입력했을 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$(e.target).prop("disabled", false); 
			    $(e.target).parent().find("span.error").show();
				$(e.target).val("").focus(); 
			}
			else {
				// 공백이 아닌 글자를 입력했을 경우
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
		
		});// 아이디가 name 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	
		$("input#password").blur( (e) => {
		    const regExp_pwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g); 
		    // 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성 
		    
		    const bool = regExp_pwd.test($(e.target).val());	
			
			if(!bool) {
				// 암호가 정규표현식에 위배된 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$(e.target).prop("disabled", false); 
				
			    $(e.target).parent().find("span.error").show();
				$(e.target).val("").focus(); 
			}
			else {
				// 암호가 정규표현식에 맞는 경우 
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
			
		});// 아이디가 pwd 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	
		$("input#pwdcheck").blur( (e) => {
			
			if( $("input#password").val() != $(e.target).val() ) {
				// 암호와 암호확인값이 틀린 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$("input#password").prop("disabled", false);
				$(e.target).prop("disabled", false); 
			    $(e.target).parent().find("span.error").show();
				$("input#password").focus();
			}
			else {
				// 암호와 암호확인값이 같은 경우
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
			
		});// 아이디가 pwdcheck 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.	
	

		$("input#email").blur( (e) => {
		    const regExp_email = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);  
		    // 이메일 정규표현식 객체 생성 
		    
		    const bool = regExp_email.test($(e.target).val());	
			
			if(!bool) {
				// 이메일이 정규표현식에 위배된 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$(e.target).prop("disabled", false); 
			    $(e.target).parent().find("span.error").show();
				$(e.target).val("").focus(); 
			}
			else {
				// 이메일이 정규표현식에 맞는 경우 
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
			
		});// 아이디가 email 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	
		$("input#hp2").blur( (e) => {
		    const regExp_hp2 = new RegExp(/^[1-9][0-9]{3}$/);  
		    // 연락처 국번( 숫자 4자리인데 첫번째 숫자는 1-9 이고 나머지는 0-9) 정규표현식 객체 생성 
		    
		    const bool = regExp_hp2.test($(e.target).val());	
			
			if(!bool) {
				// 연락처 국번이 정규표현식에 위배된 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$(e.target).prop("disabled", false); 
			    $(e.target).parent().find("span.error").show();
				$(e.target).val("").focus(); 
			}
			else {
				// 연락처 국번이 정규표현식에 맞는 경우 
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
			
		});// 아이디가 hp2 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	
		$("input#hp3").blur( (e) => {
		    const regExp_hp3 = new RegExp(/^\d{4}$/);  
		    // 숫자 4자리만 들어오도록 검사해주는 정규표현식 객체 생성 
		    
		    const bool = regExp_hp3.test($(e.target).val());	
			
			if(!bool) {
				// 마지막 전화번호 4자리가 정규표현식에 위배된 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$(e.target).prop("disabled", false); 
			    $(e.target).parent().find("span.error").show();
				$(e.target).val("").focus(); 
			}
			else {
				// 마지막 전화번호 4자리가 정규표현식에 맞는 경우 
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
			
		});// 아이디가 hp3 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	
		$("input#postcode").blur( (e) => {
		    const regExp_postcode = new RegExp(/^\d{5}$/);  
		    // 숫자 5자리만 들어오도록 검사해주는 정규표현식 객체 생성 
		    
		    const bool = regExp_postcode.test($(e.target).val());	
			
			if(!bool) {
				// 우편번호가 정규표현식에 위배된 경우 
				$("table#tblMemberEdit :input").prop("disabled", true);  
				$(e.target).prop("disabled", false); 
			    $(e.target).parent().find("span.error").show();
				$(e.target).val("").focus(); 
			}
			else {
				// 우편번호가 정규표현식에 맞는 경우 
				$("table#tblMemberEdit :input").prop("disabled", false);
			    $(e.target).parent().find("span.error").hide();
			}
			
		});// 아이디가 postcode 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
	
	
		// === "우편번호찾기"를 클릭했을 때 이벤트 처리하기 === //
		$("span#postcodecheck").click(function(){
			
			// 주소를 쓰기가능 으로 만들기
			$("input#address").removeAttr("readonly");
	     // 참고항목을 쓰기가능 으로 만들기
	     $("input#address_extra").removeAttr("readonly");
	     
	     new daum.Postcode({
	         oncomplete: function(data) {
	             // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	             // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	             // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	             let addr = ''; // 주소 변수
	             let extraAddr = ''; // 참고항목 변수
	
	             //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	             if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                 addr = data.roadAddress;
	             } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                 addr = data.jibunAddress;
	             }
	
	             // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	             if(data.userSelectedType === 'R'){
	                 if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                     extraAddr += data.bname;
	                 }
	                 if(data.buildingName !== '' && data.apartment === 'Y'){
	                     extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                 }
	                 if(extraAddr !== ''){
	                     extraAddr = ' (' + extraAddr + ')';
	                 }
	                 document.getElementById("address_detail").value = extraAddr;
	             } else {
	                 document.getElementById("address_detail").value = '';
	             }
	
	             document.getElementById('postcode').value = data.zonecode;
	             document.getElementById("address").value = addr;
	             document.getElementById("address_detail").focus();
	         }
	     }).open();
	     
	     // 주소를 읽기전용(readonly) 로 만들기
	     $("input#address").attr("readonly", true);
	     $("input#address_extra").attr("readonly", true);
		});
	
		// "이메일중복확인" 을 클릭했을 때 이벤트 처리하기
		$("span#emailcheck").click(function(){
			 
			 b_emailcheck_click = true;
			 
			 $.ajax({
				 url:"emailDuplicateCheckEdit.dk",
				 data:{"email":$("input#email").val()
				      ,"id":$("input:hidden[name='id']").val()}, 
				 type:"post",
				 async:true,
				 dataType:"json", 
				 success:function(json){
					 if(json.isExists) {
						 $("span#emailCheckResult").html($("input#email").val() + " 은 이미 사용중 이므로 다른 이메일을 입력하세요").css({"color":"red"}); 
						 $("input#email").val(""); 
					 } else {
						 $("span#emailCheckResult").html($("input#email").val() + " 은 사용가능 합니다").css({"color":"navy"});  
					 }
				 },
				 error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				 }
			 });
		 });
	
		$("input#email").bind("change", function(){
			 b_emailcheck_click = false;
			 b_email_change = true;
		});	
		
	}); // end of $(document).ready(function(){}) ----------------------


	//Function Declaration
	//"수정하기" 버튼 클릭시 호출되는 함수 
	function goEdit(){
		
		
		
		
	  	let b_requiredInfo = false;
	  
	  	const requiredInfo_list = document.querySelectorAll("input.requiredInfo"); 
	  	for(let i=0; i<requiredInfo_list.length; i++){
			const val = requiredInfo_list[i].value.trim();
			if(val == "") {
				alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
			    b_requiredInfo = true;
			    break; 
			}
		} // end of for-----------------------------
	  	
		
		if(b_requiredInfo) {
			return;
		}
		
		if(b_email_change && !b_emailcheck_click) {
			alert("이메일 중복확인을 클릭하셔야 합니다.");
			return;
		}
		
		const postcode = $("input#postcode").val().trim();
		const address = $("input#address").val().trim();
		const address_detail = $("input#address_detail").val().trim();
		const address_extra = $("input#address_extra").val().trim();
		
		if(postcode == "" || address == "" || address_detail == "" || address_extra == "") {
			alert("우편번호 및 주소를 입력하셔야 합니다.");
			return;
		}
		
		let isNewPwd = true;
		
		$.ajax({
				 url:"duplicatePwdCheck.dk",
				 data:{"new_pwd":$("input:password[name='password']").val()
				      ,"id":$("input:hidden[name='id']").val()},
				 type:"post",
				 async:false,
				 dataType:"json",
				 success:function(json){
					 if(json.isExists) {
						 $("span#duplicate_pwd").html("현재 사용중인 비밀번호로 비밀번호 변경은 불가합니다."); 
						 isNewPwd = false;
					 }
				 },
				 error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				 }
		}); 
		
		if(isNewPwd) {
			const frm = document.editFrm;
			frm.action = "<%= ctxPath%>/member/memberEditEnd.dk";
			frm.method = "post";
			frm.submit();
		}
	}// end of function goEdit()-----------------------

	function goReset() {
	    history.back(); // 이전 페이지로 이동
	}
</script>

	<div class="container" id="divEditFrm">
   		<div class="col-md-12">
      		<form name="editFrm">
          		<table id="tblMemberEdit">
             		<thead>
	                	<tr>
	                   		<th colspan="2" > ${sessionScope.loginuser.name} 님의 회원정보 수정 <span style="font-size: 10pt; font-style: italic;">(<span class="star">*</span>표시는 필수입력사항 입니다.)</span> </th>
	                	</tr>
	             	</thead>
	      			<tbody>
	    				<br>
					    <tr>
					        <td>성명&nbsp;:&nbsp;<span class="star">*</span></td>
					        <td>
					            <input type="hidden" name="id"  value="${sessionScope.loginuser.id}" />
					            <input style="text-transform: none !important;" type="text" class="customWidth"  name="name" id="name" maxlength="30" class="requiredInfo" value="${sessionScope.loginuser.name}" />
					            <span class="error" style="color:red;">성명은 필수입력 사항입니다.</span>
					        </td>
					    </tr>
					    <tr>
					        <td>비밀번호&nbsp;<span class="star">*</span></td>
					        <td>
					            <input type="password"  style="text-transform: none !important;" class="customWidth" name="password" id="password" maxlength="15" class="requiredInfo" />
					            <span class="error" style="color:red;">암호는 영문자,숫자,특수기호가 혼합된 8~15 글자로 입력하세요.</span>
					            <span id="duplicate_pwd" style="color: red;"></span>
					        </td>
					    </tr>
					    <tr>
					        <td>비밀번호확인&nbsp;<span class="star">*</span></td>
					        <td>
					            <input style="text-transform: none !important;" type="password" class="customWidth" id="pwdcheck" maxlength="15" class="requiredInfo" />
					            <span class="error" style="color: red;">암호가 일치하지 않습니다.</span>
					        </td>
					    </tr>
					    <tr>
					        <td>이메일&nbsp;<span class="star">*</span></td>
					        <td>
					            <input style="text-transform: none !important;" type="text" name="email" class="customWidth"  id="email" maxlength="60" class="requiredInfo" value="${sessionScope.loginuser.email}" />
					            <button type="button" id="emailcheck" class="btn btn-outline-dark">이메일중복확인</button>
					            <span class="error" style="color:red;">이메일 형식에 맞지 않습니다.</span>
					            <span id="emailCheckResult"></span>
					        </td>
					    </tr>
					    <tr>
					        <td>연락처&nbsp;</td>
					        <td>
					            <input type="text" class="customWidth" name="hp1" id="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp; 
					            <input type="text" class="customWidth" name="hp2" id="hp2" size="6" maxlength="4" value="${fn:substring(sessionScope.loginuser.tel, 3, 7)}" />&nbsp;-&nbsp;
					            <input type="text" class="customWidth" name="hp3" id="hp3" size="6" maxlength="4" value="${fn:substring(sessionScope.loginuser.tel, 7, 11)}" />    
					            <span class="error" style="color:red;">휴대폰 형식이 아닙니다.</span>
					        </td>
					    </tr>
					    <tr>
					        <td>우편번호</td>
					        <td>
					            <input type="text" class="customWidth" name="postcode" id="postcode" size="6" maxlength="5" value="${sessionScope.loginuser.postcode}" />&nbsp;&nbsp;
					            <button type="button" id="postcodecheck" class="btn btn-outline-dark">우편번호 찾기</button>
					            <span class="error" style="color:red;">우편번호 형식에 맞지 않습니다.</span>
					        </td>
					    </tr>
					    <tr>
					        <td>주소</td>
					        <td>
					            <input type="text" class="customWidth" name="address" id="address" size="40" maxlength="200" placeholder="주소" value="${sessionScope.loginuser.address}" /><br>
					            <input type="text" class="customWidth" name="address_detail" id="address_detail" size="40" maxlength="200" placeholder="상세주소" value="${sessionScope.loginuser.address_detail}" />&nbsp;
					            <input type="text" class="customWidth" name="address_extra" id="address_extra" size="40" maxlength="200" placeholder="참고항목" value="${sessionScope.loginuser.address_extra}" />            
					            <span class="error" style="color:red;">주소를 입력하세요.</span>
					        </td>
					    </tr>
					   
					</tbody>
				</table>
			</form>
      		<button type="button" class="btn btn-outline-warning" value="수정하기" onclick="goEdit()" >수정하기</button>
      		<input type="reset" class="btn btn-outline-danger" value="취소하기" onclick="goReset()" />
		</div>
	</div>

