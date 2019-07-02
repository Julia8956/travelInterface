package com.kh.ti.member.controller;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import com.kh.ti.common.PageInfo;
import com.kh.ti.common.Pagination;
import com.kh.ti.member.model.exception.LoginException;
import com.kh.ti.member.model.service.MemberService;
import com.kh.ti.member.model.vo.Member;

@SessionAttributes("loginUser")
@Controller
public class MemberController {
	
	@Autowired
	private MemberService ms;
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	//로그인화면 보여주기 전용(forward loginForm.jsp)--세령
	@RequestMapping("loginForm.me")
	public String showLoginForm() {
		return "member/loginForm";
	}
	
	//회원정보수정화면 보여주기 전용(forward updateMemberInfo.jsp)--세령
	@RequestMapping("updateMemberForm.me")
	public String showMemberInfo(Model model, HttpServletRequest request) {
		return "member/updateMemberInfo";
	}
	
	//관리자회원관리화면 보여주기 전용(forward adminMemberList.jsp)--세령
	@RequestMapping("adminMemberListForm.me")
	public String showAdminMemberList(Model model, @RequestParam("currentPage") int currentPage, 
									  @RequestParam("status") String status) {
		//조회 기능 추가
		int listCount = ms.getListCount(status);
		PageInfo pi = Pagination.getPageInfo(currentPage, listCount);
		
		ArrayList<Member> mList = ms.selectAllMember(pi, status);
		model.addAttribute("mList", mList);
		model.addAttribute("listCount", listCount);
		model.addAttribute("pi", pi);
		model.addAttribute("status", status);
		return "admin/member/adminMemberList";
	}
	
	//계좌정보변경 창 띄우기용 메소드(forward confirmAccountPopup.jsp) --세령
	@RequestMapping("showConfirmAcc.me")
	public String showConfirmAccPopup() {
		return "member/confirmAccount";
	}
	
	//로그인용메소드--세령--세령
	@RequestMapping("login.me")
	public String loginCheck(@ModelAttribute Member m, Model model) {
		Member loginUser;
		try {
			loginUser = ms.loginMember(m);
			model.addAttribute("loginUser", loginUser);
			return "redirect:index.jsp";
		} catch (LoginException e) {
			model.addAttribute("msg", e.getMessage());
			return "common/errorPage";
		}
	}
	
	//로그아웃용메소드--세령--세령
	@RequestMapping("logout.me")
	public String logoutMember(SessionStatus status) {
		status.setComplete();
		return "redirect:index.jsp";
	}
	
	//회원가입용메소드--세령
	@RequestMapping("insert.me")
	public String insertMember(@ModelAttribute Member m, Model model) {
		//비밀번호 암호화
		String encPassword = passwordEncoder.encode(m.getPassword());
		m.setPassword(encPassword);
		
		int result = ms.insertMember(m);
		if(result > 0) {
			return "redirect:index.jsp";
		} else {
			model.addAttribute("msg", "회원가입 실패!");
			return "common/errorPage";
		}
	}
	
	//비밀번호수정용메소드--세령
	@RequestMapping("updateUserPwd.me")
	public String updateUserPwd(@RequestParam("oldPassword") String oldPassword, 
							  @RequestParam("newPassword") String newPassword,
							  HttpServletRequest request, SessionStatus status,
							  Model model) {
		Member loginUser = (Member) request.getSession().getAttribute("loginUser");
		
		try {
			int result = ms.updateUserPwd(loginUser, oldPassword, newPassword);
			status.setComplete();
			return "redirect:index.jsp";
		} catch (LoginException e) {
			model.addAttribute("msg", e.getMessage());
			return "common/errorPage";
		}
	}
	
	//계좌정보수정용메소드--세령
	@RequestMapping("updateUserAcc.me")
	public String updateUserAcc(@RequestParam("bankcode") String accCode, @RequestParam("accnum") String accNumber,
							  Model model, HttpServletRequest request) {
		Member loginUser = (Member) request.getSession().getAttribute("loginUser");
		loginUser.setAccCode(accCode);
		loginUser.setAccNumber(accNumber);
		int result = ms.updateUserAcc(loginUser);
		if(result > 0) {
			model.addAttribute("loginUser", loginUser);
			model.addAttribute("success", "success");
			return "member/confirmAccount";
		} else {
			model.addAttribute("msg", "계좌정보수정 실패!");
			return "common/erroPage";
		}
	}
	
	//회원정보수정용메소드--세령
	@RequestMapping("updateUserInfo.me")
	public String updateUserInfo(@ModelAttribute Member m, Model model, HttpServletRequest request) {
		int result = ms.updateUserInfo(m);
		if(result > 0) {
			//세션 정보 업데이트
			Member loginUser = (Member) request.getSession().getAttribute("loginUser");
			loginUser.setUserName(m.getUserName());
			loginUser.setEmail(m.getEmail());
			loginUser.setGender(m.getGender());
			loginUser.setBirthday(m.getBirthday());
			model.addAttribute("loginUser", loginUser);			
			return "member/updateMemberInfo";
		} else {
			model.addAttribute("msg", "회원정보수정 실패!");
			return "common/errorPage";
		}
	}
	
	//회원탈퇴용메소드--세령
	@RequestMapping("dropOutUser.me")
	public String dropOutUserInfo(HttpServletRequest request, SessionStatus status, Model model) {
		Member loginUser = (Member) request.getSession().getAttribute("loginUser");
		int result = ms.dropOutUserInfo(loginUser);
		if(result > 0) {
			status.setComplete();
			return "redirect:index.jsp";
		} else {
			model.addAttribute("msg", "회원탈퇴 실패!");
			return "common/errorPage";
		}
	}
	
	//회원조건조회용메소드--세령
	@RequestMapping(value = "/selectCondition.me")
	public String selectConditionMemberList(@RequestParam Map<String, String> map) {
		System.out.println("condition : " + map.get("condition"));
		System.out.println("conditionValue : " + map.get("condition"));
		return null;
	}
	
	//회원게시글내역화면전환용메소드--세령
	@RequestMapping("selectUserBoard.me")
	public String selectUserBoardList() {
		return null;
	}
	
	//회원신고내역화면전환용메소드--세령
	@RequestMapping("selectUserNotify.me")
	public String selectUserNotifyList() {
		return null;
	}
	
	//회원결제내역화면전환용메소드--세령
	@RequestMapping("selectUserPay.me")
	public String selectUserPayList() {
		return null;
	}
	
	//회원문의내역화면전환용메소드--세령
	@RequestMapping("selectUserInquiry.me")
	public String selectUserInquiryList() {
		return null;
	}
	
} //end class
