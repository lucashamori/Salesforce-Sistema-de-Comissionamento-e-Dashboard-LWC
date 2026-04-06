public with sharing class VendaTriggerHandler {
    
    // Método estático que receberá a lista de vendas que estão sendo salvas/atualizadas
    public static void calcularComissao(List<Venda__c> novasVendas) {
        
        // Laço de repetição (for) para passar por cada venda individualmente
        for(Venda__c venda : novasVendas) {
            
            // Verificamos duas coisas: se o status é 'Fechada' e se o Valor foi preenchido
            if(venda.Status__c == 'Fechada' && venda.Valor__c != null) {
                // Se sim, a comissão recebe 10% do valor da venda
                venda.Comissao__c = venda.Valor__c * 0.10; 
            } else {
                // Se não for fechada ou não tiver valor, a comissão é zero
                venda.Comissao__c = 0;
            }
        }
    }
}