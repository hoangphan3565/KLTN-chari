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
		// We don't need CSRF for this example
		httpSecurity.csrf().disable()
				// dont authenticate this particular request
				.authorizeRequests().antMatchers(
						"/api/login","/api/login_facebook","/api/register","/api/activate/{usn}",
				"/api/save_user","/api/change/password","/api/username/{usn}","/api/save_fcmtoken",
				"/api/projects","/api/projects/{id}",
				"/api/post/public",
				"/api/paypal/donator_id/{did}/project_id/{pid}/donate",
				"/api/paypal/success/donator_id/{did}/project_id/{pid}/money/{money}",
				"/api/donate_details/project/{prjid}",
				//for admin
				"/api/posts","/api/posts/public/{id}","/api/posts/un_public/{id}","/api/posts/{id}",
				"/api/push_notifications","/api/push_notifications/{id}",
				"/api/push_notifications/topic","/api/notification/username/{usn}","/api/notification/data",
				"/api/projects/approve/{id}","/api/projects/create/is_admin/{isadmin}",
				"/api/projects/close/{id}","/api/projects/extend/{id}/num_of_date/{nod}",
				"/api/project_types","/api/project_types/{id}",
				"/api/donators","/api/donators/{id}",
				"/api/donate_details/donate_with_bank",
				"/api/collaborators","/api/collaborators/{id}",
				"/api/feedbacks","/api/feedbacks/{id}","/api/users","/api/users/{id}",
				"/api/supported_peoples","/api/supported_peoples/{id}").permitAll().
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