import {data} from "../repositories/connection";
import queries from '../repositories/queries'

export class controller {

    constructor(){}

    getInstance() {
        if (this.instance){
            this.instance = new controller();
        }
        return this.instance;
    }

    getUsuario = async (req, res) => {
        const pool = new data().pool;
        const result = await (await pool).request().query(queries.getUsuarios);
        console.log(result);
        
        res.json(result.recordset);
    }

}

export const execEP1 = async (req, res) => {
    
    const pool = await connection.getConnection();
    const result = await pool.request().query(queries.endpoint1);
    console.log(result);
    
    res.json(result.recordset);

};

export const execEP2 = async (req, res) => {
    
    const connect = new data();
    const pool = await connect.getConnection();
    const result = await pool.request().query(queries.endpoint2);
    console.log(result);
    
    res.json(result.recordset);

};

export const execEP4 = async (req, res) => {
    
    const pool = await connection.getConnection();
    const result = await pool.request().query(queries.endpoint4);
    console.log(result);
    
    res.json(result.recordset);

};

export const execEP5 = async (req, res) => {
    
    const pool = await connection.getConnection();
    const result = await pool.request().query(queries.endpoint5);
    console.log(result);
    
    res.json(result.recordset);

};