package com.fstop.first.dao;

import com.fstop.first.entity.BookEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface BookDao extends CrudRepository<BookEntity, Integer> {
    List<BookEntity> findBookEntityByBookNameContains(String bookName);
    List<BookEntity> findBookEntityByBookNameContainsAndCategoryId(String bookName, int categoryId);
}


