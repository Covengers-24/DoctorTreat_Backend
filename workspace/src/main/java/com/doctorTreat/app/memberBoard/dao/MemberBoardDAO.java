package com.doctorTreat.app.memberBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.doctorTreat.app.dto.MemberBoardDTO;
import com.mybatis.config.MyBatisConfig;

public class MemberBoardDAO {
	private SqlSession sqlSession;

	public MemberBoardDAO() {
		sqlSession = MyBatisConfig.getSqlSessionFactory().openSession(true);
	}

	// 페이지네이션 적용된 리스트 가져오기
	public List<MemberBoardDTO> showList(int page, int pageSize) {
		int offset = (page - 1) * pageSize;

		Map<String, Object> params = new HashMap<>();
		params.put("pageSize", pageSize);
		params.put("offset", offset);

		return sqlSession.selectList("memberBoard.showlist", params);
	}

	// 총 게시물 수를 가져오는 메서드 추가
	public int getTotalCount() {
		return sqlSession.selectOne("memberBoard.getTotalCount");
	}

	// 게시글 상세
	public MemberBoardDTO showDetail(int medicalInfoNumber) {
	    return sqlSession.selectOne("memberBoard.showDetail",  medicalInfoNumber);  
	}
	

	//게시글 작성
	 public void write(MemberBoardDTO memberBoardDTO) {
	        sqlSession.insert("memberBoard.write", memberBoardDTO);
	    }
	 
	 //게시글 삭제 1
	 public void delete1(int medicalInfoNumber) {
		 sqlSession.delete("memberBoard.deleteDoctorComment", medicalInfoNumber);
	 }
	 
	 //게시글 삭제 2
	 public void delete2(int medicalInfoNumber) {
		 sqlSession.delete("memberBoard.deleteMedicalInfo", medicalInfoNumber);
	 }
	 
	 //게시글 삭제 3
	 public void delete3(int medicalInfoNumber) {
		 sqlSession.delete("memberBoard.deleteMember", medicalInfoNumber);
	 }
	 
	 //게시글 삭제 4
	 public void delete4(int medicalInfoNumber) {
		 sqlSession.delete("memberBoard.deleteDoctor", medicalInfoNumber);
	 }
	 
	 //게시글 수정
	 public void update(MemberBoardDTO memberBoardDTO) {
		 sqlSession.update("memberBoard.update" , memberBoardDTO);
	 }
	 
	 // 게시글 수정때 보여주기
	 public MemberBoardDTO show (int medicalInfoNumber) {
		 return sqlSession.selectOne("memberBoard.content" , medicalInfoNumber);
	 }

}
