package com.spring.app.trip.cro;
import java.util.*;

import com.spring.app.trip.domain.LodgingVO;
import com.spring.app.trip.domain.RoomDetailVO;

import java.sql.*;
public class DataDAO {
   private Connection conn;
   private PreparedStatement ps;
   private final String URL="jdbc:oracle:thin:@211.238.142.186:1521:XE";
   private static DataDAO dao;
   // 드라이버 등록 
   public DataDAO()
   {
	   try
	   {
		   Class.forName("com.jdbc.driver.OracleDriver");
	   }catch(Exception ex){}
   }
   // 연결 
   public void getConnection()
   {
	   try
	   {
		   conn=DriverManager.getConnection(URL,"final_orauser2","gclass");
	   }catch(Exception ex) {}
   }
   public void disConnection()
   {
	   try
	   {
		   if(ps!=null) ps.close();
		   if(conn!=null) conn.close();
	   }catch(Exception ex) {}
   }
   // 싱글턴 => DAO를 한번만 사용이 가능 (메모리 공간을 1개만 생성) = 재사용
   // 스프링에서는 기본 (싱글턴) => 필요시에는 여러개 객체 생성 => prototype
   public static DataDAO newInstance()
   {
	   if(dao==null)
		   dao=new DataDAO();
	   return dao;
   }
   // 데이터 수집 => insert
   
   
   // 카테고리 저장 
   public int lodging_insert(LodgingVO lvo){
	   
	   int n = 0;
	   
	   if(lvo.getLodging_content().length() > 1000) {
		   
		   
		   lvo.setLodging_content("내용이 너무길어요");
		   
	   }
	   
	   try {
		   
		   getConnection();
		   
		   String sql = " INSERT INTO tbl_lodging (LODGING_CODE, LODGING_NAME, LODGING_TELL, LODGING_CONTENT, LODGING_ADDRESS, MAIN_IMG) "
		   		+ " values (?, ?, ?, ?, ?, ?) ";
		   
		   ps = conn.prepareStatement(sql);
		   
		   ps.setString(1, lvo.getLodging_code());
		   ps.setString(2, lvo.getLodging_name());
		   ps.setString(3, lvo.getLodging_tell());
		   ps.setString(4, lvo.getLodging_content());
		   ps.setString(5, lvo.getLodging_address());
		   ps.setString(6, lvo.getMain_img());
		   
		   n = ps.executeUpdate();
		   
		   System.out.println(n);
		   
	   }catch(Exception ex) {
		   ex.printStackTrace();
	   }finally{
		   disConnection();
	   }
	   
	   return n;
   }
   
   
	// 숙소일련번호 채번해오기
	public String select_num() {
	    String result = "";
	    ResultSet rs = null; // ResultSet 선언
	
	    try {
	        getConnection();
	
	        String sql = "SELECT seq_common.nextval AS num FROM dual";
	
	        ps = conn.prepareStatement(sql);
	
	        rs = ps.executeQuery(); // 쿼리 실행 후 ResultSet 가져오기
	
	        if (rs.next()) { // ResultSet에서 데이터 가져오기 전에 이동
	            result = rs.getString("num"); // "num" 컬럼명으로 데이터 가져오기
	        }
	
	    } catch (Exception ex) {
	        ex.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close(); // ResultSet 닫기
	            if (ps != null) ps.close(); // PreparedStatement 닫기
	            if (conn != null) conn.close(); // Connection 닫기
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	
	    return result;
	}
   
   
   
   public void room_detailinsert(RoomDetailVO rvo) {
	   
	   int n = 0;
	   
	   if(rvo.getRoom_name().length() > 200 ) {
		   
	   }
	   else if(rvo.getRoom_img().length() > 100){
		   
		   
		   
	   }
	   
	   try {
		   
		   getConnection();
		   
		   String sql = " INSERT INTO tbl_room_detail (ROOM_DETAIL_CODE, FK_LODGING_CODE, ROOM_NAME, PRICE, CHECK_IN, CHECK_OUT, MIN_PERSON, MAX_PERSON, ROOM_IMG ) "
		   		+ " values (seq_room.nextval, ?, ?, ?, ?, ?, ?, ?, ?) ";
		   
		   ps = conn.prepareStatement(sql);
		   
		   ps.setString(1, rvo.getFk_lodging_code());
		   ps.setString(2, rvo.getRoom_name());
		   ps.setInt(3, Integer.parseInt(rvo.getPrice()));
		   ps.setString(4, rvo.getCheck_in());
		   ps.setString(5, rvo.getCheck_out());
		   ps.setInt(6, rvo.getMin_person());
		   ps.setInt(7, rvo.getMin_person());
		   ps.setString(8, rvo.getRoom_img());
		   
		   n = ps.executeUpdate();
		   
		   if(n==1) {
			   
			   System.out.println("객실 insert 성공");
		   }
		   else {
			   System.out.println("객실 insert 실패");
		   }
		   
	   }catch(Exception ex) {
		   ex.printStackTrace();
	   }finally{
		   try {
	            if (ps != null) ps.close(); // PreparedStatement 닫기
	            if (conn != null) conn.close(); // Connection 닫기
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	   }

	
   }
   
   /*
   // 카테고리별 맛집 저장
   public void foodHouseInsert(FoodHouseVO vo)
   {
	   try
	   {
		   getConnection();
		   String sql="INSERT INTO project_food_house VALUES("
				     +"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		   ps=conn.prepareStatement(sql);
		   ps.setInt(1, vo.getNo());
		   ps.setInt(2, vo.getCno());
		   ps.setString(3, vo.getPoster());
		   ps.setString(4, vo.getName());
		   ps.setDouble(5, vo.getScore());
		   ps.setString(6, vo.getAddress());
		   ps.setString(7, vo.getTel());
		   ps.setString(8, vo.getType());
		   ps.setString(9, vo.getPrice());
		   ps.setString(10, vo.getParking());
		   ps.setString(11, vo.getTime());
		   ps.setString(12, vo.getMenu());
		   ps.setInt(13, vo.getGood());
		   ps.setInt(14, vo.getSoso());
		   ps.setInt(15, vo.getBad());
		   ps.executeUpdate();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
   }
   // 지역별 맛집 => 캡쳐 
   
   public void foodLocationInsert(FoodLocationVO vo)
   {
	   try
	   {
		   getConnection();
		   String sql="INSERT INTO food_location VALUES("
				     +"?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		   ps=conn.prepareStatement(sql);
		   ps.setInt(1, vo.getNo());
		   ps.setString(2, vo.getPoster());
		   ps.setString(3, vo.getName());
		   ps.setDouble(4, vo.getScore());
		   ps.setString(5, vo.getAddress());
		   ps.setString(6, vo.getTel());
		   ps.setString(7, vo.getType());
		   ps.setString(8, vo.getPrice());
		   ps.setString(9, vo.getParking());
		   ps.setString(10, vo.getTime());
		   ps.setString(11, vo.getMenu());
		   ps.setInt(12, vo.getGood());
		   ps.setInt(13, vo.getSoso());
		   ps.setInt(14, vo.getBad());
		   ps.executeUpdate();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
   }
   
   public List<FoodCategoryVO> foodCategoryInfoData()
   {
	   // link , cno
	   List<FoodCategoryVO> list=new ArrayList<FoodCategoryVO>();
	   try
	   {
		   getConnection();
		   String sql="SELECT cno,link FROM project_food_category "
				     +"ORDER BY 1";
		   ps=conn.prepareStatement(sql);
		   ResultSet rs=ps.executeQuery();
		   while(rs.next())
		   {
			   FoodCategoryVO vo=new FoodCategoryVO();
			   vo.setCno(rs.getInt(1));
			   vo.setLink(rs.getString(2));
			   list.add(vo);
		   }
		   rs.close();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
	   return list;
   }
   // ==> 영화 => 맛집 => 레시피 => 명소 ,호텔 , 자연(관광) => 일정(코스) (추천)
   // 명소 


   public void seoulLocationInsert(SeoulLocationVO vo)
   {
	   try
	   {
		   getConnection();
		   String sql="INSERT INTO seoul_location VALUES(?,?,?,?,?)";
		   ps=conn.prepareStatement(sql);
		   ps.setInt(1, vo.getNo());
		   ps.setString(2, vo.getTitle());
		   ps.setString(3, vo.getPoster());
		   ps.setString(4, vo.getMsg());
		   ps.setString(5, vo.getAddress());
		   ps.executeUpdate();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
   }

   public void seoulHotelInsert(SeoulHotelVO vo)
   {
	   try
	   {
		   getConnection();
		   String sql="INSERT INTO seoul_hotel VALUES(?,?,?,?,?,?)";
		   ps=conn.prepareStatement(sql);
		   ps.setInt(1, vo.getNo());
		   ps.setString(2, vo.getName());
		   ps.setDouble(3, vo.getScore());
		   ps.setString(4, vo.getAddress());
		   ps.setString(5, vo.getPoster());
		   ps.setString(6, vo.getImages());
		   ps.executeUpdate();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
   }
   // 자연 
  
   public void seoulNatureInsert(SeoulNatureVO vo)
   {
	   try
	   {
		   getConnection();
		   String sql="INSERT INTO seoul_nature VALUES(?,?,?,?,?)";
		   ps=conn.prepareStatement(sql);
		   ps.setInt(1, vo.getNo());
		   ps.setString(2, vo.getTitle());
		   ps.setString(3, vo.getPoster());
		   ps.setString(4, vo.getMsg());
		   ps.setString(5, vo.getAddress());
		   ps.executeUpdate();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
   }

  
   public List<RecipeVO> recipeData()
   {
	   List<RecipeVO> list=new ArrayList<RecipeVO>();
	   try
	   {
		   getConnection();
		   String sql="SELECT no,link FROM recipe ORDER BY no ASC";
		   ps=conn.prepareStatement(sql);
		   ResultSet rs=ps.executeQuery();
		   while(rs.next())
		   {
			   RecipeVO vo=new RecipeVO();
			   vo.setNo(rs.getInt(1));
			   vo.setLink(rs.getString(2));
			   list.add(vo);
		   }
		   rs.close();
	   }catch(Exception ex)
	   {
		   ex.printStackTrace();
	   }
	   finally
	   {
		   disConnection();
	   }
	   return list;
   }
   */
}






