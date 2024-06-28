package com.spring.app.trip.cro;
import java.util.*;
import java.sql.*;
public class DataDAO {
	
	/*
   private Connection conn;
   private PreparedStatement ps;
   private final String URL="jdbc:oracle:thin:@localhost:1521:XE";
   private static DataDAO dao;
   // 드라이버 등록 
   public DataDAO()
   {
	   try
	   {
		   Class.forName("com.mysql.cj.jdbc.Driver");
	   }catch(Exception ex){}
   }
   // 연결 
   public void getConnection()
   {
	   try
	   {
		   conn=DriverManager.getConnection(URL,"hr","happy");
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
   */
   /*
   // 카테고리 저장 
   public void foodCategoryInsert(FoodCategoryVO vo)
   {
	   try
	   {
		   getConnection();
		   String sql="INSERT INTO project_food_category VALUES("
				     +"?,?,?,?,?)";
		   ps=conn.prepareStatement(sql);
		   ps.setInt(1, vo.getCno());
		   ps.setString(2, vo.getTitle());
		   ps.setString(3, vo.getSubject());
		   ps.setString(4, vo.getPoster());
		   ps.setString(5, vo.getLink());
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






