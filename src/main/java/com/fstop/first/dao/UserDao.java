package com.fstop.first.dao;

import com.fstop.first.entity.UserEntity;
import org.springframework.data.repository.CrudRepository;

public interface UserDao extends CrudRepository<UserEntity, Integer> {
    Boolean existsByEmailAndPassword(String email, String password);

}
