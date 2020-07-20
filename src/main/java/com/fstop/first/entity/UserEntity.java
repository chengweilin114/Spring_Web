package com.fstop.first.entity;

import lombok.Data;

import javax.persistence.*;

@Entity
@Table(name = "USER")
@Data
public class UserEntity {
    @Id
    @Column(name = "Id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "email")
    private String email;
    @Column(name = "password")
    private String password;

    public UserEntity() {
    }

    public UserEntity(Integer id, String email, String password) {
        this.id = id;
        this.email = email;
        this.password = password;
    }
}
