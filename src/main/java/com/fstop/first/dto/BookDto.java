package com.fstop.first.dto;

import com.fstop.first.entity.CategoryEntity;
import lombok.Data;

@Data
public class BookDto {
    private Integer id;
    private String bookName;
    private CategoryEntity category;
    private String introduction;

    public BookDto(Integer id, String bookName, CategoryEntity category, String introduction) {
        this.id = id;
        this.bookName = bookName;
        this.category = category;
        this.introduction = introduction;
    }
}
