import {Router} from "express";
import {getUsuario} from '../controllers/controllers'

const router = Router();


router.get('/prueba', getUsuario);

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