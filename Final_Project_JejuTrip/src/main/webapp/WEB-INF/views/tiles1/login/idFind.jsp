<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">

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

    button#idFindBtn {
        width: 100%;
        height: 50px;
        margin: 1% auto;
        border-radius: 8px;
        border-color: #ff5000;
        color: #ff5000;
    }

    button#idFindBtn:hover {
        background-color: #ff5000;
        color: white;
    }

    span#result {
        font-size: 15pt;
    }

    div#idFindDiv {
        border: solid 1px rgba(0, 0, 0, 0.15);
        border-radius: 20px;
    }
</style>

<script type="text/javascript">
    $(document).ready(function() {
    	
        $("input#email").keyup(function(e) {
            if(e.keyCode == 13) {
                goIdFind();
            }
        });
        
        // '로그인하러 가기' 버튼 클릭 시
        $(document).on("click", "button#loginBtn", function() {
        	location.href = "<%=ctxPath%>/login.trip";
        });
           
        // '비밀번호 찾기' 버튼 클릭 시
        $(document).on("click", "button#pwFindBtn", function() {
        	location.href = "<%=ctxPath%>/login/pwFind.trip";
        });
        
    });

    function goIdFind() {
        const name = $("input#name").val().trim();
        const email = $("input#email").val().trim();

        if(name == "") {
            alert("성명을 입력해주세요!");
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
        
        $.ajax({
        	url: "<%=ctxPath%>/login/idFindEnd.trip",
        	type: "post",
        	data: {"memberType":$("input:radio[name='memberType']:checked").val(),
        		   "name":$("input#name").val(),
        		   "email":$("input#email").val()},
        	dataType: "json",
        	success: function(json) {
        		
        		let v_html = ``;
        		
        		if(json.findInfo) {
        			
	                if (json.findInfo.userid && json.findInfo.user_name) {
	                    v_html = `<span id="result">\${json.findInfo.user_name}님의 아이디</span>
	                              <div class="mt-4 p-5" id="idFindDiv">
	                                  <span class="font-weight-bold" style="font-size: 16pt;">\${json.findInfo.userid}</span>
	                              </div>
	                              <div class="mt-5 text-center" style="margin-bottom: 20%;">
	                                  <button type="button" class="btn btn-success mr-2" id="loginBtn">로그인하러 가기</button>
	                                  <button type="button" class="btn btn-outline-success" id="pwFindBtn">비밀번호 찾기</button>
	                              </div>`;
					
	                } else if (json.findInfo.companyid && json.findInfo.company_name) {
	                    v_html = `<span id="result">\${json.findInfo.company_name} 계정 아이디</span>
	                              <div class="mt-4 p-5" id="idFindDiv">
	                                  <span class="font-weight-bold" style="font-size: 16pt;">\${json.findInfo.companyid}</span>
	                              </div>
	                              <div class="mt-5 text-center" style="margin-bottom: 20%;">
	                                  <button type="button" class="btn btn-success mr-2" id="loginBtn">로그인하러 가기</button>
	                                  <button type="button" class="btn btn-outline-success" id="pwFindBtn">비밀번호 찾기</button>
	                              </div>`;
	                
	                }
        		}
                
                if (v_html != "") {
                    $("div#idFindInput").html(v_html).addClass("text-center");
                    
                } else {
                	alert("일치하는 사용자 정보가 없습니다.");
        			$("input#name").val("");
        			$("input#email").val("");
        			$("input#name").focus();
                }
        	},
        	error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
		
    }
</script>

<div class="container">
    <div style="width: 80%; margin: 7% auto;">
        <h2 style="margin-top: 20%;" class="font-weight-bold">아이디 찾기</h2>
		
		<div id="idFindInput">
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
	    	
	        <form name="idFindFrm">
	            <div class="info">
	                <input type="text" name="name" id="name" placeholder="성명">
	                <input type="text" name="email" id="email" placeholder="이메일">
	            </div>
	
	            <div class="mt-5 text-center" style="margin-bottom: 20%;">
	                <button type="button" class="btn" id="idFindBtn" onclick="goIdFind()">아이디 찾기</button>
	            </div>
	        </form>
		</div>
		
    </div>
</div>
