package com.zm.ams.dao;

import java.util.List;
import java.util.Optional;

import com.zm.ams.dto.SearchCriteria;

public interface AmsDao <T, S extends SearchCriteria> {
	Optional<T> get(int id);
    
    List<T> getAll();
    
    List<T> getBySearchCriteria(S criteria);
    
    void save(T t);
    
    void update(T t, String[] params);
    
    void delete(T t);
}
