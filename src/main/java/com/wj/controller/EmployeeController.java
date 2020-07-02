package com.wj.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wj.bean.Employee;
import com.wj.bean.Msg;
import com.wj.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工的CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 检查用户名是否可用
     */
    @ResponseBody
    @RequestMapping("/checkUser")
    public Msg checkUser(@RequestParam("empName") String empName){
        //先检验用户名是否满足要求
        String regx = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名错误，请输入2-5位中文！");
        }
        boolean b = employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else{
            return Msg.fail().add("va_msg","用户名已存在");
        }
    }

    /**
     * 保存员工数据
     *
     * 关于URI
     * /emp/{id}  GET    查询员工数据
     * /emp/      POST   保存员工数据
     * /emp/{id}  PUT    修改员工数据
     * /emp/{id}  DELETE   删除员工数据
     */
    /**
     * 使用JSR303校验用户名和邮箱
     * 1、引入hibernate-validator依赖
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            Map<String,Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError: errors) {
                System.out.println("错误字段名："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else{
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 查询员工数据（pageHelper分页查询）
     * @return
     */
    /**
     * 使用ajax、json,适用于各种平台，浏览器、安卓、ios
    * 1、index.jsp页面直接发送ajax请求进行员工数据的分页查询
    * 2、服务器将查询出的数据，以json字符串的形式返回给浏览器
    * 3、浏览器接收到js字符串。可以使用js对json进行解析，使用js通过dom增删改改变页面。
    * 4、返回json。实现客户端的无关性。
    *
    * springMVC的@ResponseBody 可以将对象转换成json字符串
    * 要使@ResponseBody正常工作，需要导入jackson包。
    */
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //引入pageHelper插件实现分页查询
        //在查询之前只需调用，传入页码以及每页的数据量
        PageHelper.startPage(pn,3);
        //startPage后面紧跟的这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        //使用PageInfo包装查询后的结果，只需要将PageInfo交给页面就行了
        //封装了详细的分页信息，包括查询出来的数据
        PageInfo page = new PageInfo(emps,5);

        return Msg.success().add("pageInfo",page);
    }

    /**
     * 按照员工ID查询员工数据（编辑模态框）
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id")Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    /**
     * 如果直接发送ajax=PUT形式的请求
     * 封装的数据
     * Employee
     * [empId=20, empName=null, gender=null, email=null, dId=null]
     *
     * 问题：
     * 请求体中有数据；
     * 但是Employee对象封装不上；
     * update tbl_emp  where emp_id = 20;
     *
     * 原因：
     * Tomcat：
     * 		1、将请求体中的数据，封装一个map。
     * 		2、request.getParameter("empName")就会从这个map中取值。
     * 		3、SpringMVC封装POJO对象的时候。
     * 				会把POJO中每个属性的值，request.getParamter("email");
     * AJAX发送PUT请求引发的血案：
     * 		PUT请求，请求体中的数据，request.getParameter("empName")拿不到
     * 		Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
     * org.apache.catalina.connector.Request--parseParameters() (3111);
     *
     * protected String parseBodyMethods = "POST";
     * if( !getConnector().isParseBodyMethod(getMethod()) ) {
             success = true;
             return;
         }
     *
     * 解决方案；
     * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
     * 1、配置上HttpPutFormContentFilter；
     * 2、他的作用；将请求体中的数据解析包装成一个map。
     * 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
     *
     * 更新员工数据
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println("请求体中的值："+request.getParameter("gender"));
        System.out.println("将要更新的员工数据："+employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 删除单个员工数据+批量删除员工数据
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids")String ids){

        if(ids.contains("-")){
            //批量删除员工数据
            List<Integer> del_ids = new ArrayList<>();
            String[] str_id = ids.split("-");
            for (String string:str_id){
                del_ids.add(Integer.parseInt(string));
            }
            employeeService.deleteBatch(del_ids);
        }else{
            //单个删除员工数据
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }

    /**
     * 下面这种未使用ajax和json的查询方式只适用于浏览器-服务器模式
     * 1、访问index.jsp页面
     * 2、index.jsp页面发送查询员工列表请求
     * 3、EmployeeController来接收请求，查出员工数据
     * 4、来到list.jsp页面进行展示
     * 5、pageHelper分页插件完成分页查询
     */
    /*@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){
        //引入pageHelper插件实现分页查询
        //在查询之前只需调用，传入页码以及每页的数据量
        PageHelper.startPage(pn,3);
        //startPage后面紧跟的这个查询就是分页查询
        List<Employee> emps=employeeService.getAll();
        //使用PageInfo包装查询后的结果，只需要将PageInfo交给页面就行了
        //封装了详细的分页信息，包括查询出来的数据
        PageInfo page = new PageInfo(emps,3);
        model.addAttribute("pageInfo",page);

        return "list";
    }*/

}
