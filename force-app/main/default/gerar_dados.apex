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