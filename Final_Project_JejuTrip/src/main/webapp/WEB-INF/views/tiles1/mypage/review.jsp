<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> 

<%
    String ctxPath = request.getContextPath();
%>   

<%-- Bootstrap CSS --%>
<link rel="stylesheet" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>


<style type="text/css">

.container {
	
	border: solid 0px red;
    float: none;
    width: 100%;
    margin: 64px auto 0px;
}


table#memberTbl {
   width: 100%;
   margin: 0 auto;
}

table#memberTbl th, table#memberTbl td {
   text-align: center;
   font-size: 12pt;
}

table#memberTbl tr.memberInfo:hover {
   background-color: #e6ffe6;
   cursor: pointer;
}

form[name="member_search_frm"] {
   border: solid 0px red;
   width: 50%;
   margin: 0 auto 3% auto;
   display: flex;
   align-items: center;
}

form[name="member_search_frm"] button.btn-secondary {
   width: 20%;
   height: 5%;
   margin-left: 2%;
   margin-right: 2%;
}

div#pageBar {
   border: solid 0px red;
   width: 80%;
   margin: 3% auto 0 auto;
   display: flex;
}

div#pageBar>nav {
   margin: auto;
}

.titleArea{
    color: #1a1a1a;
    font-size: 32px;
    font-weight: 700;
    text-align: center;
    line-height: 40px;
    text-transform: uppercase;
    
 }
 
 a{
    color:black !important;
 }
 .countReview{
 border:1px #ff8000 solid; 
 background: #ff8000;
 min-width:100px; 
 border-radius:30px;  
 display: inline-block; 
 font-size: 20px;
}

</style>

<script type="text/javascript">


$(document).ready(function() {




   $("table#questioTbl tr.questioninfo").click(e=>{
      
      const question_seq = $(e.target).parent().children(".question_seq").text();
   
      const frm = document.QuestionDetail_frm;
      frm.question_seq.value = question_seq;
      
      
      frm.action = "<%= ctxPath%>/member/questionView.dk";
      frm.method = "post";
      frm.submit();
   });   

   

});//end of ------------------------


/*
function goSearch(){
	
	
	const searchType = $("select[name='searchType']").val();
	
	if(searchType == ""){
		alert("검색대상을 선택하세요!!");
		return;//종료
	}
	
	const frm = document.member_search_frm; //회원을 찾는 폼
	// frm.action = "memberList.up";
	// form 태그에 action 이 명기되지 않았으면 현재보이는 URL 경로로 submit 되어진다.
	// frm.method = "get";
	// form 태그에 method 를 명기하지 않으면 "get" 방식이다.
	frm.submit();
	
}//end of function goSearch()-----------------	
*/


   
</script>


<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
   <h2 class="titleArea ">
      <font face="Arial">나의 이용후기</font>
      <span class="countReview">0건</span>
   </h2>
   <br> &nbsp;
   
   <div style="display:flex;justify-content:flex-end;">
      <button type="button" class="btn" style="background-color: #ff8000; font-weight: bold; color:#fff;" onclick="" >이용후기등록</button>
   </div>
      
   &nbsp;
   <table class="table table-hover" id="questioTbl">
      <thead>
         <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성일</th>
            <th>작성자</th>
           
         </tr>
      </thead>

         <tbody>
            <c:if test="${not empty requestScope.questionList}" >
               <c:forEach var="rieview" items="${requestScope.questionList}" varStatus="status">
                  <c:if test="${sessionScope.loginuser.id == question.id || sessionScope.loginuser.id == 'admin'}" >
                     <tr class="rieviewinfo" >
                     	<fmt:parseNumber var="currentPage" value="${requestScope.currentPage}"/>
          				<fmt:parseNumber var="blockSize" value="${requestScope.blockSize}"/>
          				
          				<td>${(requestScope.totalQuestionCount) -( currentPage - 1 ) * blockSize-(status.index)}</td>
                        <td class="rieview_seq" style="display:none;">${question.question_seq}</td>  <%--번호--%>    
                        <td>${question.title}</td>                          						  <%--제목 --%>
                        <td>${question.ragisterdate}</td>                   		                  <%--작성일 --%>
                        <td>${question.id}</td>                        				                  <%--작성자 --%>
                        
                     </tr>
                  </c:if>
               </c:forEach>
            </c:if>
            
            <c:if test="${empty requestScope.questionList}">
                   <td colspan="5" style="text-align: center;">작성한 이용후기가 없습니다.</td>
               </c:if>
      </tbody>
         

   </table>

  
   <div id="pageBar">
       <nav>
          <ul class="pagination">${requestScope.pageBar}</ul>
       </nav>
    </div>
</div>

<form name="RieviewDetail_frm">
   <input type="hidden" name="rieview_seq"/> <%--한명의 회원을 넘겨주기위해--%>
   <input type="hidden" name="goBackURL" value="${requestScope.currentURL}" /> 
</form>
	
</body>
</html>