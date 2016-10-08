
public interface GoogleSheetsApi {
    String getAccessToken();
    String getRefreshToken();
    DateTime getAccessTokenExpires();
	void appendCells(String spreadsheetId, List<String[]> rows);
}
