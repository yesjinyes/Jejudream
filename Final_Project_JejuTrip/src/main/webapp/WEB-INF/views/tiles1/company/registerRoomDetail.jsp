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
	}
	
	.carousel-item {
	    min-width: 100%;
	    box-sizing: border-box;
	    display: flex;
	    flex-direction: column;
	    align-items: flex-start;
	    
	    
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
	    height: 50px;
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
	    top: 50%;
	    width: 96%;
	    display: flex;
	    justify-content: space-between;
	    transform: translateY(-50%);
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
            <div class="carousel" id="carousel">
                <div class="carousel-item">
                    <div class="info col-md-4">
                        <div class="info_block">
                            <h4>객실명</h4>
                            <input type="text" name="room_name[]" placeholder="객실 명 입력">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>객실 가격</h4>
                            <input type="text" name="price[]" placeholder="객실 가격 입력">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>최소 기준 인원</h4>
                            <input type="number" name="min_person[]" min="2" placeholder="최소 2명 이상">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>최대 입실 가능 인원</h4>
                            <input type="number" name="max_person[]" min="2" placeholder="최소 2명 이상">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>체크인 시간</h4>
                            <input type="number" min="0" max="24" name="check_in[]" placeholder="00시는 0으로 입력">
                            <span class="error"></span>
                        </div>
                        <div class="info_block mt-3">
                            <h4>체크아웃 시간</h4>
                            <input type="number" min="0" max="24" name="check_out[]" placeholder="00시는 0으로 입력">
                            <span class="error"></span>
                        </div>
                        <div class="mt-3">
                            <h4>객실 대표 사진</h4>
                            <input type="file" name="attach[]">
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
    $(document).ready(function(){
        let currentIndex = 1;

        $('#addRoomBtn').click(function() {
            const newRoom = `
            <div class="carousel-item">
                <div class="info col-md-4">
                    <div class="info_block">
                        <h4>객실명</h4>
                        <input type="text" name="room_name[]" placeholder="객실 명 입력">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <h4>객실 가격</h4>
                        <input type="text" name="price[]" placeholder="객실 가격 입력">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <h4>최소 기준 인원</h4>
                        <input type="number" name="min_person[]" min="2" placeholder="최소 2명 이상">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <h4>최대 입실 가능 인원</h4>
                        <input type="number" name="max_person[]" min="2" placeholder="최소 2명 이상">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <h4>체크인 시간</h4>
                        <input type="number" min="0" max="24" name="check_in[]" placeholder="00시는 0으로 입력">
                        <span class="error"></span>
                    </div>
                    <div class="info_block mt-3">
                        <h4>체크아웃 시간</h4>
                        <input type="number" min="0" max="24" name="check_out[]" placeholder="00시는 0으로 입력">
                        <span class="error"></span>
                    </div>
                    <div class="mt-3">
                        <h4>객실 대표 사진</h4>
                        <input type="file" name="attach[]">
                        <span class="error"></span>
                    </div>
                </div>
            </div>`;
            
            $('#carousel').append(newRoom);
            
            currentIndex = $('#carousel .carousel-item').length - 1;
            updateCarousel();
            
            
        });

        $('#deleteRoomBtn').click(function() {
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
        	
            $('#carousel').css('transform', `translateX(-\${currentIndex * 100}%)`);
            
        }
    });
</script>

    
