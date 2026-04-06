import { LightningElement, wire } from 'lwc';
// Importamos o método que criamos no Apex
import getResumoVendas from '@salesforce/apex/VendasController.getResumoVendas';

export default class DashboardVendas extends LightningElement {
    dadosVendas;
    erro;

    // O @wire chama o Apex assim que o componente carrega na tela
    @wire(getResumoVendas)
    wiredVendas({ error, data }) {
        if (data) {
            this.dadosVendas = data;
            this.erro = undefined;
        } else if (error) {
            this.erro = error;
            this.dadosVendas = undefined;
        }
    }
}