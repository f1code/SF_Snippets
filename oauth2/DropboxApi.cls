public interface DropboxApi {    
    // Form authorization URL that we need to redirect the user to to get a new token
    String getAuthorizationUrl(String settingsId);
    
    // get access token and refresh token for the given auth code
    // this will populate the accessToken, accessTokenExpires and refreshToken fields
    void validateAuthCode(String authCode);
    
    // Copy a folder, return the unique folder id (which is not the same as the shared folder id!)
    String copyFolder(String sourcePath, String destinationPath);
    
    // Share a specified folder and return the shared folder id    
    String shareFolder(String folderPath);
    
    // add members (by email) to a folder that was already shared
    void addShareMembers(String shareFolderId, String[] members);
    
    void saveSettings(String settingsId);
}
