@isTest
public class <%= entity %>TriggerTest {
    // very simple test because the handler is prevented from running - just want to get coverage for the trigger
    static testMethod void testInsert() {
		<%= entity %>TriggerHandler.execute = false;
        <%= entity %> entity = <%= testFactory %>(true);
    }

    static testMethod void testUpdate() {
		<%= entity %>TriggerHandler.execute = false;
        <%= entity %> entity = <%= testFactory %>(true);
        // may need to change the property to something else - something that would trigger an update
        entity.Name = 'Something else';
        update entity;
    }
}
