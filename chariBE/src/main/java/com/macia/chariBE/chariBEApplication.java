package com.macia.chariBE;

import com.macia.chariBE.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

@SpringBootApplication
public class chariBEApplication implements CommandLineRunner {

	@Autowired
	private ProjectService projectService;

	public static void main(String[] args)  throws SQLException {
		SpringApplication.run(chariBEApplication.class, args);


		String url = "jdbc:postgresql://localhost:5432/chari?user=postgres&password=123";
//		String url = "jdbc:postgresql://ec2-54-85-13-135.compute-1.amazonaws.com:5432/d1rovdsrk9r70l?user=ubkpsljlfyuuab&password=96ef0a841b72520b7695b69025a064a0ddfd4aab7715f5661b6da9874eb9643c";

		Connection conn = DriverManager.getConnection(url);
		Statement stmt = conn.createStatement();
		String query_add_donator="insert into donator(dnt_id,full_name,phone_number,address) values (0,'Nhà hảo tâm ẩn danh','','');";
		stmt.execute(query_add_donator);
	}


	@Override
	public void run(String... args) throws Exception {
//		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//		String ps = passwordEncoder.encode("hoang123");
//		System.out.println(ps);
		projectService.updateAllProjectStatus();
		System.out.println("Web API service is running!");
	}
}
