trigger <%= entityName %>Trigger on <%= entity %> (after insert, after update) {
    if(Trigger.isInsert) {
        <%= entityName %>TriggerHandler.onAfterInsert(Trigger.new);
        //System.enqueueJob(new <%= name %>ProjectQueue(toCreate, true));
    } else if(Trigger.isUpdate) {
        <%= entityName %>TriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);         
    }
}
