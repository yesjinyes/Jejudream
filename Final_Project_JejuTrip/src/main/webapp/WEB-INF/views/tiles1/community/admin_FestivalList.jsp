<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% String ctxPath = request.getContextPath(); %>    
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    
    
<style>

.cen {

	vertical-align: middle !important;

}


</style>
<script type="text/javascript">

let searchWord = "";
let isSearching = false;

$(document).ready(function() {
	
    $("span#totalHITCount").hide();
    
    $("span#countHIT").hide();
    
    festivalList("1", searchWord);

    $(document).on("click", "button#btnMoreHIT", function() {
    	
        const $btn = $(this);
        
        if ($btn.text() === "처음으로") {
        	
            $("tbody").empty(); // 기존 데이터를 지우기
            $("span#end").empty(); // 끝 메시지 지우기
            $("span#countHIT").text("0"); // 현재 카운트 초기화

            if (isSearching) {
                // 검색 상태일 때 처리
                searchWord = ""; // 검색어 초기화
                isSearching = false; // 검색 상태 플래그 해제
                $("input:text[name='searchWord']").val(""); // 검색어 입력 필드 비우기
            }
            
            festivalList("1", searchWord); // 초기 데이터 조회
            $btn.text("더보기"); // 버튼 텍스트 변경
            
        }else {
        	
        	festivalList($(this).val(), searchWord);
        } 
        
    });; // end of $(document).on("click", "button#btnMoreHIT", function() {})
    
    
    $("input:text[name='searchWord']").bind("keydown", function(e){
		
		if(e.keyCode == 13){
			
			goSearch();
			
		} // end of if
    
    });	// end of $("input:text[name='searchWord']").bind("keydown", function(e){})
    
    
    $(document).on("click", "button#updateFestival", function(e){
    	
		const $target = $(e.target);
    	
    	const festival_no = $target.siblings("input:hidden[name='festival_no']").val();
    	
    	const frm = document.forEditFestival;
    	
    	frm.for_edit_festival_no.value = festival_no;
    	
    	frm.method = "post";
    	frm.action = "goEditFestival.trip";
    	
    	frm.submit();
    	
    }); // end of $(document).on("click", "button#deleteFestival", function(e){})
    
    
    
    $(document).on("click", "button#deleteFestival", function(e){
    	
    	const $target = $(e.target);
    	
    	const festival_no = $target.siblings("input:hidden[name='festival_no']").val();
    	const festival_img = $target.siblings("input:hidden[name='festival_img']").val();
    	
    	// alert(seq);
    	
    	if( confirm("정말 해당 " + festival_no + "번 축제 및 행사를 삭제 하시겠습니까?") ){
    		
    		
    		$.ajax({
    	    	
    	        url: "<%= ctxPath%>/JSONAdminDeleteFestival.trip",
    	        type: "post",
    	        data: {"festival_no": festival_no, "festival_img": festival_img},
    	        dataType: "json",
    	        success: function(json) {
    	        	
    	        	if(json.result == "1"){
    	        		
    	        		alert(festival_no + "번 축제 및 행사 삭제 성공!");
        	        	location.reload(true);
    	        		
    	        	}
    	        	else {
    	        		
    	        		alert("데이터 오류로 인한 " + festival_no + "번 축제 및 행사 삭제 실패!");
    	        		alert(`\${json.msg}`);
        	        	location.reload(true);
    	        		
    	        	}
    	        	
    	        },
    	        error: function(request, status, error) {
    	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
    	        }
    		
    		}); // end of $.ajax
    	
    	} // end of confirm if
    	
    }); // end of $(document).on("click", "button#deleteFestival", function(e){})
    
    
}); // end of document

let lenHIT = 8;

