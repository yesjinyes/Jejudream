
$(document).ready(function(){
	
	const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const day = String(today.getDate()).padStart(2, '0');
    
    
    $('input#datepicker').keyup( (e)=>{
        // 생년월일 input태그가 text 타입인데 키보드로 문자를 입력하려고할때 막아야한다 마우스클릭으로만 가능하게끔
            $(e.target).val("").next().show(); // 에러메시지 표현

        }); // end of $('input#datepicker').keyup( (e)=>{})

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // **** 아래거는 jsp파일에 주석처리된 투숙날짜달력에 적용되는 태그로서 시작일자 종료일자를 세팅해주게끔 해주는 것이다!!! 유용할듯 ******    

        // === 전체 datepicker 옵션 일괄 설정하기 ===  
        //     한번의 설정으로 $("input#fromDate"), $('input#toDate')의 옵션을 모두 설정할 수 있다.
        $(function() {
        //모든 datepicker에 대한 공통 옵션 설정
        $.datepicker.setDefaults({
             dateFormat: 'yy-mm-dd' //Input Display Format 변경
            ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
            ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
            ,changeYear: true //콤보박스에서 년 선택 가능
            ,changeMonth: true //콤보박스에서 월 선택 가능                
         // ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
         // ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
         // ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
         // ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
            ,yearSuffix: "년" //달력의 년도 부분 뒤에 붙는 텍스트
            ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
            ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
            ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
            ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
          ,minDate: "0D" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
          ,maxDate: "+1Y" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)                    
        });
 
        // input을 datepicker로 선언
        $("input#fromDate").datepicker();                    
        $("input#toDate").datepicker();
        
        
        // From의 초기값을 오늘 날짜로 설정
        $('input#fromDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
        
        // To의 초기값을 1일후로 설정
        $('input#toDate').datepicker('setDate', '+1D'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
        
        $('input#toDate').datepicker('option', 'minDate', '+1D');
     });
   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    $('input#datepicker').bind("change", (e)=> {
    // 생년월일에 입력되어진값이 변경되었다면 에러메시지를 지워야한다
        if($(e.target).val() != "" ){
        // 정상적이지않으면 자동으로 값이 ""로 된다! 그렇기때문에 올바른값을 검사하는 기준이 된다
            $(e.target).next().hide();
        }// 생년월일에 마우스로 달력에 있는 날짜를 선택한 경우 이벤트 처리 한것 
    }); // end of $('input#datepicker').bind("change", (e)=> {})
   
	
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    // == 맛집 카테고리 선택 == //
    const categoryArr = []; // 선택한 카테고리를 담을 배열

    $("input:checkbox[name='food_category']").change(function(e){
        const category_name = $(e.target).val();
        console.log("category_name : " + category_name);

        var is_checked = $(e.target).is(":checked");
        if(is_checked) {
            // console.log("is_checked true확인 : " + is_checked);
            
            categoryArr.push(category_name);
            // console.log("배열에 추가되는지 확인 : " + categoryArr);
        }

        else {
            // console.log("is_checked false확인 : " + is_checked);
            let value = category_name;

            // 체크박스 해제하면 배열에서 삭제하기
            for(let i = 0; i < categoryArr.length; i++) {
                if (categoryArr[i] === value) {
                    categoryArr.splice(i, 1);
                }
            }
            // console.log("배열에서 삭제되는지 확인 : " + categoryArr);
        }

        console.log(categoryArr); // ['japanese', 'western', 'korean' ...]




        ///////////////////////////////////////////////////////////////////////////////
       
        //$("div#foodstoreList").hide();

        const queryString = $("form[name='foodstoreFrm']").serialize();
        
        $.ajax({
            url:"viewCheckCategory.trip",
            data:queryString,
            dataType:"json",
            success:function(json) {
                // console.log("json 확인 : "+JSON.stringify(json))



            },
            error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }

        });// end of $.ajax({})---------------------
            
       
   
    });// end of $("input:checkbox[name='category']").change(function(e){})-------------------------
 
    
});// end of $(document).ready(function(){})----------------------------------------------------

