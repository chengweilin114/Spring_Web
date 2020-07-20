package com.fstop.first.entity;

import lombok.Data;

import javax.persistence.*;

@Entity
@Data
@Table(name = "BOOK")
public class BookEntity {
    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "BOOK_NAME")
    private String bookName;

    @JoinColumn(name = "CATEGORY_ID", referencedColumnName = "ID")
    @ManyToOne(fetch = FetchType.LAZY)
    private CategoryEntity category;
    @Column(name = "INTRODUCTION")
    private String introduction;

    public BookEntity() {

    }


}
