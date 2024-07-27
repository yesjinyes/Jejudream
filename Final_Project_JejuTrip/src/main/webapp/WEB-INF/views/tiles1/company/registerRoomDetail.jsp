<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
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

	form {
	    display: flex;
	    flex-direction: column;
	    align-items: flex-start;
	    margin-left: 30%; /* 왼쪽 마진 추가 */
	    width: calc(100% - 40px); /* 마진을 제외한 너비 설정 */
	}
	
	.carousel {
	    width: 100%;
	    display: flex;
	    transition: transform 0.5s ease-in-out;
	    margin-bottom:5%;
	}
	
	.carousel-item {
	    min-width: 100%;
	    box-sizing: border-box;
	    display: flex;
	    flex-direction: column;
	    align-items: flex-start;
	    margin: 0;
	    
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
	
	.carousel-controls {
	    position: absolute;
	    top: 48%;
	    width: 96%;
	    display: flex;
	    justify-content: space-between;
	    transform: translateY(-50%);
	    height: 5px;
    	align-items: center;
	}
	
	
	div.info_block > input {
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
	
	.carousel-controls button {
	    background-color: rgba(0, 0, 0, 0.5);
	    color: white;
	    border: none;
	    padding: 10px;
	    cursor: pointer;
	}
</style>
    
</head>
<body>
    <div class="container">
    	<div style="width: 80%; margin: 7% auto;">
	        <h2 class="font-weight-bold">객실 등록</h2>
	        <h5>객실을 등록해서 최고의 숙소가 되봅시다!</h5>
	    </div>
        <form name="registerFrm" enctype="multipart/form-data">
        	<input type="hidden" name="str_room_name" />
        	<input type="hidden" name="str_price" />
        	<input type="hidden" name="str_check_in" />
        	<input type="hidden" name="str_check_out" />
        	<input type="hidden" name="str_min_person" />
        	<input type="hidden" name="str_max_person" />
        	<input type="hidden" name="str_attach" />
        	<input type="hidden" name="fk_lodging_code" value="${requestScope.fk_lodging_code}" />
        	
            <div class="carousel" id="carousel">
                <div class="carousel-item">
                <h2>1번째 객실</h2>
                    <div class="info col-md-4">
                    
                        <div class="info_block">
                        	
                            <h4>객실명</h4>
                            <input type="text" name="room_name" placeholder="객실 명 입력">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>객실 가격</h4>
                            <input type="text" name="price" placeholder="객실 가격 입력">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>최소 기준 인원</h4>
                            <input type="number" name="min_person" min="2" max="20" placeholder="최소 2명 이상" />
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>최대 입실 가능 인원</h4>
                            <input type="number" name="max_person" min="2"  max="20"placeholder="최소 2명 이상">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>체크인 시간</h4>
                            <input type="text" min="0" max="24" name="check_in" placeholder="예시) 0시, 15시">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>체크아웃 시간</h4>
                            <input type="text" min="0" max="24" name="check_out" placeholder="예시) 0시, 15시">
                            <span class="error"></span>
                        </div>
                        <div class="mt-3">
                            <h4>객실 대표 사진</h4>
                            <input type="file" name="attach">
                            <span class="error"></span>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <div class="carousel-controls">
            <button id="prevBtn">&lt;</button>
            <button id="nextBtn">&gt;</button>
        </div>
        <div style="text-align: center; margin-bottom: 13%;">
        	
            <button type="button" class="btn btn-dark" id="addRoomBtn">객실 추가하기</button>
            <button type="button" class="btn btn-danger" id="deleteRoomBtn">추가된 객실 삭제하기</button>
            <button type="button" class="btn" id="registerBtn" onclick="goRoomRegister()">객실 등록하기</button>
        </div>
    </div>

<script>

let room_cnt = 1;
let isCheck = true;
    $(document).ready(function(){
        let currentIndex = 0;

        $('#addRoomBtn').click(function() {
        	room_cnt++;
            const newRoom = `
            				<div class="carousel-item">
            					<h2>\${room_cnt}번째 객실</h2>
				                <div class="info col-md-4">
				                <div class="info_block">
				                    <h4>객실명</h4>
				                    <input type="text" name="room_name" placeholder="객실 명 입력">
				                    <span class="error"></span>
				                </div>
				                <div class="info_block mt-3">
				                    <h4>객실 가격</h4>
				                    <input type="text" name="price" placeholder="객실 가격 입력">
				                    <span class="error"></span>
				                </div>
				                <div class="info_block mt-3">
				                    <h4>최소 기준 인원</h4>
				                    <input type="number" name="min_person" min="2" placeholder="최소 2명 이상">
				                    <span class="error"></span>
				                </div>
				                <div class="info_block mt-3">
				                    <h4>최대 입실 가능 인원</h4>
				                    <input type="number" name="max_person" min="2" placeholder="최소 2명 이상">
				                    <span class="error"></span>
				                </div>
				                <div class="info_block mt-3">
				                    <h4>체크인 시간</h4>
				                    <input type="text" min="0" max="24" name="check_in" placeholder="00시는 0으로 입력">
				                    <span class="error"></span>
				                </div>
				                <div class="info_block mt-3">
				                    <h4>체크아웃 시간</h4>
				                    <input type="text" min="0" max="24" name="check_out" placeholder="00시는 0으로 입력">
				                    <span class="error"></span>
				                </div>
				                <div class="mt-3">
				                    <h4>객실 대표 사진</h4>
				                    <input type="file" name="attach">
				                    <span class="error"></span>
				                </div>
				            </div>
				        </div>`;
            
            $('#carousel').append(newRoom);
            
            currentIndex = $('#carousel .carousel-item').length - 1;
            updateCarousel();
            	
            
        });

        $('#deleteRoomBtn').click(function() {
        	room_cnt--;
            if ($('#carousel .carousel-item').length > 1) {
                $('#carousel .carousel-item').last().remove();
                currentIndex = Math.max(0, currentIndex - 1);
                updateCarousel();
            }
        });

        $('#prevBtn').click(function() {
            currentIndex = Math.max(0, currentIndex - 1);
            updateCarousel();
        });

        $('#nextBtn').click(function() {
            currentIndex = Math.min($('#carousel .carousel-item').length - 1, currentIndex + 1);
            updateCarousel();
        });
        
        function updateCarousel() {
        	
        	 $('#carousel').css('transform', 'translateX(-' + currentIndex * 100 + '%)');
            
        } // end of function updateCarousel() {})
        
    
    }); // end of $(document).ready(function(){})
    
    
    
  
	
	function goRoomRegister() {
    	
		let arr_room_name = [];
	 	let arr_price = [];
	 	let arr_min_person = [];
	 	let arr_max_person = [];
	 	let arr_check_in = [];
	 	let arr_check_out = [];
	 	
	 	let str_room_name = "";
	 	let str_price = "";
	 	let str_min_person = "";
	 	let str_max_person = "";
	 	let str_check_in = "";
	 	let str_check_out = "";
		
	    let isCheck = true; // 초기화 필요
	
	    $('.error').text(''); // 기존 유효성 text 제거하기
	    $('input').removeClass('input_error');
	
	    // 객실명 검사하기
        $('input[name="room_name"]').each(function() {
            if ($(this).val().trim() === '') {
                $(this).next('.error').text('객실명을 입력하세요.');
                $(this).addClass('input_error');
                isCheck = false;
            }

            arr_room_name.push($(this).val().trim());
        });

        // 객실 가격 검사하기
        $('input[name="price"]').each(function() {
            if ($(this).val().trim() === '') {
                $(this).next('.error').text('객실 가격을 입력하세요.');
                $(this).addClass('input_error');
                isCheck = false;
            }else if ( isNaN($(this).val().trim() ) ){
           	 
           	 $(this).next('.error').text('객실 가격은 숫자로만 입력해야합니다!');
                $(this).addClass('input_error');
                $(this).val("");
                isCheck = false;
           	 
            }else if ( Number($(this).val().trim()) > 200000000 ){
           	 
           	 $(this).next('.error').text('입력된 객실 가격이 너무 말도 안됩니다!');
                $(this).addClass('input_error');
                $(this).val("");
                isCheck = false;
           	 
            }

            arr_price.push($(this).val().trim());
        });

        // 최소 기준인원 검사하기
        $('input[name="min_person"]').each(function() {
       	 
       	 const min_person = $(this).val().trim();

	       	 if (min_person == '') {
	       		 
	       	     $(this).next('.error').text('올바른 숫자로 반드시 입력하세요!');
	       	     $(this).addClass('input_error');
	       	     isCheck = false;
	       	     
	       	 } else if (isNaN(min_person) || Number(min_person) <= 1 || Number(min_person) > 20) {
	       	 
	       		 $(this).next('.error').text('올바른 숫자로 2에서 최대 20까지만 입력하셔야합니다!');
	       	     $(this).addClass('input_error');
	       	     $(this).val("");
	       	     isCheck = false;
	       	     
	       	 }
	       	 
	       	 arr_min_person.push(min_person);
	       	 
        });

        // 최대 입실인원 검사하기
        $('input[name="max_person"]').each(function() {
       	 
       	 const max_person = $(this).val().trim();

	       	 if (max_person == '') {
	       		 
	       	     $(this).next('.error').text('올바른 숫자로 반드시 입력하세요!');
	       	     $(this).addClass('input_error');
	       	     isCheck = false;
	       	     
	       	 } else if (isNaN(max_person) || Number(max_person) <= 1 || Number(max_person) > 20) {
	       	 
	       		 $(this).next('.error').text('올바른 숫자로 2에서 최대 20까지만 입력하셔야합니다!');
	       	     $(this).addClass('input_error');
	       	     $(this).val("");
	       	     isCheck = false;
	       	     
	       	 } 
	       	 
	       	 arr_max_person.push(max_person);
	       	 
        });
			
        
        // 체크인, 체크아웃시간 0시부터 24시까지 검사하는 정규표현식
        const regtime = new RegExp(/^(0?[0-9]|1[0-9]|2[0-4])시$/);
        
        // 입력된 체크인 시간 검사하기
        $('input[name="check_in"]').each(function() {
            if ($(this).val().trim() === '') {
                $(this).next('.error').text('반드시 입력하세요!');
                $(this).addClass('input_error');
                isCheck = false;
            }else if( !regtime.test($(this).val()) ) {
           	 
           	 $(this).next('.error').text('00시~24시 사이인 올바른 시간을 입력하세요!');
           	 $(this).addClass('input_error');
           	 isCheck = false;
            }

            arr_check_in.push($(this).val().trim());
        });

        // 입력된 체크아웃 시간 검사하기
        $('input[name="check_out"]').each(function() {
            if ($(this).val().trim() === '') {
                $(this).next('.error').text('반드시 입력하세요!');
                $(this).addClass('input_error');
                isCheck = false;
            }else if( !regtime.test($(this).val()) ) {
           	 
           	 $(this).next('.error').text('00시~24시 사이인 올바른 시간을 입력하세요!');
           	 $(this).addClass('input_error');
           	 isCheck = false;
            }

            arr_check_out.push($(this).val().trim());
        });

        // 첨부파일 검사하기
        $('input[name="attach"]').each(function() {
            if ($(this).get(0).files.length === 0) {
                $(this).next('.error').text('사진을 추가하세요.');
                $(this).addClass('input_error');
                isCheck = false;
            }
        });
	
	    
	    
	    if (!isCheck) {
	        alert('올바른 데이터를 모두 입력하셔야 객실등록이 가능합니다!!');
	        return;
	    }
	    
	    
	    
	    str_room_name = arr_room_name.join();
	 	str_price = arr_price.join();
	 	str_min_person = arr_min_person.join();
	 	str_max_person = arr_max_person.join();
	 	str_check_in = arr_check_in.join();
	 	str_check_out = arr_check_out.join();
	    
	 	const frm = document.registerFrm;
	 	
	 	frm.str_room_name.value = str_room_name;
	 	frm.str_price.value = str_price;
	 	frm.str_min_person.value = str_min_person;
	 	frm.str_max_person.value = str_max_person;
	 	frm.str_check_in.value = str_check_in;
	 	frm.str_check_out.value = str_check_out;
	 	
	
	 	frm.method = "post";
	 	frm.action = "<%= ctxPath%>/registerRoomDetailEnd.trip";
	 	
	 	frm.submit();
	 	
	    // 유효성 검사를 모두 통과한 경우 폼을 제출합니다.
	    // $('#registerFrm').submit();
	} // end of function goRoomRegister() {
    
</script>

    
