<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    
    
    
<style>


ul.pagination li {
   font-size: 12pt;
   border: solid 0px gray;

}
.pagination{

justify-content: center;
}


.pagination a {
    color: #555;
    float: left;
    padding: 8px 16px;
    text-decoration: none;
    transition: color .3s;
}

.pagination a.active {
   /*
    color: white;
    background-color: #2196F3;*/
    text-decoration: underline;
    font-weight: bolder;
    color:#2196F3;
}

.pagination a.active:hover,
.pagination a:hover:not(.active) {
    color: #2196F3;
}

.pagination .disabled {
    color: black;
    pointer-e
}    	

.cen {

	vertical-align: middle !important;
}	
	
</style>    
    
    
<div class="container" style="padding: 3% 0;">
   
   
   <div class="col-md-12 mx-auto pt-4">
            <h2 class="text-center mb-5"> 축제와 행사 목록 </h2>
            
            <form name="">
			    <input type="text" name="searchWord" /> 
       			<input type="text" style="display: none;" /> 
      			<button type="button" class="btn btn-secondary" onclick="goSearch()">검색</button>
			    <p class="text-right form-group">
		            <label for="startDate">축제 시작 날짜 :</label>
		            <input type="date" id="startDate" name="startDate" class="px-4" value="${requestScope.startDate}">
		        </p>
		        <p class="text-right form-group">
		            <label for="endDate">축제 종료 날짜 :</label>
		            <input type="date" id="endDate" name="endDate" class="px-4" value="${requestScope.endDate}">
		        </p>
		        <p class="text-right">
		            <button type="submit" class="btn-submit btn-light">조회</button>
		        </p>
			</form>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th scope="col" class="text-center">축제등록번호</th>
                        <th scope="col" class="text-center">축제명</th>
                        <th scope="col" class="text-center">시작날짜</th>
                        <th scope="col" class="text-center">종료날짜</th>
                        <th scope="col" class="text-center">지역구분</th>
                        <th scope="col" class="text-center">축제링크</th>
                        <th scope="col" class="text-center">수정/삭제</th>
                    </tr>
                </thead>
                <tbody>
                    
                        <tr>
                            <td class="cen text-center" style="cursor: pointer;">ddd</td>
                            <td class="cen text-center">fff</td>
                            <td class="cen text-center">cc
                                
                            </td>
                            <td class="cen text-center">총 <fmt:formatNumber value="" type="number" groupingUsed="true" />원</td>
                            <td class="cen text-center">dsa</td>
                            <td class="cen text-center">asd</td>
                            <td class="cen text-center">
                                <button type="button" class="btn btn-info">수정</button>
                                <button type="button" class="btn btn-danger">삭제</button>
                                <input name="ordercode" type="hidden" value="${odr.ordercode}" />
                            </td>
                        </tr>
                   
                </tbody>
            </table>
            <div class="d-flex justify-content-center pt-3">
                <div id="pageBar">
                    <nav>
                        <ul class="pagination">
                            <li>${requestScope.pageBar}</li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>    