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
        
        choice_month_reservation($("select[name='choice_year_to_month_reservation']").val());
        choice_day_reservation($("select[name='choice_month_to_day_reservation']").val());
        choice_month_profit($("select[name='choice_year_to_month_profit']").val());
        
		$("select[name='choice_year_to_month_reservation']").bind("change",function(e){
			choice_month_reservation($(e.target).val());
		});
		
		$("select[name='choice_month_to_day_reservation']").bind("change",function(e){
			choice_day_reservation($(e.target).val());
		});
		
		$("select[name='choice_year_to_month_profit']").bind("change",function(e){
			choice_month_profit($(e.target).val());
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
    		data:{"lodging_code":"${sessionScope.loginCompanyuser.companyid}"},
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
			                        maxWidth: 1000
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
			url:"<%= ctxPath%>/get_year_profit_chart.trip",
    		data:{"companyid":"${sessionScope.loginCompanyuser.companyid}"},
			async:false, 
    		dataType:"json",
    		success:function(json){
    			
   				const line_data = [];   
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.profit));
			    	 
			    });          
   				
			     
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 연도별 매출액 통계 차트 시작 ===== --%>
			     Highcharts.setOptions({

					lang: {
						thousandsSep: ','
					}

				});
			     
			     Highcharts.chart('year_profit_chart_div', {
			    	    chart: {
			    	        type: 'column'
			    	    },
			    	    title: {
			    	        text: '연도별 매출액 통계'
			    	    },
			    	    subtitle: {
			    	        text: ''
			    	    },
			    	    xAxis: {
			    	        categories: [
			    	            '2015',
			    	            '2016',
			    	            '2017',
			    	            '2018',
			    	            '2019',
			    	            '2020',
			    	            '2021',
			    	            '2022',
			    	            '2023',
			    	            '2024'
			    	        ],
			    	        crosshair: true
			    	    },
			    	    yAxis: {
			    	        title: {
			    	            useHTML: true,
			    	            text: ''
			    	        }
			    	    },
			    	    tooltip: {
			    	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
			    	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
			    	            '<td style="padding:0"><b>{point.y}원</b></td></tr>',
			    	        footerFormat: '</table>',
			    	        shared: true,
			    	        useHTML: true
			    	    },
			    	    plotOptions: {
			    	        column: {
			    	            pointPadding: 0.2,
			    	            borderWidth: 0
			    	        }
			    	    },
			    	    series: [{
			    	        name: '매출액',
			    	        data: line_data
			    	    }]
			    	});
			     
			     <%-- ===== 연도별 매출액 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
        
        
    }); // end of $(document).ready(function(){
    
	function choice_month_reservation(choice_year){
    	$.ajax({
			url:"<%= ctxPath%>/get_month_reservation_chart.trip",
			data:{"choice_year":choice_year,"companyid":"${sessionScope.loginCompanyuser.companyid}"},
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			console.log(JSON.stringify(json));
   				const line_data = [];   
			    
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.CNT));
			    	 
			    });    
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 월별 숙소 예약 건수 통계 차트 시작 ===== --%>
			    
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
			                        maxWidth: 1000
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
			     
			     <%-- ===== 월별 개인 회원 가입자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
    }
	
	function choice_day_reservation(choice_month){
    	$.ajax({
			url:"<%= ctxPath%>/get_day_reservation_chart.trip",
			data:{"choice_month":choice_month,"companyid":"${sessionScope.loginCompanyuser.companyid}"},
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			console.log(JSON.stringify(json));
   				const line_data = [];   
			    const chart_length = json.length;
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.CNT));
			    	 
			    });    
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 월별 숙소 예약 건수 통계 차트 시작 ===== --%>
			    
			     Highcharts.chart('day_reservation_chart_div', {

			            title: {
			                text: '일별 예약건수 통계'
			            },

			            yAxis: {
			                title: {
			                    text: 'Number of User'
			                }
			            },

			            xAxis: {
			                accessibility: {
			                    rangeDescription: 'Range: 1 to '+chart_length
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
			                        maxWidth: 1000
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
			     
			     <%-- ===== 월별 개인 회원 가입자수 통계 차트 끝 ===== --%>
				     
    			
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
		});
    }
	
	function choice_month_profit(choice_year){
    	$.ajax({
			url:"<%= ctxPath%>/get_month_profit_chart.trip",
			data:{"choice_year":choice_year,"companyid":"${sessionScope.loginCompanyuser.companyid}"},
    		async:false, 
    		dataType:"json",
    		success:function(json){
    			console.log(JSON.stringify(json));
   				const line_data = [];   
			    
   				$.each(json, function(index, item){       
			    	 
			    	 line_data.push(Number(item.profit));
			    	 
			    });    
			     ////////////////////////////////////////////////////////////////////////////////////////
			     
			     <%-- ===== 월별 매출액 통계 차트 시작 ===== --%>
			    
			     Highcharts.setOptions({

					lang: {
						thousandsSep: ','
					}

				});
			     
			     Highcharts.chart('month_profit_chart_div', {
			    	    chart: {
			    	        type: 'column'
			    	    },
			    	    title: {
			    	        text: '연도별 매출액 통계'
			    	    },
			    	    subtitle: {
			    	        text: ''
			    	    },
			    	    xAxis: {
			    	        categories: [
			    	            '1',
			    	            '2',
			    	            '3',
			    	            '4',
			    	            '5',
			    	            '6',
			    	            '7',
			    	            '8',
			    	            '9',
			    	            '10',
			    	            '11',
			    	            '12'
			    	        ],
			    	        crosshair: true
			    	    },
			    	    yAxis: {
			    	        title: {
			    	            useHTML: true,
			    	            text: ''
			    	        }
			    	    },
			    	    tooltip: {
			    	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
			    	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
			    	            '<td style="padding:0"><b>{point.y}원</b></td></tr>',
			    	        footerFormat: '</table>',
			    	        shared: true,
			    	        useHTML: true
			    	    },
			    	    plotOptions: {
			    	        column: {
			    	            pointPadding: 0.2,
			    	            borderWidth: 0
			    	        }
			    	    },
			    	    series: [{
			    	        name: '매출액',
			    	        data: line_data
			    	    }]
			    	});
			     
			     <%-- ===== 월별 매출액 통계 차트 끝 ===== --%>
				     
    			
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
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
                </a>
            </li>
            <li class="list active">
                <a href="<%= ctxPath%>/company_chart.trip">
                    <span class="icon"><ion-icon name="bar-chart-outline"></ion-icon></ion-icon></span>
                    <span class="title">통계</span>
                </a>
            </li>
            <li class="list">
                <a href="<%= ctxPath%>/myRegisterHotel.trip">
                    <span class="icon"><ion-icon name="wallet-outline"></ion-icon></span>
                    <span class="title">숙소등록신청현황</span>
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
			    <a class="nav-link" data-toggle="tab" href="#day_reservation">일별 예약 건수 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#year_profit">연도별 수익 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#month_profit">월별 수익 통계</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#day_profit">일별 수익 통계</a>
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
					<select name="choice_year_to_month_reservation">
						<option value="2024" selected>현재</option>
						<option value="2015">2015년</option>
						<option value="2016">2016년</option>
						<option value="2018">2018년</option>
						<option value="2019">2019년</option>
						<option value="2020">2020년</option>
						<option value="2021">2021년</option>
						<option value="2022">2022년</option>
						<option value="2023">2023년</option>
						<option value="2024">2024년</option>
					</select>
					<figure class="highcharts-figure">
					    <div id="month_reservation_chart_div"></div>
					</figure>
				</div>
			  	<div class="tab-pane fade" id="day_reservation">
					<select name="choice_month_to_day_reservation">
						<option value="1" selected>1월</option>
						<option value="2">2월</option>
						<option value="3">3월</option>
						<option value="4">4월</option>
						<option value="5">5월</option>
						<option value="6">6월</option>
						<option value="7">7월</option>
						<option value="8">8월</option>
						<option value="9">9월</option>
						<option value="10">10월</option>
						<option value="11">11월</option>
						<option value="12">12월</option>
					</select>
					<figure class="highcharts-figure">
					    <div id="day_reservation_chart_div"></div>
					</figure>
				</div>
			  	<div class="tab-pane fade" id="year_profit">
					<figure class="highcharts-figure">
					    <div id="year_profit_chart_div"></div>
					</figure>
				</div>
				<div class="tab-pane fade" id="month_profit">
					<select name="choice_year_to_month_profit">
						<option value="2024" selected>현재</option>
						<option value="2015">2015년</option>
						<option value="2016">2016년</option>
						<option value="2018">2018년</option>
						<option value="2019">2019년</option>
						<option value="2020">2020년</option>
						<option value="2021">2021년</option>
						<option value="2022">2022년</option>
						<option value="2023">2023년</option>
						<option value="2024">2024년</option>
					</select>
					<figure class="highcharts-figure">
					    <div id="month_profit_chart_div"></div>
					</figure>
				</div>
				<div class="tab-pane fade" id="day_profit">
					<select name="choice_month_to_day_profit">
						<option value="1" selected>1월</option>
						<option value="2">2월</option>
						<option value="3">3월</option>
						<option value="4">4월</option>
						<option value="5">5월</option>
						<option value="6">6월</option>
						<option value="7">7월</option>
						<option value="8">8월</option>
						<option value="9">9월</option>
						<option value="10">10월</option>
						<option value="11">11월</option>
						<option value="12">12월</option>
					</select>
					<figure class="highcharts-figure">
					    <div id="day_profit_chart_div"></div>
					</figure>
				</div>
				
			</div>
		</div>
	</form>

</div>