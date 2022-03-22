import sql from 'mssql';
import queries from '../repositories/queries';

export class data {
    constructor(){
        this.dbSettings = {
            user: 'usersql',
            password: '1234',
            server: 'localhost',
            database: 'bases2_caso1',
            options: {
                encrypt: true,
                trustServerCertificate: true,
            }
        }

        this.pool = this.getConnection();
    }
    
    // Un solo pool
    async getConnection() {
        try {
            const pool = await sql.connect(this.dbSettings);
            return pool;
        } catch (error) {
            console.error(error);
            }
    }

    // Llamadas a SP
    async getUsuario(){
        const result = await (await this.pool).request().query(queries.getUsuarios);
        return result;
    }

    
    async execEP1(){
        const result = await (await this.pool).request().query(queries.endpoint1);
        return result;
    }

    async execEP2(partido,accion){
        const result = await (await this.pool).request()
        .input("par1", partido)
        .input("par2", accion)
        .query(queries.endpoint2);

        return result;
    }
    /*
    async execEP3(palabras){
        const result = await (await this.pool).request()
        .input("par", palabras)
        .query(queries.endpoint3);
        return result;
    }*/

    async execEP4(){
        const result = await (await this.pool).request().query(queries.endpoint4);
        return result;
    }

    async execEP5(){
        const result = await (await this.pool).request().query(queries.endpoint5);
        return result;
    }

    async execEP6(usuario, plan, EntregablesType){
        const result = await (await this.pool).request()
        .input("Usuario", usuario)
        .input("Plan", plan)
        .input("EntregablesType", EntregablesType)
        .execute(queries.endpoint6);
        return result;
    }
}