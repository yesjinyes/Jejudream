<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
    //    /JejuDream
%>

    <style>
        #logo {
            margin-left: 55%;
        }

        .content {
            font-size: 20px;
            color: gray;
        }

        .label {
            font-size: 20px;
            font-weight: bold;
        }

        .recommendation {
            border: 1px solid black;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 10px;
            background-color: #f8f9fa;
        }

        .rand {
            display: flex;
        }

        .mini_img {
            width: 140px;
            height: 140px;
            border-radius: 5px;
            margin-right: 10px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <c:set var="resultMap" value="${requestScope.resultMap}" />
    <div class="container my-3">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <div class="col-md-4">
                    <img id="logo" alt="" src="<%= ctxPath %>/resources/images/예약결과슉슉이.png" class="img-fluid" style="width: 150px;">
                </div>
                <div class="col-md-8 ml-3">
                    <span style="font-size:24px;">감사합니다. 예약신청이 완료되었습니다!<br>빠른 예약확정을 도와드릴게요!</span>
                </div>
            </div>
            <div class="card-body row">
                <div class="col-lg-8 col-md-7">
                    <h3 class="text-center my-5">
                        <c:if test="${resultMap.leftdays > 0}">체크인 날짜까지 <span style="color:blue;">${resultMap.leftdays}</span>일 남았습니다!</c:if>
                        <c:if test="${resultMap.leftdays == 0}">잊지마세요! 오늘이 바로 체크인날!</c:if>
                    </h3>
                    <label class="h4 my-3">예약 신청결과</label>
                    <table class="table">
                        <tbody>
                            <tr>
                                <th class="label">예약번호</th>
                                <td class="content">${resultMap.reservation_code}</td>
                            </tr>
                            <tr>
                                <th class="label">숙소명</th>
                                <td class="content">${resultMap.lodging_name}</td>
                            </tr>
                            <tr>
                                <th class="label">숙소 주소</th>
                                <td class="content">${resultMap.lodging_address}</td>
                            </tr>
                            <tr>
                                <th class="label">숙소 연락처</th>
                                <td class="content">${resultMap.lodging_tell}</td>
                            </tr>
                            <tr>
                                <th class="label">객실명</th>
                                <td class="content">${resultMap.room_name}</td>
                            </tr>
                            <tr>
                                <th class="label">결제 금액</th>
                                <td class="content"><fmt:formatNumber value="${resultMap.reservation_price}" pattern="#,###" />원</td>
                            </tr>
                            <tr>
                                <th class="label">총 숙박일</th>
                                <td class="content">${resultMap.days}박 <fmt:formatNumber var="outday" value="${resultMap.days}" />${outday + 1}일</td>
                            </tr>
                            <tr>
                                <th class="label">체크인 날짜</th>
                                <td class="content">${resultMap.check_intime}</td>
                            </tr>
                            <tr>
                                <th class="label">체크아웃 날짜</th>
                                <td class="content">${resultMap.check_outtime}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="col-lg-4 col-md-5 mt-4 mt-md-0" style="align-content:center;">
                    <div class="recommendation">
                        <h5>같은 지역 맛집 추천</h5>
                        <div class="rand">
                            <div>
                                <a href="<%= ctxPath %>/foodstoreDetail.trip?food_store_code=${requestScope.randMap.fvo.food_store_code}">
                                    <img class="mini_img" alt="" src="<%= ctxPath %>/resources/images/foodstore/imgMain/${requestScope.randMap.fvo.food_main_img}">
                                </a>
                            </div>
                            <div>
                                <a href="<%= ctxPath %>/foodstoreDetail.trip?food_store_code=${requestScope.randMap.fvo.food_store_code}">
                                    <h4>${requestScope.randMap.fvo.food_name}</h4>
                                </a>
                                <p>${requestScope.randMap.fvo.food_content}</p>
                            </div>
                        </div>
                    </div>
                    <div class="recommendation">
                        <h5>같은 지역 즐길거리 추천</h5>
                        <div class="rand">
                            <div>
                                <a href="<%= ctxPath %>/goAddSchedule.trip?play_code=${requestScope.randMap.pvo.play_code}">
                                    <img class="mini_img" alt="" src="<%= ctxPath %>/resources/images/play/${requestScope.randMap.pvo.play_main_img}">
                                </a>
                            </div>
                            <div>
                                <a href="<%= ctxPath %>/goAddSchedule.trip?play_code=${requestScope.randMap.pvo.play_code}">
                                    <h4>${requestScope.randMap.pvo.play_name}</h4>
                                </a>
                                <p>${requestScope.randMap.pvo.play_content}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center px-3 mb-4">
                <button type="button" class="btn btn-lg btn-light mx-3" onclick="javascript:location.href='<%= ctxPath %>/requiredLogin_goMypage.trip'">나의 예약현황</button>
                <button type="button" class="btn btn-lg btn-warning mx-3" onclick="javascript:location.href='<%= ctxPath %>/lodgingList.trip'">숙소리스트</button>
            </div>
        </div>
    </div>
