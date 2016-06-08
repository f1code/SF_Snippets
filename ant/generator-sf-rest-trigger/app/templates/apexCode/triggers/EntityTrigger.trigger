trigger <% entity %>Trigger on <% entity %> (after insert, after update) {
    if(Trigger.isInsert) {
        <% entity %>TriggerHandler.onAfterInsert(Trigger.new);
        //System.enqueueJob(new <% name %>ProjectQueue(toCreate, true));
    } else if(Trigger.isUpdate) {
        <% entity %>TriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);         
    }
}
