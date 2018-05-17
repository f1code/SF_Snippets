@isTest
public class <%= entityName %>TriggerHandlerTest {
    static testMethod void testOnAfterInsert() {
        <%= entityName %>TriggerHandler.execute = false;
        <%= entityName %> entity = <%= testFactory %>(true);
        <%= entityName %>TriggerHandler.execute = true;
        MockBatcher batcher = new MockBatcher();
        <%= entityName %>TriggerHandler.batcher = batcher;

        <%= entityName %>TriggerHandler.onAfterInsert(new <%= entity %>[] { entity });

        System.assertEquals(1, batcher.createCount);
        System.assertEquals(0, batcher.updateCount);
    }

    static testMethod void testOnAfterUpdate() {
        <%= entityName %>TriggerHandler.execute = false;
        <%= entityName %> entity = <%= testFactory %>(true);
        <%= entityName %>TriggerHandler.execute = true;
        MockBatcher batcher = new MockBatcher();
        <%= entityName %>TriggerHandler.batcher = batcher;
        Map<Id, <%= entity %>> entityMap = new Map<Id, <%= entity %>>();
        entityMap.put(entity.Id, new <%= entity %>());
        <%= entityName %>TriggerHandler.onAfterUpdate(new <%= entity %>[] { entity }, entityMap);

        System.assertEquals(1, batcher.updateCount);
    }

    public class MockBatcher implements <%= name %>SyncBatcher {
        public Integer createCount = 0;
        public Integer updateCount = 0;

        public void batchCreate<%= name %><%= entityName %>s(<%= entity %>[] entities) {
            createCount += entities.size();
        }

        public void batchUpdate<%= name %><%= entityName %>s(<%= entity %>[] entities) {
            updateCount += entities.size();
        }
    }
}
