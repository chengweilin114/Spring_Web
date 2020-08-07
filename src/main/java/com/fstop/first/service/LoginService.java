package com.fstop.first.service;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fstop.first.dao.BookDao;
import com.fstop.first.entity.BookEntity;
import lombok.Data;
import model.User;
import javax.persistence.Entity;
import java.util.List;
import java.util.Optional;


@Data
@Service
public class LoginService {
    @Autowired
    BookDao bookDao;
    public List<BookEntity> book1(String bookName){
       return bookDao.findBookEntityByBookNameContains(bookName);
    }
    public List<BookEntity> book2(String bookName, int category){
        return bookDao.findBookEntityByBookNameContainsAndCategoryId(bookName, category);
    }
    public Optional<BookEntity> book3 (int id){
        return bookDao.findById(id);
    }

}
