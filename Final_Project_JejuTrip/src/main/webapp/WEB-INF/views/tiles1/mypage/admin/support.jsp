<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.net.InetAddress" %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/member/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>


<style type="text/css">

button#btnRegisterFaq {
  margin-right: 10%;
}

select#category-selectbox {
  display: block;
  width: 80%;
  height: 50px;
  border-radius: 8px;
  border: solid 1px rgba(15, 19, 42, .1);
  padding: 0 0 0 15px;
  font-size: 16px;
  color: gray;
}

.input_error {
  border: solid 1px red !important;
}

textarea.register-input,
textarea.update-input{
  height: 100px;
}

div.form-group > label {
  font-size: 14pt;
  margin-left: 1%;
}

input#searchWordFaq {
  height: 35px;
  padding-left: 1%;
  border: solid 1px gray;
  border-radius: 5px;
}

button#btnSearch {
  height: 35px;
  border: solid 1px gray;
  border-radius: 5px;
}

ul.nav-tabs {
  width: 90%;
}

.accordion {
  width: 90%;
}

div.accordionEach {
  margin-bottom: 1%;
}

.accordion-item {
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  margin-bottom: 2%;
  overflow: hidden;
}

.accordion-header {
  display: flex;
  width: 100%;
  background-color: #fff2e6;
  color: #333333;
  padding: 15px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  position: relative;
}

.accordion-header:hover {
  background-color: #ffe5cc;
}

.arrow {
  position: absolute;
  top: 50%;
  right: 15px;
  width: 0;
  height: 0;
  border: 6px solid transparent;
  border-top-color: #333333;
  transform: translateY(-50%);
  transition: transform 0.3s ease;
}


/* 화살표 회전 */
.accordion-item.active .arrow {
  transform: translateY(-50%) rotate(180deg);
}

.accordion-content {
  padding: 15px;
  font-size: 14px;
  line-height: 1.6;
  display: none;
}

.accordion-item.active .accordion-content {
  display: block;
}

span.faq_answer {
  font-size: 12pt;
}

div.accordion-content {
  padding: 2%;
}

.backgroundColor {
    background-color: #ffe5cc;
}

</style>



