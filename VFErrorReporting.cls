/**
 * Error reporting utilities for Visual Force page controllers
 */
public class VFErrorReporting {
    /**
     * Convenience method for logging an error  and adding a Page Message for it
     * 
     * This returns a null PageReference just so we can return the result right away from the controller handler
     * without having to add a "return null" line - there is no significance to the returned value.
     * 
     * @param sp - if provided, we'll roll back to it.  Pass null if not needed
     */
    public static PageReference reportException(Exception x, SavePoint sp) {
        System.debug(LoggingLevel.WARN, 'Exception: ' + x.getTypeName() + ': ' + x.getMessage() + ' -- ' + x.getCause());
        if(sp != null)
            Database.rollback(sp);
        if(x instanceof DmlException) {
            // for DML Exception: just get the message for the first row, because the full message will have 
            // some unfriendly technical details
            DmlException dmlx = (DmlException)x;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, dmlx.getDmlMessage(0)));
        } else {
        	ApexPages.addMessages(x);
        }
        return null;
    }
    
    /**
     * Convenience method for logging an error  and adding a Page Message for it
     * 
     * This returns a null PageReference just so we can return the result right away from the controller handler
     * without having to add a "return null" line - there is no significance to the returned value.
     * 
     * Note that any database operation will not be rolled back (unlike if the exception was thrown and not handled)
     */
    public static PageReference reportException(Exception x) {
        return reportException(x, null);
    }
}
