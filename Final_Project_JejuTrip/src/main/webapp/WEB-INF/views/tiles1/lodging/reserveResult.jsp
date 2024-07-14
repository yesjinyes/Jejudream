<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

<style>

#logo{

	margin-left: 55%;

}

.content{

	font-size:20px;
	color:gray;

}

.label {
	font-size:20px;
    font-weight: bold;
}
.recommendation {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-bottom: 10px;
    background-color: #f8f9fa;
}

</style>

<c:set var="resultMap" value="${requestScope.resultMap}"/>
	 <div class="container mt-3">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <div style="width: 40%;">
                    <img id="logo" alt="" src="<%= ctxPath %>/resources/images/logo_circle.png" style="width: 150px;">
                </div>
                <div class="ml-3" style="width: 60%;">
                    <span style="font-size:24px;">감사합니다. 예약신청이 완료되었습니다!<br>빠른 예약확정을 도와드릴게요!</span>
                </div>
            </div>
            <div class="card-body d-flex">
                <div style="flex: 2;">
                    <h3 class="text-center my-5">
                        <c:if test="${resultMap.leftdays > 0}">체크인 날짜까지 <span style="color:blue;">${resultMap.leftdays}</span>일 남았습니다!</c:if>
                        <c:if test="${resultMap.leftdays == 0}">잊지마세요! 오늘이 바로 체크인날!</c:if>
                    </h3>
                    <label class="h4 my-3">예약 신청결과</label>
                    <p><span class="label">예약번호 :</span> <span class="content">${resultMap.reservation_code}</span></p>
                    <p><span class="label">숙소명 :</span> <span class="content">${resultMap.lodging_name}</span></p>
                    <p><span class="label">숙소 주소 :</span> <span class="content">${resultMap.lodging_address}</span></p>
                    <p><span class="label">숙소 연락처 :</span> <span class="content">${resultMap.lodging_tell}</span></p>
                    <p><span class="label">객실명 :</span> <span class="content">${resultMap.room_name}</span></p>
                    <p><span class="label">결제 금액 :</span> <span class="content"><fmt:formatNumber value="${resultMap.reservation_price}" pattern="#,###"/>원</span></p>
                    <p><span class="label">총 숙박일 :</span> <span class="content">${resultMap.days}박 <fmt:formatNumber var="outday" value="${resultMap.days}"/>${outday + 1}일</span></p>
                    <p><span class="label">체크인 날짜 :</span> <span class="content">${resultMap.check_in}</span></p>
                    <p><span class="label">체크아웃 날짜 :</span> <span class="content">${resultMap.check_out}</span></p>
                </div>
                <div style="flex: 1; margin-left: 20px;">
                    <div class="recommendation">
                        <h5>같은 지역 맛집 추천</h5>
                        <div></div>
                    </div>
                    <div class="recommendation">
                        <h5>같은 지역 즐길거리 추천</h5>
                        <div></div>
                    </div>
                </div>
            </div>
            <div class="text-center px-3 mb-4">
                <button type="button" class="btn btn-lg btn-light mx-3" onclick="javascript:location.href='<%= ctxPath%>/requiredLogin_goMypage.trip'">나의 예약현황</button>
                <button type="button" class="btn btn-lg btn-warning mx-3" onclick="javascript:location.href='<%= ctxPath%>/lodgingList.trip'">숙소리스트</button>
            </div>
        </div>
    </div>