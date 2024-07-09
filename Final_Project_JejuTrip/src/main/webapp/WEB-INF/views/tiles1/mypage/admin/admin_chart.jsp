<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/mypageMain.css"/>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
<script src="<%=ctxPath%>/resources/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%=ctxPath%>/resources/Highcharts-10.3.1/code/modules/series-label.js"></script>
<script src="<%=ctxPath%>/resources/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%=ctxPath%>/resources/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%=ctxPath%>/resources/Highcharts-10.3.1/code/modules/accessibility.js"></script>



<script type="text/javascript">
    $(document).ready(function(){
        const list = document.querySelectorAll('.list');

        function activeLink() {
            // 모든 네비게이션 항목에서 active 클래스를 제거합니다.
            list.forEach((item) => item.classList.remove('active'));
            // 클릭된 네비게이션 항목에 active 클래스를 추가합니다.
            this.classList.add('active');
        }

        list.forEach((item) => {
            item.addEventListener('click', function () {
                // active 클래스를 변경하는 함수 호출
                activeLink.call(this);
                // iframe의 src 속성을 변경하여 콘텐츠를 로드
                const link = this.getAttribute('data-link');
                document.getElementById('contentFrame').src = link;
            });
        });
        
        
        $.ajax({
			url:"<%= ctxPath%>/get_chart.trip",
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			
   				// console.log(JSON.stringify(json));
   				// [{"CNT":"245","PERCNTAGE":"   7.6","GU":"송파구"},{"CNT":"223","PERCNTAGE":"   6.9","GU":"강서구"},{"CNT":"195","PERCNTAGE":"   6.0","GU":"강남구"},{"CNT":"186","PERCNTAGE":"   5.7","GU":"영등포구"},{"CNT":"175","PERCNTAGE":"   5.4","GU":"노원구"},{"CNT":"162","PERCNTAGE":"   5.0","GU":"서초구"},{"CNT":"142","PERCNTAGE":"   4.4","GU":"마포구"},{"CNT":"134","PERCNTAGE":"   4.1","GU":"구로구"},{"CNT":"132","PERCNTAGE":"   4.1","GU":"강동구"},{"CNT":"131","PERCNTAGE":"   4.0","GU":"양천구"},{"CNT":"124","PERCNTAGE":"   3.8","GU":"종로구"},{"CNT":"115","PERCNTAGE":"   3.5","GU":"성동구"},{"CNT":"112","PERCNTAGE":"   3.5","GU":"중구"},{"CNT":"110","PERCNTAGE":"   3.4","GU":"은평구"},{"CNT":"106","PERCNTAGE":"   3.3","GU":"성북구"},{"CNT":"104","PERCNTAGE":"   3.2","GU":"중랑구"},{"CNT":"103","PERCNTAGE":"   3.2","GU":"도봉구"},{"CNT":"103","PERCNTAGE":"   3.2","GU":"관악구"},{"CNT":"102","PERCNTAGE":"   3.1","GU":"용산구"},{"CNT":"102","PERCNTAGE":"   3.1","GU":"광진구"},{"CNT":"101","PERCNTAGE":"   3.1","GU":"동대문구"},{"CNT":"94","PERCNTAGE":"   2.9","GU":"서대문구"},{"CNT":"88","PERCNTAGE":"   2.7","GU":"동작구"},{"CNT":"81","PERCNTAGE":"   2.5","GU":"금천구"},{"CNT":"70","PERCNTAGE":"   2.2","GU":"강북구"}] 
   				const line_data_arr = [];
   				const bar_data_arr = [];
   				const line_data = [];   
			    let length = json.length;
			    for(let i=length;i<10;i++){
			    	line_data.push(null);
			    }
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.line_year_CNT));
			    	 
			    });          
   				
			     
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 개인 회원 가입자수 통계 차트 시작 ===== --%>
			    
			     Highcharts.chart('container', {

			            title: {
			                text: '연별 개인 회원 가입자 수 통계'
			            },

			            yAxis: {
			                title: {
			                    text: 'Number of User'
			                }
			            },

			            xAxis: {
			                accessibility: {
			                    rangeDescription: 'Range: 2014 to 2024'
			                }
			            },

			            legend: {
			                layout: 'vertical',
			                align: 'right',
			                verticalAlign: 'middle'
			            },

			            plotOptions: {
			                series: {
			                    label: {
			                        connectorAllowed: false
			                    },
			                    pointStart: 2014
			                }
			            },

			            series: [{
			                name: "가입자 수",
			            	data: line_data
			            }],

			            responsive: {
			                rules: [{
			                    condition: {
			                        maxWidth: 500
			                    },
			                    chartOptions: {
			                        legend: {
			                            layout: 'horizontal',
			                            align: 'center',
			                            verticalAlign: 'bottom'
			                        }
			                    }
			                }]
			            }

			        });
			     
			     <%-- ===== 개인 회원 가입자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
        
        
    }); // end of $(document).ready(function(){
</script>

<div class="body">
    <div class="navigation">
        <ul>
            <li class="list">
                <a href="#">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/show_userList.trip">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원관리</span>
                </a>
            </li>
            <li class="list active">
                <a href="<%= ctxPath%>/admin_chart.trip">
                    <span class="icon"><ion-icon name="bar-chart-outline"></ion-icon></ion-icon></span>
                    <span class="title">통계</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/review.trip">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <br><br><br>
            <li class="list">
                <a href="<%= ctxPath%>/support.trip">
                    <span class="icon"><ion-icon name="help-circle-outline"></ion-icon></span>
                    <span class="title">고객센터</span>
                </a>
            </li>
        </ul>
    </div>
	
    <form class = "reservationFrm" name="reservationFrm">
		
		<div class="reservation_bar" style="margin-top: 10%;">
		 <!-- Nav tabs -->
			<ul class="nav nav-tabs">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#year_register_member">개인회원가입차트</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#month_register_member">기업회원가입차트</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#day_register_member">취소내역</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#year_reservation_member">취소내역</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#month_reservation_member">취소내역</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#day_reservation_member">취소내역</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  	<div class="tab-pane container active" id="year_register_member">
					<figure class="highcharts-figure">
					    <div id="container"></div>
					    <p class="highcharts-description">
					        
					    </p>
					</figure>
				</div>
			  	<div class="tab-pane container fade" id="month_register_member">
					
				</div>
				<div class="tab-pane container fade" id="day_register_member">
					
				</div>
				<div class="tab-pane container fade" id="year_reservation_member">
					
				</div>
				<div class="tab-pane container fade" id="month_reservation_member">
					
				</div>
				<div class="tab-pane container fade" id="day_reservation_member">
					
				</div>
				
			</div>
		</div>
	</form>

</div>