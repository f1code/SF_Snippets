public interface <%= name %>SyncBatcher {
	void batchUpdate<%= name %><%= entity %>s(<%= entity %>[] opps);
    
    void batchCreate<%= name %><%= entity %>s(<%= entity %>[] opps);
}
