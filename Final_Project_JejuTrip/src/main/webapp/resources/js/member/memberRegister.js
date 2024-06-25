$(function () {

    let checkUserid = false;
    let checkName = false;
    let checkPw = false;
    let checkPwCheck = false;
    let checkEmailId = false;
    let checkEmailDropdown = false;
    let checkMobile = false;

    $("span.error").hide();
    // $("button#registerBtn").prop("disabled", true);

    // 생년월일
    let today = new Date();
    let day = today.getDate();
    let month = today.getMonth() + 1;
    let year = today.getFullYear();
    if (day < 10) day = '0' + day;
    if (month < 10) month = '0' + month;
    today = year + '-' + month + '-' + day;

    // 기본값 및 선택할 수 있는 최대 날짜를 현재 날짜로 설정
    document.getElementById("birthday").setAttribute("value", today);
    document.getElementById("birthday").setAttribute("max", today);
    

    // 주소 클릭 시
    $('input#address').click(function () {

        new daum.Postcode({
            oncomplete: function (data) {

                let addr = '';

                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }

                document.getElementById("address").value = addr;
                document.getElementById("detail_address").focus();

            }
        }).open();

    });

    // ===== 아이디 유효성 검사 =====
    $("input#userid").blur((e) => {

        const userid = $(e.target).val().trim();

        const regExp_userid = new RegExp(/^[a-z]{5,20}$/);
        const bool = regExp_userid.test(userid);

        if(userid == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("아이디를 입력해주세요.");
            checkUserid = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("아이디는 영어 소문자 5~20자 이내로 입력해주세요.");
            checkUserid = false;
        }
        // else if(아이디 중복확인 로직 추가하기) {}
        
        else {
            $(e.target).removeClass("input_error");
            $(e.target).next().hide();
            checkUserid = true;
        }
    });

    // ===== 성명 유효성 검사 =====
    $("input#user_name").blur((e) => {

        const name = $(e.target).val().trim();

        const regExp_name = new RegExp(/^[가-힣]{2,6}$/);
        const bool = regExp_name.test(name);

        if(name == "") {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("성명을 입력해주세요.");
            checkName = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).next().show();
            $(e.target).next().text("성명은 2~6자 이내 한글로만 입력해주세요.");
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
    $("input#email_id").blur((e) => {

        const email_id = $(e.target).val().trim();

        const regExp_emailId = new RegExp(/^[a-z]{5,20}$/);
        const bool = regExp_emailId.test(email_id);

        if(email_id == "") {
            $(e.target).addClass("input_error");
            $(e.target).parent().next().show();
            $(e.target).parent().next().text("이메일 아이디를 입력해주세요.");
            checkEmailId = false;

        } else if(!bool) {
            $(e.target).addClass("input_error");
            $(e.target).parent().next().show();
            $(e.target).parent().next().text("이메일 아이디는 5~20자 이내 영문으로만 입력해주세요.");
            checkEmailId = false;

        } else {
            $(e.target).removeClass("input_error");
            $(e.target).parent().next().hide();
            checkEmailId = true;
        }

    });




});