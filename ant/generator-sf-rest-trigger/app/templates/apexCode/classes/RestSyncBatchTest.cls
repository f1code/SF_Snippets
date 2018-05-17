@isTest
public class <%= name %>SyncBatchTest {
    static testMethod void testCreate<%= name %><%= entity %>s() {
        <%= entityName %>TriggerHandler.execute = false;
        <%= entity %> opp = <%= testFactory %>(true);
        <%= name %>SyncBatch batch = new <%= name %>SyncBatch(new <%= entity %>[] { opp }, true, new MockSuccess());

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        <% if(externalIdProperty) { %> 
        opp = [select Id, <%= externalIdProperty %> from <%= entity %> where Id = :opp.Id];
        System.assertNotEquals(null, opp.<%= externalIdProperty %>);
        <% } %>
        IntegrationLog__c[] log = [select Id from IntegrationLog__c where <%= entity %>__c = :opp.Id and Result__c = 'Success' and Sync_Type__c = 'Create'];
        System.assertNotEquals(0, log.size(), 'Should have created log');
	}


    static testMethod void testUpdate<%= name %><%= entityName %>s() {
        <%= entityName %>TriggerHandler.execute = false;
        <%= entity %> opp = <%= testFactory %>(true);
        <% if(externalIdProperty) { %> 
        opp.<%= externalIdProperty %> = '444';
        <% } %>
        update opp;
        <%= name %>SyncBatch batch = new <%= name %>SyncBatch(new <%= entity %>[] { opp }, false, new MockSuccess());

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        <% if(externalIdProperty) { %> 
        opp = [select Id, <%= externalIdProperty %> from <%= entity %> where Id = :opp.Id];
        System.assertEquals('444', opp.<%= externalIdProperty %>, 'Should not update project id');
        <% } %>
        IntegrationLog__c[] log = [select Id from IntegrationLog__c where <%= entity %>__c = :opp.Id and Result__c = 'Success' and Sync_Type__c = 'Update'];
        System.assertNotEquals(0, log.size(), 'Should have created log');
    }

    static testMethod void testLogErrors() {
        <%= entityName %>TriggerHandler.execute = false;
        <%= entity %> opp = <%= testFactory %>(true);
        <%= name %>SyncBatch batch = new <%= name %>SyncBatch(new <%= entity %>[] { opp }, true, new MockFailure());

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        IntegrationLog__c[] log = [select Error_Message__c from IntegrationLog__c where <%= entity %>__c = :opp.Id and Result__c = 'Failure'];
        System.assertNotEquals(0, log.size(), 'Should have created log');
        System.assertNotEquals(null, log.get(0).Error_Message__c);
    }

    public class MockSuccess implements <%= name %> {
        public String create<%= name %><%= entityName %>(<%= entity %> opp) {
            return '123';
        }

        public String update<%= name %><%= entityName %>(<%= entity %> opp) {
            return opp.<%= externalIdProperty || 'Id' %>;
        }
    }


    public class MockFailure implements <%= name %> {
        public String create<%= name %><%= entityName %>(<%= entity %> opp) {
            throw new <%= name %>Exception('Failed!');
        }

        public String update<%= name %><%= entityName %>(<%= entity %> opp) {
            throw new <%= name %>Exception('Failed!');
        }
    }
}
