# ☁️ Salesforce Full-Stack: Sistema de Comissionamento e Dashboard LWC

## 🎯 O Propósito do Projeto
Este projeto foi desenvolvido para demonstrar o domínio do ciclo completo de desenvolvimento dentro do ecossistema Salesforce (Back-end, Quality Assurance, Análise de Dados e Front-end). 

O objetivo de negócio simulado foi automatizar o cálculo de comissões de uma equipe de vendas e fornecer um painel gerencial (Dashboard) em tempo real para a diretoria, garantindo que a lógica financeira ficasse protegida no back-end e a visualização fosse fluida e moderna no front-end.

## 🏗️ Arquitetura e Tecnologias Utilizadas

A solução foi construída utilizando as seguintes tecnologias e padrões:

* **Modelagem de Dados (Data Layer):** Criação de Custom Objects (`Venda__c`) e campos customizados para suportar as regras de negócio.
* **Back-end (Apex):** Utilização do padrão **Trigger Handler** para separar a escuta de eventos do banco de dados (Trigger) da inteligência do negócio (Classe Apex). Isso garante um código escalável e de fácil manutenção.
* **Quality Assurance (Testes Unitários):** Implementação de testes automatizados utilizando o padrão **AAA (Arrange, Act, Assert)**. O código possui **100% de code coverage**, garantindo que os cálculos financeiros de comissão sejam feitos à prova de falhas.
* **Análise de Dados (SOQL):** Construção de queries agregadas (`COUNT`, `SUM`, `GROUP BY`) para cruzar os dados de faturamento e comissões pagas, extraindo inteligência do banco de dados.
* **Front-end (LWC & SLDS):** Desenvolvimento de um **Lightning Web Component (LWC)** reativo. Utilizei o *Salesforce Lightning Design System (SLDS)* para aplicar conceitos de UX/UI, criando cards responsivos que consomem a classe Apex via `@wire` e apresentam os dados financeiros formatados aos diretores.

## ⚙️ Fluxo de Funcionamento

1. Um novo registro de Venda é inserido ou atualizado.
2. A `VendaTrigger` intercepta a ação (Before Insert / Before Update) e envia os dados para a `VendaTriggerHandler`.
3. A classe verifica o status da venda. Se for "Fechada", calcula automaticamente 10% de comissão e insere no registro antes de salvar no banco.
4. O componente LWC `dashboardVendas` escuta o Apex Controller, faz uma query analítica agrupando todos os status e renderiza os totais de Faturamento e Comissões na tela inicial do CRM.

## 🏗️ Estrutura de Código

### 1. Camada de Dados (Back-end)
Utilização do padrão **Trigger Handler** para garantir isolamento e escalabilidade da lógica de negócio. A comissão de 10% é calculada automaticamente via Apex antes da inserção no banco, isolando a regra de negócio da interface.

```java
// Trecho da classe VendaTriggerHandler.cls
public with sharing class VendaTriggerHandler {
    public static void calcularComissao(List<Venda__c> novasVendas) {
        for(Venda__c venda : novasVendas) {
            if(venda.Status__c == 'Fechada' && venda.Valor__c != null) {
                venda.Comissao__c = venda.Valor__c * 0.10; 
            } else {
                venda.Comissao__c = 0;
            }
        }
    }
}
```

O gatilho que intercepta os eventos de banco de dados.

**VendaTrigger.trigger**

```java
trigger VendaTrigger on Venda__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        VendaTriggerHandler.calcularComissao(Trigger.new);
    }
}
```

### Garantia de Qualidade (Testes)
Implementei testes automatizados seguindo o padrão AAA (Arrange, Act, Assert) para validar a regra de negócio.

**VendaTriggerTest.cls**

```java
@isTest
public class VendaTriggerTest {
    @isTest
    static void testarCalculoComissao() {
        Venda__c v = new Venda__c(Valor__c = 1000, Status__c = 'Pendente', Name = 'Teste');
        insert v;
        
        Test.startTest();
        v.Status__c = 'Fechada';
        update v;
        Test.stopTest();
        
        Venda__c vAtu = [SELECT Comissao__c FROM Venda__c WHERE Id = :v.Id];
        System.assertEquals(100, vAtu.Comissao__c, 'Cálculo de comissão falhou');
    }
}
```

