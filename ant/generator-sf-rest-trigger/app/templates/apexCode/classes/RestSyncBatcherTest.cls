@isTest
public class <%= name %>SyncBatcherTest {
    static testMethod void testBatchUpdate() {
        <%= name %>SyncBatcher h = new <%= name %>SyncBatcherImpl();
        h.batchCreate<%= name %><%= entityName %>s(new <%= entity %>[] {} );
    }
    
    static testMethod void testBatchCreate() {
        <%= name %>SyncBatcher h = new <%= name %>SyncBatcherImpl();
        h.batchUpdate<%= name %><%= entityName %>s(new <%= entity %>[] {} );
    }
}
