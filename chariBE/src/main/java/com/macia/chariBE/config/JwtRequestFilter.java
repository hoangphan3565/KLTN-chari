package com.macia.chariBE.config;

import com.macia.chariBE.security.JwtTokenUtil;
import com.macia.chariBE.security.JwtUserDetailsService;
import io.jsonwebtoken.ExpiredJwtException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class JwtRequestFilter extends OncePerRequestFilter {
	@Autowired
	private JwtUserDetailsService jwtUserDetailsService;
	@Autowired
	private JwtTokenUtil jwtTokenUtil;
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws ServletException, IOException {

		final String requestTokenHeader = request.getHeader("Authorization");
		String username = null;
		String jwtToken = null;
		if (isBearerToken(requestTokenHeader)) {
			jwtToken = getTokenFromRequestTokenHeader(requestTokenHeader);
			username = getUsernameFromTokenJWT(jwtToken);
		}
		if (isUsernameNotAuthenticated(username)) {
			UserDetails userDetails = this.jwtUserDetailsService.loadUserByUsername(username);
			setAuthentcationInSpringSecurity(request, jwtToken, userDetails);
		}
		chain.doFilter(request, response);
	}
	private boolean isUsernameNotAuthenticated(String username) {
		return username != null && SecurityContextHolder.getContext().getAuthentication() == null;
	}
	private boolean isBearerToken(final String requestTokenHeader) {
		return requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ");
	}
	private String getUsernameFromTokenJWT(String jwtToken) {
		String username=null;
		try {
			username = jwtTokenUtil.getUsernameFromToken(jwtToken);
		} catch (IllegalArgumentException e) {
			System.out.println("Unable to get JWT Token");
		} catch (ExpiredJwtException cmde) {
			System.out.println("JWT Token has expired");
		}
		return username;
	}
	private String getTokenFromRequestTokenHeader(final String requestTokenHeader) {
		String jwtToken;
		jwtToken = requestTokenHeader.substring(7);
		return jwtToken;
	}
	private void setAuthentcationInSpringSecurity(HttpServletRequest request, String jwtToken,
			UserDetails userDetails) {
		if (jwtTokenUtil.validateToken(jwtToken, userDetails)) {

			UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = 
														new UsernamePasswordAuthenticationToken(
														userDetails, null, userDetails.getAuthorities());
			usernamePasswordAuthenticationToken
											.setDetails(new WebAuthenticationDetailsSource()
											.buildDetails(request));
			// After setting the Authentication in the context, we specify
			// that the current user is authenticated. So it passes the
			// Spring Security Configurations successfully.
			SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
		}
	}
}