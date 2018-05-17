/**
 * Interface for communication with the <%= name %> API
 */
public interface <%= name %> {
    /**
     * Create a record for the <%= entity %> and return its id on the remote system.
     */
	  String create<%= name %><%= entityName %>(<%= entity %> rec);
    /**
     * Locate and update the record
     */
    String update<%= name %><%= entityName %>(<%= entity %> rec);
}