<script type="text/javascript">
	
	$(document).ready(function(){

		let searchWordFaq = "";
		
		goViewFaqList(1,searchWordFaq); // 자주묻는질문 전체 띄우기
		
		// == 카테고리 값 띄우기 == //
		$("a.faq_category").click(function(e) {
			
			const faq_category = $(e.target).text(); // 선택한 카테고리 값 가져오기

			if(faq_category == '전체') {
				$("input[name='faq_category']").val(""); // input 태그에 클릭된 카테고리 꽂아주기 (전체일 경우 "" 이 되고, mapper 에서 조건 주었음)
			}
			else {
				$("input[name='faq_category']").val(faq_category); // input 태그에 클릭된 카테고리 꽂아주기
			}
			
			goViewFaqList(1, searchWordFaq);
			
			$("input[name='searchWordFaq']").val(""); // 검색 후 카테고리 탭 변경 시 검색창 초기화
			
		});// end of $("a.faq_category").click(function(e) {})-------------------------
		
		
		// == 검색하기 엔터 == //
   		$("input[name='searchWordFaq']").bind("keyup", function(e){
			 if(e.keyCode == 13) {
				const searchWordFaq = $(this).val();
				goViewFaqList(1, searchWordFaq);
			} 
		});
		
		/////////////////////////////////////////////////////////////////////////////////////
		
		// == 질문등록 버튼 클릭 시 모달 띄우기 == //
		$("button#btnRegisterFaq").click(function() {
			$("#faqRegisterModal").modal("show");
		});
		
		// == 질문 수정  == //
		$(document).on("click", "button#btnEditFaq", function(e) {
			
	 		const $button = $(e.target);
		    const $faqItem = $button.closest('.accordionEach'); // 버튼이 속한 아코디언 아이템

		    const faqSeq = $faqItem.find("input[name='faq_seq']").val();
		    const question = $faqItem.find(".faq_question").text();
		    const answer = $faqItem.find(".faq_answer").text();

		    // 모달에 값 설정
		    $("#faqUpdateModal").find("input[name='update_faq_seq']").val(faqSeq);
		    $("#faqUpdateModal").find("textarea[name='question_update']").val(question);
		    $("#faqUpdateModal").find("textarea[name='answer_update']").val(answer);

		    // 모달 열기
		    $("#faqUpdateModal").modal("show");
			
		});// end of $(document).on("click", "button.btnUpdateReview", function(e)--------------
		
		
		// == 질문 삭제 == //
		$(document).on("click", "button#btnDeleteFaq", function(e) {
			
			const $button = $(e.target);
		    const $faqItem = $button.closest('.accordionEach'); // 버튼이 속한 아코디언 아이템

		    const faqSeq = $faqItem.find("input[name='faq_seq']").val();
		    //const question = $faqItem.find(".faq_question").text();
		    //const answer = $faqItem.find(".faq_answer").text();
		    
		    // const deleteFrm = $("form[name='reservationFrm']").serialize();
	       	
			// 질문 삭제 데이터 넘기기
			if(confirm("FAQ를 정말로 삭제하시겠습니까?")) {
				
				$.ajax({
					url:"<%= ctxPath%>/deleteFAQ.trip",
					type:"post",
					data:{"faq_seq":faqSeq},
					dataType:"json",
					success:function(json) {

						if(json.n == 1) {
							goViewFaqList(1, "");
						}
						else {
							alert("질문 삭제에 실패했습니다.");
						}
					},
					error: function(request, status, error) {
		                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
		            }
				});// end of $.ajax------------------------
				
				
			}
		});// end of $(document).on("click", "button#btnDeleteFaq", function(e)--------------

		
	});// end of $(document).ready(function(){})-----------------------------------------
	
	// ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
	
	/////// Function Declaration ///////
	
	// == 질문 아코디언 == //
	function toggleAccordion(header) {
	    // jQuery를 사용하여 클릭된 헤더의 다음 형제 요소인 accordion-content를 찾습니다.
	    var $content = $(header).next('.accordion-content');

	    // 현재의 display 속성을 확인하고, 숨겨져 있으면 보이게 하고, 보이는 중이면 숨깁니다.
	    if ($content.is(':visible')) {
	        $content.hide(); // content를 숨깁니다.
	    } else {
	        $content.show(); // content를 보이게 합니다.
	    }
	}// end of function toggleAccordion(header)---------------

	
	// == 자주묻는질문 리스트 띄우기 == //
	function goViewFaqList(currentShowPageNo, searchWordFaq){
		
		searchWordFaq = $("input[name='searchWordFaq']").val();
		
		$.ajax({
			url:"<%= ctxPath%>/faqListJSON.trip",
			data:{"currentShowPageNo":currentShowPageNo
				, "faq_category":$("input[name='faq_category']").val()
				, "searchWordFaq":searchWordFaq},
			type:"get",
			dataType:"json",
			success:function(json){
				
				let v_html_faq = "";
				
				if(json.length > 0){
					$.each(json, function(index, item){
						v_html_faq += `<div class="accordionEach">
										   <div class="accordion-header" id="accordion-header" onclick="toggleAccordion(this)">
											   <div style="width: 78%;">
												   <span>Q.</span>&nbsp;&nbsp;
							    			       <input type="hidden" name="faq_seq" value="\${item.faq_seq}" />
									               <span class="faq_question">\${item.faq_question}</span>
											   </div>
											   <div style="width: 20%;">
											   	   <button type="button" class="btn btn-sm btn-secondary ml-5 mr-2" id="btnEditFaq">수정</button>
										       	   <button type="button" class="btn btn-sm btn-danger" id="btnDeleteFaq">삭제</button>
								               </div>
											   <div class="justify-content-right" style="width: 2%;">
								               	   <span class="arrow"></span>
								               </div>
								           </div>
									       <div class="accordion-content" id="accordion-content">
									       	   <span class="faq_answer">\${item.faq_answer}</span>
									       </div>
									   </div>`; 
						
					}); // end of $.each-------------------------
					
					// 페이지바 함수 호출 
				    const totalPage = Math.ceil(json[0].totalCount/json[0].sizePerPage); 
				 	// console.log("totalPage : ", totalPage);
				 	
				    makeAllFaqListPageBar(currentShowPageNo, totalPage);
				}
				else {
					v_html_faq += "<span style='font-size: 13pt;'>등록된 질문이 없습니다.</span>";
				}
				
				$("div#faqList").html(v_html_faq);
				
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});// $.ajax-----------------------------
		
		
		// == 자주묻는질문 페이지바 == //
		function makeAllFaqListPageBar(currentShowPageNo, totalPage){
			const blockSize = 10;
			
			let loop = 1;
			
			let pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
			
			let pageBar_HTML = "<ul style='list-style:none;'>";
			
			// [맨처음][이전] 만들기
			if(pageNo != 1) {
				pageBar_HTML += "<li class='fist_page'><a href='javascript:goViewFaqList(1,"+searchWordFaq+")'>[맨처음]</a></li>";
				pageBar_HTML += "<li class='before_page'><a href='javascript:goViewFaqList("+(pageNo-1)+","+searchWordFaq+")'>[이전]</a></li>"; 
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar_HTML += "<li class='this_page_no'>"+pageNo+"</li>";
				}
				else {
					pageBar_HTML += "<li class='choice_page_no'><a href='javascript:goViewFaqList("+pageNo+",searchWordFaq)'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while------------------------ 
			
			// [다음][마지막] 만들기
			if(pageNo <= totalPage) {
				pageBar_HTML += "<li class='next_page_no'><a href='javascript:goViewFaqList("+pageNo+","+searchWordFaq+")'>[다음]</a></li>";
				pageBar_HTML += "<li class='last_page_no'><a href='javascript:goViewFaqList("+totalPage+","+searchWordFaq+")'>[마지막]</a></li>"; 
			}
			
			pageBar_HTML += "</ul>";		
			
			// 페이지바 출력하기
			$("div#faqList_pageBar").html(pageBar_HTML);
		}
		
	}// end of function goViewFaqList(currentShowPageNo)-------------------------
	
	// == 질문 수정 == //
	function goUpdateFaq() {

		const question_update = $("textarea[name='question_update']").val();
		const answer_update = $("textarea[name='answer_update']").val();
		
		$("input[name='question_update']").val(question_update);
		$("input[name='answer_update']").val(answer_update);
		
		// 유효성 검사
		if(question_update == "") {
			alert("질문을 작성해주세요.")
			$("textarea[name='question_update']").focus();
			return;
		}
		
		if(answer_update == "") {
			alert("답변을 작성해주세요.")
			$("textarea[name='answer_update']").focus();
			return;
		}
		
		// 질문 Form
		const updateFrm = $("form[name='reservationFrm']").serialize();
       	
		// 질문 수정 데이터 넘기기
		$.ajax({
			url:"<%= ctxPath%>/updateFAQ.trip",
			type:"post",
			data:updateFrm,
			success:function(json) {
				$("#faqUpdateModal").modal("hide");
				goViewFaqList(1, "");
			},
			error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
		});// end of $.ajax------------------------
		
	}// end of function goUpdateFaq()---------------
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	
 	// == 검색하기 == //
	function goSearch() {
		const searchWordFaq = $("input[name='searchWordFaq']").val();
		goViewFaqList(1, searchWordFaq);
	}// end of function goSearch()--------------------
	
	
	// == 자주묻는질문 등록하기 == //
	function goRegisterFaq() {

	    const selected_category = $("#category-selectbox option:selected").val();
		const question = $("textarea#question").val().trim();
		const answer = $("textarea#answer").val().trim();
		
		// 카테고리 유효성 검사
		if(selected_category == "카테고리 선택") {
			alert("질문 카테고리를 선택하세요");
			return;
		}
		
		// 질문 유효성 검사
		if(question == "") {
			alert("질문 내용을 입력하세요");
			$("textarea#question").focus();
			return;
		}
		
		// 답변 유효성 검사
		if(answer == "") {
			alert("답변 내용을 입력하세요");
			$("textarea#answer").focus();
			return;
		}
		
		$("input[name='selected_category']").val(selected_category);
		$("input[name='question']").val(question);
		$("input[name='answer']").val(answer);

		const submit = $("form[name='reservationFrm']").serialize();
	
		// 질문 등록 데이터 넘기기
		$.ajax({
			url:"<%= ctxPath%>/registerFAQ.trip",
			type:"post",
			data:submit,
			dataType:"json",
			success:function(json) {
				if(json.n == 1) {
	        		$("#faqRegisterModal").modal("hide");
	        		location.href = "<%= ctxPath%>/support.trip"
	        	}
				else {
	        		alert("질문 등록에 실패했습니다.");
	        		$("#faqRegisterModal").modal("hide");
	        	}
			},
			error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
		});// end of $.ajax------------------------
		
	}// end of function goRegisterFaq()--------------------
	
</script>


<div class="body">
    <div class="navigation">
        <ul>
            <li class="list active">
                <a href="<%= ctxPath%>/support.trip">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">자주묻는질문</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/mypage_admin_chatting.trip">
                    <span class="icon"><ion-icon name="chatbubble-ellipses-outline"></ion-icon></span>
                    <span class="title">채팅</span><c:if test="${requestScope.newChattingCnt > 0}"><span style="border:solid 1px red; color:white; background-color:red; font-weight:bold; font-size:10px; width:40px; height:20px; border-radius:8px; text-align:center;">new</span></c:if>
                </a>
            </li>
        </ul>
    </div>
	
 	<form class="reservationFrm" name="reservationFrm">
		
		<div class="faq_header">
			<div>
				<h2 style="margin-bottom: 3%; font-weight: bold;">자주 묻는 질문 (FAQ)</h2>
				<p>고객님들이 제주드림 상품 및 서비스에 대해 자주 문의하는 내용입니다.<br>원하는 내용을 찾지 못하실 경우 <span style="color: orange;">웹채팅</span>으로 문의해 주시면 친절하게 안내해 드리겠습니다.
			</div>
		
			<!-- 자주묻는질문 등록 모달 시작-->
		    <div class="modal fade" id="faqRegisterModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		            
		                <div class="modal-header">
		                    <h3 class="modal-title" id="exampleModalLabel" style="margin-left: 2%; font-weight: 800; color: orange;">FAQ 등록</h3>
		                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                </div>
		                
		                <div class="modal-body" style="padding: 2% 5%;">
		                    <div class="form-group">
								<label class="col-form-label">질문 카테고리</label>
		                    	<select name="category-selectbox" id="category-selectbox" class="mb-3">
		                    		<option selected>카테고리 선택</option>
		                    		<option>예약</option>
		                    		<option>카드/결제</option>
		                    		<option>숙소</option>
		                    		<option>맛집</option>
		                    		<option>즐길거리</option>
		                    		<option>기타</option>
		                    	</select>
		                    	<input type="hidden" name="selected_category"/><br>
		                        
		                        <label for="question" class="col-form-label">질문</label>
		                        <textarea class="form-control register-input mb-3" id="question" name="question" placeholder="등록할 질문을 작성하세요."></textarea>
		                        <input type="hidden" id="question" name="question"/>
		                        
		                        <label for="answer" class="col-form-label">답변</label>
		                        <textarea class="form-control register-input mbs-3" id="answer" name="answer" placeholder="질문에 대한 답변을 작성하세요."></textarea>
		                        <input type="hidden" id="answer" name="answer"/>
						    
		                    </div>
		                </div>
		                
		                <div class="modal-footer">
		                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="sprintSettingModalClose">취소</button>
		                    <button type="button" class="btn btn-info" id="btnRegister" onclick="goRegisterFaq()">등록</button>
		                </div>
		    
		            </div>
		        </div>
		    </div>
			<!-- 일정 추가 모달 끝-->
		
			<!-- 검색창 -->
			<div style="margin-top: 5%;">
				<span>
					<input type="text" name="searchWordFaq" id="searchWordFaq" placeholder="검색어를 입력하세요.">
					<input type="text" style="display: none;">
	                <button type="button" id="btnSearch" title="검색" onclick="goSearch()">검색</button>
				</span>
			</div>
		</div>
		

		<div class="faq_content" style="margin-top: 5%;">
					
			<!-- FAQ 카테고리 네비바 -->
			<button type="button" class="btn btn-warning float-right" id="btnRegisterFaq">질문등록</button>	
			<ul class="nav nav-tabs">
				<li class="nav-item">
					<a class="nav-link active faq_category" data-toggle="tab" href="#faqList">전체</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href=#faqList>예약</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">카드/결제</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">숙소</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">맛집</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">즐길거리</a>
				</li>
				<li class="nav-item">
					<a class="nav-link faq_category" data-toggle="tab" href="#faqList">기타</a>
				</li>
			</ul>
			
			<!-- FAQ 리스트 담기는 곳 -->
			<div class="tab-content" style="border: none;"><br>
				<div class="accordion">
				    <div class="accordion-item" id="accordion-item">
				    	<div id="faqList">
				    	
				    	</div>
				    </div>
				</div>
			</div>
			<div id="faqList_pageBar" class="pageBar"></div>
			<input type="hidden" name="faq_category"/>
			
			<!-- 질문 수정 모달 시작-->
		    <div class="modal fade" id="faqUpdateModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		            
		                <div class="modal-header">
		                    <h3 class="modal-title" id="exampleModalLabel" style="margin-left: 2%; font-weight: 800; color: orange;">FAQ 수정</h3>
		                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                </div>
		                
		                <div class="modal-body" style="padding: 0 5% 2% 5%;">
		                    <div class="form-group">
		                    	<input type="hidden" name="update_faq_seq"/><br>
		                    	
		                    	<span>※ 수정사항을 입력해주세요.</span><br><br><br>
		                    	
		                        <label for="question_update" class="col-form-label">질문</label>
		                        <textarea class="form-control update-input mb-1" id="question_update" name="question_update"></textarea>
		                        <input type="hidden" id="question_update" name="question_update"/><br>
		                        
		                        <label for="answer_update" class="col-form-label">답변</label>
		                        <textarea class="form-control update-input mb-4" id="answer_update" name="answer_update"></textarea>
		                        <input type="hidden" id="answer_update" name="answer_update"/>
		                    </div>
		                </div>
		                
		                <div class="modal-footer">
		                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="sprintSettingModalClose">취소</button>
		                    <button type="button" class="btn btn-info" id="btnUpdate" onclick="goUpdateFaq()">수정</button>
		                </div>
		    
		            </div>
		        </div>
		    </div>
			<!-- 일정 추가 모달 끝-->
			
			
			
			
			
		</div>
	</form>


</div>