<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/admin/screeningRegister.css"/>
<script type="text/javascript">
    $(document).ready(function(){

    }); // end of $(document).ready(function(){
</script>
<c:if test="${not empty requestScope.lodgingvoList}">
	<c:forEach var="lodgingvo" items="${requestScope.lodgingvoList}">
		<div class="container">
			<div class="info">
	            <div class="info_block">
	                <input type="text" name="lodging_name" id="lodging_name" placeholder="숙소 명 입력">
	                
	            </div>
	            
	        </div>
        </div>
	</c:forEach>
</c:if>