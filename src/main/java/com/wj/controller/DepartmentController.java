package com.wj.controller;

import com.wj.bean.Department;
import com.wj.bean.Msg;
import com.wj.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门有关的所有请求
 */
@Controller
public class DepartmentController {

    @Autowired
    public DepartmentService departmentService;

    /**
     * 查出所有的部门信息
     * @return
     */
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){
        List<Department> list = departmentService.getDepts();
        return Msg.success().add("depts",list);
    }
}
