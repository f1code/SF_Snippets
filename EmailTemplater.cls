/**
 * Used to send emails using a template, when it is not possible to just set the template id when sending the email.
 */
public class EmailTemplater {
    public static void sendTemplated(TemplateData[] templateInfos, String templateName) {
        EmailTemplate[] templates = [select Id, Name, Subject, BrandTemplateId, HtmlValue from EmailTemplate where DeveloperName = :templateName];        
        if(templates.size() == 0)
            throw new CKSException('Unable to locate template ' + templateName);
        EmailTemplate template = templates.get(0);    
        String letterHeadTemplate = null;
        if(template.BrandTemplateId != null)
            letterHeadTemplate = getLetterHead(template.Id);
        String orgWideEmailAddressId = getOrgWideEmailAddressId();
        // retrieve the template HTML
        // for each templateInfo:
        //  - create mail message instance
        //  - fill in values in the template based on the error + opp data
        // send all the accumulated messages
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(TemplateData ti: templateInfos) {
            String body = replaceTemplateFields(template.HtmlValue, ti.record, ti.additionalData);
            String subject = replaceTemplateFields(template.Subject, ti.Record, ti.additionalData);
            if(letterHeadTemplate != null) {
                body = mergeIntoLetterHead(body, letterHeadTemplate);
            }
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(ti.recipientId);
            // What Id is not valid when sending for a user, 
            // but the values are getting interpolated in code anyway, so we don't really need it
            //email.setWhatId(ti.record.Id);
            email.setSaveAsActivity(false); 
            email.setSubject(subject);
            email.setHtmlBody(body); 
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            // hard coded copy
            email.setCcAddresses(new String[] { 'ash_bull@cargill.com' });
            emails.add(email);
        }
        
        if(Test.isRunningTest()){
            lastNotificationSent = emails;
            notificationCount += emails.size();
        }
        // note this may fail in a sandbox if deliverability is not enabled.
        try {
            Messaging.sendEmail(emails);
        } catch(EmailException e) { 
            System.debug(LoggingLevel.WARN, 'Failed to send email: ' + e.getMessage());
        }
    }
    
    // replace data binding expressions in body using the specified record and any additional data
    public static String replaceTemplateFields(String body, SObject record, Map<String, String> additionalData) {
        Matcher m = Pattern.compile('\\{![^.}]*\\.([^.}]*)\\}').matcher(body);
        // anything with a dot in it, is a reference to an sobject, which we'll assume to be the record.
        // this does not handle relationships (like {!Opportunity.Account.Name})
        while(m.find()) {
            String mergeField = m.group(0);
            String field = m.group(1);
            //System.debug(LoggingLevel.INFO, 'Got field = ' + field + ', merge field = ' + mergeField);
            String value = '';
            try {
                value = String.valueOf(record.get(field));
                if(value == null) 
                    value = '';
            } catch(Exception x) {
                // OK just keep the blank
            }
            body = body.replace(mergeField, value);
        }
        
        m = Pattern.compile('\\{!([^.}]*)\\}').matcher(body);
        while(m.find()) {
            String key = m.group(1);
            String value = additionalData.containsKey(key) ? additionalData.get(key) : '';
            body = body.replace(m.group(0), value);
        }        
        
        // we need to remove the cdata stuff
        body = body.replaceAll('<!\\[CDATA\\[(.*)\\]\\]>', '$1');
        return body;
    }
    
    private static String mergeIntoLetterHead(String body, String letterHead) {
        return letterHead.replace('___PLACEHOLDER___', body);
    }
    
    // Use a fake email to retrieve the letter head template
    public static String getLetterHead(String templateId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'invalid@emailaddr.es'};
        mail.setToAddresses(toAddresses);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
//        mail.setSenderDisplayName('MMPT');
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setTemplateId(templateId);
        Savepoint sp = Database.setSavepoint();
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        } catch(EmailException e) {
            System.debug(LoggingLevel.WARN, 'Failed to read letterhead: ' + e.getMessage());
            return null;
        } finally {
            Database.rollback(sp);
        }
        
        String mailHtmlBody = mail.getHtmlBody();
        //System.debug(LoggingLevel.INFO, 'HTML BODY = ' + mailHtmlBody);
        Matcher m = Pattern.compile('(<td tEditID="c1r1".*?>).*?(</td></tr></table></td></tr>)').matcher(mailHtmlBody);
        if(m.find()) {
            String template = mailHtmlBody.replace(m.group(0), m.group(1) + '___PLACEHOLDER___' + m.group(2));
            return template;
        }        
        return null;
    }
    
    private static String getOrgWideEmailAddressId(){
         // to use hard coded address uncomment next line and comment out rest of method
         // return '0D2A0000000PFcz';
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'cvam_feedback@cargill.com'];
        if(owea.size() > 0){
            // if the address cannot be verified, comment out the next line to avoid setting the From
            return owea.get(0).Id;
        }
        return null;
    }
    
    public class TemplateData {
        public SObject record;
        public Map<String, String> additionalData = new Map<String, String>();
        public String recipientId;
    }
    
        
    // reference to the last notification batch that was sent - used in unit tests ONLY
    public static Messaging.SingleEmailMessage[] lastNotificationSent;
    // total number of notifications that were sent (i.e. sum of count of emails in each batch)
    public static Integer notificationCount = 0;
}
