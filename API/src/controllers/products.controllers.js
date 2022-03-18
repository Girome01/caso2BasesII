import {getConnection} from "../database/connection";
import queries from '../database/queries'

export const getUsuario = async (req, res) => {
    
    const pool = await getConnection();
    const result = await pool.request().query(queries.getUsuarios);
    console.log(result);
    
    res.json(result.recordset);

};

export const execEP1 = async (req, res) => {
    
    const pool = await getConnection();
    const result = await pool.request().query(queries.endpoint1);
    console.log(result);
    
    res.json(result.recordset);

};

export const execEP2 = async (req, res) => {
    
    const pool = await getConnection();
    const result = await pool.request().query(queries.endpoint2);
    console.log(result);
    
    res.json(result.recordset);

};