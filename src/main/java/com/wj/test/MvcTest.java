package com.wj.test;

import com.github.pagehelper.PageInfo;
import com.wj.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用spring单元测试功能，测试crud的正确性
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {

    MockMvc mockMvc;

    //引入springmvc的 Ioc容器
    @Autowired
    WebApplicationContext context;
    //虚拟MVC请求，获取到处理结果

    //模拟MVC请求发送
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        //模拟发送请求拿到返回值
        MvcResult mvcResult = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn","1")).andReturn();

        //请求成功以后，请求域中会有pageInfo，我们可以取出pageInfo进行验证
        MockHttpServletRequest req = mvcResult.getRequest();

        PageInfo pi = (PageInfo) req.getAttribute("pageInfo");

        System.out.println("当前页码" + pi.getPageNum());
        System.out.println("总页码" + pi.getPages());
        System.out.println("总记录数" + pi.getTotal());
        System.out.println("在页面要显示的连续页码");
        int [] nums = pi.getNavigatepageNums();
        for (int i : nums) {
            System.out.print(i);
        }

        //获取员工信息
        List<Employee> list = pi.getList();
        for (Employee employee : list) {
            System.out.print("ID:"+employee.getEmpId() + "==>NAME:" + employee.getEmpName());
        }

    }
}
