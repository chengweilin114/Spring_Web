create table db.category
(
    ID         int auto_increment
        primary key,
    BOOK_CLASS varchar(50) not null
)
    charset = utf8;

create table db.book
(
    ID           int auto_increment
        primary key,
    BOOK_NAME    varchar(100) not null,
    CATEGORY_ID  int          not null,
    INTRODUCTION mediumtext   null,
    constraint book_category_id_fk
        foreign key (CATEGORY_ID) references db.category (ID)
)
    charset = utf8;

create table db.user
(
    ID       int auto_increment
        primary key,
    EMAIL    varchar(50) not null,
    PASSWORD varchar(50) not null
);

