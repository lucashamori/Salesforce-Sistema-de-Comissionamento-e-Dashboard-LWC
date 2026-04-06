// A anotação @isTest avisa a Salesforce que esta classe não deve ir para produção, é apenas para testes.
@isTest
public class VendaTriggerTest {
    
    // Todo método de teste precisa ter a anotação @isTest também
    @isTest
    static void testarCalculoComissao() {
        
        // ==========================================
        // 1. ARRANGE (Preparação dos Dados)
        // ==========================================
        // Vamos criar uma Venda simulada na memória. Note que não passamos a comissão, 
        // pois queremos que a Trigger calcule isso para nós.
        Venda__c vendaTeste = new Venda__c();
        vendaTeste.Valor__c = 1000;
        vendaTeste.Status__c = 'Pendente';
        
        // O comando 'insert' salva esse dado no banco de dados temporário de testes.
        insert vendaTeste; 
        
        // ==========================================
        // 2. ACT (Execução)
        // ==========================================
        // startTest() e stopTest() resetam os limites de processamento da plataforma 
        // para garantir que o teste rode num ambiente "limpo".
        Test.startTest();
        
        // Aqui simulamos a ação do usuário: mudando o status para 'Fechada' e atualizando.
        // É esse 'update' que vai disparar a nossa VendaTrigger!
        vendaTeste.Status__c = 'Fechada';
        update vendaTeste;
        
        Test.stopTest();
        
        // ==========================================
        // 3. ASSERT (Verificação)
        // ==========================================
        // Precisamos buscar a venda atualizada no banco de dados para ver se a Trigger fez o trabalho dela.
        // Usamos uma query SOQL para isso.
        Venda__c vendaAtualizada = [SELECT Comissao__c FROM Venda__c WHERE Id = :vendaTeste.Id];
        
        // O System.assertEquals é o "juiz" do teste. 
        // Parâmetro 1: O que esperamos (10% de 1000 é 100).
        // Parâmetro 2: O que realmente está no banco.
        // Parâmetro 3: A mensagem de erro caso dê errado.
        System.assertEquals(100, vendaAtualizada.Comissao__c, 'A comissão calculada pela Trigger está incorreta.');
    }
}