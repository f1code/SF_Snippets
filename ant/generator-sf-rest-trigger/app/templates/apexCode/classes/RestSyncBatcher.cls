public interface <%= name %>SyncBatcher {
	  void batchUpdate(<%= entityName %>[] recs);
    
    void batchCreate(<%= entityName %>[] recs);
}
