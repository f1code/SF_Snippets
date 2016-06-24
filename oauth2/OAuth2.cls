// Facilitator for OAuth2 Flow (only tested with Google API)
public virtual class OAuth2 {
    protected String accessTokenUrl, clientId, clientSecret;
    public String accessToken;    
    public String refreshToken;    
    public DateTime accessTokenExpires;

    public OAuth2(String accessToken, DateTime accessTokenExpires, String refreshToken, String accessTokenUrl, String clientId, String clientSecret) {
        this.accessToken = accessToken;
        this.accessTokenUrl = accessTokenUrl;
        this.refreshToken = refreshToken;
        this.accessTokenExpires = accessTokenExpires;
        this.clientId = clientId;
        this.clientSecret = clientSecret;        
    }
    
    // Retrieve an access token (call after getting the auth code from the callback URL)
    // Will throw an exception if there is an error.
    // After authentication, the accessToken and refreshToken fields will be populated
    public String getAccessTokenForCode(String code, String callbackUrl){ 
        String body = 'client_id=' + clientId + 
            '&redirect_uri=' + callbackUrl + 
            '&client_secret=' + clientSecret + 
            '&code=' + code + 
            '&grant_type=authorization_code';
 
        String response = makeAPICall(accessTokenUrl, body, 'POST', false);
 
        System.debug('=========================== RESPONSE:'+response);
 
        TokenResponse t = parseAccessToken(response);
        this.accessToken = t.access_token;
        this.refreshToken = t.refresh_token;        
        this.accessTokenExpires = System.now().addSeconds(t.expires_in);
        return accessToken;
    }    
    
    public Boolean hasAccessToken() {
        return this.accessToken != null && this.accessToken != '';
    }
    
    private void refreshToken() {
        String body = 'client_id=' + clientId + 
            '&client_secret=' + clientSecret + 
            '&refresh_token=' + EncodingUtil.urlEncode(this.refreshToken, 'UTF-8') + 
            '&grant_type=refresh_token';
 
        String response = makeAPICall(accessTokenUrl, body, 'POST', false);
 
        System.debug('=========================== RESPONSE:'+response);
 
        TokenResponse t = parseAccessToken(response);
        this.accessToken = t.access_token;
        this.refreshToken = t.refresh_token;        
        this.accessTokenExpires = System.now().addSeconds(t.expires_in);
    }
    
    public String getAccessToken() {
        if(hasAccessToken()) {
            if(this.refreshToken != null && 
                this.accessTokenExpires != null && 
                this.accessTokenExpires < System.now().addSeconds(180)) {
                this.refreshToken();
            }
            return this.accessToken;
        }
        throw new OAuthException('No access token');
    }
    
    public String getRefreshToken() {
        return refreshToken;
	}
    
    public DateTime getAccessTokenExpires() {
        return accessTokenExpires;
    }
    
    // make an authenticated API call
    public String makeAPICall(String apiUrl, String body, String method, Boolean useAuthentication){
        HttpRequest req = new HttpRequest();
        if(useAuthentication) {
            req.setHeader('Authorization', 'Bearer ' + this.getAccessToken());
        }
        req.setMethod(method);
        if(method == 'POST') {
            req.setBody(body);
        } else {
            if(apiUrl.indexOf('?') > -1) {
                apiUrl += '&';            
            } else {
                apiUrl += '?';
            }
            apiUrl += body;
        }
        req.setEndpoint(apiUrl);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() >= 400) {
            throw new ApiException(res.getStatusCode(), res.getBody());
        }
        return res.getBody();        
    }
    
    private TokenResponse parseAccessToken(String jsonResponse) {
    //    {
    //  "access_token":"1/fFAGRNJru1FTz70BzhT3Zg",
    //  "expires_in":3920,
    //  "token_type":"Bearer"
    // }
        JSONParser parser = JSON.createParser(jsonResponse);
        if(parser.nextToken() != null) {
            TokenResponse response = (TokenResponse)parser.readValueAs(TokenResponse.class);
            if(response.access_token == null || response.access_token == '') {
                throw new OAuthException('Unable to get access token from response');
            }
            return response;
        }
        throw new OAuthException('Unable to get access token from response: parse error');        
    }
    
    private class TokenResponse {
        public String access_token;
        public String refresh_token;
        public Integer expires_in;
        public String token_type;
    }
    
    public class OAuthException extends Exception {
    
    }
    
    public class ApiException extends Exception {
        public Integer statusCode;
        
        public ApiException(Integer statusCode, String response) {
            this(response);
            this.statusCode = statusCode;
        }
	}
}
