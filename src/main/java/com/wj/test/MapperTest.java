package com.wj.test;

import com.wj.bean.Department;
import com.wj.bean.Employee;
import com.wj.bean.EmployeeExample;
import com.wj.dao.DepartmentMapper;
import com.wj.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * 推荐spring的项目使用spring的单元测试，可以自动注入我们需要的组件
 * 1、pom.xml中导入springTest模块
 * 2、@ContextConfiguration指定spring配置文件的位置
 * 3、直接Autowired要使用的组件即可
 * */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = ("classpath:applicationContext.xml"))
public class MapperTest {

    /**
     * 测试DepartmentMapper
     * */
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD(){
        System.out.println(departmentMapper);

        /*//1、插入几个部门
        departmentMapper.insertSelective(new Department(1,"开发部"));
        departmentMapper.insertSelective(new Department(2,"测试部"));
        departmentMapper.insertSelective(new Department(3,"人力资源部"));

        //2、生成员工数据，测试插入员工信息
        employeeMapper.insertSelective(new Employee(0000,"张三","男","zhangsan@qq.com",1));
*/
        //3、批量插入多个员工信息，使用可以批量执行操作的sqlSession
        /*for(){
            employeeMapper.insertSelective(new Employee(0000,"张三","男","zhangsan@qq.com",1));
        }*/
        EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
        for (int i=0;i<10;i++){
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null,uid,"M",uid + "@qq.com",2));
        }
        System.out.println("批量插入成功");

        /*//4、删除一条员工数据
        employeeMapper.deleteByPrimaryKey(13);*/

        /*//5、查询一个员工信息带部门信息
        Employee employee=employeeMapper.selectByPrimaryKeyWithDept(1);
        System.out.println(employee);*/

        //6、修改某条员工数据
        /*employeeMapper.updateByPrimaryKey(new Employee(2,"李四","男","lisi@163.cn",3));*/


    }
}
