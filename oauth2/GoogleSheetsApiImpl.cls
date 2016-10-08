public class GoogleSheetsApiImpl extends OAuth2 implements GoogleSheetsApi {
    private String redirectUrl;
    
    public GoogleSheetsApiImpl(String clientId, String clientSecret, String redirectUrl, String accessToken, DateTime accessTokenExpires, String refreshToken) {
        super(accessToken, accessTokenExpires, refreshToken, 'https://www.googleapis.com/oauth2/v4/token', clientId, clientSecret);
        this.redirectUrl = redirectUrl;                
    }
    
    public String getAuthorizationUrl(String settingsId) {
        String uri = 'https://accounts.google.com/o/oauth2/v2/auth?' + 
            'scope=' + EncodingUtil.urlEncode('https://www.googleapis.com/auth/spreadsheets', 'UTF-8') + '&' + 
            'redirect_uri=' + EncodingUtil.urlEncode(this.redirectUrl, 'UTF-8') + '&' + 
            'state=' + EncodingUtil.urlEncode(settingsId, 'UTF-8') + '&' + 
            'access_type=offline&' + 
            // ensure we show prompt so we can get the refresh token
            'prompt=consent&' + 
            'response_type=code&' + 
            'client_id=' + this.clientId;
        return uri;
    }
    
    // get access token and refresh token for the given auth code
    public void validateAuthCode(String authCode) {
        this.getAccessTokenForCode(authCode, this.redirectUrl);       
    }   
    
    public void appendCells(String spreadsheetId, List<String[]> rows) {        
        JSONGenerator request = JSON.createGenerator(true);
        /*
{
  "requests": 
  [
    {
      "appendCells": 
      {
        "rows": 
        [
          {
            "values": 
            [
              {
                "userEnteredValue": 
                {
                  "stringValue": ""
                }
              }
            ]
          }
        ],
        "fields": "*"
      }
    }
  ]
} 
*/
        request.writeStartObject();  // {
        request.writeFieldName('requests'); // "requests":
        request.writeStartArray(); // [
        request.writeStartObject(); // {
        request.writeFieldName('appendCells'); // "appendCells":
        request.writeStartObject(); // {
        request.writeFieldName('rows'); // "rows":
        request.writeStartArray(); // [
        for(String[] rowValues: rows) {        
        	request.writeStartObject(); // {
            request.writeFieldName('values');
            request.writeStartArray(); // [
            for(String cellValue: rowValues) {
            	request.writeStartObject(); // {    
                request.writeFieldName('userEnteredValue');
                request.writeStartObject(); // {
                request.writeStringField('stringValue', cellValue);
                request.writeEndObject(); // } end userEnteredValue
                request.writeEndObject(); // } end value item
            }
            request.writeEndArray(); // ]
        	request.writeEndObject(); // }  // end of row
        }
        request.writeEndArray(); // ]
        request.writeStringField('fields', '*'); // "fields": "*"
        request.writeEndObject(); // }  // end of appendCells
        request.writeEndObject(); // } // end of request item
        request.writeEndArray(); // ]
        request.writeEndObject(); // } // end of requests
        
        String response = this.makeAPICall('https://sheets.googleapis.com/v4/spreadsheets/' + spreadsheetId + ':batchUpdate', request.getAsString(), 'POST', true);
    }
}
