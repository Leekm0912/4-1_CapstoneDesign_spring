package kr.ac.yc.smartsw.controller;

import java.io.IOException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.yc.smartsw.service.RESTVO;
import kr.ac.yc.smartsw.service.SocketService;

@Controller
//@RestController
@RequestMapping("/socket")
public class SocketController {
	
	@Autowired
	SocketService service;
	
	@GetMapping("/{serverIP}/{msg}")
	@ResponseBody
	public String sendMsg(@PathVariable Optional<String> serverIP, @PathVariable Optional<String> msg) {
		SocketService.SERVER_IP = serverIP.orElse("localhost");
		service.sendMsg(msg.orElse("test"));
		return msg.orElse("test");
	}
}
