@isTest
public class <%= entityName %>TriggerTest {
    // very simple test because the handler is prevented from running - just want to get coverage for the trigger
    static testMethod void testInsert() {
		<%= entityName %>TriggerHandler.execute = false;
        <%= entity %> entity = <%= testFactory %>(true);
    }

    static testMethod void testUpdate() {
		<%= entityName %>TriggerHandler.execute = false;
        <%= entity %> entity = <%= testFactory %>(true);
        // may need to change the property to something else - something that would trigger an update
        entity.Name = 'Something else';
        update entity;
    }
}
