package com.fstop.first.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fstop.first.dao.UserDao;
import lombok.Data;

@Data
@Service
public class UserService {
    @Autowired
    UserDao userDao;
    public Boolean user1 (String account, String password) {
        return userDao.existsByEmailAndPassword(account, password);
    }
}
