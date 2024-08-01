<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/mypage/adminChart.css"/>
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
		choice_month_login_member_chart_year($("select[name='choice_year_login']").val());
        choice_month_reservation($("select[name='choice_year_reservation']").val());
		
		$("select[name='choice_year_login']").bind("change",function(e){
			choice_month_login_member_chart_year($(e.target).val());
		});
		$("select[name='choice_year_reservation']").bind("change",function(e){
			choice_month_reservation($(e.target).val());
		});
		
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
			url:"<%= ctxPath%>/get_year_reservation_hotel_chart.trip",
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			
   				const line_data = [];   
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.line_year_CNT));
			    	 
			    });          
   				
			     
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 연도별 숙소예약자수 통계 차트 시작 ===== --%>
			    
			     Highcharts.chart('year_reservation_chart_div', {

			            title: {
			                text: '연도별 예약건수 통계'
			            },

			            yAxis: {
			                title: {
			                    text: 'Number of User'
			                }
			            },

			            xAxis: {
			                accessibility: {
			                    rangeDescription: 'Range: 2015 to 2024'
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
			                    pointStart: 2015
			                }
			            },

			            series: [{
			                name: "예약건수",
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
			     
			     <%-- ===== 연도별 숙소예약자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
        
        $.ajax({
			url:"<%= ctxPath%>/get_year_login_member_chart.trip",
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			
   				const line_data = [];   
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.line_year_CNT));
			    	 
			    });          
   				
			     
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 연도별 개인 회원 방문자수 통계 차트 시작 ===== --%>
			    
			     Highcharts.chart('year_login_member_chart_div', {

			            title: {
			                text: '연도별 사용자 방문자수 통계'
			            },

			            yAxis: {
			                title: {
			                    text: 'Number of User'
			                }
			            },

			            xAxis: {
			                accessibility: {
			                    rangeDescription: 'Range: 2015 to 2024'
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
			                    pointStart: 2015
			                }
			            },

			            series: [{
			                name: "방문자 수",
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
			     
			     <%-- ===== 연도별 개인 회원 방문자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
        
        <%-- === 회원 연령대별 파이차트 통계 시작 === --%>
        
        $.ajax({
			url:"<%= ctxPath%>/user_age_group_chart.trip",
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			
    			let resultArr = [];
				for(let i=0;i<json.length;i++){
					let obj;
					if(i==0){
						obj = {
							   name: json[i].ageGroup,
							   y: Number(json[i].PERCNTAGE),
							   sliced: true,
							   selected: true
							  };
					}
					else{
						obj = {
							   name: json[i].ageGroup,
							   y: Number(json[i].PERCNTAGE)
							  };
					}
					resultArr.push(obj);
				}      
   				
			     
			     ////////////////////////////////////////////////////////////////////////////////////////
			    
			     Highcharts.chart('user_age_group_chart_div', {
			            chart: {
			                plotBackgroundColor: null,
			                plotBorderWidth: null,
			                plotShadow: false,
			                type: 'pie'
			            },
			            title: {
			                text: '사용자 연령대별 퍼센티지'
			            },
			            tooltip: {
			                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
			            },
			            accessibility: {
			                point: {
			                    valueSuffix: '%'
			                }
			            },
			            plotOptions: {
			                pie: {
			                    allowPointSelect: true,
			                    cursor: 'pointer',
			                    dataLabels: {
			                        enabled: true,
			                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
			                    }
			                }
			            },
			            series: [{
			                name: '연령대',
			                colorByPoint: true,
			                data: resultArr
			            }]
			        });
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
        <%-- === 회원 연령대별 파이차트 통계 종료 === --%>
        
        
		<%-- === 회원 성별 파이차트 통계 시작 === --%>
        
        $.ajax({
			url:"<%= ctxPath%>/user_gender_chart.trip",
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			
    			let resultArr = [];
				for(let i=0;i<json.length;i++){
					let obj;
					if(i==0){
						obj = {
							   name: json[i].gender,
							   y: Number(json[i].PERCNTAGE),
							   sliced: true,
							   selected: true
							  };
					}
					else{
						obj = {
							   name: json[i].gender,
							   y: Number(json[i].PERCNTAGE)
							  };
					}
					resultArr.push(obj);
				}      
   				
			     
			     ////////////////////////////////////////////////////////////////////////////////////////
			    
			     Highcharts.chart('user_gender_chart_div', {
			            chart: {
			                plotBackgroundColor: null,
			                plotBorderWidth: null,
			                plotShadow: false,
			                type: 'pie'
			            },
			            title: {
			                text: '사용자 연령대별 퍼센티지'
			            },
			            tooltip: {
			                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
			            },
			            accessibility: {
			                point: {
			                    valueSuffix: '%'
			                }
			            },
			            plotOptions: {
			                pie: {
			                    allowPointSelect: true,
			                    cursor: 'pointer',
			                    dataLabels: {
			                        enabled: true,
			                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
			                    }
			                }
			            },
			            series: [{
			                name: '연령대',
			                colorByPoint: true,
			                data: resultArr
			            }]
			        });
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
        <%-- === 회원 성별 파이차트 통계 종료 === --%>
        
    }); // end of $(document).ready(function(){
    	
    	
    function choice_month_login_member_chart_year(choice_year){
    	
    	$.ajax({
			url:"<%= ctxPath%>/get_month_login_member_chart.trip",
			data:{"choice_year":choice_year},
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			console.log(JSON.stringify(json));
   				const line_data = [];   
			    
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.line_month_CNT));
			    	 
			    });    
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 연도별 개인 회원 가입자수 통계 차트 시작 ===== --%>
			    
			     Highcharts.chart('month_login_member_chart_div', {

			            title: {
			                text: '월별 사용자 방문자수 통계'
			            },

			            yAxis: {
			                title: {
			                    text: 'Number of User'
			                }
			            },

			            xAxis: {
			                accessibility: {
			                    rangeDescription: 'Range: 1 to 12'
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
			                    pointStart: 1
			                }
			            },

			            series: [{
			                name: "방문자 수",
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
			     
			     <%-- ===== 연도별 개인 회원 가입자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
    }
    
	function choice_month_reservation(choice_year){
    	
    	$.ajax({
			url:"<%= ctxPath%>/get_month_reservation_chart.trip",
			data:{"choice_year":choice_year},
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			console.log(JSON.stringify(json));
   				const line_data = [];   
			    
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.CNT));
			    	 
			    });    
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 연도별 개인 회원 가입자수 통계 차트 시작 ===== --%>
			    
			     Highcharts.chart('month_reservation_chart_div', {

			            title: {
			                text: '월별 예약건수 통계'
			            },

			            yAxis: {
			                title: {
			                    text: 'Number of User'
			                }
			            },

			            xAxis: {
			                accessibility: {
			                    rangeDescription: 'Range: 1 to 12'
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
			                    pointStart: 1
			                }
			            },

			            series: [{
			                name: "예약건수",
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
			     
			     <%-- ===== 연도별 개인 회원 가입자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
    }
</script>

<div class="body">
    <div class="navigation">
        <ul>
            <li class="list">
                <a href="<%= ctxPath%>/requiredLogin_goMypage.trip">
                    <span class="icon"><ion-icon name="list-outline"></ion-icon></span>
                    <span class="title">등록 컨텐츠</span>
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
                <a href="<%= ctxPath%>/admin_review.trip">
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
		
		<div class="reservation_bar">
		 <!-- Nav tabs -->
			<ul class="nav nav-tabs">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#year_reservation">연도별 예약 건수 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#month_reservation">월별 예약 건수 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#year_login_member">연도별 사용자 방문자수 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#month_login_member">월별 사용자 방문자수 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#user_age_group">사용자 연령별 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#user_gender">사용자 성별 통계</a>
			  </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			  	<div class="tab-pane active" id="year_reservation">
					<figure class="highcharts-figure">
					    <div id="year_reservation_chart_div"></div>
					</figure>
				</div>
				<div class="tab-pane fade" id="month_reservation">
					<select name="choice_year_reservation">
						<option value="2024" selected>현재</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
						<option value="2021">2021</option>
						<option value="2022">2022</option>
						<option value="2023">2023</option>
						<option value="2024">2024</option>
					</select>
					<figure class="highcharts-figure">
					    <div id="month_reservation_chart_div"></div>
					</figure>
				</div>
			  	<div class="tab-pane fade" id="year_login_member">
					<figure class="highcharts-figure">
					    <div id="year_login_member_chart_div"></div>
					</figure>
				</div>
			  	<div class="tab-pane fade" id="month_login_member">
					<select name="choice_year_login">
						<option value="2024" selected>현재</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
						<option value="2021">2021</option>
						<option value="2022">2022</option>
						<option value="2023">2023</option>
						<option value="2024">2024</option>
					</select>
					<figure class="highcharts-figure">
					    <div id="month_login_member_chart_div"></div>
					</figure>
				</div>
				<div class="tab-pane fade" id="user_age_group">
					<figure class="highcharts-figure">
					    <div id="user_age_group_chart_div"></div>
					</figure>
				</div>
				<div class="tab-pane fade" id="user_gender">
					<figure class="highcharts-figure">
					    <div id="user_gender_chart_div"></div>
					</figure>
				</div>
				
			</div>
		</div>
	</form>

</div>