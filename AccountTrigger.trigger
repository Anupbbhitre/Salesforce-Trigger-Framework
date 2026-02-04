trigger AccountTrigger on Account (before insert, before update) {
    TriggerDispatcher.Run(new AccountTriggerHandler());
}