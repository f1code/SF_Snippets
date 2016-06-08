public class <%= entity %>TriggerHandler {
    // can be set to false to skip triggers during testing
    public static Boolean execute = true;
    // can be set to a mock during testing
    public static <%= name %>SyncBatcher batcher = new <%= name %>SyncBatcherImpl();

    public static void onAfterInsert(<%= entity %>[] inserted) {
        if(!execute)
            return;
        hubPlannerBatcher.batchCreate<%= name %><%= entity %>s(inserted);
    }

    public static void onAfterUpdate(<%= entity %>[] updated, Map<Id, <%= entity %>> oldMap) {
        <%= entity %>[] toUpdate = new List<<%= entity %>>();
        for(<%= entity %> opp: updated) {
            <%= entity %> old = (<%= entity %>)oldMap.get(opp.Id);
            // TODO: condition for triggering an update
            if(TODO)
                toUpdate.add(opp);
        }
        if(execute && toUpdate.size() > 0) {
            batcher.batchUpdate<%= name %><%= entity %>s(toUpdate);
        }
    }
}
