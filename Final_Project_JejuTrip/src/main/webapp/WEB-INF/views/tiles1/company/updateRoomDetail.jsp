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
    .tab-content {
        margin-top: 20px;
    }
    .tab-pane {
        display: none;
    }
    .tab-pane.active {
        display: block;
    }
    .info_block input {
        display: block;
        width: 100%;
        max-width: 680px;
        height: 50px;
        margin: 0 auto;
        border-radius: 8px;
        border: solid 1px rgba(15, 19, 42, .1);
        padding: 0 0 0 15px;
        font-size: 16px;
        color: gray;
    }
    .error {
        color: red;
    }
    .input_error {
        border: solid 1px red !important;
    }
    button {
        margin: 5px;
    }
    .btn-dark, .btn-danger, .btn {
        width: 100%;
        max-width: 300px;
        margin: 10px auto;
    }
</style>

    <div class="container">
        <div style="width: 80%; margin: 7% auto;">
            <h2 class="font-weight-bold">객실 수정</h2>
            <h5>등록된 객실을 수정해보세요!</h5>
        </div>
        <ul class="nav nav-tabs" id="roomTabs">
            <!-- 동적으로 탭이 생성될 영역 -->
        </ul>
        <form name="updateRoom" enctype="multipart/form-data">
        <div class="tab-content" id="roomTabContent">
            <!-- 동적으로 탭 콘텐츠가 생성될 영역 -->
        </div>
        <input type="hidden" name="str_room_detail_code" />
        <input type="hidden" name="str_room_img" />
        <input type="hidden" name="str_room_name" />
       	<input type="hidden" name="str_price" />
       	<input type="hidden" name="str_check_in" />
       	<input type="hidden" name="str_check_out" />
       	<input type="hidden" name="str_min_person" />
       	<input type="hidden" name="str_max_person" />
       	<input type="hidden" name="str_attach" />
       	<input type="hidden" name="fk_lodging_code" value="${requestScope.fk_lodging_code}" />
        </form>
        <div style="text-align: center; margin-bottom: 13%; margin-top: 5%;">
            <button type="button" class="btn btn-dark" id="addRoomBtn">객실 추가하기</button>
            <button type="button" class="btn btn-danger" id="deleteRoomBtn">추가된 객실 삭제하기</button>
            <button type="button" class="btn btn-info" id="registerBtn" onclick="goRoomUpdate()">객실 수정하기</button>
            <button type="button" class="btn btn-warning"  onclick="javascript:history.back()">취소하기</button>
        </div>
    </div>

 <script>
     $(document).ready(function(){
     	
     	
         // 서버에서 기존 객실 정보를 가져오기 위한 AJAX 요청
         $.ajax({
             url: "<%= ctxPath %>/JSONGetRoomDetails.trip",  // 객실 정보를 제공하는 API URL
             type: "get",
             data: {"fk_lodging_code":"${requestScope.fk_lodging_code}"},
             dataType: "json",
             success: function(json) {
             	
                 if (json.length > 0) {
                 	
                 	$.each(json, function(index, item){  
                         const tabId = `room\${index + 1}`;
                         const isActive = index === 0 ? 'active' : '';

                         // 탭 생성
                         $('#roomTabs').append(`
                             <li class="nav-item">
                                 <a class="nav-link \${isActive}" data-toggle="tab" href="#\${tabId}">객실 \${index + 1}</a>
                             </li>
                         `);

                         // 탭 콘텐츠 생성
                         $('#roomTabContent').append(`
                             <div id="\${tabId}" class="tab-pane \${isActive}" data-existing="true">
                                 <div class="info">
                                     <div class="info_block">
                                     	<input type="hidden" name="room_detail_code" value="\${item.room_detail_code}" />
                                         <h4>객실명</h4>
                                         <input type="text" name="room_name" value="\${item.room_name}" placeholder="객실 명 입력">
                                         <span class="error"></span>
                                     </div>
                                     <div class="info_block mt-3">
                                         <h4>객실 가격</h4>
                                         <input type="text" name="price" value="\${item.price}" placeholder="객실 가격 입력">
                                         <span class="error"></span>
                                     </div>
                                     <div class="info_block mt-3">
                                         <h4>최소 기준 인원</h4>
                                         <input type="text" name="min_person" value="\${item.min_person}" min="2" max="20" placeholder="최소 2명 이상">
                                         <span class="error"></span>
                                     </div>
                                     <div class="info_block mt-3">
                                         <h4>최대 입실 가능 인원</h4>
                                         <input type="text" name="max_person" value="\${item.max_person}" min="2" max="20" placeholder="최소 2명 이상">
                                         <span class="error"></span>
                                     </div>
                                     <div class="info_block mt-3">
                                         <h4>체크인 시간</h4>
                                         <input type="text" name="check_in" value="\${item.check_in}" min="0" max="24" placeholder="00시는 0시로 입력">
                                         <span class="error"></span>
                                     </div>
                                     <div class="info_block mt-3">
                                         <h4>체크아웃 시간</h4>
                                         <input type="text" name="check_out" value="\${item.check_out}" min="0" max="24" placeholder="00시는 0시로 입력">
                                         <span class="error"></span>
                                     </div>
                                     <div class="mt-3">
                                         <h4>객실 대표 사진</h4>
                                         <span>원래 파일명 : \${item.orgFilename}</span><br>
                                         <input type="hidden" name="room_img" value="\${item.room_img}" />
                                         <input type="file" name="attach">
                                         <span class="error"></span>
                                     </div>
                                 </div>
                             </div>
                         `);
                     });

                 	
                 }
             },
             error: function(request, status, error){
  			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
  			}
             
         }); // end of $.ajax
         
         // 객실 추가하기
         $('#addRoomBtn').click(function() {
             const roomCount = $('#roomTabs .nav-item').length + 1;
             const tabId = `room\${roomCount}`;

             // 새로운 탭 생성
             $('#roomTabs').append(`
                 <li class="nav-item">
                     <a class="nav-link" data-toggle="tab" href="#\${tabId}">객실 \${roomCount}</a>
                 </li>
             `);

             // 새로운 탭 콘텐츠 생성
             $('#roomTabContent').append(`
                 <div id="\${tabId}" class="tab-pane">
                     <div class="info">
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
                             <input type="text" name="min_person" min="2" max="20" placeholder="최소 2명 이상">
                             <span class="error"></span>
                         </div>
                         <div class="info_block mt-3">
                             <h4>최대 입실 가능 인원</h4>
                             <input type="text" name="max_person" min="2" max="20" placeholder="최소 2명 이상">
                             <span class="error"></span>
                         </div>
                         <div class="info_block mt-3">
                             <h4>체크인 시간</h4>
                             <input type="text" min="0" max="24" name="check_in" placeholder="00시는 0시로 입력">
                             <span class="error"></span>
                         </div>
                         <div class="info_block mt-3">
                             <h4>체크아웃 시간</h4>
                             <input type="text" min="0" max="24" name="check_out" placeholder="00시는 0시로 입력">
                             <span class="error"></span>
                         </div>
                         <div class="mt-3">
                             <h4>객실 대표 사진</h4>
                             <input type="file" name="attach">
                             <span class="error"></span>
                         </div>
                     </div>
                 </div>
             `);
    
             // 새로 추가된 탭으로 전환
             $('#roomTabs .nav-link').removeClass('active');
             $(`#roomTabs .nav-item:last-child .nav-link`).addClass('active');
             $('#roomTabContent .tab-pane').removeClass('active');
             $(`#\${tabId}`).addClass('active');
             
         }); // end of $('#addRoomBtn').click(function() {})
         
         
      	// 탭 클릭 이벤트 설정
         $(document).on('click', 'a[data-toggle="tab"]', function(e) {
             e.preventDefault();
             $(this).tab('show');

             const targetId = $(this).attr('href');
             
             $('#roomTabs .nav-link').removeClass('active');
             $(this).addClass('active');
             
             $('#roomTabContent .tab-pane').removeClass('active');
             $(targetId).addClass('active');
             
         }); // end of $(document).on('click', 'a[data-toggle="tab"]', function(e) {})

         

      	// 객실 삭제 버튼 클릭
         $('#deleteRoomBtn').click(function() {
        	
             const activeTab = $('#roomTabs .nav-link.active');

             if (activeTab.length > 0) {
            	 
                 const targetId = activeTab.attr('href');
                 const isExisting = $(targetId).data('existing');
                 
                 const room_detail_code = $(targetId).find('input[name="room_detail_code"]').val();

                 if (isExisting) {
                     // data-existing="true" 인 것만 삭제
                     
                     if(confirm('정말 해당객실을 삭제하시겠습니까?')){
                    	 
                    	 $.ajax({
                        	 
                             url: "<%= ctxPath %>/deleteRoomDetails.trip",
                             type: "post",
                             data: {"room_detail_code":room_detail_code},
                             dataType:"json",
                             success: function(json) {
                            	 
                            	 if(json.result == "1"){
                            		 
                            		 alert('객실 삭제 성공!');
                            		 
                            	 }else{
                            		 
                            		 alert('객실 삭제 실패!');
                            	 }
                            	 
                             },
                             error: function(request, status, error) {
                            	 
                                 alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
                                 
                             }
                             
                         }); // end of $.ajax
                    	 
                     } else {
                    	 
                    	 return false;
                     }
                     
                     
                     
                 } // end of if data-existing="true" 인 것만 삭제

                 // 탭과 콘텐츠 삭제
                 activeTab.closest('.nav-item').remove();
                 $(targetId).remove();

                 // 새로 활성화된 탭 설정
                 if ($('#roomTabs .nav-item').length > 0) {
                     const newActiveTab = $('#roomTabs .nav-item:last-child .nav-link');
                     newActiveTab.addClass('active');
                     $(newActiveTab.attr('href')).addClass('active');
                 }
                 
             }
             
         }); // end of  $('#deleteRoomBtn').click(function() {})
         
         
         
     }); // end of $(document).ready(function(){})
     
     function goRoomUpdate() {
    	 
         let arr_room_name = [];
         let arr_price = [];
         let arr_min_person = [];
         let arr_max_person = [];
         let arr_check_in = [];
         let arr_check_out = [];
         
         // 수정을 위한 room_code 배열생성
         let arr_room_detail_code = [];
         let str_room_detail_code = "";
         
         $('input[name="room_detail_code"]').each(function() {
         	
         	arr_room_detail_code.push($(this).val().trim());
         });
         
      	// 수정을 위한 원래 이미지파일명 배열 생성
         let arr_room_img = [];
         let str_room_img = "";
         
		$('input[name="room_img"]').each(function() {
	         	
			arr_room_img.push($(this).val().trim());
	    });

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
             alert('올바른 데이터를 모두 입력하셔야 객실수정이 가능합니다!!');
             return;
         }

         str_room_detail_code = arr_room_detail_code.join();
         str_room_img = arr_room_img.join();
         
         str_room_name = arr_room_name.join();
         str_price = arr_price.join();
         str_min_person = arr_min_person.join();
         str_max_person = arr_max_person.join();
         str_check_in = arr_check_in.join();
         str_check_out = arr_check_out.join();

         const frm = document.updateRoom;

         frm.str_room_detail_code.value = str_room_detail_code;
         frm.str_room_img.value = str_room_img;
         
         frm.str_room_name.value = str_room_name;
         frm.str_price.value = str_price;
         frm.str_min_person.value = str_min_person;
         frm.str_max_person.value = str_max_person;
         frm.str_check_in.value = str_check_in;
         frm.str_check_out.value = str_check_out;

         frm.method = "post";
         frm.action = "<%= ctxPath %>/updateRoomDetailEnd.trip";

         frm.submit();
         
     } // end of function goRoomUpdate() {}
 </script>

