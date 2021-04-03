package com.macia.charitysystem;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

@SpringBootApplication
public class CharitysystemApplication implements CommandLineRunner {

	public static void main(String[] args)  throws SQLException {
		SpringApplication.run(CharitysystemApplication.class, args);


		//Connect to existing database
		String url = "jdbc:postgresql://localhost:5432/chari?user=postgres&password=123";
//		String url = "jdbc:postgresql://ec2-54-85-13-135.compute-1.amazonaws.com:5432/d1rovdsrk9r70l?user=ubkpsljlfyuuab&password=96ef0a841b72520b7695b69025a064a0ddfd4aab7715f5661b6da9874eb9643c";

		Connection conn = DriverManager.getConnection(url);
		//Creating the Statement
		Statement stmt = conn.createStatement();
		//Query to create a function
		String query = "CREATE OR REPLACE FUNCTION public.get_projects_dto(\n" +
				"\t)\n" +
				"    RETURNS TABLE(prj_id integer, project_code character varying, project_name character varying, brief_description character varying, description character varying, image_url character varying, video_url character varying, target_money integer, cur_money integer, num_of_donations integer, remaining_term integer, prt_id integer, project_type_name character varying, status text)\n" +
				"    LANGUAGE 'plpgsql'\n" +
				"\n" +
				"    COST 100\n" +
				"    VOLATILE\n" +
				"    ROWS 1000\n" +
				"\n" +
				"AS $BODY$\n" +
				"begin\n" +
				"\treturn query\n" +
				"\t\tselect \tpr.prj_id, pr.project_code, pr.project_name,pr.brief_description,\n" +
				"\t\t\t\tpr.description,pr.image_url,pr.video_url,pr.target_money,\n" +
				"\t\t\t\tsum(dd.money)::integer as cur_money,count(dd.dnd_id)::integer as num_of_donations,\n" +
				"\t\t\t\t(pr.end_date-DATE(now())) as remaining_term,pt.prt_id,pt.project_type_name,\n" +
				"\t\t\t\tcase\n" +
				"\t\t\t\t\twhen pr.end_date-DATE(now()) > 0 and sum(dd.money)::integer < pr.target_money then 'activating'\n" +
				"\t\t\t\t\twhen pr.end_date-DATE(now()) > 0 and sum(dd.money)::integer >= pr.target_money  then 'reached'\n" +
				"\t\t\t\t\twhen pr.end_date-DATE(now()) <= 0 then 'overdue'\n" +
				"\t\t\t\tend as status\n" +
				"\t\tfrom project pr, donate_activity da, donate_details dd,project_type pt\n" +
				"\t\twhere pr.prj_id=da.prj_id and da.dna_id=dd.dna_id and pr.prt_id=pt.prt_id\n" +
				"\t\tgroup by pr.prj_id,pt.prt_id,pt.project_type_name,pr.start_date\n" +
				"        order by pr.start_date desc ;\n" +
				"end;\n" +
				"$BODY$;";
		String query_add_donator="insert into donator(dnt_id,full_name,phone_number,address) values (-1,'Khách hảo tâm','N/A','N/A');";

		//Executing the query
		stmt.execute(query);
		stmt.execute(query_add_donator);
	}

	@Override
	public void run(String... args) throws Exception {
//		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//		String ps = passwordEncoder.encode("hoang123");
//		System.out.println(ps);
		System.out.println("Web API service is running!");
	}
}
