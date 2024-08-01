<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% String ctxPath = request.getContextPath(); %>    
    
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




<script type="text/javascript">
let searchWord = "";

$(document).ready(function() {
	
    $("span#totalHITCount").hide();
    
    $("span#countHIT").hide();
    
    festivalList("1", searchWord);

    $(document).on("click", "button#btnMoreHIT", function() {
    	
        if ($(this).text() == "처음으로") {
        	
            $("tbody").empty();
            
            $("span#end").empty();
            
            $("span#countHIT").text("0");
            
            festivalList("1", searchWord);
            
            $(this).text("더보기");
            
        } else {
        	
        	festivalList($(this).val(), searchWord);
        }
        
    }); // end of $(document).on("click", "button#btnMoreHIT", function() {})
    
    
    $("input:text[name='searchWord']").bind("keydown", function(e){
		
		if(e.keyCode == 13){
			
			goSearch();
			
		} // end of if
    
    });	// end of $("input:text[name='searchWord']").bind("keydown", function(e){{)}
    
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
                            <button type="button" class="btn btn-info">수정</button>
                            <input type="hidden" id="festival_no" value="\${item.festival_no}" />
                            <button type="button" class="btn btn-danger">삭제</button>
                        </td>
                    </tr>`;
                });

                $("tbody").append(v_html);
                
                $("button#btnMoreHIT").val(Number(start) + lenHIT);
                
                $("span#countHIT").text(Number($("span#countHIT").text()) + json.length);
                

                if ($("span#countHIT").text() == $("span#totalHITCount").text()) {
                	
                    $("span#end").html("더이상 조회할 축제가 없습니다.");
                    $("button#btnMoreHIT").text("처음으로");
                    
                    
                } else {
                	
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
        <form name="">
            <div class="text-right form-group">
                <label for="startDate">축제 시작 날짜 :</label>
                <input type="date" id="startDate" name="startDate" class="px-4" value="${requestScope.startDate}">
            </div>
            <div class="text-right form-group">
                <label for="endDate">축제 종료 날짜 :</label>
                <input type="date" id="endDate" name="endDate" class="px-4" value="${requestScope.endDate}">
            </div>
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
        </form>
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
