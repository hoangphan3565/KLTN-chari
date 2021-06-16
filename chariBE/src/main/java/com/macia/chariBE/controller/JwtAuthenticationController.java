package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.UserDTO;
import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.Donator;
import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.JwtUserRepository;
import com.macia.chariBE.security.JwtRequest;
import com.macia.chariBE.security.JwtResponse;
import com.macia.chariBE.security.JwtTokenUtil;
import com.macia.chariBE.security.JwtUserDetailsService;
import com.macia.chariBE.service.CollaboratorService;
import com.macia.chariBE.service.DonatorService;
import com.macia.chariBE.utility.UserStatus;
import com.macia.chariBE.utility.UserType;
import net.minidev.json.JSONObject;
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

	@Autowired
	private PushNotificationService pushNotificationService;

	@PostMapping("/login")
	public ResponseEntity<?> createAuthenticationToken(@RequestBody JwtRequest authenticationRequest) throws Exception {
		JSONObject jo = new JSONObject();
		authenticate(authenticationRequest.getUsername(), authenticationRequest.getPassword());
		final UserDetails userDetails = userDetailsService.loadUserByUsername(authenticationRequest.getUsername());
		JwtUser user = jwtuserRepo.findByUsername(authenticationRequest.getUsername());
		Collaborator c = collaboratorService.findByUsername(authenticationRequest.getUsername());
		if(c!=null){ jo.put("info", c); }
		Donator d = donatorService.findByPhone(authenticationRequest.getUsername());
		if(d!=null){ jo.put("info", d); }
		final String token = jwtTokenUtil.generateToken(userDetails);
		jo.put("errorCode", 0);
		jo.put("token",new JwtResponse(token).getToken());
		jo.put("data", user);
		jo.put("message", "Đăng nhập thành công!");
		return new ResponseEntity<>(jo,HttpStatus.OK);
	}

	@PostMapping("/login_facebook")
	public ResponseEntity<?> loginWithFaceBook(@RequestBody UserDTO fb_user) throws Exception {
		JSONObject jo = new JSONObject();
		if(jwtuserRepo.findByUsername(fb_user.getId())==null){
			JwtUser new_user = new JwtUser();
			new_user.setUsername(fb_user.getId());
			BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
			String ps = passwordEncoder.encode("facebook");
			new_user.setPassword(ps);
			new_user.setUsertype(fb_user.getUsertype());
			new_user.setStatus(UserStatus.ACTIVATED);
			jwtuserRepo.save(new_user);
			Donator curDonator = donatorService.findByFacebookId(fb_user.getId());
			if(curDonator==null){
				donatorService.save(Donator.builder()
						.fullName(fb_user.getName())
						.facebookId(fb_user.getId())
						.favoriteNotification(pushNotificationService.findAllIdAsString())
						.favoriteProject("").build());
			}else{
				curDonator.setFullName(fb_user.getName());
				donatorService.save(curDonator);
			}
		}
		final UserDetails userDetails = userDetailsService.loadUserByUsername(fb_user.getId());
		authenticate(fb_user.getId(), "facebook");
		final String token = jwtTokenUtil.generateToken(userDetails);
		JwtUser fbUser = jwtuserRepo.findByUsername(fb_user.getId());
		Donator d = donatorService.findByFacebookId(fb_user.getId());
		if(d!=null){ jo.put("info", d); }
		jo.put("errorCode", 0);
		jo.put("token",new JwtResponse(token).getToken());
		jo.put("data", fbUser);
		jo.put("message", "Đăng nhập thành công!");
		return new ResponseEntity<>(jo,HttpStatus.OK);
	}

	@PostMapping("/register")
	public ResponseEntity<?> saveUser(@RequestBody UserDTO user) {
		JSONObject jo = new JSONObject();
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		if(jwtuserRepo.findByUsername(user.getUsername())==null){
			String p = passwordEncoder.encode(user.getPassword1());
			JwtUser newuser = new JwtUser();
			newuser.setUsername(user.getUsername());
			newuser.setPassword(p);
            newuser.setUsertype(user.getUsertype());
			newuser.setStatus(UserStatus.NOT_ACTIVATED);
			jwtuserRepo.save(newuser);
			if(user.getUsertype().equals(UserType.Collaborator)){
				collaboratorService.save(Collaborator.builder()
						.fullName(user.getName()).address(user.getAddress())
						.email(user.getEmail()).phoneNumber(user.getPhone())
						.certificate(user.getCertificate()).isAccept(false)
						.username(user.getUsername()).build());
				jo.put("errorCode", 0);
				jo.put("data", newuser);
				jo.put("message", "Đăng ký thành công! Hãy quay lại khi nhận được mail xác nhận của chúng tôi!");
				return ResponseEntity.ok(jo);
			}else{
				jo.put("errorCode", 0);
				jo.put("data", newuser);
				jo.put("message", "Đăng ký thành công!\nMã xác thực sẽ được gửi!");
				return ResponseEntity.ok(jo);
			}
		}else{
			if(user.getUsertype().equals(UserType.Collaborator)){
				jo.put("errorCode", 1);
				jo.put("message", "Tên đăng nhập đã tồn tại!");
				jo.put("data", "");
				return new ResponseEntity<>(jo, HttpStatus.ALREADY_REPORTED);
			}
			jo.put("errorCode", 1);
			jo.put("message", "Số điện thoại này đã được đăng ký!");
			jo.put("data", "");
			return new ResponseEntity<>(jo, HttpStatus.ALREADY_REPORTED);
		}
	}


	@PostMapping("/activate/{usn}")
	public ResponseEntity<?> activateUser(@PathVariable(value = "usn") String usn) {
		JSONObject jo = new JSONObject();
		JwtUser appUser = jwtuserRepo.findByUsername(usn);
		if(appUser!=null){
			appUser.setStatus(UserStatus.ACTIVATED);
			jwtuserRepo.save(appUser);
			jo.put("errorCode", 0);
			jo.put("data", appUser);
			jo.put("message", "Kích hoạt thành công!");
			return new ResponseEntity<>(jo, HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không thể tìm thấy người dùng với username: "+usn+ " !");
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
		}
	}

	@GetMapping("/users")
	public ResponseEntity<?> getAllUser() {
		return ResponseEntity.ok().body(jwtuserRepo.findAll());
	}

	@DeleteMapping("/users/{id}")
	public ResponseEntity<?> blockUser(@PathVariable(value = "id") Integer id) {
		JwtUser user = jwtuserRepo.findById(id).orElseThrow();
		user.setStatus(UserStatus.BLOCKED);
		if(user.getUsertype().equals(UserType.Collaborator)){
			Collaborator c = collaboratorService.findByUsername(user.getUsername());
			c.setIsAccept(false);
			collaboratorService.save(c);
		}
		jwtuserRepo.save(user);
		return ResponseEntity.ok().body(jwtuserRepo.findAll());
	}

	@PutMapping("/users/{id}")
	public ResponseEntity<?> unblockUser(@PathVariable(value = "id") Integer id) {
		JwtUser user = jwtuserRepo.findById(id).orElseThrow();
		user.setStatus(UserStatus.ACTIVATED);
		if(user.getUsertype().equals(UserType.Collaborator)){
			Collaborator c = collaboratorService.findByUsername(user.getUsername());
			c.setIsAccept(true);
			collaboratorService.save(c);
		}
		jwtuserRepo.save(user);
		return ResponseEntity.ok().body(jwtuserRepo.findAll());
	}

	@PostMapping("/save_user")
	public ResponseEntity<?> saveUserInfo(@RequestBody UserDTO user) {
		JSONObject jo = new JSONObject();
		JwtUser appUser = jwtuserRepo.findByUsername(user.getUsername());
		if(appUser!=null){
			if(user.getUsertype().equals(UserType.Donator)){
				if(donatorService.findByPhone(user.getUsername())==null){
					donatorService.save(Donator.builder()
							.phoneNumber(user.getUsername())
							.favoriteNotification(pushNotificationService.findAllIdAsString())
							.favoriteProject("").build());
				}
			}
			else{
				jo.put("errorCode", 1);
				jo.put("data", "");
				jo.put("message", "Kích hoạt thất bại!");
				return new ResponseEntity<>(jo,HttpStatus.BAD_REQUEST);
			}
			appUser.setStatus(UserStatus.ACTIVATED);
			jwtuserRepo.save(appUser);
			jo.put("errorCode", 0);
			jo.put("data", appUser);
			jo.put("message", "Kích hoạt thành công!");
			return new ResponseEntity<>(jo, HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không thể tìm thấy người dùng với username: "+user.getUsername()+ " !");
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
		}
	}

    @PostMapping("/change/password")
	public ResponseEntity<?> changePassword(@RequestBody UserDTO user) {
		JSONObject jo = new JSONObject();
		if(user.getUsertype().equals(UserType.Donator)){
			JwtUser appUser = jwtuserRepo.findByUsername(user.getUsername());
			if(appUser!=null){
				BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
				String p = passwordEncoder.encode(user.getPassword1());
				appUser.setPassword(p);
				jwtuserRepo.save(appUser);
				jo.put("errorCode", 0);
				jo.put("data", appUser);
				jo.put("message", "Đổi mật khẩu thành công!");
				return new ResponseEntity<>(jo, HttpStatus.OK);
			}
			else{
				jo.put("errorCode", 1);
				jo.put("data", "");
				jo.put("message", "Không thể tìm thấy người dùng với username: "+user.getUsername()+ " !");
				return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
			}
		}
		else if(user.getUsertype().equals(UserType.Collaborator)) {
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Đổi mật khẩu cho "+UserType.Collaborator.toString()+" chưa có sẵn!");
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không thể tìm thấy loại người dùng: "+user.getUsertype());
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
		}
	}

	@GetMapping("/username/{usn}")
	public ResponseEntity<?> getUserByUSN(@PathVariable(value = "usn") String usn) {
		JSONObject jo = new JSONObject();
		if (jwtuserRepo.findByUsername(usn) != null) {
			jo.put("errorCode", 0);
			jo.put("data", jwtuserRepo.findByUsername(usn));
			jo.put("message", "Mã xác thực sẽ được gửi!");
			return new ResponseEntity<>(jo, HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", usn+" Chưa được đăng ký!");
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
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
			return new ResponseEntity<>(jo, HttpStatus.OK);
		}
		else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không tìm thấy người dùng có username: "+usn+" !");
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
		}
	}

	@PostMapping("/save_fcmtoken")
	public ResponseEntity<?> saveFCMTokenToUser(@RequestBody UserDTO user) {
		JSONObject jo = new JSONObject();
		JwtUser appUser = jwtuserRepo.findByUsername(user.getUsername());
		if(appUser!=null){
			appUser.setFcmToken(user.getFcmToken());
			jwtuserRepo.save(appUser);
			jo.put("errorCode", 0);
			jo.put("data", appUser);
			jo.put("message", "Cập nhật thành công!");
			return new ResponseEntity<>(jo, HttpStatus.OK);
		}else{
			jo.put("errorCode", 1);
			jo.put("data", "");
			jo.put("message", "Không thể tìm thấy người dùng với username: "+user.getUsername()+ " !");
			return new ResponseEntity<>(jo, HttpStatus.BAD_REQUEST);
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