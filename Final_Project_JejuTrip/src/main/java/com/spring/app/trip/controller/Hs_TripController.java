package com.spring.app.trip.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.domain.CompanyVO;
import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.service.Hs_TripService;

@Controller
public class Hs_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Hs_TripService service;
	
	@Autowired
	private FileManager fileManager;
	
	// === 커뮤니티 메인 페이지 보이기 === //
		@GetMapping("mypageMain.trip")
		public String mypage_main(HttpServletRequest request) {
			return "mypage/mypageMain.tiles1"; 
			// /WEB-INF/views/tiles1/mypage/mypageMain.jsp 파일 생성
		}
		
		
		@GetMapping("reservations.trip")
		public String reservation(HttpServletRequest request) {
			return "mypage/reservations.tiles1"; 
			// /WEB-INF/views/mypage/reservations.jsp 파일 생성
		}
		
		
		@GetMapping("edit_profile.trip")
		public String edit_profile(HttpServletRequest request) {
			return "mypage/edit_profile.tiles1"; 
			// /WEB-INF/views/mypage/edit_profile.jsp 파일 생성
		}
		
		/*@GetMapping("cash_points.trip")
		public String cash_points(HttpServletRequest request) {
			return "mypage/cash_points"; 
			// /WEB-INF/views/mypage/cash_points.jsp 파일 생성
		}*/
		
		@GetMapping("review.trip")
		public String review(HttpServletRequest request) {
			return "mypage/review.tiles1"; 
			// /WEB-INF/views/mypage/review.jsp 파일 생성
		}
		
		@GetMapping("support.trip")
		public String support(HttpServletRequest request) {
			return "mypage/support.tiles1"; 
			// /WEB-INF/views/mypage/support.jsp 파일 생성
		}
		
		
		
		//즐길거리 등록페이지 
		@GetMapping("registerPlay.trip")
		public ModelAndView registerPlay(ModelAndView mav, HttpServletRequest request) {
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			if(loginuser != null ) {
				mav.setViewName("play/registerPlay.tiles1");
			}
			else {
				String message = "비정상적인 경로입니다.";
				String loc = "javascript:history.back()";

				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
			}
			
			return mav;
		}
		
		
		
		@ResponseBody
		@PostMapping("registerPlayEnd.trip")
		public ModelAndView registerPlayEnd(ModelAndView mav,PlayVO playvo, MultipartHttpServletRequest mrequest) {

			// =========== !!! 첨부파일 업로드 시작 !!! ============ // 
			MultipartFile attach = playvo.getAttach();
		      
			if( !attach.isEmpty() ) {
			    
				HttpSession session = mrequest.getSession(); 
				String root = session.getServletContext().getRealPath("/"); 
				
				// System.out.println("~~~ 확인용 webapp 의 절대경로 => " + root); 
				// ~~~ 확인용 webapp 의 절대경로 => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\
				
				String path = root + "resources"+File.separator+"files";     
		        // System.out.println(path);
		        /* File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
		                            운영체제가 Windows 이라면 File.separator 는  "\" 이고,
		                            운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
		         */
		                  
		        // path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
		        //   System.out.println("~~~ 확인용 path => " + path);
		        //  ~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files 
		                  
		        /*
		             2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기  
		         */
		        String newFileName = "";
		        // WAS(톰캣)의 디스크에 저장될 파일명 
		         
		        byte[] bytes = null;
		        // 첨부파일의 내용물을 담는 것
		         
		        long fileSize = 0;
		        // 첨부파일의 크기 
		         
		         
		        try {
		            bytes = attach.getBytes();
		            // 첨부파일의 내용물을 읽어오는 것
		            
		            String originalFilename = attach.getOriginalFilename();
		            // attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다.
		            
		            //   System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
		            // ~~~ 확인용 originalFilename => LG_싸이킹청소기_사용설명서.pdf 
		            
		            newFileName = fileManager.doFileUpload(bytes, originalFilename, path); 
		            // 첨부되어진 파일을 업로드 하는 것이다.
		            
		            //   System.out.println("~~~ 확인용 newFileName => " + newFileName); 
		            // ~~~ 확인용 newFileName => 20231124113600755016855987700.pdf 
		                     
		                  
		            /*
		                3. CommentVO commentvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기  
		            */
		            playvo.setFileName(newFileName);
		            // WAS(톰캣)에 저장된 파일명(20231124113600755016855987700.pdf)
		                     
		            playvo.setOrgFilename(playvo.getPlay_name()+"_main.jpg");
		            // 게시판 페이지에서 첨부된 파일(LG_싸이킹청소기_사용설명서.pdf)을 보여줄 때 사용.
		            // 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
		                     
		            fileSize = attach.getSize();  // 첨부파일의 크기(단위는 byte임) 
		            playvo.setFileSize(String.valueOf(fileSize));
		                     
		         } catch (Exception e) {
		            e.printStackTrace();
		         }   
			}
			// =========== !!! 첨부파일 업로드 끝 !!! ============ //;
			
			String address = mrequest.getParameter("play_address");
			String detail_address = mrequest.getParameter("detail_address");
			
			playvo.setPlay_address(address + " " + detail_address);
			// === 데이터 베이스에 등록하려는 숙소 정보 insert 하기 === // 
		
			int n = service.registerPlayEnd(playvo);
			
			if(n == 1) {
				String message = "즐길거리 등록이 성공적으로 완료되었습니다.";
				String loc = "index.trip";

				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
			}
			else {
				String message = "즐길거리 등록 신청에 실패했습니다.";
				String loc = "index.trip";

				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
			}
			
			return mav;
			
		}
		
		
		//-------------------------------------------------------------------------------//
		
		//즐길거리 페이지
		@GetMapping(value = "playMain.trip", produces = "text/plain;charset=UTF-8")
		public ModelAndView play_main(ModelAndView mav) {
			List<PlayVO> playList = service.playList();
			
			mav.addObject("playList", playList);
			mav.setViewName("play/playMain.tiles1");
			
			return mav;
		}
		
		
		
		//카테고리별로 데이터 가져오기 JSON
		@ResponseBody
		@GetMapping(value = "playMainJSON.trip", produces = "text/plain;charset=UTF-8")
		public String play_mainJSON( HttpServletRequest request) {
			
			//--------------스크롤 페이징----------------------//
			
			String start = request.getParameter("start");
		    String len = request.getParameter("len");
		    String end = String.valueOf(Integer.parseInt(start) + Integer.parseInt(len) - 1); // 1 + 8 = 9 - 1 = 8
		    
		    //--------------스크롤 페이징----------------------//

		    String category = request.getParameter("category");
		  
		    System.out.println(category);
		    
		    Map<String, String> paraMap = new HashMap<>();
		    paraMap.put("start", start); // "1"  "9"  "17"  "25"  "33"
		    paraMap.put("end", end); // end => start + len - 1; 
		    paraMap.put("category", category); 
		    
		    
			List<PlayVO> playList;
			
			if (category == null || category.equals("전체")) {
	            playList = service.playList(paraMap); // 모든 항목 가져오기
	        } else {
	            playList = service.getPlayListByCategory(paraMap); // 카테고리에 따른 항목 가져오기
	        }
			
			
			JSONArray jsonArr = new JSONArray();
			if(playList != null) {
				for(PlayVO playvo : playList) {
					JSONObject jsonObj = new JSONObject(); //{}
					jsonObj.put("play_category",playvo.getPlay_category()); 
					jsonObj.put("play_name",playvo.getPlay_name() );
					jsonObj.put("play_content",playvo.getPlay_content() ); 
					jsonObj.put("play_mobile",playvo.getPlay_mobile() ); 
					jsonObj.put("play_businesshours",playvo.getPlay_businesshours() ); 
					jsonObj.put("play_address",playvo.getPlay_address() ); 
					jsonObj.put("play_main_img",playvo.getPlay_main_img() ); 
					
		
					jsonArr.put(jsonObj);
				}
				//System.out.println("json" + jsonArr);
			}
			return jsonArr.toString();
		 
		}

}