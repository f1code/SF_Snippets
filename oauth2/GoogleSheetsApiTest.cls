// Test Google API callouts
@isTest
public class GoogleSheetsApiTest {
    
    static testMethod void testAppendCells() {
        GoogleSheetsApiImpl api = new GoogleSheetsApiImpl('clientId', 'clientSecret', 'redirectUrl', 'accessToken', System.now().addHours(3), 'refreshToken');
        String[] row = new String[] { '123', '456' };
        List<String[]> rows = new List<String[]>();
        rows.add(row);
        
        SuccessCalloutMock mock = new SuccessCalloutMock();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        api.appendCells('SPREADSHEET', rows);        
        Test.stopTest();
        
        System.assert(mock.successCall);
    }
    
    static testMethod void testGetters() {
        GoogleSheetsApiImpl api = new GoogleSheetsApiImpl('clientId', 'clientSecret', 'redirectUrl', 'accessToken', System.now().addHours(3), 'refreshToken');
        api.getAuthorizationUrl('settingsId');        
    }

    public class SuccessCalloutMock implements HttpCalloutMock {
        public Boolean successCall = false;
        
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // update project
            if(req.getMethod() == 'POST' && req.getEndpoint().endsWith('spreadsheets/SPREADSHEET:batchUpdate')) {                                
                res.setBody('{"spreadsheetId": "1Ss6xcyebNxHRWf-TAYjxm-r9S2WtdScrNeIYisQ2gZo", "replies": [  {  } ]}');
                res.setStatusCode(200);
                successCall = true;
            } else {
                res.setStatusCode(400);                
            }
            return res;
        }
    }
    
    public class ErrorCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');		            
            res.setStatusCode(400);            
            res.setBody('{"error": { "code" : 400, "message": "Some error" } }');
            return res;
        }
    }
}
