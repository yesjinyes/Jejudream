
$(document).ready(function(){
	
    // == 맛집 카테고리 선택 == //
 /*   const categoryArr = []; // 선택한 카테고리를 담을 배열

    $("input:checkbox[name='food_category']").change(function(e){
        const category_name = $(e.target).val();
        console.log("category_name : " + category_name);

        var is_checked = $(e.target).is(":checked");
        if(is_checked) {
            categoryArr.push(category_name);
        }

        else {
            let value = category_name;

            // 체크박스 해제하면 배열에서 삭제하기
            for(let i = 0; i < categoryArr.length; i++) {
                if (categoryArr[i] === value) {
                    categoryArr.splice(i, 1);
                }
            }
        }

        console.log(categoryArr.toString()); // japanese, western, korean ...
        const categorystr = categoryArr.toString();


        $("form[name='categoryFrm'] > input[name='food_category']").val(categorystr); // 선택한 카테고리 배열 폼으로 넘기기

*/


        ///////////////////////////////////////////////////////////////////////////////
       
        //$("div#foodstoreList").hide();
/*
        const queryString = $("form[name='foodstoreFrm']").serialize();
        
        $.ajax({
            url:"viewCheckCategory.trip",
            data:queryString,
            dataType:"json",
            success:function(json) {
                 console.log("json 확인 : "+JSON.stringify(json))

                

            },// end of success------------------------------
            error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }

        });// end of $.ajax({})---------------------
            
       
   
   // });// end of $("input:checkbox[name='category']").change(function(e){})-------------------------
 
    */

    // $("button#btnAsc").click(function() {
    //     // alert("버튼클릭");

    //     const singlepost = $("div.single-post").text;
    //     console.log("singlepost 확인 :" + singlepost);
    
    //     // let storeArr = [];
    //     // for(let i=0; i<singlepost.size(); i++) {
    //     //     storeArr.push(singlepost.get(i).getFood_name());
    //     // }
    //     // console.log("맛집배열 안나올듯:" +storeArr);
    // });


});// end of $(document).ready(function(){})----------------------------------------------------

