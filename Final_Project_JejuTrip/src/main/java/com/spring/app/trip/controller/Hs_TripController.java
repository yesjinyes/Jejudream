package com.spring.app.trip.controller;


import java.io.File;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.trip.common.FileManager;
import com.spring.app.trip.domain.Calendar_schedule_VO;
import com.spring.app.trip.domain.LikeVO;
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

	  //-------------------------------------------------------------------------------//
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
		
		//-------------------------------------------------------------------------------//
		
		@ResponseBody
		@PostMapping("registerPlayEnd.trip")
		public ModelAndView registerPlayEnd(ModelAndView mav,PlayVO playvo, MultipartHttpServletRequest mrequest) {

			// =========== !!! 첨부파일 업로드 시작 !!! ============ // 
			MultipartFile attach = playvo.getAttach();
		      
			if( !attach.isEmpty() ) {
			    
				HttpSession session = mrequest.getSession(); 
				String root = session.getServletContext().getRealPath("/"); 
				String path = root + "resources"+File.separator+"images"+File.separator+"play";     
		        String newFileName = "";  // WAS(톰캣)의 디스크에 저장될 파일명 
		       
		        byte[] bytes = null;// 첨부파일의 내용물을 담는 것
		        long fileSize = 0;// 첨부파일의 크기 
		        
		        try {
		            bytes = attach.getBytes();
		            // 첨부파일의 내용물을 읽어오는 것
		            
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
		
		
		//-------------------------------------------------------------------------------//
		
		//카테고리별로 데이터 가져오기 JSON
		@ResponseBody
		@GetMapping(value = "/playMainJSON.trip",produces="text/plain;charset=UTF-8")
		public String play_mainJSON( HttpServletRequest request,
									@RequestParam(defaultValue="") String str_local, 
									@RequestParam(defaultValue="") String category, 
									@RequestParam(defaultValue="") String currentShowPageNo,
									@RequestParam(defaultValue="") String searchWord) {
			
			
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
				
				paraMap.put("arr_local_status",arr_local_status);
			} 
		    paraMap.put("currentShowPageNo", currentShowPageNo);
		    paraMap.put("searchWord", searchWord); 
		    
		    //전체개수
		    int totalCount = service.getPlayTotalCount(paraMap);
		    //System.out.println("totalCount"+totalCount);
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
		
		//-------------------------------------------------------------------------------//
		
		//디테일겸, 일정추가 있는 페이지
		@GetMapping("goAddSchedule.trip")
		public ModelAndView goAddSchedule (ModelAndView mav , HttpServletRequest request) {
			
			String play_code = request.getParameter("play_code");
			//System.out.println("play_code"+play_code);
			PlayVO playvo = service.goAddSchedule(play_code);
			


			mav.addObject("playvo", playvo);
			mav.setViewName("play/goAddSchedule.tiles1");
			
			return mav;
		}
		
		//-------------------------------------------------------------------------------//
		
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

		//-------------------------------------------------------------------------------//
		
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
			}
			return jsonArr.toString();
		}
		
		//-------------------------------------------------------------------------------//
		
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
		
		//-------------------------------------------------------------------------------//
		
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
		
		//-------------------------------------------------------------------------------//
		
		//즐길거리 수정
		@GetMapping("editPlay.trip")
		public ModelAndView requiredLogin_editPlay(HttpServletRequest request,HttpServletResponse response, ModelAndView mav) {
			String message = "";
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			String play_code = request.getParameter("play_code");
			
			try {
				Integer.parseInt(play_code);
				
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
		
		//-------------------------------------------------------------------------------//
		
		//즐길거리 수정
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
		                     
		            fileSize = attach.getSize();
		            playvo.setFileSize(String.valueOf(fileSize));
		                     
		         } catch (Exception e) {
		            e.printStackTrace();
		         }   
			}
			
			// =========== !!! 첨부파일 업로드 끝 !!! ============ //;
			String address = mrequest.getParameter("play_address");
			String detail_address = mrequest.getParameter("detail_address");
			
			playvo.setPlay_address(address + " " + detail_address);
			
			
			int n = service.editEnd(playvo); 
			
			if(n==1) {
				mav.addObject("message","글 수정 성공!!");
				mav.addObject("loc", mrequest.getContextPath()+"/goAddSchedule.trip?play_code=" + playvo.getPlay_code());//수정되어진 글을 다시 보여줌
				
				mav.setViewName("msg");
			}
			else {
		        String loc = "javascript:history.back()";
				mav.addObject("loc", loc);
		        
		      }
			return mav;
		}
		
		//-------------------------------------------------------------------------------//
		
		//글삭제요청
		@PostMapping("deletePlay.trip")
		public ModelAndView requiredLogin_del(HttpServletRequest request,HttpServletResponse response, ModelAndView mav) {
			
			  String message = "";
			    HttpSession session = request.getSession();
			    MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");

			    // 글 삭제 할 글번호 가져오기
			    String play_code = request.getParameter("play_code");

			    if(!"admin".equals(loginuser.getUserid())) {
			        message = "관리자 외 삭제가 불가능 합니다";
			        mav.setViewName("redirect:/playMain.trip");
			        return mav;
			    }

			    Map<String, String> paraMap = new HashMap<>();
			    paraMap.put("play_code", play_code);

			    PlayVO playvo = service.getPlaySelect(paraMap);
			    String fileName = playvo.getFileName(); // 삭제해야 할 파일이름

			    if (fileName != null && !"".equals(fileName)) { 
			        String root = session.getServletContext().getRealPath("/"); 
			        String path = root + "resources" + File.separator + "images" + File.separator + "play";  
			        paraMap.put("path", path); // 삭제해야할 파일이 저장된 경로
			        paraMap.put("fileName", fileName); // 삭제해야할 파일 명 
			        
			        //System.out.println("if fileName 들어옴");
			    }

			    int n = service.delPlay(paraMap);

			    if(n == 1) {
			        mav.addObject("message", "글 삭제 성공!!");
			        mav.addObject("loc", request.getContextPath() + "/playMain.trip");
			        mav.setViewName("msg");
			    } else {
			        mav.addObject("message", "글 삭제 실패!!");
			        mav.addObject("loc", request.getContextPath() + "/playMain.trip");
			        mav.setViewName("msg");
			    }

			    return mav;
		}
		
		
		
		@ResponseBody
		@PostMapping(value =("play/playLike.trip"),produces="text/plain;charset=UTF-8")
		 public String playLike(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			String parent_code = request.getParameter("parent_code");
			String fk_userid = request.getParameter("fk_userid");
			String like_division_R = "C";
			int n = 0;
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("parent_code", parent_code);
			paraMap.put("fk_userid", fk_userid);
			paraMap.put("like_division_R", like_division_R);
			
			List<LikeVO> check = service.checkLike(paraMap); 
			
			if(check.size() == 0) {
				n = service.likeAdd(paraMap);  // 좋아요 업데이트
			}
			else {
				service.likeDel(paraMap);  // 좋아요 지우기
		        n=0;
		        
			}
			
			//System.out.println("n"+n);
			
		    JSONObject jsonObj = new JSONObject(); 
		    jsonObj.put("n", n);
	         
	        return jsonObj.toString();
			

		}
		
		
		@ResponseBody
		@GetMapping(value =("countLike.trip"),produces="text/plain;charset=UTF-8")
		 public String countLike(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			String parent_code = request.getParameter("parent_code");
		    String fk_userid = request.getParameter("fk_userid");

		    Map<String, String> paraMap = new HashMap<>();
		    paraMap.put("parent_code", parent_code);

		    // 좋아요 총 수량 알아오기
		    int countLike = service.countLike(paraMap);

		    JSONObject jsonObj = new JSONObject();
		    jsonObj.put("countLike", countLike);

		    if (fk_userid != null && !fk_userid.isEmpty()) {
		        paraMap.put("fk_userid", fk_userid);
		        List<LikeVO> check = service.checkLike(paraMap); // 좋아요를 했는지 알아오는 것 (0 또는 1)
		        jsonObj.put("check", check != null ? check.size() > 0 : false);
		    } else {
		        jsonObj.put("check", false);
		    }

		    return jsonObj.toString();
		}
		
		
		//-------------------카테고리에 있는 수량 count 하기-------------------------//
		@ResponseBody
		@GetMapping(value = "getCategoryCount.trip", produces = "application/json;charset=UTF-8")
		public String getCategoryCount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		    Map<String, Integer> categoryCount = new HashMap<>();
		    
		    int total = service.countTotal(); // 전체 항목 수
		    int tourism = service.countTourism(); // 관광지 항목 수
		    int showing = service.countShowing(); // 전시회 항목 수
		    int experience = service.countExperience(); // 체험 항목 수

		    categoryCount.put("total", total);
		    categoryCount.put("tourism", tourism);
		    categoryCount.put("showing", showing);
		    categoryCount.put("experience", experience);
		    
		    JSONObject jsonObj = new JSONObject(categoryCount);
		    
		    return jsonObj.toString();
		}
		
		
		
		
		//--------------------------------일정추가 관련 시작-------------------------------------------//
	/*	
		// === 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기 ===
		@ResponseBody
		@RequestMapping(value="/schedule/insertSchedule/searchPlayJoinUserList.trip", produces="text/plain;charset=UTF-8")
		public String searchPlayJoinUserList(HttpServletRequest request) {
			
			String joinUserName = request.getParameter("joinUserName");
			
			// 회원명단 불러오기
			List<MemberVO> joinUserList = service.searchPlayJoinUserList(joinUserName);

			JSONArray jsonArr = new JSONArray();
			if(joinUserList != null && joinUserList.size() > 0) {
				for(MemberVO mvo : joinUserList) {
					JSONObject jsObj = new JSONObject();
					jsObj.put("userid", mvo.getUserid());
					jsObj.put("name", mvo.getUser_name());
					
					jsonArr.put(jsObj);
				}
			}
			
			return jsonArr.toString();
			
		}
		*/
		
		// === 일정 등록하기 ===
		@PostMapping("/schedule/registerPlaySchedule_end.trip")
		public ModelAndView registerPlaySchedule_end(ModelAndView mav, HttpServletRequest request) throws Throwable {
			
			String startdate= request.getParameter("startdate");
			String enddate = request.getParameter("enddate");
			
			String subject = request.getParameter("subject");
			String fk_lgcatgono= request.getParameter("fk_lgcatgono");
			String fk_smcatgono = request.getParameter("fk_smcatgono");
			String color = request.getParameter("color");
			String place = request.getParameter("place");
			String joinuser = request.getParameter("joinuser");
			String parent_code = request.getParameter("parent_code");
			
			String content = request.getParameter("content");
			String fk_userid = request.getParameter("fk_userid");
			String schedule_divison = request.getParameter("review_division");
			System.out.println("parent_code" + parent_code);
			Map<String,String> paraMap = new HashMap<String, String>();
			paraMap.put("startdate", startdate);
			paraMap.put("enddate", enddate);
			paraMap.put("subject", subject);
			paraMap.put("fk_lgcatgono",fk_lgcatgono);
			paraMap.put("fk_smcatgono", fk_smcatgono);
			paraMap.put("parent_code", parent_code);
			paraMap.put("color", color);
			paraMap.put("place", place);
			paraMap.put("schedule_divison", schedule_divison);
			
			paraMap.put("joinuser", joinuser);
			
			paraMap.put("content", content);
			paraMap.put("fk_userid", fk_userid);
			
			int n = service.registerPlaySchedule_end(paraMap);

			if(n == 0) {
				mav.addObject("message", "일정 등록에 실패하였습니다.");
			}
			else {
				mav.addObject("message", "일정 등록에 성공하였습니다.");
			}
			
			mav.addObject("loc", request.getContextPath()+"/index.trip");
			
			mav.setViewName("msg");
			
			return mav;
		}
		
		
		
		@ResponseBody
		@GetMapping(value =("checkSchedule.trip"),produces="text/plain;charset=UTF-8")
		 public String checkSchedule(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			String parent_code = request.getParameter("parent_code");
		    String fk_userid = request.getParameter("fk_userid");

		    Map<String, String> paraMap = new HashMap<>();
		    
		    JSONObject jsonObj = new JSONObject();
		    paraMap.put("parent_code", parent_code);

		    if (fk_userid != null && !fk_userid.isEmpty()) {
		        paraMap.put("fk_userid", fk_userid);
		        
		        List<Calendar_schedule_VO> calcheck = service.checkSchedule(paraMap); // 좋아요를 했는지 알아오는 것 (0 또는 1)
		        jsonObj.put("calcheck", calcheck != null ? calcheck.size() > 0 : false);
		    } else {
		        jsonObj.put("calcheck", false);
		    }

		    return jsonObj.toString();
		}
		
		
		
		
		
		
		
		
		
		
}