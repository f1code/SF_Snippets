/*
 * Generic REST controller with execption handling.
 */
public class PGRestController {
    public static Object invokeAction(PGServiceAction action) {
        return invokeAction(null, action);
    }
   
    /*
     * @param routePattern Regular expression.  Capture groups will be passed to the action
     * @param action action to be invoked.  Request parameters (other than route parameters) should be
     *  saved as instance variables.
     */
    public static Object invokeAction(String routePattern, PGServiceAction action) {                   
        try {
            String[] urlParams = null;
        	if(routePattern != null) {
	            urlParams = parseRouteParams(routePattern, RestContext.request.requestURI);            
    	    }
            return action.execute(urlParams);
        } catch(PGNotFoundException ex) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(ex.getMessage());
            return null;
        } catch(PGException ex) {
            // probably a validation error
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(ex.getMessage());
            return null;
        } catch(Exception ex) {
            // generic SF exception
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf(ex.getMessage());
            return null;
        }
    }
    
    private static String[] parseRouteParams(String routePattern, String uri) {
        String requestUri = RestContext.request.requestURI;       
        Pattern rx = Pattern.compile(routePattern);
        Matcher match = rx.matcher(requestUri);    
        if(!match.matches()) {
            throw new PGNotFoundException('Invalid route');
        }
        String[] params = new List<String>();
        for(Integer i=1; i <= match.groupCount(); i++) {
            params.add(match.group(i));
        }
        return params;
    }
}
