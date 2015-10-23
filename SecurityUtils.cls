public class SecurityUtils {
    /**
     * Return true if current user has the System Administrator profile.
     */
    public static Boolean isCurrentUserAdmin(){
        Id profileId=userinfo.getProfileId();        
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        return profileName == 'System Administrator';
    }
}
