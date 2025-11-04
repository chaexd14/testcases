package com.example.testcase.auth;

import com.example.testcase.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/")
    public String showLoginPage() {
        return "index";
    }

    @PostMapping("/signin")
    public String signin(@RequestParam String username,
                         @RequestParam String password,
                         HttpSession session,
                         Model model) {

        boolean isValid = userService.validateCredentials(username, password);

        if (isValid) {
            session.setAttribute("username", username);
            return "redirect:/dashboard";
        } else {
            model.addAttribute("errorMessage", "Invalid username or password!");
            return "index";
        }
    }

    @GetMapping("/signout/new")
    public String signout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
