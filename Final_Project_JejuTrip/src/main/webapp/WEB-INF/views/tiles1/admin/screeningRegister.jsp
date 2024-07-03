<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/admin/screeningRegister.css"/>
<script type="text/javascript">
    $(document).ready(function(){
		$("select[name='choice_status']").bind("change",function(e){
			location.href="<%=ctxPath%>/screeningRegister.trip?choice_status="+$(e.target).val();
		});
		
		if(${not empty requestScope.choice_status}){
			$("select[name='choice_status']").val(${requestScope.choice_status})
		}
		
		$("input[name='agree']").bind("click",function(e){
			let status = 0;
			let feedback_msg = "";
			if($(e.target).val()=="승인"){
				if(confirm("정말 승인하시겠습니까?")){
					status = 1;	
				}
				else{
					return;
				}
			}
			else{
				if(confirm("정말 반려하시겠습니까?")){
					status = 2;
					feedback_msg = $("textarea").val();	
				}
				else{
					return;	
				}
			}
			const lodging_code = $(e.target).next().val();
			
			update_status(lodging_code,status,feedback_msg);
		});
		
		$("input[name='disagree']").bind("click",function(e){
			if($(e.target).val()=="반려"){
				$("textarea").show();
				$(e.target).parent().find("input[name='agree']").val("반려");
				$(e.target).parent().find("input[name='agree']").addClass("change_disagree");
				$(e.target).val("취소");
			}
			else{
				$("textarea").val("");
				$("textarea").hide();
				$(e.target).parent().find("input[name='agree']").val("승인");
				$(e.target).parent().find("input[name='agree']").removeClass("change_disagree");
				$(e.target).val("반려");
			}
		});
    }); // end of $(document).ready(function(){

	function update_status(lodging_code, status, feedback_msg){
		$.ajax({
			url:"<%= ctxPath%>/screeningRegisterEnd.trip",
			data:{"lodging_code":lodging_code 
				 ,"status":status
				 ,"feedback_msg":feedback_msg}, 
			type:"post",
			dataType:"json",
			success:function(json){
			    if(json.n == 0){
			    	alert("해당 처리 과정에서 문제가 생겼습니다.");
			    }
			    else {
			    	location.href="<%=ctxPath%>/screeningRegister.trip";
			    }
			},
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); 
	}
</script>

<select name="choice_status">
	<option selected>전체</option>
	<option value="0">등록요청</option>
	<option value="1">승인완료</option>
	<option value="2">반려</option>
</select>

<c:if test="${not empty requestScope.lodgingvoList}">
	<c:forEach var="lodgingvo" items="${requestScope.lodgingvoList}">
		<div class="container">
			<div class="info">
	            <div class="info_block">
	                <h4 style="display:inline-block;">${lodgingvo.lodging_name}</h4>
	                <c:if test="${lodgingvo.status == 0}">
	                	<h5 style="display:inline-block; color:blue;">등록 요청</h5>
	                </c:if>
					<c:if test="${lodgingvo.status == 1}">
	                	<h5 style="display:inline-block; color:green;">승인 완료</h5>
	                </c:if>
					<c:if test="${lodgingvo.status == 2}">
	                	<h5 style="display:inline-block; color:red;">반려</h5>
	                </c:if>
	            </div>
				<div class="info_block">
	                <div>숙소구분 : ${lodgingvo.lodging_category}</div>
	            </div>
				<div class="info_block">
	                <div>전화번호 : ${lodgingvo.lodging_tell}</div>
	            </div>
				<div class="info_block">
	                <div>주소 : ${lodgingvo.lodging_address}</div>
	            </div>
				<div class="info_block">
	                <div>지역구분 : ${lodgingvo.local_status}</div>
	            </div>
				<div class="info_block">
	                <div>숙소설명 : ${lodgingvo.lodging_content}</div>
	            </div>
				<div class="info_block">
	                <c:if test="${lodgingvo.fileName == null}">
	                	<img style="width:100%;" src="<%=ctxPath%>/resources/images/lodginglist/${lodgingvo.main_img}"/>
	                </c:if>
	                <c:if test="${lodgingvo.fileName != null}">
	                	<img style="width:100%;" src="<%=ctxPath%>/resources/images/lodginglist/${lodgingvo.fileName}"/>
	                </c:if>
	            </div>
                <c:if test="${lodgingvo.status == 0}">
	                <textarea name="disagree_text" placeholder="반려사유"></textarea>
					<div style="margin-top: 30px;">
						<input type="button" class="agree" name="agree" value="승인"/>
						<input type="hidden" name="lodging_code" value="${lodgingvo.lodging_code}"/>
						<input type="button" class="disagree" name="disagree" value="반려"/>
					</div>
                </c:if>
	        </div>
        </div>
	</c:forEach>
	<div class="pageBar">${requestScope.pageBar}</div>
</c:if>