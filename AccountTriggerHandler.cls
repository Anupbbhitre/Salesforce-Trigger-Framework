public class AccountTriggerHandler extends TriggerHandler {
    public override Boolean IsDisabled() {
        return false;
    }
    public override void BeforeInsert(List<sObject> newItems) {
        List<Account> newAccList = ((List<Account>)newItems);
    }
}