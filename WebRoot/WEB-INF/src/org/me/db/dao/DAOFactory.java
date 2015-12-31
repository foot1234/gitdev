package org.me.db.dao;

public class DAOFactory {
	public static IDoDao getUserDao() {
		return new DoDao();
	}
}
