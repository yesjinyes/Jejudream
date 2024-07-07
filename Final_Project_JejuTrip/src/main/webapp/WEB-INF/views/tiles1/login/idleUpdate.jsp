<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
    body {
        font-family: "Noto Sans KR", sans-serif;
        font-optical-sizing: auto;
    }
    div.container {
        width: 45%;
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

    button#certifyBtn {
        width: 100%;
        height: 50px;
        margin: 1% auto;
        border-radius: 8px;
        border-color: #ff5000;
        color: #ff5000;
    }

    button#certifyBtn:hover {
        background-color: #ff5000;
        color: white;
    }

    input[name='input_confirmCode'] {
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

    button#confirmBtn {
        position: absolute;
        width: 90px;
        height: 40px;
        top: 0;
        bottom: 0;
        right: 5px;
        margin: auto 0;
        border-radius: 8px;
    }
</style>

<script type="text/javascript">
    $(document).ready(function() {
		
        $("input#email").keyup(function(e) {
            if(e.keyCode == 13) {
            	goEmailCertify();
            }
        });
        
        $(document).on("keyup", "input:text[name='input_confirmCode']", function(e) {
        	if(e.keyCode == 13) {
        		goPwUpdate();
        	}
        });

    });

    function goEmailCertify() {

        const id = $("input#id").val().trim();
        const email = $("input#email").val().trim();

        if(id == "") {
            alert("아이디를 입력해주세요!");
            return;
        }

        if(id.length < 5 || id.length > 20) {
            alert("아이디는 5~20자 이내로 입력해주세요!");
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
            $("input#email").val("");
            return;
        }

        const queryString = $("form[name='pwdFindFrm']").serialize();
        
        $.ajax({
        	url: "<%=ctxPath%>/login/emailCertifyJSON.trip",
        	type: "post",
        	data: queryString,
        	dataType: "json",
        	success: function(json) {
        		
        		if(json.isUserExist) {
        			
        			let v_html = ``;
        			
        			if(json.sendMailSuccess) {
        				v_html += `<div class="text-center mb-3">
		        	               	  <span><span class="font-weight-bold">\${json.email}</span> 으로 메일이 발송되었습니다.</span>
		        		           </div>
		        		           <div style="position: relative;">
		        		              <input type="text" name="input_confirmCode" placeholder="인증번호 입력">
		        		              <button type="button" class="btn btn-success" id="confirmBtn" onclick="goPwUpdate()">인증하기</button>
		        		           </div>`;
		        		
        			} else {
        				v_html += `<span style="color: red;">메일 발송에 실패했습니다.</span>`;
        			}
					
        			$("div#emailConfirm").html(v_html);
        			
        		} else {
        			alert("일치하는 사용자 정보가 없습니다.");
        			$("input#id").val("").focus();
        			$("input#email").val("");
        			return;
        		}
        		
        	},
        	error: function(request, status, error) {
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
        });
    }
    
    function goPwUpdate() {
    	const input_confirmCode = $("input[name='input_confirmCode']").val().trim();
    	
    	if(input_confirmCode == "") {
    		alert("인증번호를 입력해주세요.");
    		return;
    	}

		const frm = document.verifyCertificationFrm;
		frm.userCertificationCode.value = input_confirmCode; // 입력받은 인증코드 넣기
		frm.memberType.value = $("input:radio[name='memberType']:checked").val();
		frm.id.value = $("input:text#id").val();
		
		frm.action = "<%=ctxPath%>/login/emailCertification.trip";
		frm.method = "post";
		frm.submit();
    	;
		
    }
</script>

<div class="container">
    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">휴면 해제하기</h2>

        <form name="emailCertifyFrm">
        
            <div class="d-flex justify-content-center mt-5">
               <div class="form-check form-check-inline">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio1" value="member" checked>
                 <label class="form-check-label" for="inlineRadio1">일반회원</label>
               </div>
               <div class="form-check form-check-inline pl-3">
                 <input class="form-check-input" type="radio" name="memberType" id="inlineRadio2" value="company">
                 <label class="form-check-label" for="inlineRadio2">업체회원</label>
               </div>
            </div>
        
        
            <div class="info">
                <input type="text" name="id" id="id" placeholder="아이디">
                <input type="text" name="email" id="email" placeholder="이메일">
            </div>

            <div class="mt-5 text-center">
                <button type="button" class="btn" id="certifyBtn" onclick="goEmailCertify()">이메일 인증하기</button>
            </div>
        </form>

        <div id="emailConfirm" class="mt-5" style="margin-bottom: 20%;">
        </div>

		<%-- 인증하기 form --%>
		<form name="verifyCertificationFrm">
			<input type="hidden" name="userCertificationCode" />
			<input type="hidden" name="memberType">
			<input type="hidden" name="id" />
		</form>
    </div>
</div>

