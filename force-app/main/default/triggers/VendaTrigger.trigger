// A Trigger é disparada 'before insert' (antes de criar) e 'before update' (antes de atualizar)
trigger VendaTrigger on Venda__c (before insert, before update) {
    
    // Boa prática: garantir que este bloco só rode nos contextos corretos
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Chamamos a classe Handler e passamos a lista de registros novos (Trigger.new)
        VendaTriggerHandler.calcularComissao(Trigger.new);
        
    }
}