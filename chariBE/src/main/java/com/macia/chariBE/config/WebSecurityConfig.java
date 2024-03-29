package com.macia.chariBE.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.bind.annotation.GetMapping;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	@Autowired
	private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
	@Autowired
	private UserDetailsService jwtUserDetailsService;
	@Autowired
	private JwtRequestFilter jwtRequestFilter;
	@Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		// configure AuthenticationManager so that it knows from where to load
		// user for matching credentials
		// Use BCryptPasswordEncoder
		auth.userDetailsService(jwtUserDetailsService).passwordEncoder(passwordEncoder());
	}
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	@Bean
	@Override
	public AuthenticationManager authenticationManagerBean() throws Exception {
		return super.authenticationManagerBean();
	}
	@Override
	protected void configure(HttpSecurity httpSecurity) throws Exception {
		httpSecurity.cors();
		httpSecurity.csrf().disable()
				// dont authenticate this particular request
				.authorizeRequests().antMatchers(
						"/api/login","/api/login_facebook","/api/register","/api/activate/{usn}",
				"/api/save_user","/api/change/password","/api/username/{usn}","/api/save_fcmtoken",
				"/api/cities","/api/projects","/api/projects/find/{key}","/api/projects/count",
				"/api/projects/page/{a}/size/{b}","/api/projects/{id}","/api/project_types",
				"/api/posts/{id}","/api/posts/public/count","/api/posts/public/page/{a}/size/{b}",
				"/api/posts/public/find/{name}/count","/api/posts/public/find/{name}/page/{a}/size/{b}",
				"/api/paypal/donator_id/{did}/project_id/{pid}/donate",
				"/api/paypal/success/donator_id/{did}/project_id/{pid}/money/{money}",
				"/api/donate_details/project/{prjid}","/api/comments/project/{id}","/api/comments/{id}/project/{pid}",
				"/api/projects/filter/favorite/donator/{did}/city/{c_ids}/project_type/{pt_ids}/status/{st}/find/{key}/page/{p}/size/{s}",
				"/api/projects/filter/favorite/donator/{did}/city/{c_ids}/project_type/{pt_ids}/status/{st}/find/{key}/count",
				"/api/supported_people_recommends"
				).permitAll().
				// all other requests need to be authenticated
				anyRequest().authenticated().and().
				// make sure we use stateless session; session won't be used to
				// store user's state.
				exceptionHandling().authenticationEntryPoint(jwtAuthenticationEntryPoint)
									.and()
									.sessionManagement()
									.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
		// Add a filter to validate the tokens with every request
		httpSecurity.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
	}
}