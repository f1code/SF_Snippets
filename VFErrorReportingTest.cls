@isTest
public class VFErrorReportingTest {
    static testMethod void testReportDmlException() {
		Savepoint sp = Database.setSavepoint();
        try {
            Account a = new Account();
            insert a;
            System.assert(false, 'Should have thrown an Exception');
        } catch(DmlException x) {
            VFErrorReporting.reportException(x, sp);
        }
    }
    
    static testMethod void testReportRegularException() {
        try {
            Integer i = 10 / 0;
            System.assert(false, 'Should have thrown an Exception');
        } catch(Exception x) {
            VFErrorReporting.reportException(x);
        }
    }        
}
