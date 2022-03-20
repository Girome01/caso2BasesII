import {Router} from "express";
import {controller} from '../controllers/controllers'

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
    
    //console.log(result); 
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

router.get('/endpoint6', async (req, res)=>{
    const result = await control.execEP6();
    
    //console.log(result);
    res.json(result.recordset);
});

export default router;