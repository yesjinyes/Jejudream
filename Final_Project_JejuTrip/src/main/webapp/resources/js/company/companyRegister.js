let checkId = false;
let checkName = false;
let checkPw = false;
let checkPwCheck = false;
let checkEmail = false;
let checkMobile = false;

$(function () {

    $("span.error").hide();
    
    // ===== 아이디 유효성 검사 =====
    $("input#companyid").blur((e) => {

        const companyid = $(e.target).val().trim();

        const regExp_companyid = new RegExp(/^(?=.*[A-Za-z])[A-Za-z0-9]{5,20}$/);
        const bool = regExp_companyid.test(companyid);
        if(companyid == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("아이디를 입력해주세요.");
            checkId = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("아이디는 5~20자 이내의 영문, 숫자로만 입력해주세요.");
            checkId = false;
        }
        // else if(아이디 중복확인 로직 추가하기) {}
        
        else {
	        $.ajax({
	            url: "companyIdCheck.trip",
	            data: {"companyid":companyid},
	            type: "post",
	            dataType: "json",
	            success: function(json) {
	                if(json.n == 1) {
	                    $(e.target).addClass("input_error");
			            $(e.target).next().show();
			            $(e.target).next().text("이미 존재하는 아이디 입니다.");
			            checkId = false;
	                } else {
	                    $(e.target).removeClass("input_error");
			            $(e.target).next().hide();
			            checkId = true;
	                }
	            },
	            error: function(request, status, error) {
	                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
	        });
        }
    });

    // ===== 성명 유효성 검사 =====
    $("input#company_name").blur((e) => {

        const name = $(e.target).val().trim();

        if(name == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("업체명을 입력해주세요.");
            checkName = false;

        } else {
            $(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkName = true;
        }
    });

    // ===== 비밀번호 유효성 검사 =====
    $("input#pw").blur((e) => {

        const pw = $(e.target).val().trim();

        const regExp_pw = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
        const bool = regExp_pw.test(pw);

        if(pw == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("비밀번호를 입력해주세요.");
            checkPw = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).val("");
            $(e.target).next().text("비밀번호는 조건에 맞게 입력해주세요.");
            checkPw = false;

        } else {
            $(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkPw = true;
        }

    });

    // ===== 비밀번호 확인 유효성 검사 =====
    $("input#pwCheck").blur((e) => {

        const pw = $("input#pw").val();
        const pwCheck = $(e.target).val().trim();

        if(pwCheck == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("비밀번호 확인을 입력해주세요.");
            checkPwCheck = false;

        } else if(pw != pwCheck) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("비밀번호가 일치하지 않습니다.");
            checkPwCheck = false;

        } else {
            $(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkPwCheck = true;
        }
    });

    // ===== 이메일 유효성 검사 =====
    $("input#email").blur((e) => {

        const email = $(e.target).val().trim();

        const regExp_email = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);  
        const bool = regExp_email.test(email);

        if(email == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("이메일을 입력해주세요.");
            checkEmail = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("올바른 이메일 형식이 아닙니다.");
            $("input#email").val("");
            checkEmail = false;

        } else {
            $.ajax({
	            url: "companyEmailCheck.trip",
	            data: {"email":email},
	            type: "post",
	            dataType: "json",
	            success: function(json) {
	                if(json.n == 1) {
	                    $(e.target).addClass("input_error");
			            $(e.target).next().show();
			            $(e.target).next().text("이미 존재하는 이메일 입니다.");
			            checkId = false;
	                } else {
	                    $(e.target).removeClass("input_error");
			            $(e.target).next().hide();
			            checkId = true;
	                }
	            },
	            error: function(request, status, error) {
	                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
	        });
            
            $(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkEmail = true;
        }

    });

    // ===== 휴대폰 유효성 검사 =====
    $("input#mobile").blur((e) => {

        const mobile = $(e.target).val().trim();

        const regExp_mobile = new RegExp(/^0[0-9]{2}[0-9]{3,4}[0-9]{4}$/);
        const bool = regExp_mobile.test(mobile);
		
        if(mobile == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("업체 연락처를 입력해주세요.");
            checkMobile = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("유효하지 않은 연락처입니다.");
            checkMobile = false;

        } else {

            $.ajax({
                url: "companyMobileDuplicateCheck.trip",
                type: "post",
                data: {"mobile": $(e.target).val()},
                dataType: "json",
                success: function(json) {
                    if(json.isExist) {
                        $(e.target).addClass("input_error");
                        $(e.target).next().show();
                        $(e.target).next().text("중복된 연락처입니다.");
                        checkMobile = false;

                    } else {
                        $(e.target).removeClass("input_error");
                        $(e.target).next().hide();
                        checkMobile = true;
                    }
                },
                error: function(request, status, error) {
                    alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
                }
            });

        }

    });


    $("input#mobile").keyup(function(e) {
        if(e.keyCode == 13) {
            goRegister();
        }
    });

});


function goRegister(ctxPath) {

    if(checkId && checkName && checkPw && checkPwCheck && checkEmail && checkMobile) {
		
		let queryString = $("form[name='registerFrm']").serialize();
		
        // 회원가입 처리하기
        $.ajax({
            url: ctxPath + "/companyRegisterEnd.trip",
            type: "post",
            data: queryString,
            dataType: "json",
            success: function(json) {
                if(json.n == 1) {
                    alert("회원가입이 성공되었습니다.");
                    location.href = ctxPath + "/index.trip";

                } else {
                    alert("회원가입에 실패했습니다.");
                    history.back();
                }
            },
            error: function(request, status, error) {
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
        });

    } else {
        alert("가입 정보를 모두 입력하세요.");
        return;
    }

}