package org.axxissamples.dao;

import java.util.List;

import org.axxissamples.bean.CreditAccount;

public interface CreditAccountDao {

	List<CreditAccount> findCreditAccountsByUsername(String username);

	void updateCreditAccount(int cashAccountId, double round);

}
