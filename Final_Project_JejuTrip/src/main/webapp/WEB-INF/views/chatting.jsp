<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="<%=ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" >

<%-- === #223. (웹채팅관련5) === --%>
<script type="text/javascript">
	let total_fileSize = 0;
	//=== !!! WebSocket 통신 프로그래밍은 HTML5 표준으로써 자바스크립트로 작성하는 것이다. !!! === //
	// WebSocket(웹소켓)은 웹 서버로 소켓을 연결한 후 데이터를 주고 받을 수 있도록 만든 HTML5 표준이다. 
	// 그런데 이러한 WebSocket(웹소켓)은 HTTP 프로토콜로 소켓 연결을 하기 때문에 웹 브라우저가 이 기능을 지원하지 않으면 사용할 수 없다. 
	/*
	>> 소켓(Socket)이란? 
	  - 어떤 통신프로그램이 네트워크상에서 데이터를 송수신할 수 있도록 연결해주는 연결점으로써 
	    IP Address와 port 번호의 조합으로 이루어진다. 
	      또한 어떤 하나의 통신프로그램은 하나의 소켓(Socket)만을 가지는 것이 아니라 
	      동일한 프로토콜, 동일한 IP Address, 동일한 port 번호를 가지는 수십개 혹은 수만 개의 소켓(Socket)을 가질 수 있다.
	
	   =================================================================================================  
	      클라이언트  소켓(Socket)                                         서버  소켓(Socket)
	        211.238.142.70:7942 ◎------------------------------------------◎  211.238.142.72:9099
	   
	        클라이언트는 서버인 211.238.142.72:9090 소켓으로 클라이언트 자신의 정보인 211.238.142.70:7942 을 
	        보내어 연결을 시도하여 연결이 이루어지면 서버는 클라이언트의 소켓인 211.238.142.70:7942 으로 데이터를 보내면서 통신이 이루어진다.
	 ================================================================================================== 
	        
	        소켓(Socket)은 데이터를 통신할 수 있도록 해주는 연결점이기 때문에 통신할 두 프로그램(Client, Server) 모두에 소켓이 생성되야 한다.
	
	    Server는 특정 포트와 연결된 소켓(Server 소켓)을 가지고 서버 컴퓨터 상에서 동작하게 되는데, 
	     이 Server는 소켓을 통해 Cilent측 소켓의 연결 요청이 있을 때까지 기다리고 있다(Listening 한다 라고도 표현함).
	    Client 소켓에서 연결요청을 하면(올바른 port로 들어왔을 때) Server 소켓이 허락을 하여 통신을 할 수 있도록 연결(connection)되는 것이다.
	*/

	$(document).ready(function(){
	    
	    const url = window.location.host; // 웹브라우저의 주소창의 포트까지 가져오는 것이다.
		// alert("url : " + url);
	    // url : 192.168.0.191:9099
	
	    const pathname = window.location.pathname; // 최초 '/' 부터 오른쪽에 있는 모든 주소창의 정보를 가져온다.
	    // alert("pathname : " + pathname);
	    // pathname : /JejuDream/mypage_chatting_toCompany.trip
	    
	    const appCtx = pathname.substring(0,pathname.lastIndexOf("/")); // "전체 문자열".lastIndexOf("검사할 문자"); 
	    // alert("appCtx : " + appCtx);
	    // appCtx : /board
	    
	    const root = url + appCtx;
	    // alert("root : " + root);
	    // root : 192.168.0.191:9099/JejuDream
	    
	    const wsUrl = "ws://"+root+"/multichatstart.trip";
		// 웹소켓통신을 하기위해서는 http:// 을 사용하는 것이 아니라 ws:// 을 사용해야 한다. 
	    // "/multichatstart.action" 에 대한 것은 /WEB-INF/spring/config/websocketContext.xml 파일에 있는 내용이다.
	    
	    const websocket = new WebSocket(wsUrl);
		// 즉 const websocket = new WebSocket("ws//192.168.0.191:9099/board/chatting/multichatstart.action"); 이다.
	 	// >> ====== !!중요!! Javascript WebSocket 이벤트 정리 ====== << //
	    /*   -------------------------------------
				이벤트 종류             		설명
	         -------------------------------------
	             onopen         WebSocket 연결
	             onmessage      메시지 수신
	             onerror        전송 에러 발생
	             onclose        WebSocket 연결 해제
	    */
	    
	    // === 웹소켓에 최초로 연결이 되었을 경우에 실행되어지는 콜백함수 정의하기 === //
	    let messageObj = {}; // 자바스크립트 객체 생성함
	    websocket.onopen = function(){
	 		// alert("웹소켓 연결됨.");
	    	 
	    	messageObj = {message : "채팅방에 <span style='color: red;'>입장</span> 했습니다."
                			,type : "all"
                			  ,to : "all"}; // 자바스크립트에서 객체의 데이터값 초기화 
                
   			websocket.send(JSON.stringify(messageObj));
               	// JSON.stringify(자바스크립트객체) 는 자바스크립트객체를 JSON 표기법의 문자열(string)로 변환한다
                // JSON.parse(JSON 표기법의 문자열) 는 JSON 표기법의 문자열(string)을 자바스크립트객체(object)로 변환해준다.
			 	/*
         			JSON.stringify({});                  // '{}'
			       	JSON.stringify(true);                // 'true'
			       	JSON.stringify('foo');               // '"foo"'
			       	JSON.stringify([1, 'false', false]); // '[1,"false",false]'
			       	JSON.stringify({ x: 5 });            // '{"x":5}'
			 	*/ 
	 	};
	    
	 	// === 메시지 수신시 콜백함수 정의하기 === //
	 	websocket.onmessage = function(event){
	 		if(event.data.substr(0,1)=="「" && event.data.substr(event.data.length-1)=="」") {
            	
       	  	}
          	else {
            	// event.data 는 수신받은 채팅 문자이다.
            	$("div#chatMessage").append(event.data);
            	$("div#chatMessage").append("<br>");
             	$("div#chatMessage").scrollTop(99999999);
          	}
	 	};
	 	
	 	// === 웹소켓 연결 해제시 콜백함수 정의하기 === //
       	websocket.onclose = function(){
	          
       	}
	 	
	 	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 	
	 	
     	// === 메시지 입력후 엔터하기 === //
        $("input#message").keyup(function(key){
           	if(key.keyCode == 13) {
              	$("input#btnSendMessage").click(); 
           	}
        });
	 	
     	// === 메시지 보내기 === //
        let isOnlyOneDialog = false; // 귀속말 여부. true 이면 귀속말, false 이면 모두에게 공개되는 말 
        
        $("input#btnSendMessage").click(function(){
        
           if( $("input#message").val().trim() != "" ) {
              
           		// ==== 자바스크립트에서 replace를 replaceAll 처럼 사용하기 ====
             	// 자바스크립트에서 replaceAll 은 없다.
             	// 정규식을 이용하여 대상 문자열에서 모든 부분을 수정해 줄 수 있다.
             	// 수정할 부분의 앞뒤에 슬래시를 하고 뒤에 gi 를 붙이면 replaceAll 과 같은 결과를 볼 수 있다. 
             
                let messageVal = $("input#message").val();
                messageVal = messageVal.replace(/<script/gi, "&lt;script"); 
                // 스크립트 공격을 막으려고 한 것임.
                
                <%-- 
                 messageObj = {message : messageVal
                            ,type : "all"
                            ,to : "all"}; 
                --%>
                // 또는
                messageObj = {}; // 자바스크립트 객체 생성함. 
                messageObj.message = messageVal;
                messageObj.type = "all";
                messageObj.to = "all";
              
                const to = $("input#to").val();
                if( to != "" ){
                   	messageObj.type = "one";
                    messageObj.to = to;
                }
                
                websocket.send(JSON.stringify(messageObj));
                // JSON.stringify() 는 값을 그 값을 나타내는 JSON 표기법의 문자열로 변환한다
             
                // 위에서 자신이 보낸 메시지를 웹소켓으로 보낸 다음에 자신이 보낸 메시지 내용을 웹페이지에 보여지도록 한다. 
                
                const now = new Date();
                let ampm = "오전 ";
                let hours = now.getHours();
                
                if(hours > 12) {
                    hours = hours - 12;
                    ampm = "오후 ";
                }
                
                if(hours == 0) {
                    hours = 12;
                }
                
                if(hours == 12) {
                  	ampm = "오후 ";
                }
                
                let minutes = now.getMinutes();
                if(minutes < 10) {
                   	minutes = "0"+minutes;
                }
              
                const currentTime = ampm + hours + ":" + minutes; 
                
                if(isOnlyOneDialog == false) { // 귀속말이 아닌 경우
                   	$("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 8px; word-break: break-all;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>"); 
                                                                                                                                                                           /* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
                }
                
                else { // 귀속말인 경우. 글자색을 빨강색으로 함.
                   	$("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 8px; word-break: break-all; color: red;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>");
                                                                                                                                                                           /* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
                }
                
                $("div#chatMessage").scrollTop(99999999);
                
                $("input#message").val("");
                $("input#message").focus();
           }
           
        });
        ////////////////////////////////////////////////////
        
     	// 귀속말대화끊기 버튼은 처음에는 보이지 않도록 한다.
        $("button#btnAllDialog").hide();
        
        // 아래는 귓속말을 위해서 대화를 나누는 상대방의 이름을 클릭하면 상대방이름의 웹소켓id 를 알아와서 input태그인 귓속말대상웹소켓.getId()에 입력하도록 하는 것.
        
        $(document).on("click", "span.loginuserName", function(){
           /* span.loginuserName 은 
              com.spring.chatting.websockethandler.WebsocketEchoHandler 의 
              public void handleTextMessage(WebSocketSession wsession, TextMessage message) 메소드내에
              166번 라인에 기재해두었음.
           */
           
           const ws_id = $(this).prev().text();
        // alert(ws_id);
           $("input#to").val(ws_id); 
            
           $("span#privateWho").text($(this).text());
           $("button#btnAllDialog").show(); // 귀속말대화끊기 버튼 보이기 
            $("input#message").css({'background-color':'black', 'color':'white'});
            $("input#message").attr("placeholder","귀속말 메시지 내용");
            
            isOnlyOneDialog = true; // 귀속말 대화임을 지정 
        });  
        
        
        // 귀속말대화끊기 버튼을 클릭한 경우에는 전체대상으로 채팅하겠다는 말이다.
        $("button#btnAllDialog").click(function(){
           
           $("input#to").val("");
           $("span#privateWho").text("");
           $("input#message").css({'background-color':'', 'color':''});
           $("input#message").attr("placeholder","메시지 내용");
           $(this).hide();
           
           isOnlyOneDialog = false; // 귀속말 대화가 아닌 모두에게 공개되는 대화임을 지정.
        });
        
        let file_arr=[];// 첨부되어진 파일 정보를 담아둘 배열
        $("input#message").on("dragenter",function(e){
			/* "dragenter" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 최초로 들어왔을 때 */
			e.preventDefault();
	        <%-- 
	           브라우저에 어떤 파일을 drop 하면 브라우저 기본 동작이 실행된다. 
	           이미지를 drop 하면 바로 이미지가 보여지게되고, 만약에 pdf 파일을 drop 하게될 경우도 각 브라우저의 pdf viewer 로 브라우저 내에서 pdf 문서를 열어 보여준다. 
	           이것을 방지하기 위해 preventDefault() 를 호출한다. 
	           즉, e.preventDefault(); 는 해당 이벤트 이외에 별도로 브라우저에서 발생하는 행동을 막기 위해 사용하는 것이다.
	        --%>
	           
	        e.stopPropagation();
	        <%--
               propagation 의 사전적의미는 전파, 확산이다.
               stopPropagation 은 부모태그로의 이벤트 전파를 stop 중지하라는 의미이다.
               즉, 이벤트 버블링을 막기위해서 사용하는 것이다. 
               사용예제 사이트 https://devjhs.tistory.com/142 을 보면 이해가 될 것이다. 
	        --%>
		}).on("dragover", function(e){ /* "dragover" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 머물러 있는 중일 때. 필수이벤트이다. dragover 이벤트를 적용하지 않으면 drop 이벤트가 작동하지 않음 */ 
	           e.preventDefault();
	           e.stopPropagation();
	           $(this).css("background-color", "gray");
	    }).on("dragleave", function(e){ /* "dragleave" 이벤트는 Drag 한 파일이 드롭대상인 박스 밖으로 벗어났을 때  */
	           e.preventDefault();
	           e.stopPropagation();
	           $(this).css("background-color", "#fff");
	    }).on("drop", function(e){      /* "drop" 이벤트는 드롭대상인 박스 안에서 Drag 한것을 Drop(Drag 한 파일(객체)을 놓는것) 했을 때. 필수이벤트이다. */
	           e.preventDefault();
	           var files = e.originalEvent.dataTransfer.files;  
	           <%--  
	               jQuery 에서 이벤트를 처리할 때는 W3C 표준에 맞게 정규화한 새로운 객체를 생성하여 전달한다.
	               이 전달된 객체는 jQuery.Event 객체 이다. 이렇게 정규화된 이벤트 객체 덕분에, 
	               웹브라우저별로 차이가 있는 이벤트에 대해 동일한 방법으로 사용할 수 있습니다. (크로스 브라우징 지원)
	               순수한 dom 이벤트 객체는 실제 웹브라우저에서 발생한 이벤트 객체로, 네이티브 객체 또는 브라우저 내장 객체 라고 부른다.
	            --%>
	           /*  Drag & Drop 동작에서 파일 정보는 DataTransfer 라는 객체를 통해 얻어올 수 있다. 
	                jQuery를 이용하는 경우에는 event가 순수한 DOM 이벤트(각기 다른 웹브라우저에서 해당 웹브라우저의 객체에서 발생되는 이벤트)가 아니기 때문에,
	               event.originalEvent를 사용해서 순수한 원래의 DOM 이벤트 객체를 가져온다.
	                Drop 된 파일은 드롭이벤트가 발생한 객체(여기서는 $("div#fileDrop")임)의 dataTransfer 객체에 담겨오고, 
	                담겨진 dataTransfer 객체에서 files 로 접근하면 드롭된 파일의 정보를 가져오는데 그 타입은 FileList 가 되어진다. 
	                그러므로 for문을 사용하든지 또는 [0]을 사용하여 파일의 정보를 알아온다. 
	         */
	      	 // console.log(typeof files); // object
	         // console.log(files);
             /*
             FileList {0: File, length: 1}
             0: File {name: 'berkelekle단가라포인트03.jpg', lastModified: 1605506138000, lastModifiedDate: Mon Nov 16 2020 14:55:38 GMT+0900 (한국 표준시), webkitRelativePath: '', size: 57641, …}
                      length:1
             [[Prototype]]: FileList
             */
             
             if(files!=null && files != undefined){
            	// console.log("files.length 는 => " + files.length);  
                 // files.length 는 => 1 이 나온다.   
	                
	             <%--
	                for(let i=0; i<files.length; i++){
	                     const f = files[i];
	                     const fileName = f.name;  // 파일명
	                     const fileSize = f.size;  // 파일크기
	                     console.log("파일명 : " + fileName);
	                     console.log("파일크기 : " + fileSize);
	                 } // end of for------------------------
	             --%>
	             let html = "";
	               const f = files[0]; // 어차피 files.length 의 값이 1 이므로 위의 for문을 사용하지 않고 files[0] 을 사용하여 1개만 가져오면 된다. 
	              let fileSize = f.size/1024/1024;  /* 파일의 크기는 MB로 나타내기 위하여 /1024/1024 하였음 */
	              
	              if( !(f.type == 'image/jpeg' || f.type == 'image/png') ) {
	                 alert("jpg 또는 png 파일만 가능합니다.");
	                 $(this).css("background-color", "#fff");
	                 return;
	              }
	              
	              else if(fileSize >= 10) {
	                 alert("10MB 이상인 파일은 업로드할 수 없습니다.!!");
	                 $(this).css("background-color", "#fff");
	                 return;
	              }
	              
	              else {
	                 file_arr.push(f);
	                 const fileName = f.name; // 파일명   
	              
	                  fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1);
	                  // fileSize 가 1MB 보다 작으면 소수부는 반올림하여 소수점 3자리까지 나타내며, 
	                   // fileSize 가 1MB 이상이면 소수부는 반올림하여 소수점 1자리까지 나타낸다. 만약에 소수부가 없으면 소수점은 0 으로 표시한다.
	                   /* 
	                        numObj.toFixed([digits]) 의 toFixed() 메서드는 숫자를 고정 소수점 표기법(fixed-point notation)으로 표시하여 나타난 수를 문자열로 반환해준다. 
	                                        파라미터인 digits 는 소수점 뒤에 나타날 자릿수 로써, 0 이상 20 이하의 값을 사용할 수 있으며, 구현체에 따라 더 넓은 범위의 값을 지원할 수도 있다. 
	                        digits 값을 지정하지 않으면 0 을 사용한다.
	                        
	                        var numObj = 12345.6789;

	                   numObj.toFixed();       // 결과값 '12346'   : 반올림하며, 소수 부분을 남기지 않는다.
	                   numObj.toFixed(1);      // 결과값 '12345.7' : 반올림한다.
	                   numObj.toFixed(6);      // 결과값 '12345.678900': 빈 공간을 0 으로 채운다.
	                   */
	                   
	                   
	                  
	               // ===>> 이미지파일 미리보기 시작 <<=== // 
	                  // 자바스크립트에서 file 객체의 실제 데이터(내용물)에 접근하기 위해 FileReader 객체를 생성하여 사용한다.
	              // console.log(f);
	                  const fileReader = new FileReader();
	                 fileReader.readAsDataURL(f); // FileReader.readAsDataURL() --> 파일을 읽고, result속성에 파일을 나타내는 URL을 저장 시켜준다. 
	                
	                 fileReader.onload = function() { // FileReader.onload --> 파일 읽기 완료 성공시에만 작동하도록 하는 것임. 
	                 // console.log(fileReader.result); 
	                   /*
	                     data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAeAB4AAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAg 
	                     이러한 형태로 출력되며, img.src 의 값으로 넣어서 사용한다.
	                   */
	                    document.getElementById("previewImg").src = fileReader.result;
	                    $('#modal_showDetail').modal('show');
	                };
	                // ===>> 이미지파일 미리보기 끝 <<=== //
	              }
	              
             }// end of if(files!=null && files != undefined)
            	 $(this).css("background-color","#fff");
	    });
        
        $("button#addCom").click(function(){
			// 값을 입력했는지 안했는지 유효성 검사 시작 
			let is_infoData_OK = true;
			if(is_infoData_OK){
				/* 
	               FormData 객체는 ajax 로 폼 전송을 가능하게 해주는 자바스크립트 객체이다.
	               즉, FormData란 HTML5 의 <form> 태그를 대신 할 수 있는 자바스크립트 객체로서,
	               자바스크립트 단에서 ajax 를 사용하여 폼 데이터를 다루는 객체라고 보면 된다. 
	               FormData 객체가 필요하는 경우는 ajax로 파일을 업로드할 때 필요하다.
	            */ 
	    
	            /*
	              === FormData 의 사용방법 2가지 ===
	             <form id="myform">
	                <input type="text" id="title"   name="title" />
	                <input type="file" id="imgFile" name="imgFile" />
	             </form>
	               
	              첫번째 방법, 폼에 작성된 전체 데이터 보내기   
	              var formData = new FormData($("form#myform").get(0));  // 폼에 작성된 모든것       
	              또는
	              var formData = new FormData($("form#myform")[0]);  // 폼에 작성된 모든것
	              // jQuery선택자.get(0) 은 jQuery 선택자인 jQuery Object 를 DOM(Document Object Model) element 로 바꿔주는 것이다. 
	             // DOM element 로 바꿔주어야 순수한 javascript 문법과 명령어를 사용할 수 있게 된다. 
	       
	             또는
	              var formData = new FormData(document.getElementById('myform'));  // 폼에 작성된 모든것
	        
	              두번째 방법, 폼에 작성된 것 중 필요한 것만 선택하여 데이터 보내기 
	              var formData = new FormData();
	              // formData.append("key", value값);  // "key" 가 name 값이 되어진다.
	              formData.append("title", $("input#title").val());
	              formData.append("imgFile", $("input#imgFile")[0].files[0]);
	            */
				var formData = new FormData($("form[name='fileSend']").get(0));// $("form[name='prodInputFrm']").get(0) 폼 에 작성된 모든 데이터 보내기
	            
				if(file_arr.length > 0){ // 추가 이미지 파일을 추가했을 경우
					// 첨부한 파일의 총합의 크기가 10MB 이상 이라면 전송을 하지 못하게 막는다.
					let sum_file_size = 0;
				
					for(let i=0;i<file_arr.length;i++){
						sum_file_size += file_arr[i].size;
					}// end of for(let i=0;i<file_arr.length;i++){
						
					////////////////////////////////////////
                   	// 첨부한 파일의 총량을 누적하는 용도 
                   	total_fileSize += sum_file_size;
	              	////////////////////////////////////////
	              	
					if( sum_file_size >= 10*1024*1024 ) { // 첨부한 파일의 총합의 크기가 10MB 이상 이라면 
	                   alert("첨부한 추가이미지 파일의 총합의 크기가 10MB 이상이라서 제품등록을 할 수 없습니다.!!");
	                   return; // 종료
		            }
					else{
						formData.append("attachCount",file_arr.length);
						file_arr.forEach(function(item,index){
							formData.append("attach"+index,item); // 첨부파일 추가하기. item 이 첨부파일이다.
						});// end of file_arr.forEach(function(item){
					}
				}// end of if(file_arr.length > 0){ // 추가 이미지 파일을 추가했을 경우
				///////////////////////////////////////
	          	// 첨부한 파일의 총량이 20MB 초과시 //   
	          	if( total_fileSize > 20*1024*1024 ) {
	                alert("ㅋㅋㅋ 첨부한 파일의 총합의 크기가 20MB를 넘어서 제품등록을 할 수 없습니다.!!");
	              	return; // 종료
	          	} 
		       	///////////////////////////////////////
		       	
				$.ajax({
					<%-- url : "<%= ctxPath%>/shop/admin/productRegister.up", --%>
	                url : "${pageContext.request.contextPath}/SendImageToChatting.trip",
	                type : "post",
	                data : formData,
	                processData:false,  // 파일 전송시 설정 
	                contentType:false,  // 파일 전송시 설정
	                dataType:"json",
	                success:function(json){
	                	console.log("~~~ 확인용 : " + JSON.stringify(json));
                        // ~~~ 확인용 : {"result":1}
                        if(json.result == 1) {
                	       location.href="${pageContext.request.contextPath}/shop/mallHomeMore.up"; 
                        }
	                },
	                error: function(request, status, error){
	                // alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	                   alert("첨부된 파일의 크기의 총합이 20MB 를 초과하여 제품등록이 실패했습니다.ㅜㅜ");
	               }
				})
				
				/*
	             processData 관련하여, 일반적으로 서버에 전달되는 데이터는 query string(쿼리 스트링)이라는 형태로 전달된다. 
	             ex) http://localhost:9090/board/list.action?searchType=subject&searchWord=안녕
	                 ? 다음에 나오는 searchType=subject&searchWord=안녕 이라는 것이 query string(쿼리 스트링) 이다. 
	   
	             data 파라미터로 전달된 데이터를 jQuery에서는 내부적으로 query string 으로 만든다. 
	             하지만 파일 전송의 경우 내부적으로 query string 으로 만드는 작업을 하지 않아야 한다.
	             이와 같이 내부적으로 query string 으로 만드는 작업을 하지 않도록 설정하는 것이 processData: false 이다.
	         */
	          
	         /*
	             contentType 은 default 값이 "application/x-www-form-urlencoded; charset=UTF-8" 인데, 
	             "multipart/form-data" 로 전송이 되도록 하기 위해서는 false 로 해야 한다. 
	             만약에 false 대신에 "multipart/form-data" 를 넣어보면 제대로 작동하지 않는다.
	         */
			}
		})// end of 제품등록하기 -------------------
        
        
	});// end of $(document).ready(function(){

</script>


<div class="container-fluid">
<div class="row">
<div class="col-md-10 offset-md-1">
   <div id="chatStatus"></div>
   <div class="my-3">
   </div>
   <input type="hidden" id="to" placeholder="귓속말대상웹소켓.getId()"/>
 <span id="privateWho" style="font-weight: bold; color: red;"></span>
   <button type="button" id="btnAllDialog" class="btn btn-secondary btn-sm">귀속말대화끊기</button>
   <div id="connectingUserList" style=" max-height: 100px; overFlow: auto;"></div>
   
   <div id="chatMessage" style="background-color:rgb(255, 195, 84); border-radius:8px 8px 0 0; max-height: 530px; padding:10px 10px; overFlow: auto;"></div>

   <input type="text"   id="message" class="form-control" style="position:fixed; top:80%; border:solid 1px gray; border-radius:8px; width:95%; height:100px;" placeholder="메시지 내용"/>
   <input type="button" id="btnSendMessage" class="btn btn-success btn-sm my-3" value="전송" />
</div>
</div>
</div>  

<!-- 사진 전송을 하려고 사진을 올려뒀을때 나타나는 모달 -->
<div class="modal fade" id="modal_showDetail" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">사진을 전송하시겠습니까?</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
      	<form name="fileSend"  enctype="multipart/form-data">
      		
      	</form>
      	<img name="previewImg" id="previewImg" style="width:100%;"/>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	  <button type="button" id="addCom" class="btn btn-success btn-sm">전송</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


<style type="text/css">
body{
		background-color:rgb(255, 195, 84) !important;
	}
input#btnSendMessage {
	background-color: orange; 
	border:solid 1px orange;
	width:50px;
	height:30px;
	float:right;
	color:white;
	font-weight:bold;
	margin: 10px 10px 10px 0;
	border-radius:8px;
	cursor: pointer;
	position: fixed;
	top:85%;
	left:85%;
}

input#btnSendMessage:hover {
	background-color: rgb(255, 123, 0); 
	border:solid 1px rgb(255, 123, 0);
}

::-webkit-scrollbar {display:none;}
</style>