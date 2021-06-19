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
				"/api/projects","/api/projects/count","/api/projects/from/{a}/to/{b}","/api/projects/{id}", "/api/posts/public","/api/posts/public/count","/api/posts/public/from/{a}/to/{b}",
				"/api/paypal/donator_id/{did}/project_id/{pid}/donate",
				"/api/paypal/success/donator_id/{did}/project_id/{pid}/money/{money}",
				"/api/donate_details/project/{prjid}","/api/comments/project/{id}","/api/comments/{id}/project/{pid}",

				"/api/projects/collaborator/{id}/count","/api/projects/collaborator/{id}/from/{a}/to/{b}",
				"/api/projects/activating/collaborator/{id}",
				"/api/projects/overdue/collaborator/{id}",
				"/api/projects/reached/collaborator/{id}",
				"/api/projects/closed/collaborator/{id}",
				"/api/posts/collaborator/{id}/count","/api/posts/collaborator/{id}/from/{a}/to/{b}",
				"/api/supported_peoples/collaborator/{id}",

				"/api/posts","/api/posts/count","/api/posts/from/{a}/to/{b}","/api/posts/public/{id}","/api/posts/un_public/{id}","/api/posts/{id}",
				"/api/push_notifications","/api/push_notifications/{id}",
				"/api/push_notifications/topic","/api/notification/username/{usn}","/api/notification/data",
				"/api/projects/verified","/api/projects/unverified","/api/projects/activating",
				"/api/projects/overdue","/api/projects/reached","/api/projects/closed","/api/projects/update","/api/projects/handle_all_money",
				"/api/projects/approve/{id}",
				"/api/projects/create/collaborator/{id}", "/api/projects/close/{id}/collaborator/{clb_id}","/api/projects/extend/{id}/num_of_date/{nod}/collaborator/{clb_id}",
				"/api/project_types","/api/project_types/{id}",
				"/api/donators","/api/donators/{id}",
				"/api/donate_details/donate_with_bank",
				"/api/collaborators","/api/collaborators/{id}","/api/collaborators/accept/{id}","/api/collaborators/block/{id}",
				"/api/feedbacks","/api/feedbacks/{id}","/api/users","/api/users/{id}",
				"/api/supported_peoples","/api/supported_peoples/{id}"
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