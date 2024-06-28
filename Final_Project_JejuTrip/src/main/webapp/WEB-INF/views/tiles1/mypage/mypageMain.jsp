<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String ctxPath = request.getContextPath();
%>

<style>

.container{
	 display: flex;
	 float: none;
	 width: 100%;
	 margin-top:50px;
	 justify-content: center;
	 
}


.navigation {
    position: relative;
    height: 800px;
    width: 250px;
    background: #ff8000;
}


.navigation ul {
    position: absolute;
    width: 100%;
    padding-left: 5px;
    padding-right: 5px;
    padding-top: 40px;
}

.navigation ul li {
    position: relative;
    list-style: none;
    width: 90%;
    border-radius: 20px 20px;
}

.navigation ul li.active {
    background: #ffcccc;/* 고정되어있을때 강조색 [1] */
}

.navigation ul li a {
    position: relative;
    display: block;
    width: 100%;
    display: flex;
    text-decoration: none;
    color: #fff;
}
 


.navigation ul li a .icon {
    position: relative;
    display: block;
    min-width: 60px;
    height: 60px;
    line-height: 70px;
    text-align: center;
}

.navigation ul li a .icon ion-icon {
    position: relative;
    font-size: 1.5em;
    z-index: 1;
}

.navigation ul li a .title {
    position: relative;
    display: block;
    height: 60px;
    line-height: 60px;
    white-space: nowrap;
    font-weight:bold;
}
#contentFrame{
	width: 1024px; 
	padding-bottom: 1%; 
	margin-left: 2%;
	border: 1px solid #e6e6e6;
	/* background: #008000; */
	
}
</style>

<div class="container">
	
    <div class="navigation">
        <ul>
            <li class="list active" data-link="<%= ctxPath%>/reservations.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="bed-outline"></ion-icon></span>
                    <span class="title">예약내역</span>
                </a>
            </li>
            <li class="list" data-link="<%= ctxPath%>/editProfile.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                    <span class="title">회원정보수정</span>
                </a>
            </li>
            <li class="list" data-link="<%= ctxPath%>/cash_points.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="wallet-outline"></ion-icon></span>
                    <span class="title">캐시&포인트</span>
                </a>
            </li>
            <li class="list" data-link="<%= ctxPath%>/review.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="clipboard-outline"></ion-icon></span>
                    <span class="title">이용후기</span>
                </a>
            </li>
            <br><br><br>
            <li class="list" data-link="<%= ctxPath%>/support.trip">
                <a href="#">
                    <span class="icon"><ion-icon name="help-circle-outline"></ion-icon></span>
                    <span class="title">고객센터</span>
                </a>
            </li>
        </ul>
    </div>
	
    <iframe id="contentFrame" src="<%= ctxPath%>/reservations.trip"></iframe><!--로드시 적용되어 있는 탭은 마이페이지  -->
</div>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    
    <script>
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
    </script>

