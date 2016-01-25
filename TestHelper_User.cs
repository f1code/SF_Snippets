// Snippets for helping manipulate / retrieve users inside of unit tests
// These are specific to hard-coded profile / BU so they need to be adapted as needed

/**
	 * Retrieve a random standard user in the CTSEMEA BU
	 */
	public static User getRandomUser(){
		String profileId = [select Id from Profile where Name='CTS EMEA Sales'].Id;
		User[] users = [select Id from User where Business_Unit__c = 'CTS EMEA' and IsActive=true and ProfileId=:profileId limit 10];
		return users[(Integer)Math.floor(Math.random() * users.size())];
	}
	
	/**
	 * Retrieve a random standard user, other than the specified user id, in the CTSEMEA BU
	 */
	public static User getRandomUserOtherThan(String userId){
		String profileId = [select Id from Profile where Name='CTS EMEA Sales'].Id;
		User[] users = [select Id from User where Business_Unit__c = 'CTS EMEA' and IsActive=true and ProfileId=:profileId and Id <> :userId limit 10];
		return users[(Integer)Math.floor(Math.random() * users.size())];
	}
	
	
	/**
	 * Get a user with the CTS EMEA System Administrator profile.
	 * This is used in tests because it will bypass the validation rule but still enable us to match the lookup filters
	 * (they have many filters that are defined in function of the user's profile, so when running as another BU's system admin they fail)
	 * It's not great because it makes the tests less accurate but it will help prevent false negatives when other BUs run them.
	 */
	public static User getCtsAdminUser() {
		String profileId = [select Id from Profile where Name='CTS EMEA System Administrator'].Id;
		User[] users = [select Id from User where Business_Unit__c = 'CTS EMEA' and IsActive=true and ProfileId=:profileId limit 10];
		return users[(Integer)Math.floor(Math.random() * users.size())];		
	}
