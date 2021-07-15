package com.macia.chariBE.repository;

import com.macia.chariBE.model.JwtUser;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IJwtUserRepository extends CrudRepository<JwtUser,Integer> {
    public JwtUser findByUsername(String username);
}