### Camada de Vizualização **(Front-end LWC)**
O dashboard consome dados agregados via Apex Controller para exibir cartões responsivos.
**VendasController.cls** (Apoio ao Front)
Realiza a soma e agrupamento dos dados (SOQL) para enviar ao componente.

```java
public with sharing class VendasController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getResumoVendas() {
        List<Map<String, Object>> resultados = new List<Map<String, Object>>();
        for(AggregateResult ar : [SELECT Status__c s, COUNT(Id) t, SUM(Valor__c) f, SUM(Comissao__c) c FROM Venda__c GROUP BY Status__c]) {
            resultados.add(new Map<String, Object>{
                'status' => ar.get('s'),
                'total' => ar.get('t'),
                'faturamento' => ar.get('f'),
                'comissoes' => ar.get('c')
            });
        }
        return resultados;
    }
}
```

## Resultado e Análise de Dados

### Visualização de Métricas (SOQL)

Abaixo, o insert da query rodada diretamente no VS Code.

```sql
// Criamos uma lista vazia para guardar nossas vendas
List<Venda__c> listaVendas = new List<Venda__c>();

// Adicionamos Vendas FECHADAS na lista
listaVendas.add(new Venda__c(Name = 'Venda 001 - Sistema Cloud', Valor__c = 1000, Status__c = 'Fechada'));
listaVendas.add(new Venda__c(Name = 'Venda 002 - Implantação', Valor__c = 2500, Status__c = 'Fechada'));
listaVendas.add(new Venda__c(Name = 'Venda 003 - Licenças', Valor__c = 5000, Status__c = 'Fechada'));

// Adicionamos Vendas PENDENTES na lista
listaVendas.add(new Venda__c(Name = 'Venda 004 - Consultoria', Valor__c = 1500, Status__c = 'Pendente'));
listaVendas.add(new Venda__c(Name = 'Venda 005 - Suporte', Valor__c = 3000, Status__c = 'Pendente'));
listaVendas.add(new Venda__c(Name = 'Venda 006 - Integração', Valor__c = 4500, Status__c = 'Pendente'));

// Adicionamos Vendas CANCELADAS na lista
listaVendas.add(new Venda__c(Name = 'Venda 007 - Manutenção', Valor__c = 800, Status__c = 'Cancelada'));
listaVendas.add(new Venda__c(Name = 'Venda 008 - Treinamento', Valor__c = 1200, Status__c = 'Cancelada'));

// Comando mágico que insere as 8 vendas no banco de dados de uma só vez
insert listaVendas;
```
### Dashboard Final (LWC)

Interface renderizada no Salesforce Lightning Experience, proporcionando uma visão clara de:

* Faturamento: Valor total convertido em vendas.
* Comissões: Valor real a ser pago aos consultores.
* Lost Pipeline (Canceladas): Monitoramento de valores perdidos para análise de causa raiz.

<img width="1920" height="953" alt="image" src="https://github.com/user-attachments/assets/812dd200-c34c-494b-a396-ce4dc583a30f" />


## Cobertura de Código
O projeto mantém 100% de cobertura de testes, garantindo segurança para futuras manutenções.

<img width="467" height="370" alt="image" src="https://github.com/user-attachments/assets/3cc2ab05-5762-47b0-a8ee-e9c07886e14d" />


## 🚀 Como testar este projeto na sua Org

1. Clone este repositório: `git clone https://github.com/seu-usuario/salesforce-comission-dashboard.git`
2. Autorize sua Org no Salesforce CLI: `sf org login web -a minha-org`
3. Faça o deploy dos metadados: `sf project deploy start -d force-app`
4. Adicione o componente `dashboardVendas` a uma Lightning App Page através do Lightning App Builder.


---
*Desenvolvido com foco em boas práticas de engenharia de software e análise de dados no Salesforce.*
