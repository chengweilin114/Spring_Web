<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!--输出,条件,迭代标签库-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="fmt" %>
<!--数据格式化标签库-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="sql" %>
<!--数据库相关标签库-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="fn" %>
<!--常用函数标签库-->
<%@ page isELIgnored="false" %>
<!--支持EL表达式，不设的话，EL表达式不会解析-->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>select</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
          integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">

    <script src="https://code.jquery.com/jquery-3.5.1.js"
            integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"
            integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI"
            crossorigin="anonymous"></script>
    <script>
        $(document).ready(function () {
            const category = ['不顯示', '商業理財', '電腦資訊', '文學小說', '社會科學']
            console.log("started");

            function init() {
                $.each($(".btn-success"), function (index, item) {
                    item.onclick = function () {
                        let tr = $($("tr")[index + 1]);
                        console.log(tr);
                        let bookName = tr.find(".bookName").html();
                        let categoryId = tr.find(".nowrap").attr('categoryId')
                        console.log("fixed");
                        $("#changeBookName").val(bookName);
                        $("#editCategoryType").val(categoryId);
                        $("#id").val(tr.find(".bookId").val())
                        $(".send").attr('changeId',index +1)
                    }
                })
                $.each($(".send"), function (index, item) {
                    console.log(item);
                    item.onclick = function () {
                        let changeBookName = $("#changeBookName").val();
                        let changeIntroduction = $(".modal-body")[index + 1].value;
                        let changeCategoryId = $('#editCategoryType').val()
                        console.log(changeCategoryId);
                        $.ajax(
                            {
                                type: 'POST',
                                url: '/change',
                                data: {
                                    bookName: changeBookName,
                                    introduction: changeIntroduction,
                                    id: $("#id").val(),
                                    categoryId: changeCategoryId
                                },
                                success: function (msg) {
                                    let tr = $($("tr")[$(item).attr('changeId')]);
                                    console.log($(item).attr('changeId'))
                                    tr.find('.bookName').html(changeBookName)
                                    tr.find(".categoryId").html(category[changeCategoryId]);
                                    tr.find(".categoryId").attr('categoryId',changeCategoryId);
                                    console.log(msg);

                                }
                            }
                        );
                    }

                })
                $.each($(".btn-delete"), function (index, item) {

                    item.onclick = function () {
                        let tr = $($("tr")[index + 1]);
                        $(".delete").attr("del-id", tr.find(".bookId").val());
                        $("#exampleModalLabel").html("確認要刪除『" + tr.find(".bookName").html() + "』嗎")
                    }
                })
                $.each($(".delete"), function (index, item) {
                    console.log(item);
                    item.onclick = function () {
                        let delId = $(item).attr("del-id")
                        $.ajax(
                            {
                                type: 'POST',
                                url: '/delete',
                                data: {
                                    id: delId
                                },
                                success: function (msg) {
                                    console.log(msg);
                                    $("#tr" + delId).remove();
                                    $(".modal-backdrop").remove()
                                }
                            }
                        );
                    }

                })
            }

            init();
            $('#sendInsert').on('click', function () {
                let bookName = $('#insertBookName').val()
                if (bookName !== "") {
                    $.ajax(
                        {
                            type: 'POST',
                            url: '/insert',
                            data: {
                                bookName: bookName,
                                introduction: $("#insertIntroduction").html(),
                                categoryId: $('#insertCategoryType').val()
                            },
                            success: function (msg) {
                                console.log(msg)
                                $("#mtable").find("tr:last").after(
                                    "                        <tr id=\"tr" + msg['id'] + "\">\n" +
                                    "                        <input type=\"hidden\" class=\"bookId\" value='" + msg['id'] + "'>\n" +
                                    "                        <td class=\"bookName\">" + msg['bookName'] + "</td>\n" +
                                    "                        <td class=\"categoryId nowrap\"\n" +
                                    "                            categoryId=\"" + msg['category']['id'] + "\">" + msg['category']['bookClass'] + "</td>\n" +
                                    "                        <td class=\"nowrap\">\n" +
                                    "                            <button type=\"button\" class=\"btn btn-success \" data-toggle=\"modal\"\n" +
                                    "                                    data-target=\"#exampleModalCenter\">編輯\n" +
                                    "                            </button>\n" +
                                    "                        </td>\n" +
                                    "                        <td class=\"nowrap\">\n" +
                                    "                            <!-- Button trigger modal -->\n" +
                                    "                            <button type=\"button\" class=\"btn btn-danger btn-delete\" data-toggle=\"modal\"\n" +
                                    "                                    data-target=\"#remove\">\n" +
                                    "                                刪除\n" +
                                    "                            </button>\n" +
                                    "                        </td>\n" +
                                    "                    </tr>");
                                init();
                            }
                        }
                    );
                } else {
                    alert("書名不可為空");
                }
            });


        });
    </script>
    <style type="text/css">
        .category {
            height: 32px;
            width: 182px;
        }

        .categoryId {

        }

        .bookId {

        }

        .bookName {

        }

        .edit-select {
            height: 36px;
        }

        .edit-type {
            margin-left: 10px;
        }

        #my-table-box {
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: scroll;
            /*margin-top: 30px;*/
        }

        #form {
            display: flex;
            align-items: center;
            flex: 1;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        #mtable {
            align-items: center;
            overflow: scroll;
            /*table-layout: fixed;*/
        }


        .searchBtn {
            margin-left: 10px;
            width: 32px;
            height: 32px;
            background-image: url("https://img.icons8.com/pastel-glyph/64/000000/search--v2.png");
            background-size: contain;
            background-repeat: no-repeat;
        }

        .modal-dialog.customer-modal-dialog {
            max-width: 800px;
        }

        .customer-modal-height {
            height: 500px;
        }

        .send {

        }

        ::-webkit-scrollbar {
            display: none
        }

        .main {
            max-width: 100vw;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        body {
            display: flex;
            justify-content: center;
            flex-direction: column;
        }

        .header-box {
            display: flex;
            flex-direction: row;
            align-items: center;
        }

        .my-title {
            margin-left: 20px;
            justify-content: flex-start;
            flex: 1;
            font-weight: bold;
        }

        .delete {

        }

        .nowrap {
            white-space: nowrap
        }

        .insert {
            margin-right: 20px;
        }

        .changeBookName {

        }

        .btn-delete {

        }

        .in-box {
            width: 80vw;
        }
        .title-box{
            display: flex;
            background: rgba(255, 190, 190, 0.55);
            justify-content: center;
            align-items: center;
        }
        .logout{
            margin-right: 20px;
        }
    </style>
</head>
<body>
<div class="title-box">
    <div class="my-title"><h1>書籍管理</h1></div>
    <div><button class="btn btn-outline-info logout"><a href="/logout">logout</a></button></div>
</div>
<div class="main">
    <div class="in-box">
        <div class="header-box">

            <form action="/select" id="form" method="post" class="select ">
                <div style="display: flex; flex-direction: column">
                    <div>
                        書名 <input type="search" name="bookName">
                    </div>
                    <div>
                        類型 <select name="category" class="category">
                        <option value="0">請選擇</option>

                        <option value="1">商業理財</option>
                        　
                        <option value="2">電腦資訊</option>
                        　
                        <option value="3">文學小說</option>
                        　
                        <option value="4">社會科學</option>

                    </select>

                    </div>
                </div>
                <input type="submit" value="" class="searchBtn btn btn-light ">
            </form>
            <div class="insert">
                <button class="btn btn-primary" id="insert" data-toggle="modal" data-target="#insertModalCenter">新增
                </button>
            </div>
            <!-- Modal -->
            <div class="modal fade " id="insertModalCenter" tabindex="-1" role="dialog"
                 aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                <div class="modal-dialog  customer-modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content customer-modal-height">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editBookName">
                                書名: <input id="insertBookName" value=""></h5>
                            <h5 class="modal-title edit-type">
                                類型:
                                <select class="edit-select" name="category" id="insertCategoryType">

                                    <option value="1">商業理財</option>
                                    　
                                    <option value="2">電腦資訊</option>
                                    　
                                    <option value="3">文學小說</option>
                                    　
                                    <option value="4">社會科學</option>

                                </select>
                            </h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <textarea class="modal-body" id="insertIntroduction"></textarea>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">關閉
                            </button>
                            <button type="button" class="btn btn-primary " data-dismiss="modal" id="sendInsert">
                                送出
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="my-table-box">

            <jsp:useBean id="resp" scope="request" type="java.util.ArrayList<com.fstop.first.entity.BookEntity>"/>
            <c:if test="${resp.size() != 0}">
                <table class="table .table-responsive" id="mtable">
                    <thead class="thead-dark thead-test">
                    <tr>
<%--                        <th>ID</th>--%>
                        <th>書名</th>
                        <th>類型</th>
                        <th>編輯</th>
                        <th>刪除</th>
                    </tr>
                    </thead>
                    <c:forEach var="i" begin="0" end="${ resp.size() -1 }" varStatus="loop">
                        <tr id="tr${resp.get(i).id}">
<%--                            <th class="bookId" scope="row">${resp.get(i).id}</th>--%>
                            <input type="hidden" class="bookId" value="${resp.get(i).id}">
                            <td class="bookName">${resp.get(i).bookName}</td>
                            <td class="categoryId nowrap"
                                categoryId="${resp.get(i).category.id}">${resp.get(i).category.bookClass}</td>
                            <td class="nowrap">
                                <button type="button" class="btn btn-success " data-toggle="modal"
                                        data-target="#exampleModalCenter">編輯
                                </button>
                            </td>
                            <td class="nowrap">
                                <!-- Button trigger modal -->
                                <button type="button" class="btn btn-danger btn-delete" data-toggle="modal"
                                        data-target="#remove">
                                    刪除
                                </button>
                            </td>
                        </tr>

                    </c:forEach>

                </table>
                <!-- update Modal -->
                <div class="modal fade " id="exampleModalCenter" tabindex="-1" role="dialog"
                     aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                    <div class="modal-dialog  customer-modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content customer-modal-height">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    書名: <input id="changeBookName"></h5>
                                <h5 class="modal-title edit-type">
                                    類型:
                                    <select class="edit-select" name="category" id="editCategoryType">

                                        <option value="1">商業理財</option>
                                        　
                                        <option value="2">電腦資訊</option>
                                        　
                                        <option value="3">文學小說</option>
                                        　
                                        <option value="4">社會科學</option>

                                    </select>
                                </h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <textarea class="modal-body"><%-- TODO 未填值 --%></textarea>
                            <input type="hidden" id="id">
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">關閉
                                </button>
                                <button type="button" class="btn btn-primary send" data-dismiss="modal" changeId="">儲存
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- delete Modal -->
                <div class="modal fade" id="remove" tabindex="-1" role="dialog"
                     aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">
                                    確認要刪除『』嗎</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">否
                                </button>
                                <button type="button" class="btn btn-danger delete" data-dismiss="modal"
                                        del-id="">是
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${resp.size() == 0}">
                <div>查無資料</div>
            </c:if>
        </div>
    </div>
</div>
</body>


</html>