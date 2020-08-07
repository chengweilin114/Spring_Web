package com.fstop.first.service;
import com.fstop.first.dao.BookDao;
import com.fstop.first.entity.BookEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fstop.first.dao.CategoryDao;
import com.fstop.first.entity.CategoryEntity;
import lombok.Data;

import java.util.List;
import java.util.Optional;

@Data
@Service
public class CategoryService {
    @Autowired
    CategoryDao categoryDao;
    public Optional<CategoryEntity> category1 (int id) {
        return categoryDao.findById(id);
    }
}
