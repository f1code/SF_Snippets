public class <%= name %>SyncBatcherImpl implements <%= name %>SyncBatcher {
    public void batchUpdate(<%= entity %>[] recs) {
        Database.executeBatch(new <%= name %>SyncBatch(recs, false, new <%= name %>Impl()), 25);
    }

    public void batchCreate(<%= entity %>[] recs) {
		Database.executeBatch(new <%= name %>SyncBatch(recs, true, new <%= name %>Impl()), 50);
    }
}
