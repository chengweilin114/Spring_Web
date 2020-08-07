package com.fstop.first.controller;


import com.fstop.first.dao.BookDao;
import com.fstop.first.dao.CategoryDao;
import com.fstop.first.dao.UserDao;
import com.fstop.first.entity.BookEntity;
import com.fstop.first.entity.CategoryEntity;
import com.fstop.first.service.CategoryService;
import com.fstop.first.service.LoginService;
import com.fstop.first.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class HelloController {
    private static final String SELECT = "select";
    @Autowired
    private UserService userService;
    @Autowired
    private UserDao userDao;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private CategoryDao categoryDao;
    @Autowired
    private BookDao bookDao;
    @Autowired
    private  LoginService loginService;

    @GetMapping("/login")
    public String index() {
        return "index";
    }

    @PostMapping("/login")
    public ModelAndView login(@RequestParam(value = "account") String account, @RequestParam(value = "password") String password, HttpServletRequest request) {
        Boolean isExists = userDao.existsByEmailAndPassword(account, password);
        if (Boolean.TRUE.equals(isExists)) {
            HttpSession session = request.getSession();
            session.setAttribute("userName", account);
            userService.user1(account,password);
            return new ModelAndView("redirect:/select");
        }
        return new ModelAndView("index", "resp", "登入失敗");
    }

    @RequestMapping("/edit")
    public ModelAndView edit(@RequestParam int id) {
        Optional<BookEntity> data;
        data = bookDao.findById(id);
        ModelAndView model = new ModelAndView("edit");
        data.ifPresent(bookEntity -> model.addObject("resp", bookEntity));
        model.addObject("id", id);
        return model;
    }

    @PostMapping("/change")
    @ResponseBody
    public String change(@RequestParam int id, @RequestParam String bookName, @RequestParam String introduction, @RequestParam int categoryId) {
        Optional<BookEntity> data;
        data = bookDao.findById(id);
        if (data.isPresent()) {
            BookEntity book = data.get();
            book.setBookName(bookName);
            book.setIntroduction(introduction);
            if (categoryId != 0) {
                Optional<CategoryEntity> categoryEntity = categoryDao.findById(categoryId);
                categoryEntity.ifPresent(book::setCategory);

            }
            loginService.book3(id);
            categoryService.category1(id);
        }

        return "Success";
    }

    @PostMapping("/select")
    public ModelAndView select(@RequestParam(value = "bookName") String bookName, @RequestParam(value = "category") int category) {
        if (category == 0) {
            return new ModelAndView(SELECT,
                    "resp",
                    loginService.book1(bookName));
        }
        return new ModelAndView(SELECT,
                "resp",
                loginService.book2(bookName, category));
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int id) {
        bookDao.deleteById(id);
        return "Success";
    }

    @PostMapping("/insert")
    @ResponseBody
    public BookEntity insert(@RequestParam String bookName, @RequestParam String introduction, @RequestParam int categoryId) {
        BookEntity bookEntity = new BookEntity();
        bookEntity.setBookName(bookName);
        bookEntity.setIntroduction(introduction);
        Optional<CategoryEntity> categoryEntity = categoryDao.findById(categoryId);
        categoryEntity.ifPresent(bookEntity::setCategory);
        return bookDao.save(bookEntity);

    }

    @GetMapping("logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/select")
    public ModelAndView show() {

        return new ModelAndView(SELECT,
                "resp",
                bookDao.findAll());
    }


}
