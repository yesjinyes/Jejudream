package com.spring.app.trip.controller;


import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import com.spring.app.trip.domain.MemberVO;
import com.spring.app.trip.domain.PlayVO;
import com.spring.app.trip.domain.ReviewVO;
import com.spring.app.trip.service.Hs_TripService;

@Controller
public class Hs_TripController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private Hs_TripService service;
	
	@Autowired
	private FileManager fileManager;

	
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
				
				String path = root + "resources"+File.separator+"images"+File.separator+"play";     
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
		public ModelAndView play_main(HttpServletRequest request,ModelAndView mav) {
			List<PlayVO> playList = service.playList();
			
			
			mav.addObject("playList", playList);
			mav.setViewName("play/playMain.tiles1");
			
			return mav;
		}
		
		
		
		//카테고리별로 데이터 가져오기 JSON
		@ResponseBody
		@GetMapping(value = "/playMainJSON.trip",produces="text/plain;charset=UTF-8")
		public String play_mainJSON( HttpServletRequest request,
									@RequestParam(defaultValue="") String str_local, 
									@RequestParam(defaultValue="") String category, 
									@RequestParam(defaultValue="") String currentShowPageNo,
									@RequestParam(defaultValue="") String searchWord) {
			
//			System.out.println("str_local"+str_local);
//			System.out.println("category"+category);
//			System.out.println("currentShowPageNo"+currentShowPageNo);
			
			
			
			int sizePerPage = 6; //한페이지당 6개의 글 보여주기
			
			
		    
		    Map<String,Object> paraMap = new HashMap<>();
		    
		    if("".equals(currentShowPageNo) || currentShowPageNo == null) {
		    	currentShowPageNo="1";
			}
		    if("".equals(searchWord) || searchWord == null) {
		    	searchWord="";
		    }
		    
		    int startRno = ((Integer.parseInt(currentShowPageNo)- 1) * sizePerPage) + 1; // 시작 행번호 
		    int endRno = startRno + sizePerPage - 1; // 끝 행번호
		    
		    paraMap.put("startRno",String.valueOf(startRno) );
		    paraMap.put("endRno",String.valueOf(endRno));
		     
		   
		    if(!"".equals(category)) { 
		    	paraMap.put("category", category);
		    }
		    if(!"".equals(str_local)) {
				String[] arr_local_status = str_local.trim().split("\\,"); // in 절을 사용하기 위해서는 배열로 만든 후 넘겨줘야한다
				System.out.println("arr_local_status"+Arrays.toString(arr_local_status));
				
				paraMap.put("arr_local_status",arr_local_status);
			} 
		    paraMap.put("currentShowPageNo", currentShowPageNo);
		    paraMap.put("searchWord", searchWord); 
		    
		    //전체개수
		    int totalCount = service.getPlayTotalCount(paraMap);
		    System.out.println("totalCount"+totalCount);
		    //조건에 맞는 리트 가져오기
			List<PlayVO> playList=service.getPlayListByCategory(paraMap);
			
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
					jsonObj.put("play_code",playvo.getPlay_code() ); 
					
					jsonObj.put("totalCount", totalCount); //총 페이지 
	            	jsonObj.put("sizePerPage", sizePerPage); //한페이지당 보여줄 개수
	            	jsonObj.put("currentShowPageNo", currentShowPageNo); //현재페이지
	            	jsonObj.put("searchWord", searchWord); //검색어가 있을경우
		
					jsonArr.put(jsonObj);
				}
				//System.out.println("json" + jsonArr);
			}
			return jsonArr.toString();
		 
		}
		
		
		//디테일겸, 일정추가 있는 페이지
		@GetMapping("goAddSchedule.trip")
		public ModelAndView goAddSchedule (ModelAndView mav , HttpServletRequest request) {
			
			String play_code = request.getParameter("play_code");
			System.out.println("play_code"+play_code);
			
			
			PlayVO playvo = service.goAddSchedule(play_code);
			
			
			mav.addObject("playvo", playvo);
			mav.setViewName("play/goAddSchedule.tiles1");
			
			return mav;
		}
		
		
		//리뷰작성
		@ResponseBody
		@PostMapping(value = "reviewRegister.trip",produces="text/plain;charset=UTF-8")
		public String reviewRegister (HttpServletRequest request) {
			 
			 String review_content = request.getParameter("review_content");
	         String fk_userid = request.getParameter("fk_userid");
	         String parent_code = request.getParameter("play_code");
	         String review_division_R = "C";
	        /* 
	         // **** 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어 코드) 작성하기 **** // 
	         contents = contents.replaceAll("<", "&lt;");
	         contents = contents.replaceAll(">", "&gt;");
	         
	         // 입력한 내용에서 엔터는 <br>로 변환시키기
	         contents = contents.replaceAll("\r\n", "<br>");
	         */
	         
	         System.out.println("review_content"+review_content);
	         System.out.println("fk_userid"+fk_userid);
	         System.out.println("parent_code"+parent_code);
	         System.out.println("review_division_R"+review_division_R);
	         
	         ReviewVO reviewvo = new ReviewVO();
	         reviewvo.setFk_userid(fk_userid);
	         reviewvo.setReview_content(review_content);
	         reviewvo.setParent_code(parent_code);
	         reviewvo.setReview_division_R(review_division_R);
	         
	         int n = service.addReview(reviewvo);
	         
	         
	         JSONObject jsonObj = new JSONObject();
	         jsonObj.put("n", n);
	         
	        
	         return jsonObj.toString();
		}

		
		//리뷰 보여주기 
		@ResponseBody
		@GetMapping(value="reviewList.trip",produces="text/plain;charset=UTF-8")
		public String reviewList (HttpServletRequest request) {
			
			String parent_code = request.getParameter("parent_code");
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			
			if("".equals(currentShowPageNo) || currentShowPageNo == null) {
		    	currentShowPageNo="1";
			}
			
			int sizePerPage = 6; //한페이지당 6개의 글 보여주기
			int startRno = ((Integer.parseInt(currentShowPageNo)- 1) * sizePerPage) + 1; // 시작 행번호 
			int endRno = startRno + sizePerPage - 1; // 끝 행번호
			
			Map<String,String> paraMap = new HashMap<>();

		
		    paraMap.put("startRno",String.valueOf(startRno) );
		    paraMap.put("endRno",String.valueOf(endRno));

		    paraMap.put("parent_code", parent_code);
		    paraMap.put("currentShowPageNo", currentShowPageNo);
		     
		    //전체개수
		    int totalCount = service.getPlayReviewCount(paraMap);
		    System.out.println("totalCount"+totalCount);
		    //조건에 맞는 리트 가져오기
			List<ReviewVO> reviewList = service.reviewList(paraMap);
			
			JSONArray jsonArr = new JSONArray();
			if(reviewList != null) {
				for(ReviewVO reviewvo : reviewList) {
					JSONObject jsonObj = new JSONObject(); //{}
					jsonObj.put("review_content",reviewvo.getReview_content()); 
					jsonObj.put("fk_userid",reviewvo.getFk_userid()); 
					jsonObj.put("registerday",reviewvo.getRegisterday()); 
					jsonObj.put("review_code",reviewvo.getReview_code()); 
					
					jsonObj.put("totalCount", totalCount); //총 페이지 
	            	jsonObj.put("sizePerPage", sizePerPage); //한페이지당 보여줄 개수
	            	jsonObj.put("currentShowPageNo", currentShowPageNo); //현재페이지
				
		
					jsonArr.put(jsonObj);
				}
				//System.out.println("json" + jsonArr);
			}
			return jsonArr.toString();
		}
		
		
		
		
		//리뷰수정하기
		@ResponseBody
		@PostMapping(value="play/reviewUpdate.trip",produces="text/plain;charset=UTF-8")
		public String reviewUpdate (HttpServletRequest request) {
		
			String review_code = request.getParameter("review_code");
			String review_content = request.getParameter("review_content");
			
			
			Map<String, String>paraMap = new HashMap<>();
			paraMap.put("review_code",review_code);
			paraMap.put("review_content",review_content);
			
			int n = service.updateReview(paraMap);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("n",n);

			return jsonObj.toString();
		
		}
		
		//리뷰삭제하기
		@ResponseBody
		@PostMapping(value="play/reviewDel.trip",produces="text/plain;charset=UTF-8")
		public String reviewDel (HttpServletRequest request) {
			
			String review_code = request.getParameter("review_code");
			
			int n = service.reviewDel(review_code);

		    JSONObject jsonObj = new JSONObject(); 
		    jsonObj.put("n", n);
	         
	        return jsonObj.toString();
			
		}
		
	
		@GetMapping("editPlay.trip")
		public ModelAndView requiredLogin_editPlay(HttpServletRequest request,HttpServletResponse response, ModelAndView mav) {
			String message = "";
			// 글 삭제 할 글번호 가져오기
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			String play_code = request.getParameter("play_code");
			System.out.println("play_code " + play_code);
			
			try {
				Integer.parseInt(play_code);
				System.out.println("play_code integer" + play_code);
				
				if(loginuser != null && !loginuser.getUserid().equals("admin")) {
					message="관리자만 접근 가능합니다.";
					mav.setViewName("play/playMain.tiles1");
				}
				else {
				//글 수정해야 할 글 1 개 내용 가져오기
					Map<String, String> paraMap = new HashMap<>();
					paraMap.put("play_code", play_code);
					
					PlayVO playvo=service.getPlaySelect(paraMap);
					
					if(playvo == null) {
						message = "존재하지 않는 글 입니다";
					}
					else {
						mav.addObject("playvo",playvo);
						mav.setViewName("play/edit.tiles1");
						
						return mav;
					}
				}
				
				
			} catch (NumberFormatException e) {
				message = "관리자만 접근 가능합니다.2";
			}
			
			String loc = "javascript:history.back()";
			mav.addObject("message",message);
			mav.addObject("loc",loc);
			
			mav.setViewName("msg");
			
			return mav;
		}
		
		
		
		@PostMapping("editPlayEnd.trip")
		public ModelAndView editEnd (ModelAndView mav ,PlayVO playvo ,MultipartHttpServletRequest mrequest) {
			
			MultipartFile attach = playvo.getAttach();
		      
			if( !attach.isEmpty() ) {
			    
				HttpSession session = mrequest.getSession(); 
				String root = session.getServletContext().getRealPath("/"); 
				
				String path = root + "resources"+File.separator+"images"+File.separator+"play";     
		        String newFileName = "";
		         
		        byte[] bytes = null;// 첨부파일의 내용물을 담는 것
		        
		         
		        long fileSize = 0;// 첨부파일의 크기 

		        try {
		            bytes = attach.getBytes();
		            String originalFilename = attach.getOriginalFilename();
		            newFileName = fileManager.doFileUpload(bytes, originalFilename, path); 
		            
		            playvo.setFileName(newFileName);
		                     
		            playvo.setOrgFilename(playvo.getPlay_name()+"_main.jpg");
		                     
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
			
			System.out.println("setPlay_address"+ playvo.getPlay_address());
			System.out.println("getFileName"+ playvo.getFileName());
			System.out.println("getLocal_status"+ playvo.getLocal_status());
			System.out.println("getPlay_businesshours"+  playvo.getPlay_businesshours());
			
			
			int n = service.editEnd(playvo); 
			
			if(n==1) {
				mav.addObject("message","글 수정 성공!!");
				mav.addObject("loc", mrequest.getContextPath()+"/playMain.trip?play_code=" + playvo.getPlay_code());//수정되어진 글을 다시 보여줌
				
				mav.setViewName("msg");
				//  /list.action 페이지로 redirect(페이지이동)해라는 말이다.
			}
			else {
		        mav.setViewName("play/playMain.tiles1");
		        //  /WEB-INF/views/tiles1/board/error/add_error.jsp 파일을 생성한다.
		      }
			return mav;
		}
		
		
		
}