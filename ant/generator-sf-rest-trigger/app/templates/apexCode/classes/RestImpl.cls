/**
 * Logic for <%= name %> calls.
 * This is the implementation for the REST API Communication
 */
public class <%= name %>Impl implements <%= name %> {
    public String create<%= name %><%= entityName %>(<%= entity %> opp) {
        throw new <%= name %>Exception('TODO: implement create logic');
    }

    /**
     * Locate and update the record on the remote system.
     */
    public String update<%= name %><%= entityName %>(<%= entity %> opp) {
        throw new <%= name %>Exception('TODO: implement update logic');
    }
}
