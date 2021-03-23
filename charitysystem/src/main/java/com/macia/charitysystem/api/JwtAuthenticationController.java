package com.macia.charitysystem.api;

import com.macia.charitysystem.DTO.JwtUserDTO;
import com.macia.charitysystem.model.Collaborator;
import com.macia.charitysystem.model.Donator;
import com.macia.charitysystem.model.JwtUser;
import com.macia.charitysystem.repository.JwtUserRepository;
import com.macia.charitysystem.security.JwtRequest;
import com.macia.charitysystem.security.JwtResponse;
import com.macia.charitysystem.security.JwtTokenUtil;
import com.macia.charitysystem.security.JwtUserDetailsService;
import com.macia.charitysystem.service.CollaboratorService;
import com.macia.charitysystem.service.DonatorService;
import com.macia.charitysystem.utility.UserType;
import javassist.NotFoundException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;


@RestController
@CrossOrigin("*")
@RequestMapping("/api")
public class JwtAuthenticationController {
	@Autowired
	private AuthenticationManager authenticationManager;

	@Autowired
	private JwtTokenUtil jwtTokenUtil;

	@Autowired
	private JwtUserDetailsService userDetailsService;
	@Autowired
	private JwtUserRepository jwtuserRepo;
	@Autowired
	private CollaboratorService collaboratorService;

	@Autowired
	private DonatorService donatorService;

	@PostMapping("/login")
	public ResponseEntity<?> createAuthenticationToken(@RequestBody JwtRequest authenticationRequest) throws Exception {
		JSONObject jo = new JSONObject();

		authenticate(authenticationRequest.getUsername(), authenticationRequest.getPassword());

		final UserDetails userDetails = userDetailsService.loadUserByUsername(authenticationRequest.getUsername());

		JwtUser user = jwtuserRepo.findByUsername(authenticationRequest.getUsername());

		final String token = jwtTokenUtil.generateToken(userDetails);

		jo.put("errorCode", 0);
		jo.put("token",new JwtResponse(token).getToken());
		jo.put("data", user);
		jo.put("message", "Đăng nhập thành công!");
		return new ResponseEntity<>(jo.toMap(),HttpStatus.OK);
	}
	
	@PostMapping("/register")
	public ResponseEntity<?> saveUser(@RequestBody JwtUserDTO user) throws Exception {
		JSONObject jo = new JSONObject();
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		if(jwtuserRepo.findByUsername(user.getUsername())==null){
			String p = passwordEncoder.encode(user.getPassword1());
			JwtUser newuser = new JwtUser();
			newuser.setUsername(user.getUsername());
			newuser.setPassword(p);
			newuser.setStatus("NOT-ACTIVATED");
			jwtuserRepo.save(newuser);
			jo.put("errorCode", 0);
			jo.put("data", newuser);
			jo.put("message", "Đăng ký thành công!\nMã xác thực sẽ được gửi!");
			return ResponseEntity.ok(jo.toMap());
		}else{
			jo.put("errorCode", 1);
			jo.put("message", "Số điện thoại này đã được đăng ký!");
			jo.put("data", "");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.ALREADY_REPORTED);
		}
	}
	@PostMapping("/activate")
	public ResponseEntity<?> activateUser(@RequestBody JwtUserDTO user) throws Exception {
		JSONObject jo = new JSONObject();
		JwtUser appUser = jwtuserRepo.findByUsername(user.getUsername());
		if(appUser!=null){
			if(user.getUsertype().equals(UserType.Donator.toString())){
				appUser.setUsertype(UserType.Donator);
				donatorService.save(Donator.builder().phoneNumber(user.getUsername()).favoriteProject("").build());
			}else if(user.getUsertype().equals(UserType.Collaborator.toString())){
				appUser.setUsertype(UserType.Collaborator);
				collaboratorService.save(Collaborator.builder().phoneNumber(user.getUsername()).build());
			}else{
				jo.put("errorCode", 1);
				jo.put("data", "");
				jo.put("message", "Kích hoạt thất bại!");
				return new ResponseEntity<>(jo.toMap(),HttpStatus.BAD_REQUEST);
			}
			appUser.setStatus("ACTIVATED");
			jwtuserRepo.save(appUser);
			jo.put("errorCode", 0);
			jo.put("data", appUser);
			jo.put("message", "Kích hoạt thành công!");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không thể tìm thấy người dùng với username: "+user.getUsername()+ " !");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
		}
	}
	@PostMapping("/change/password")
	public ResponseEntity<?> changePassword(@RequestBody JwtUserDTO user) {
		JSONObject jo = new JSONObject();
		if(user.getUsertype().equals(UserType.Donator.toString())){
			JwtUser appUser = jwtuserRepo.findByUsername(user.getUsername());
			if(appUser!=null){
				BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
				String p = passwordEncoder.encode(user.getPassword1());
				appUser.setPassword(p);
				jwtuserRepo.save(appUser);
				jo.put("errorCode", 0);
				jo.put("data", appUser);
				jo.put("message", "Đổi mật khẩu thành công!");
				return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
			}
			else{
				jo.put("errorCode", 1);
				jo.put("data", "");
				jo.put("message", "Không thể tìm thấy người dùng với username: "+user.getUsername()+ " !");
				return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
			}
		}
		else if(user.getUsertype().equals(UserType.Collaborator.toString())) {
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Đổi mật khẩu cho "+UserType.Collaborator.toString()+" chưa có sẵn!");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không thể tìm thấy loại người dùng: "+user.getUsertype());
			return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
		}
	}

	@GetMapping("/username/{usn}")
	public ResponseEntity<?> getUserByUSN(@PathVariable(value = "usn") String usn) {
		JSONObject jo = new JSONObject();
		if (jwtuserRepo.findByUsername(usn) != null) {
			jo.put("errorCode", 0);
			jo.put("data", jwtuserRepo.findByUsername(usn));
			jo.put("message", "Mã xác thực sẽ được gửi!");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", usn+" Chưa được đăng ký!");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
		}
	}
	@DeleteMapping("/username/{usn}")
	public ResponseEntity<?> deleteUserByUSN(@PathVariable(value = "usn") String usn) {
		JSONObject jo = new JSONObject();
		if (jwtuserRepo.findByUsername(usn) != null) {
			jo.put("errorCode", 0);
			jo.put("data", jwtuserRepo.findByUsername(usn));
			jo.put("message", "Xóa thành công!");
			jwtuserRepo.delete(jwtuserRepo.findByUsername(usn));
			return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không tìm thấy người dùng có username: "+usn+" !");
			return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
		}
	}

	private void authenticate(String username, String password) throws Exception {
		try {
			authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
		} catch (DisabledException e) {
			throw new Exception("USER_DISABLED", e);
		} catch (BadCredentialsException e) {
			throw new Exception("INVALID_CREDENTIALS", e);
		}
	}
}