function festivalList(start, searchWord) {
	
    $.ajax({
    	
        url: "<%= ctxPath%>/JSONAdminFestivalList.trip",
        type: "post",
        data: {"start": start, "len": lenHIT, "searchWord": searchWord},
        dataType: "json",
        success: function(json) {
            let v_html = ``;

            if (start == "1" && json.length == 0) {
            	
                v_html = `현재 데이터가 없습니다.`;
                
                $("tbody").html(v_html);
                $("span#countHIT").text("0");
                $("span#totalHITCount").text("0");
                $("span#end").show();
                $("span#end").html("더이상 조회할 축제가 없습니다.");
                $("button#btnMoreHIT").text("처음으로"); // 버튼 텍스트 설정
                
            } else if (json.length > 0) {
            	
                $.each(json, function(index, item) {
                	
                    v_html += `<tr>
                        <td class="cen text-center"><img style="width: 180px; height: 180px;" src="<%= ctxPath%>/resources/images/festival/\${item.img}" /></td>
                        <td class="cen text-center">\${item.title_name}</td>
                        <td class="cen text-center">\${item.startdate}</td>
                        <td class="cen text-center">\${item.enddate}</td>
                        <td class="cen text-center">\${item.local_status}</td>
                        <td class="cen text-center"><a href="\${item.link}">링크</a></td>
                        <td class="cen text-center">
                            <button type="button" id="updateFestival" class="btn btn-info">수정</button>
                            <input type="hidden" name="festival_no" id="festival_no" value="\${item.festival_no}" />
                            <input type="hidden" name="festival_img" id="festival_img" value="\${item.img}" />
                            <button type="button" id="deleteFestival" class="btn btn-danger">삭제</button>
                        </td>
                    </tr>`;
                });

                $("tbody").append(v_html);
                
                $("button#btnMoreHIT").val(Number(start) + lenHIT);
                
                $("span#countHIT").text(Number($("span#countHIT").text()) + json.length);
                $("span#totalHITCount").text(json[0].totalCount);

                if ($("span#countHIT").text() == $("span#totalHITCount").text()) {
                	
                	$("span#end").show();
                    $("span#end").html("더이상 조회할 축제가 없습니다.");
                    $("button#btnMoreHIT").text("처음으로");
                    
                    
                } else {
                	$("span#end").hide();
                    $("span#totalHITCount").text(json[0].totalCount).show();
                    $("span#countHIT").show();
                    
                }
                
            }
        },
        error: function(request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
        
    }); // end of $.ajax
    
} // end of 

function goSearch(){
	
	$("tbody").empty();
	$("span#countHIT").text("0");
	
	searchWord = $("input:text[name='searchWord']").val();
	isSearching = true;
	
	festivalList("1", searchWord);
	
	
} // end of function goSearch(){}


function registerFestival(){
	
	const frm = document.RegisterFestival;
	
	frm.admin.value = "${sessionScope.loginuser.userid}";
	
	frm.method = "post";
	
	frm.action = "<%= ctxPath%>/RegisterFestival.trip";
	
	frm.submit();
	
} // end of function RegisterFestival(){}


</script>

<div class="container" style="padding: 3% 0;">
    <div class="col-md-12 mx-auto pt-4">
        <h2 class="text-center mb-5">관리자용 축제와 행사 목록 </h2>
        
            <div class="d-flex" style="justify-content: space-between;">
                <div class="text-left">
                    <button type="button" class="btn btn-info" onclick="registerFestival()">축제 및 행사 등록</button>
                </div>
                <div class="text-right">
                    <input type="text" name="searchWord" placeholder="검색어를 입력하세요" />
                    <input type="text" style="display: none;" />
                    <button type="button" class="btn btn-secondary" onclick="goSearch()">검색</button>
                </div>
            </div>
        
        <table class="table table-bordered">
            <thead class="table-light">
                <tr>
                    <th scope="col" class="text-center">축제이미지</th>
                    <th scope="col" class="text-center">축제명</th>
                    <th scope="col" class="text-center">시작날짜</th>
                    <th scope="col" class="text-center">종료날짜</th>
                    <th scope="col" class="text-center">지역구분</th>
                    <th scope="col" class="text-center">축제링크</th>
                    <th scope="col" class="text-center">수정/삭제</th>
                </tr>
            </thead>
            <tbody>
                <!-- ajax로 뿌려지는곳 -->
            </tbody>
            
        </table>
        <div class="text-center">
           <span id="end" style="display:block; margin:20px; font-size: 14pt; font-weight: bold; color: red;"></span> 
           
           <button type="button" class="btn btn-secondary btn-lg" id="btnMoreHIT" value="">더보기</button>
           
           <span style="margin-left: 2%;" id="countHIT">0</span>/<span id="totalHITCount"></span>
        </div>
    </div>
</div>

<form name="RegisterFestival">
	<input type="hidden" name="admin" value="" />
</form>

<form name="forEditFestival">
	<input type="hidden" name="for_edit_festival_no" />
</form>
