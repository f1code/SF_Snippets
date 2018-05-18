public interface <%= name %>SyncBatcher {
	  void batchUpdate(<%= entity %>[] recs);
    
    void batchCreate(<%= entity %>[] recs);
}
