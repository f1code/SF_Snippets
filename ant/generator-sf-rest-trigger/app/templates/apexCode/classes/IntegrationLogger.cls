public class IntegrationLogger {
    private IntegrationLog__c[] logs;
    private String integrationType;

    public IntegrationLogger(String integrationType) {
        this.logs = new List<IntegrationLog__c>();
        this.integrationType = integrationType;
    }

    public void logCreate(String entityId, String externalId) {
        this.addLog(new IntegrationLog__c(
            <%= entityName %>__c = entityId,
            External_Id__c = externalId,
            Sync_Type__c = 'Create',
            Result__c = 'Success'
        ));
    }

    public void logUpdate(String entityId, String externalId) {
        this.addLog(new IntegrationLog__c(
            <%= entityName %>__c = entityId,
            External_Id__c = externalId,
            Sync_Type__c = 'Update',
            Result__c = 'Success'
        ));
    }

    public void logError(String entityId, String errorMessage) {
        this.addLog(new IntegrationLog__c(
            <%= entityName %>__c = entityId,
            Error_Message__c = errorMessage,
            Result__c = 'Failure'
        ));
    }

    public void addLog(IntegrationLog__c logging) {
        logging.Integration_Type__c = this.integrationType;
        logs.add(logging);
    }

    public void save() {
        insert logs;
    }
}
