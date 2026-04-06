public with sharing class VendasController {
    
    // Essa é a estrutura que o nosso Front-end vai receber
    public class ResumoVenda {
        @AuraEnabled public String status;
        @AuraEnabled public Integer totalVendas;
        @AuraEnabled public Decimal faturamento;
        @AuraEnabled public Decimal comissoes;
    }

    // A anotação @AuraEnabled(cacheable=true) é obrigatória para o LWC enxergar o método
    @AuraEnabled(cacheable=true)
    public static List<ResumoVenda> getResumoVendas() {
        List<ResumoVenda> listaResumo = new List<ResumoVenda>();
        
        // Rodamos a exata mesma query que você fez no terminal
        String query = 'SELECT Status__c, COUNT(Id) t, SUM(Valor__c) f, SUM(Comissao__c) c FROM Venda__c GROUP BY Status__c';
        
        for(AggregateResult ar : Database.query(query)) {
            ResumoVenda resumo = new ResumoVenda();
            resumo.status = (String)ar.get('Status__c');
            resumo.totalVendas = (Integer)ar.get('t');
            resumo.faturamento = (Decimal)ar.get('f');
            // Como a comissão pode ser nula em canceladas, fazemos um tratamento ternário
            resumo.comissoes = ar.get('c') != null ? (Decimal)ar.get('c') : 0; 
            
            listaResumo.add(resumo);
        }
        
        return listaResumo;
    }
}