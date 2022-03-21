import {Router} from "express";
import {controller} from '../controllers/controllers'
import sql from 'mssql';

const router = Router();
const control = new controller();


router.get('/prueba', async (req, res)=>{
    const result = await control.getUsuario();
    
    //console.log(result);
    res.json(result.recordset);
});


router.get('/endpoint1', async (req, res)=>{
    const result = await control.execEP1();
    
    //console.log(result);
    res.json(result.recordset);
});

router.get('/endpoint2/:partido/:accion', async (req, res)=>{
    const {partido,accion} = req.params;
    const result = await control.execEP2(partido,accion);
    
    // console.log(result); 
    res.send(result.recordset);
});

router.get('/endpoint3/:palabras', async (req, res)=>{
    const {palabras} = req.params;
    const result = await control.execEP3(palabras);
    
    //console.log(result);
    res.send(result.recordset);
});

router.get('/endpoint4', async (req, res)=>{
    const result = await control.execEP4();
    
    //console.log(result); 
    res.json(result.recordset);
});

router.get('/endpoint5', async (req, res)=>{
    const result = await control.execEP5();
    
    //console.log(result);
    res.json(result.recordset);
});

router.post('/endpoint6/:usuario/:plan', async (req, res)=>{
    //Recibir el usuario y plan como parametros
    const {usuario, plan} = req.params;
    
    //Tratar de crear la TVP para poder incorporar todos los entregables
    // Se crea la variable que referencia a la tabla igual seria el DECLARE @TVP AS entregableType;
    var tvp_Ent = new sql.Table();  
    // Columns must correspond with type we have created in database.   
    tvp_Ent.columns.add('kpiValue', sql.SMALLINT);  
    tvp_Ent.columns.add('kpiType', sql.NVARCHAR(50)); 
    tvp_Ent.columns.add('accionId', sql.INT); 
    tvp_Ent.columns.add('fechaFinalizacion', sql.DATETIME); 
    tvp_Ent.columns.add('valorRef', sql.INT); //Hace referencia a su posicion en la lista, porque la tvp no tiene id
    tvp_Ent.columns.add('ranking', sql.SMALLINT); 
    
    //Esta parte se espera registrar todos los entregables que vengan en el body del http
    const {jkpiValue, jkpiType, jaccionId, jfechaFinalizacion, jvalorRef, jranking} = req.body;

    //tvp_Emp.rows.add('kpiValue', 'kpiType', 'accionId', 'fechaFinalizacion', 'valorRef', 'ranking');
    tvp_Ent.rows.add(jkpiValue, jkpiType, jaccionId, jfechaFinalizacion, jvalorRef, jranking);

    const result = await control.execEP6(usuario, plan, tvp_Ent);
    
    console.log(result);
    res.json(result.recordset);
});

export default router;