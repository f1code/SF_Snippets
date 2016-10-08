@isTest
public class OAuth2Test {    
    static testMethod void testGetAccessTokenForCode() {        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new AccessTokenMock());
        OAuth2 api = new OAuth2(null, null, null, 'accessTokenUrl', 'clientId', 'clientSecret');
        api.getAccessTokenForCode('code', 'callbackUrl');        
        Test.stopTest();
        
        System.assertEquals('access_token', api.accessToken);
    }
    
    static testMethod void testMakeApiCall() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new AccessTokenMock());
        OAuth2 api = new OAuth2('accesstoken', System.now().addMinutes(9999), null, null, null, null);
        String response = api.makeAPICall('apiUrl', 'body', 'POST', true);
        Test.stopTest();
        
        System.assertEquals('api_response', response);                
    }
    
    static testMethod void testRefreshToken() {                
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new RefreshTokenMock());
        OAuth2 api = new OAuth2('accessToken', System.now(), 'refreshToken', 'accessTokenUrl', 'clientId', 'clientSecret');
        api.getAccessToken();
        Test.stopTest();
        
        System.assertEquals('access_token_refreshed', api.accessToken);
    }
    
    static testMethod void testGetters() {
        OAuth2 api = new OAuth2('accessToken', System.now().addHours(2), 'refreshToken', null, null, null);
        api.getAccessToken();
        api.getRefreshToken();
        api.getAccessTokenExpires();        
    }
    
    public class AccessTokenMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // get access token
            System.debug('ENDPOINT = ' + req.getEndpoint());
            if(req.getMethod() == 'POST' && req.getEndpoint().endsWith('accessTokenUrl')) {                                
                res.setBody('{"access_token":"access_token", ' + 
                            '"refresh_token":"refresh_token", ' + 
                            '"expires_in":3600, ' + 
                            '"token_type":"bearer"}');
                res.setStatusCode(200);
            } else {
                res.setStatusCode(400);                
                res.setBody('Invalid endpoint ' + req.getEndpoint());
            }
            return res;
        }
    }
        
    public class RefreshTokenMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // update project
            if(req.getMethod() == 'POST' && req.getEndpoint().endsWith('accessTokenUrl')) {                                
                res.setBody('{"access_token":"access_token_refreshed", ' + 
                            '"expires_in":3600, ' + 
                            '"token_type":"bearer"}');
                res.setStatusCode(200);
            } else {
                res.setStatusCode(400);                
            }
            return res;
        }
    }
    
    
    public class ApiMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // update project
            if(req.getMethod() == 'POST' && req.getEndpoint() == 'apiUrl') {                                
                res.setBody('api_response');
                res.setStatusCode(200);
            } else {
                res.setStatusCode(400);                
            }
            return res;
        }
    }
}
