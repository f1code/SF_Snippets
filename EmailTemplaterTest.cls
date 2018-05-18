@isTest
public class EmailTemplaterTest {

    static testMethod void testReplaceTemplateField() {
        Opportunity o = new Opportunity(Name = 'foo');
        Map<String, String> addlData = new Map<String, String>();
        addlData.put('test', 'xxxx');
        String template = 'Hello {!Opportunity.Name}, {!test} {!otherField} {!otherobject.field}';
        String result = EmailTemplater.replaceTemplateFields(template, o, addlData);
        System.assertEquals('Hello foo, xxxx', result.trim());
	}
    
    static testMethod void testGetLetterHead() {
        EmailTemplate template = [select Id from EmailTemplate limit 1];
        String tpl = EmailTemplater.getLetterHead(template.Id);
        System.assertNotEquals(null, tpl);
        System.assert(tpl.contains('__PLACEHOLDER__'));
    }
}
