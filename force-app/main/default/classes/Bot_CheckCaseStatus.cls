public class Bot_CheckCaseStatus {
    
    /* CONCEITO DE WRAPPER CLASS:
       O Einstein Bot não consegue enviar variáveis soltas (como uma única String) 
       diretamente para o Apex. Ele precisa de uma "caixa" que empacote esses dados.
       Essa classe BotInput é a nossa "caixa de entrada".
    */
    public class BotInput {
        @InvocableVariable(required=true label='Número do Chamado')
        public String caseNumber;
    }
    
    // Esta é a "caixa de saída", o que o Apex devolve para o Bot.
    public class BotOutput {
        @InvocableVariable(label='Status Retornado')
        public String caseStatus;
    }

    /* CONCEITO DE INVOCABLE METHOD E BULKIFICATION:
       A anotação @InvocableMethod expõe esse código para o Bot (e para Flows).
       No Salesforce, TUDO precisa ser processado em Lote (Listas) para evitar 
       estourar os limites da plataforma (Governor Limits). Por isso recebemos 
       uma List<BotInput> e retornamos uma List<BotOutput>, mesmo que o bot 
       esteja atendendo apenas um cliente por vez.
    */
    @InvocableMethod(label='Consultar Status do Chamado' description='Busca o Case via SOQL')
    public static List<BotOutput> getCaseStatus(List<BotInput> inputs) {
        
        // Preparamos a lista vazia que será devolvida no final
        List<BotOutput> outputs = new List<BotOutput>();
        
        for (BotInput input : inputs) {
            BotOutput output = new BotOutput();
            
            /* CONCEITO DE TRY/CATCH:
               Sempre que fazemos uma busca no banco (SOQL), a busca pode não 
               encontrar nada. Se não usarmos try/catch, o Bot vai simplesmente 
               "quebrar" na cara do cliente.
            */
            try {
                // A query SOQL busca o objeto Case. Os ':' injetam a variável na query.
                Case c = [SELECT Status FROM Case WHERE CaseNumber = :input.caseNumber LIMIT 1];
                output.caseStatus = 'O status atual do seu chamado é: ' + c.Status;
            } catch (Exception e) {
                output.caseStatus = 'Não encontrei nenhum chamado com o número: ' + input.caseNumber;
            }
            
            outputs.add(output);
        }
        
        return outputs;
    }
}