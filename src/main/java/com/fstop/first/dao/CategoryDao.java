package com.fstop.first.dao;

import com.fstop.first.entity.CategoryEntity;
import org.springframework.data.repository.CrudRepository;

public interface CategoryDao  extends CrudRepository<CategoryEntity, Integer> {

}
