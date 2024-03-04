package kr.or.ddit.modul;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/pdf")
@Slf4j
public class pdfDownloadTest {
	
	@RequestMapping(value = "/pdfDownload", method = RequestMethod.GET)
	public String pdfDownload(Model model) {
		log.info("pdfDownload() 실행..!");
		
		return "pdf/pdfDownload";
	}
	@RequestMapping(value = "/pdfMain", method = RequestMethod.GET)
	public String pdfMain(Model model) {
		log.info("pdfMain() 실행..!");
		
		return "pdf/pdfMain";
	}
	
	
}