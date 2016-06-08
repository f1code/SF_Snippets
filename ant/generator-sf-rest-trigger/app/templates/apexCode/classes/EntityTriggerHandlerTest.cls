@isTest
public class <%= entity %>TriggerHandlerTest {
    static testMethod void testOnAfterInsert() {
        <%= entity %>TriggerHandler.execute = false;
        <%= entity %> entity = <%= testFactory %>(true);
        <%= entity %>TriggerHandler.execute = true;
        MockBatcher batcher = new MockBatcher();
        <%= entity %>TriggerHandler.hubPlannerBatcher = batcher;

        <%= entity %>TriggerHandler.onAfterInsert(new <%= entity %>[] { entity });

        System.assertEquals(1, batcher.createCount);
        System.assertEquals(0, batcher.updateCount);
    }

    static testMethod void testOnAfterUpdate() {
        <%= entity %>TriggerHandler.execute = false;
        <%= entity %> entity = <%= testFactory %>(true);
        <%= entity %>TriggerHandler.execute = true;
        MockBatcher batcher = new MockBatcher();
        <%= entity %>TriggerHandler.hubPlannerBatcher = batcher;
        Map<Id, <%= entity %>> entityMap = new Map<Id, <%= entity %>>();
        entityMap.put(entity.Id, new <%= entity %>());
        <%= entity %>TriggerHandler.onAfterUpdate(new <%= entity %>[] { entity }, entityMap);

        System.assertEquals(1, batcher.updateCount);
    }

    public class MockBatcher implements <%= name %>SyncBatcher {
        public Integer createCount = 0;
        public Integer updateCount = 0;

        public void batchCreate<%= name %><%= entity %>s(<%= entity %>[] entities) {
            createCount += entities.size();
        }

        public void batchUpdate<%= name %><%= entity %>s(<%= entity %>[] entities) {
            updateCount += entities.size();
        }
    }
}
