package com.zm.ams.dao.jdbc.impl;

import java.util.List;
import java.util.Optional;

import com.zm.ams.dao.AmsDao;
import com.zm.ams.dto.AmcSearchCriteria;
import com.zm.ams.dto.AppraisalManagementCompany;

public class AppraisalManagementCompanyJdbcDao 
	implements AmsDao<AppraisalManagementCompany, AmcSearchCriteria> {

	@Override
	public Optional<AppraisalManagementCompany> get(int id) {
		// TODO Auto-generated method stub
		return Optional.empty();
		
		//-----> Optional.ofNullable(null)
	}

	@Override
	public List<AppraisalManagementCompany> getAll() {	
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AppraisalManagementCompany> getBySearchCriteria(AmcSearchCriteria criteria) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void save(AppraisalManagementCompany t) {
		// TODO Auto-generated method stub
	}

	@Override
	public void update(AppraisalManagementCompany t, String[] params) {
		// TODO Auto-generated method stub
	}

	@Override
	public void delete(AppraisalManagementCompany t) {
		// TODO Auto-generated method stub
	}
}
