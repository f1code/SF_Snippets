public class <%= name %>SyncBatcherImpl implements <%= name %>SyncBatcher {
    public void batchUpdate<%= name %><%= entity %>s(<%= entity %>[] opps) {
        Database.executeBatch(new <%= name %>SyncBatch(opps, false, new <%= name %>Impl()), 25);
    }

    public void batchCreate<%= name %><%= entity %>s(<%= entity %>[] opps) {
		Database.executeBatch(new <%= name %>SyncBatch(opps, true, new <%= name %>Impl()), 50);
    }
}
