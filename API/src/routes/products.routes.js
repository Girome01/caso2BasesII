import {Router} from "express";
import {execEP1, execEP2, execEP3, execEP4, execEP5, execEP6, getUsuario} from '../controllers/products.controllers'

const router = Router();

router.get('/prueba', getUsuario);

router.get('/endpoint1', execEP1);
router.get('/endpoint2', execEP2);
//router.get('/endpoints', execEP3);
//router.get('/endpoints', execEP4);
//router.get('/endpoints', execEP5);
//router.get('/endpoints', execEP6);

// router.post('/products', )
// router.delete('/products', )
// router.get('/products', )
// router.get('/products', )

export default router;