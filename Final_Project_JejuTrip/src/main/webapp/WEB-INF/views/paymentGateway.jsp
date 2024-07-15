<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
	// JejuDream
%>

<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.2.js"></script>

<script type="text/javascript">

$(document).ready(function() {
	
	if(window.opener && !window.opener.closed){
		
		/*
        const paymentTotalPrice = $(window.opener.document).find("input#totalPrice").val();
         alert("확인용 결제금액 : "+paymentTotalPrice);
		*/
		
		const roomname = $(window.opener.document).find("div#room").text();
		// alert("확인용 객실명 : "+roomname);
		
		// const room_code = $(window.opener.document).find("input#room_code").val();
		// alert("확인용 숙소코드 : " + room_code);

	
		//	여기 링크를 꼭 참고하세용 http://www.iamport.kr/getstarted
	   	var IMP = window.IMP;     // 생략가능
	   	IMP.init('imp55551872');  // 중요!!  아임포트에 가입시 부여받은 "가맹점 식별코드".
		
	   	// 결제요청하기
	   	IMP.request_pay({
		    pg : 'html5_inicis', // 결제방식 PG사 구분
		    pay_method : 'card',	// 결제 수단
		    merchant_uid : 'merchant_' + new Date().getTime(), // 가맹점에서 생성/관리하는 고유 주문번호
		    name : roomname,	 // 상품명 또는 코인충전 또는 order 테이블에 들어갈 주문명 혹은 주문 번호. (선택항목)원활한 결제정보 확인을 위해 입력 권장(PG사 마다 차이가 있지만) 16자 이내로 작성하기를 권장
		    amount : 100,	  // *** '${coinmoney}'  결제 금액 number 타입. 필수항목. 
		    buyer_email : '${sessionScope.loginuser.email}',  // 구매자 email
		    buyer_name : '${sessionScope.loginuser.user_name}',	  // 구매자 이름 
		    buyer_tel : '${sessionScope.loginuser.mobile}',    // 구매자 전화번호 (필수항목)
		    buyer_addr : '',  
		    buyer_postcode : '',
		    m_redirect_url : ''  // 휴대폰 사용시 결제 완료 후 action : 컨트롤러로 보내서 자체 db에 입력시킬것!
	   	}, function(rsp) {
    	
			if ( rsp.success ) { // PC 데스크탑용
			/* === 팝업창에서 부모창 함수 호출 방법 3가지 ===
			    1-1. 일반적인 방법
				opener.location.href = "javascript:부모창스크립트 함수명();";
				opener.location.href = "http://www.aaa.com";
				
				1-2. 일반적인 방법
				window.opener.부모창스크립트 함수명();
		
				2. jQuery를 이용한 방법
				$(opener.location).attr("href", "javascript:부모창스크립트 함수명();");
			*/
			//	아래 셋다 같은거다 . 문법만 다름
				
				alert("결제성공");
				
				window.opener.goReserveInsert();
				
				self.close();
				
				<%-- window.opener.checkOutUpdate('<%= ctxPath%>','${sessionScope.loginuser.userid}', isPaymentcheck); --%>
				
       		} else {
	            alert("결제에 실패하였습니다.");
	            self.close();
	       	}
		
	   	}); // end of IMP.request_pay()----------------------------
	   	
	   	<%--
	 	// 사용자가 임의로 팝업창을 닫은경우
		$(window).bind("beforeunload", function (e){
			window.opener.checkOutUpdate('<%= ctxPath%>','${requestScope.userid}', isPaymentcheck);

		});// end of $(window).bind("beforeunload", function (e)----------
		--%>		
	   
	}// end of if (window.opener && !window.opener.closed)------------
	else{ // 부모창이 꺼지던가, 로그인이 안된 경우
		alert("비정상적인 이동경로 입니다.");
		self.close();
	}
	
}); // end of $(document).ready()-----------------------------

</script>

