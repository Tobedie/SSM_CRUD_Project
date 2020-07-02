<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2020/6/19
  Time: 10:30
  To change this template use File | Settings | File Templates.
--%>

<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>员工列表页面</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>

    <link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<%--修改员工信息弹出模态框--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改员工信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_update_input" placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="deptName_update_select">
                                <%----%>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal 新增员工信息弹出框-->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">新增员工信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="deptName_add_select">
                                <%----%>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--使用bootstrap编写页面显示信息--%>
<div class="container">
    <%--标题信息--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_model_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_all_btn">删除</button>
        </div>
    </div>
    <%--数据显示--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <th>
                        <input type="checkbox" id="check_all">
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </thead>
                <tbody>
                    <%----%>
                </tbody>
            </table>

        </div>
    </div>
    <%--分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_area">
            <%----%>
        </div>
        <%--分页条--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<script type="text/javascript">

    //定义一个全局变量，用于跳转到最后一页数据
    var totalRecord,currentRecord;

    //页面加载完成之后，直接发送ajax请求，要到分页数据
    $(function () {
        to_page(1);
    });

    //跳转到页面
    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn="+pn,
            type: "GET",
            success: function(result){
                console.log(result);
                //1、解析并显示员工信息数据
                build_emps_table(result);
                //2、解析并显示分页信息
                build_page_info(result);
                //3、解析显示分页条
                build_page_nav(result);
            }
        });
    };

    //创建显示员工数据内容
    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function(index,item){
            //将获取的员工信息添加到页面
            var checkBoxTd = $("<td></td>").append($("<input type='checkbox' class='check_item'/>"));
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == "M"?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            //将编辑按钮和删除按钮添加到页面
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                .append("编辑");
            //为编辑按钮添加一个自定义的属性，表示当前员工的ID
            editBtn.attr("edit-id",item.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            //为编辑按钮添加一个自定义的属性，表示当前删除员工的ID
            delBtn.attr("del-id",item.empId);
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    };

    //解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前第"+result.extend.pageInfo.pageNum+"页，共"+
            result.extend.pageInfo.pages+"页，共"+
            result.extend.pageInfo.total+"条记录");
        totalRecord = result.extend.pageInfo.total;
        currentRecord = result.extend.pageInfo.pageNum;
    };

    //解析显示分页条
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<li></li>").addClass("pagination");
        var firstPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append("首页"));
        var previousPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append("&laquo;"));
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            previousPageLi.addClass("disabled");
        }else{
            firstPageLi.click(function(){
                to_page(1);
            });
            previousPageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum-1);
            });
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append("尾页"));
        if (result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum+1);
            });
            lastPageLi.click(function(){
                to_page(result.extend.pageInfo.pages);
            });
        }

        //添加首页和上一页
        ul.append(firstPageLi).append(previousPageLi);
        //添加页码
        $.each(result.extend.pageInfo.navigatepageNums,function(index,item){
            var numLi = $("<li></li>").append($("<a></a>").attr("href","#").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        })
        //添加下一页和尾页
        ul.append(nextPageLi).append(lastPageLi);

        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");

    };

    //点击新增按钮弹出模态框
    $("#emp_add_model_btn").click(function(){
        //清除表单数据（表单重置,包括表单的数据、表单的样式等）
        reset_form("#empAddModal form");

        //发送ajax请求，获取所有部门信息
        getDepts("#deptName_add_select");

        //弹出模态框
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    //清空表单样式及内容
    function reset_form(ele){
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    };

    //获取部门信息
    function getDepts(ele){
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type:"GET",
            success:function(result){
                /*{"code":100,"msg":"操作成功！","extend":{"depts":[{"deptId":1,"deptName":"开发部"},
                {"deptId":2,"deptName":"测试部"},{"deptId":3,"deptName":"人力资源部"}]}}*/
                /*console.log(result);*/

                $.each(result.extend.depts,function(){
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo(ele);
                });
            }
        });
    };

    //校验表单数据
    function validate_add_form(){
        //校验用户名
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)){
            //alert("用户名错误，请输入2-5位中文或3-16位英文和数字！");
            show_validate_msg("#empName_add_input","error","用户名错误，请输入2-5位中文或3-16位英文和数字！");
            /*$("#empName_add_input").parent().addClass("has-error has-feedback");
            $("#empName_add_input").next("span").text("用户名错误，请输入2-5位中文或3-16位英文和数字！");*/
            return false;
        }else{
            show_validate_msg("#empName_add_input","success","");
            $/*("#empName_add_input").parent().addClass("has-success has-feedback");
            $("#empName_add_input").next("span").text("");*/
        }
        //校验邮箱
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            //alert("邮箱错误，请输入正确的邮箱格式！");
            show_validate_msg("#email_add_input","error","邮箱错误，请输入正确的邮箱格式！");
            return false;
        }else{
            show_validate_msg("#email_add_input","success","");
        }
        return true;
    };

    //封装校验状态
    function show_validate_msg(ele,status,msg){
        //清除元素当前的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");

        if ("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text("");

        }else if ("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //校验用户名是否重复
    $("#empName_add_input").change(function(){
        var empName = this.value;
        //发送ajax请求校验用户名是否可用
        $.ajax({
            url:"${APP_PATH}/checkUser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if (result.code == 100){
                    show_validate_msg("#empName_add_input","success","");
                    $("#emp_save_btn").attr("ajax-va","success");
                }else{
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    });

    /*模态框中点击保存按钮保存员工数据*/
    $("#emp_save_btn").click(function(){
       //1、模态框中填写的员工数据提交给服务器进行保存
       //1、先对表单提交给服务器的数据进行校验
       if(!validate_add_form()){
           return false;
       }
       //2、判断之前的用户名校验是否成功，如果成功则继续往下走。
        if ($(this).attr("ajax-va") == "error"){
            return false;
        }
       //3、发送ajax请求保存员工数据
       /*serialize()将表单数据序列化*/
       console.log($("#empAddModal form").serialize());
       $.ajax({
           url:"${APP_PATH}/emp",
           type:"POST",
           data:$("#empAddModal form").serialize(),
           success:function(result){
               //请求成功之后，判断请求
               if(result.code == 100){
                   //员工数据保存成功之后，
                   // 1、关闭模态框
                   $("#empAddModal").modal('hide');
                   //2、显示刚刚保存成功的数据
                   to_page(totalRecord);
               }else {
                   //显示失败信息
                   if(undefined != result.extend.errorFields.empName){
                       show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                   }
                   if(undefined != result.extend.errorFields.email){
                       show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                   }

               }

           }
       })
    });

    /*使用.click绑事件，是在按钮创建之前就绑定的，因此绑不上click,解决办法有两种：
    * 1、在创建按钮的同时就绑定事件
    * 2、使用.live()来绑定事件（jQuery新版没有.live()，使用.on()来代替）
    * */
    $(document).on("click",".edit_btn",function(){
       //下拉框获取所有部门信息
       getDepts("#empUpdateModal select");
       //根据id获取员工信息
       getEmp($(this).attr("edit-id"));
       //把员工的id传递给更新按钮
       $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
       //弹出模态框
       $("#empUpdateModal").modal({
           backdrop:"static"
       });
   });

    //查询员工信息  empName_update_input
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"GET",
            success:function(result){
                //console.log(result);
                var empDate = result.extend.emp;
                $("#empName_update_static").text(empDate.empName);
                $("#email_update_input").val(empDate.email);
                $("#empUpdateModal input[name='gender']").val([empDate.gender]);
                $("#empUpdateModal select").val([empDate.dId]);
            }
        })
    };

    //更新按钮绑定单击事件
    $("#emp_update_btn").click(function(){
        //校验邮箱格式是否正确
        //1、校验邮箱格式
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            //alert("邮箱错误，请输入正确的邮箱格式！");
            show_validate_msg("#email_update_input","error","邮箱错误，请输入正确的邮箱格式！");
            return false;
        }else{
            show_validate_msg("#email_update_input","success","");
        }
        //2、发送ajax请求更新员工数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            type:"PUT",
            data:$("#empUpdateModal form").serialize(),
            /*type:"POST",
            data:$("#empUpdateModal form").serialize()+"&_method=PUT",*/
            success:function(result){
                //alert(result.msg);
                //1、关闭模态框
                $("#empUpdateModal").modal("hide");
                //2、转到当前页
                to_page(currentRecord);
            }
        })

    });

    //删除单个员工数据
    $(document).on("click",".delete_btn",function(){
        //弹出是否确认对话框
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        if(confirm("确认删除【"+empName+"】员工数据？")){
            //发送ajax请求删除数据
            $.ajax({
                url:"${APP_PATH}/emp/"+$(this).attr("del-id"),
                type:"DELETE",
                success:function(result){
                    alert(result.msg);
                    //回到本页
                    to_page(currentRecord);
                }
            });
        };
    });

    //完成全选/全不选功能
    $("#check_all").click(function(){
        //attr获取checked是undefined;
        //我们这些dom原生的属性；attr获取自定义属性的值；
        //prop修改和读取dom原生属性的值
        $(".check_item").prop("checked",$(this).prop("checked"));
    });

    //check_item
    $(document).on("click",".check_item",function(){
        //判断当前选择中的元素是否3个，若是，则全选
        var flag = $(".check_item:checked").length==$(".check_item").length;
        $("#check_all").prop("checked",flag);
    });

    //点击全部删除按钮，实现批量删除功能
    $("#emp_del_all_btn").click(function(){
        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"),function(){
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        //删除最后一个”，“
        empNames = empNames.substring(0,empNames.length-1);
        //删除最后一个“-”
        del_idstr = del_idstr.substring(0,del_idstr.length-1);
        if(confirm("确认删除【"+empNames+"】员工数据？")){
            $.ajax({
               url:"${APP_PATH}/emp/"+del_idstr,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    //回到当前页面
                    to_page(currentRecord);
                }
            });
        }
    });

    //点击全部删除，就批量删除
    /*$("#emp_del_all_btn").click(function(){
        //
        var empNames = "";
        $.each($(".check_item:checked"),function(){
            //this
            empNames += $(this).parents("tr").find("td:eq(2)").text()+",";

        });
        //去除empNames多余的,
        empNames = empNames.substring(0, empNames.length-1);
        //去除删除的id多余的-

        if(confirm("确认删除【"+empNames+"】吗？")){
            //发送ajax请求删除
           /!* $.ajax({
                url:"${APP_PATH}/emp/"+del_idstr,
                type:"DELETE",
                success:function(result){
                    alert(result.msg);
                    //回到当前页面
                    to_page(currentPage);
                }
            });*!/
        }
    });*/
</script>
</body>
</html>

