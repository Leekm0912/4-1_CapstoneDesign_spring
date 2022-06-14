package kr.ac.yc.smartsw.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.ac.yc.smartsw.service.SocketService;

@Controller
//@RestController
@RequestMapping("/socket")
public class SocketController {
	
	@Autowired
	SocketService service;
	
	@GetMapping
	public String viewPage() {
		service.sendMsg("test");
		return "socket";
	}
}
