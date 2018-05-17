public class <%= name %>SyncBatcherImpl implements <%= name %>SyncBatcher {
    public void batchUpdate(<%= entityName %>[] recs) {
        Database.executeBatch(new <%= name %>SyncBatch(recs, false, new <%= name %>Impl()), 25);
    }

    public void batchCreate(<%= entityName %>[] recs) {
		Database.executeBatch(new <%= name %>SyncBatch(recs, true, new <%= name %>Impl()), 50);
    }
}
