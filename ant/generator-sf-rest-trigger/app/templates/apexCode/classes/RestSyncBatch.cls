/**
 * Batch class for <%= name %> integration.
 * This is created by <%= name %>SyncBatcher in the <%= entity %>TriggerHandler class.
 */
public class <%= name %>SyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    private Id[] entityIds;
    private Boolean create;
    private <%= name %> api;

    public <%= name %>SyncBatch(<%= entity %>[] records, Boolean create, <%= name %> api) {
    	this.entityIds = new List<Id>();
        for(<%= entity %> entity: records) {
            entityIds.add(entity.Id);
        }
        this.create = create;
        this.api = api;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select TravelFrom__c, LoadOutEndDate__c,
                                         EventEndDate__c, WRAPEndDate__c,
                                         TravelTo__c, LoadInStartDate__c,
                                         PreProductionStartDate__c, EventStartDate__c,
                                         StageName, Name, <%= name %><%= name %><%= entity %>_ID__c,
                                         PG<%= name %><%= entity %>Code__c
                                         from <%= entity %>
                                         where Id in :entityIds]);
    }

    public void execute(Database.BatchableContext BC, list<SObject> records) {
        IntegrationLogger logger = new IntegrationLogger('Hub Planner');
        for(SObject rec: records) {
            <%= entity %> entity = (<%= entity %>) rec;
            try {
                // don't want to do the callouts, if we are running in a test.
                // the callout logic will be tested separately
                String projectId;
                if(create) {
                    projectId = api.create<%= name %><%= entity %>(entity);
                } else {
                    projectId = api.update<%= name %><%= entity %>(entity);
                }
                <% if(externalIdProperty) { %>
                entity.externalIdProperty = projectId;
                <% } %>
                if(create) {
                    logger.logCreate(entity.Id, projectId);
                } else {
                    logger.logUpdate(entity.Id, projectId);
                }
            } catch(<%= name %>Exception x) {
                System.debug(LoggingLevel.WARN, 'Error in <%= name %> <%= entity %> Batch: ' + x.getMessage());
                logger.logError(entity.Id, x.getMessage());
            }
        }
        // if we want to save the records we can do that here
        <% if(externalIdProperty) { %>
      	update records;
        <% } %>
        // commit the logs to the database
        logger.save();
    }

    public void finish(Database.BatchableContext BC) {
        // nothing to do
    }
}
