public class <%= entityName %>TriggerHandler {
    // can be set to false to skip triggers during testing
    public static Boolean execute = true;
    // can be set to a mock during testing
    public static <%= name %>SyncBatcher batcher = new <%= name %>SyncBatcherImpl();

    public static void onAfterInsert(<%= entity %>[] inserted) {
        if(!execute)
            return;
        batcher.batchCreate(inserted);
    }

    public static void onAfterUpdate(<%= entity %>[] updated, Map<Id, <%= entity %>> oldMap) {
        <%= entity %>[] toUpdate = new List<<%= entity %>>();
        for(<%= entity %> opp: updated) {
            <%= entity %> old = (<%= entity %>)oldMap.get(opp.Id);
            // TODO: condition for triggering an update
            if(true)
                toUpdate.add(opp);
        }
        if(execute && toUpdate.size() > 0) {
            batcher.batchUpdate(toUpdate);
        }
    }
}
