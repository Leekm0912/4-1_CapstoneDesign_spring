package kr.ac.yc.smartsw.controller;

import java.io.IOException;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import kr.ac.yc.smartsw.service.RESTService;
import kr.ac.yc.smartsw.service.RESTVO;

@Controller
public class RESTCallController {

	private static final Logger logger = LoggerFactory.getLogger(RESTCallController.class);
	
	@Autowired
	RESTService restService;
	
	@GetMapping({"/rest/{title}", "/rest"})
	public String test(Model model, @PathVariable Optional<String> title) {
		String url = "http://localhost:8000/test/";
		
		try {
			RESTVO restVO = restService.restGet(url + title.orElse("v0") + "/");
			model.addAttribute("csv_url", restVO.getCsv());
			logger.error("요청받음!");
			return "restTestPage";
		} catch (IOException e) {
			logger.debug("rest failed");
			e.printStackTrace();
			return "index";
		}
	}
	
}
