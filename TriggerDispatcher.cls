public with sharing class TriggerDispatcher {
    public static void Run(TriggerHandler handler) {
        if (handler.IsDisabled()) return;

       if (Trigger.isBefore) {
            if (Trigger.isInsert) handler.BeforeInsert(Trigger.new);
            if (Trigger.isUpdate) handler.BeforeUpdate(Trigger.newMap, Trigger.oldMap);
            if (Trigger.isDelete) handler.BeforeDelete(Trigger.oldMap);
        }

        if (Trigger.isAfter) {
            if (Trigger.isInsert) handler.AfterInsert(Trigger.newMap);
            if (Trigger.isUpdate) handler.AfterUpdate(Trigger.newMap, Trigger.oldMap);
  			if (Trigger.isDelete) handler.AfterDelete(Trigger.oldMap);
            if (Trigger.isUndelete) handler.AfterUndelete(Trigger.oldMap);
        }
    }
}