package com.mybatis.config;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MyBatisConfig {
   //sqlSession을 만들기 위해서 세션 팩토리가 필요하다
   private static SqlSessionFactory sqlSessionFactory;
   
   //팩토리는 딱 한번만 프로그램이 시작될 때 만들면 된다
   //그러므로 static 초기화 블록으로 생성해 준다
   static {
      try {
         //설정파일의 경로를 문자열에 저장한다
         String resource = "./com/mybatis/config/config.xml";
         //Resource 클래스를 이용하여 리소스를 읽어들여 Reader 객체로 만든다
         Reader reader = Resources.getResourceAsReader(resource);
         
         //세션팩토리 빌더에게 팩토리를 지어달라고 한다 .build()																																																																																																																																																																																																																															
         //공장을 짓기 위해 설계도가 필요하다
         //설계도는 설정값을 저장하고 있는 reader이다
         sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
         //필드로 선언한 sqlSessionFactory 객체에 읽어들인 리소스로 지을 팩토리를 알려줌
      } catch (IOException e) {
         System.out.println("MyBatisConfig.java 초기화 문제 발생");
         e.printStackTrace();
      }
   }
   //여기까지 선언 됐다면 현재의 클래스를 생성할때 최초 한번 static블록으로 필드를 초기화 해 줄 수 있다

   //sqlSessionFactory의 접근 제한자가 private이므로 getter를 만든다
   //static 변수이므로 getter에도 static이 붙는다
   public static SqlSessionFactory getSqlSessionFactory() {
      return sqlSessionFactory;
   }
   
}