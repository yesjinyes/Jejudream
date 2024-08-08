package com.spring.app.trip.cro;



import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.net.ssl.*;
import java.security.cert.X509Certificate;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.RoomDetailVO;

public class InserMain {

	public static void main(String[] args) {
		
		
		InserMain cro = new InserMain();
		
		// cro.visitJeju();
		
		cro.visitfestival();

	}
	
	
	
	public void visitJeju() {
		
		disableSSLVerification();  // SSL 검증 무시 코드 추가
		
		DataDAO dao = new DataDAO();
    	
		Path path = Paths.get(System.getProperty("user.dir"), "/src/main/resources/chromedriver.exe");

        // WebDriver 경로 설정
        System.setProperty("webdriver.chrome.driver", path.toString());

        // WebDriver 옵션 설정
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--start-maximized"); // 전체화면으로 실행
        options.addArguments("--disable-popup-blocking"); // 팝업 무시
        options.addArguments("--disable-default-apps"); // 기본앱 사용안함

        // WebDriver 객체 생성
        ChromeDriver driver = new ChromeDriver(options);

        try {
            String url = "https://www.tamnao.com/web/stay/jeju.do";
            driver.get(url);

            // 페이지가 로딩 대기시간 주기
            Thread.sleep(5000); // 5초 대기, 로딩 상황에 따라 조정 가능

            // 페이지 내 요소 선택
            List<WebElement> linkElements = driver.findElements(By.cssSelector("div.stay-list div.itemPrdt a"));

            for (WebElement linkElement : linkElements) {
                // 각 a 태그 클릭
            	
                linkElement.click();

                // 필요한 데이터 추출
                
                WebElement lvoname = driver.findElement(By.cssSelector("div.ad-info-area div.ad-title"));
                
                WebElement lvoimg = driver.findElement(By.cssSelector("div.moMain span img")); 
                
                String mainImageUrl = lvoimg.getAttribute("src");
                // System.out.println("Hotel Name: " + lvoname.getText());
                // System.out.println(lvoimg.getAttribute("src")); // 메인 img src 확인
              
                String mainImageDir = System.getProperty("user.dir") + "/src/main/webapp/resources/images/lodginglist/" + lvoname.getText() +"_main.jpg";
                String mainImgname = lvoname.getText() +"_main.jpg";
                
                downloadImage(mainImageUrl, mainImageDir);
                
                // System.out.println("메인 이미지 다운로드 완료");
                
                WebElement lvoaddress = driver.findElement(By.cssSelector("div.ad-info-area div.ad-address")); 
                
                // System.out.println(lvoaddress.getText()); // 숙소 주소 출력확인
                
                LodgingVO lvo = new LodgingVO();
                
                lvo.setLodging_name(lvoname.getText()); // VO 숙소명 세팅
                lvo.setMain_img(mainImgname); // 메인이미지 vo 세팅
                lvo.setLodging_address(lvoaddress.getText()); // 주소 vo세팅
                
                
                List<WebElement> lvoconvient = driver.findElements(By.cssSelector("div.adDetail div ul.FavFeatures__List li"));
                
                for(WebElement p : lvoconvient ) {
                	// 편의시설 출력확인
                	// System.out.println(p.findElement(By.cssSelector("p")).getText());
                	
                }
                
                WebElement lvocontent = driver.findElement(By.cssSelector("div.adDetail p._adDetail"));
                
                // 숙소설명 출력확인
                // System.out.println(lvocontent.getText());
                
                lvo.setLodging_content(lvocontent.getText());
                
                
                WebElement lvotel = driver.findElement(By.xpath("//*[@id=\"subContents\"]/div[2]/div/div/div/div/div[2]/div/div[3]/section[3]/div[2]/div/div/div[2]/p[2]"));
                System.out.println("객실 전화번호 : " + lvotel.getText().substring(7));
                lvo.setLodging_tell(lvotel.getText().substring(7));
                
                String snum = dao.select_num(); // 채번해오기
                
                lvo.setLodging_code(snum);
                
                int n = dao.lodging_insert(lvo);
                
               
                if(n==1) {
                	
                	
                	Thread.sleep(2000);
                
	                List<WebElement> lvoroom = driver.findElements(By.cssSelector("div.ad-detail-con section.room_info div.room"));
	                
	                for(WebElement room : lvoroom) {
	                	
	                	
	                	// System.out.println("객실이름 : "+room.findElement(By.cssSelector("div.room_info_memo div.title p")).getText());
	                	
	                	String roomname = room.findElement(By.cssSelector("div.room_info_memo div.title p")).getText();
	                	
	                	// System.out.println("기준인원 : "+ room.findElement(By.cssSelector("div.room_info_memo div.other-group div.inline-typeA p span:nth-child(1)")).getText());
	                	String minpp =  room.findElement(By.cssSelector("div.room_info_memo div.other-group div.inline-typeA p span:nth-child(1)")).getText();
	
	                	// System.out.println("최대인원 : "+room.findElement(By.cssSelector("div.room_info_memo div.other-group div.inline-typeA p span:nth-child(2)")).getText());
	                	String maxpp = room.findElement(By.cssSelector("div.room_info_memo div.other-group div.inline-typeA p span:nth-child(2)")).getText();
	                	
	                	String price = "";
	                	try {
	                		
	                		// System.out.println("객실가격 : " + room.findElement(By.cssSelector("div.room_info_memo div.price span span:nth-child(1)")).getText());
	                		price = room.findElement(By.cssSelector("div.room_info_memo div.price span span:nth-child(1)")).getText();
	                	
	                		
	                	}catch(NoSuchElementException x) {
	                		
	                		// System.out.println("객실가격 : 태그불일치해서 예약마감");
	                		price = "예약마감";
	                	}
	                	
	                	String roomimg = room.findElement(By.cssSelector("span.pic_view img")).getAttribute("src");
	                	
	                	String roomimgdir = System.getProperty("user.dir") + "/src/main/webapp/resources/images/lodginglist/room/" + lvo.getLodging_code() + "_"+ roomname + ".jpg";
	                	// 객실별 이미지 src 출력확인
	                	// System.out.println("객실이미지파일명 : "+room.findElement(By.cssSelector("span.pic_view img")).getAttribute("src"));
	                	
	                	String roomfileName = lvo.getLodging_code() + "_"+ roomname + ".jpg";
	                	
	                	downloadImage(roomimg, roomimgdir);
	                	
	                	RoomDetailVO rvo = new RoomDetailVO();
	                	
	                	rvo.setRoom_img(roomfileName);
	                	rvo.setFk_lodging_code(snum);
	                	rvo.setRoom_name(roomname);
	                	rvo.setMin_person(Integer.parseInt(minpp));
	                	rvo.setMax_person(Integer.parseInt(maxpp));
	                	
	                	if("예약마감".equals(price)) {
	                		
	                		price = "200000";
	                	}else {
	                		
	                		price = String.join("", price.split(","));
	                		
	                	}
	                	
	                	rvo.setPrice(price);
	                	
	                	
	                	rvo.setCheck_in("15시");
	                	rvo.setCheck_out("11시");
	                	
	                	dao.room_detailinsert(rvo);
	                	
	                } // end of for
	               
                } // end of if
                else {
                	
                	System.out.println("숙소 insert 실패");
                	
                }
               
                
                Thread.sleep(2000);
                // 다시 원래 창으로 전환
                driver.navigate().back();
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        } finally {
            driver.quit();
        }
        
    } // end of
	
	
	
	public void visitfestival() {
		
		DataDAO dao = new DataDAO();
    	
		Path path = Paths.get(System.getProperty("user.dir"), "/src/main/resources/chromedriver.exe");

        // WebDriver 경로 설정
        System.setProperty("webdriver.chrome.driver", path.toString());

        // WebDriver 옵션 설정
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--start-maximized"); // 전체화면으로 실행
        options.addArguments("--disable-popup-blocking"); // 팝업 무시
        options.addArguments("--disable-default-apps"); // 기본앱 사용안함
        
        // WebDriver 객체 생성
        ChromeDriver driver = new ChromeDriver(options);

        try {
            String url = "https://korean.visitkorea.or.kr/kfes/list/wntyFstvlList.do";
            driver.get(url);

            // 페이지가 로딩 대기시간 주기
            Thread.sleep(10000); // 5초 대기, 로딩 상황에 따라 조정 가능
          
            // 페이지 내 요소 선택
            List<WebElement> Elements = driver.findElements((By.xpath("//*[@id=\"fstvlList\"]/li")));

            for (WebElement Element : Elements) {
                // 각 a 태그 클릭
            	
            	int cnt =1;
            	
            	Map<String,String> paraMap = new HashMap<>();
            	
                // 필요한 데이터 추출
            	WebElement alink = Element.findElement(By.cssSelector("a"));
            	
            	// System.out.println("링크경로 : "+alink.getAttribute("href"));
            	
            	String link = alink.getAttribute("href");
            	
                
                WebElement title = Element.findElement(By.cssSelector("div.other_festival_content strong"));
                
                String title_name = title.getText();
                
                // System.out.println("축제명 : " +title.getText());
                
                WebElement festival_date = Element.findElement(By.cssSelector("div.other_festival_content div.date"));
                
                // System.out.println("축제기간 : "+ festival_date.getText());
                String fulldate = festival_date.getText();
                
                fulldate = fulldate.replace(".", "-");
                
                String[] arr_fulldate = fulldate.split("~");
                
                String startDate = arr_fulldate[0];
                String endDate = arr_fulldate[1];
                
                // System.out.println("시작 : " + startDate);
                // System.out.println("종료 : " + endDate);
                
                WebElement festival_loc = Element.findElement(By.cssSelector("div.other_festival_content div.loc"));
                
                String loc = festival_loc.getText();
                //System.out.println("축제 장소: " + festival_loc.getText());
                
                WebElement img = Element.findElement(By.cssSelector("div.other_festival_img img"));
                
                String imgSrc = img.getAttribute("src");
                System.out.println("이미지 src : " + imgSrc); // 메인 img src 확인
                
                String mainImageDir = System.getProperty("user.dir") + "/src/main/webapp/resources/images/festival/"+ title_name+".jpg";
                
                jsoup_downloadImage(imgSrc, mainImageDir);
                
                paraMap.put("link", link);
                paraMap.put("img", title_name+".jpg");
                paraMap.put("title_name", title_name);
                paraMap.put("start_date", startDate);
                paraMap.put("end_date", endDate);
                paraMap.put("local_status", loc);
                
                
                int n = dao.festival_insert(paraMap);
                
                
                if(n ==1 ) {
                	
                	System.out.println(cnt + "번째 축제 insert 성공");
                	
                }else {
                	
                	System.out.println(cnt + "번째 축제 insert 실패");
                	return;
                }
                
                
                cnt++;
                
                Thread.sleep(2000);
                
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        } finally {
            driver.quit();
        }
        
    } // end of
	
	
	
	// 이미지 다운로드 메서드
	public static void downloadImage(String imageUrl, String destinationFile) {
	    InputStream is = null;
	    OutputStream os = null;

	    try {
	        URL url = new URL(imageUrl);
	        is = url.openStream();
	        os = new FileOutputStream(destinationFile);

	        byte[] byteArr = new byte[1024];
	        int length;

	        while ((length = is.read(byteArr)) != -1) {
	            os.write(byteArr, 0, length);
	        }

	        System.out.println("이미지 다운로드 성공: " + destinationFile);
	    } catch (IOException e) {
	        System.err.println("이미지 다운로드 실패: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        try {
	            if (is != null) {
	                is.close();
	            }
	            if (os != null) {
	                os.close();
	            }
	        } catch (IOException e) {
	            System.err.println("스트림 닫기 실패: " + e.getMessage());
	            e.printStackTrace();
	        }
	    }
	} // end of public static void downloadImage(String imageUrl, String destinationFile) throws IOException {
	
	
	// JSoup을 이용한 이미지 다운로드 메서드
    public static void jsoup_downloadImage(String imageUrl, String destinationFile) {
        try {
            disableSSLVerification();
            Connection.Response resultImageResponse = Jsoup.connect(imageUrl)
                    .ignoreContentType(true)
                    .execute();

            FileOutputStream out = new FileOutputStream(new File(destinationFile));
            out.write(resultImageResponse.bodyAsBytes());
            out.close();

            System.out.println("이미지 다운로드 성공: " + destinationFile);
        } catch (IOException e) {
            System.err.println("이미지 다운로드 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }
	
	
	public static void disableSSLVerification() {
	    try {
	        TrustManager[] trustAllCerts = new TrustManager[]{
	            new X509TrustManager() {
	                public X509Certificate[] getAcceptedIssuers() {
	                    return null;
	                }
	                public void checkClientTrusted(X509Certificate[] certs, String authType) {
	                }
	                public void checkServerTrusted(X509Certificate[] certs, String authType) {
	                }
	            }
	        };

	        SSLContext sc = SSLContext.getInstance("SSL");
	        sc.init(null, trustAllCerts, new java.security.SecureRandom());
	        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

	        HostnameVerifier allHostsValid = new HostnameVerifier() {
	            public boolean verify(String hostname, SSLSession session) {
	                return true;
	            }
	        };

	        HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
}
