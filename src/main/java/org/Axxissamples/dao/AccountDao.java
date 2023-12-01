package org.axxissamples.dao;

import java.util.List;

import org.axxissamples.bean.Account;

public interface AccountDao {

	List<Account> findUsersByUsernameAndPassword(String username, String password);

	List<Account> findUsersByUsername(String username);

	List<Account> findAllUsers();

}
