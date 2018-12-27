package com.zerozrz.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.zerozrz.service.ReplyService;

@RequestMapping("/reply")
@Controller
public class ReplyController {

	@Autowired
	private ReplyService replyService;
	
}
