import {data} from "../repositories/connection";

export class controller {

    constructor(){}

    async getUsuario() {
        const pool = new data();
        const result = await pool.getUsuario();
        return result;
    }


    async execEP1() {
        const pool = new data();
        const result = await pool.execEP1();
        return result;
    }

    async execEP2(partido,accion) {
        const pool = new data();
        const result = await pool.execEP2(partido,accion);
        return result;
    }
    /*
    async execEP3(palabras) {
        const pool = new data();
        const result = await pool.execEP3(palabras);
        return result;
    }*/

    async execEP4() {
        const pool = new data();
        const result = await pool.execEP4();
        return result;
    }

    async execEP5() {
        const pool = new data();
        const result = await pool.execEP5();
        return result;
    }

    async execEP6(usuario, plan, tvp_Ent) {
        const pool = new data();
        const result = await pool.execEP6(usuario, plan, tvp_Ent);
        return result;
    }
}