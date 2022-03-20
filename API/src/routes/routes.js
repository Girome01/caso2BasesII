import {Router} from "express";
import {controller} from '../controllers/controllers'

const router = Router();
const control = new controller();


router.get('/prueba', control.getUsuario);

//router.get('/endpoint1', execEP1);
//router.get('/endpoint2', execEP2);
//router.get('/endpoints', execEP3);
//router.get('/endpoint4', execEP4);
//router.get('/endpoint5', execEP5);
//router.get('/endpoints', execEP6);

// router.post('/products', )
// router.delete('/products', )
// router.get('/products', )
// router.get('/products', )

export default router;